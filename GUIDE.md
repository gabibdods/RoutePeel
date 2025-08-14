# Server Setup Guide

This guide outlines the necessary steps for setting up a secure server environment with Tor, NGINX, and firewall configuration. It includes installation steps for software, user and service configurations, as well as firewall and network settings.

## Prerequisites

* Ubuntu/Debian-based OS
* Root privileges or access to a user with `sudo` permissions
* Replace `${REDACTED_*}` placeholders with the actual values.

## Initial Setup

### 1. Update and Upgrade System

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Add User to Sudo Group

```bash
sudo usermod -aG sudo ${REDACTED_USER}
echo "${REDACTED_USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/${REDACTED_USER}" >/dev/null
sudo chmod 0440 "/etc/sudoers.d/${REDACTED_USER}"
sudo visudo -cf "/etc/sudoers.d/${REDACTED_USER}"
```

### 3. Modify `root` Account Configuration

```bash
sudo vim /etc/passwd
# Change 'root:x:0:0:root:/root:/bin/bash' to 'root:x:0:0:root:/root:/sbin/nologin'
```

### 4. Install Security and Networking Tools

```bash
sudo apt update && sudo apt install -y unattended-upgrades apt-listchanges nftables apparmor apparmor-utils
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### 5. Configure SSH and Firewall

Edit SSH Config:

```bash
sudo vim /etc/ssh/sshd_config
#PermitRootLogin no
#PasswordAuthentication no
```

Enable UFW Firewall:

```bash
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default deny outgoing
sudo ufw allow 443/tcp
sudo ufw reload
```

### 6. Configure Specific Ports for RoutePeel (Virtual Machine 1)

```bash
sudo ufw allow 9001/tcp
sudo ufw allow 9030/tcp
sudo ufw allow 8443/tcp
sudo ufw allow 8080/tcp
sudo ufw reload
```

### 7. Setup `nftables` Rules

```bash
sudo nft flush ruleset
sudo tee /etc/nftables.conf >/dev/null <<'EOF'
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    ct state established,related accept
    iif lo accept
  }
  chain forward { type filter hook forward priority 0; policy drop; }
  chain output {
    type filter hook output priority 0; policy drop;
    ct state established,related accept
    oif lo accept
    ip daddr ${REDACTED_SEED_IP} tcp dport 8080 accept
    tcp dport { 443, 9001, 9030, 8443 } accept
  }
}
EOF
sudo systemctl enable --now nftables
```

## Install Tor

### 8. Install and Configure Tor

```bash
sudo apt update && sudo apt install -y tor
sudo mkdir -p /var/lib/tor/${REDACTED_PROJECT}
sudo chown -R debian-tor:debian-tor /var/lib/tor/${REDACTED_PROJECT}
sudo chmod 700 /var/lib/tor/${REDACTED_PROJECT}

sudo vim /etc/tor/torrc
#HiddenServiceDir /var/lib/tor/${REDACTED_PROJECT}
#HiddenServiceVersion 3
#HiddenServicePort 80 ${REDACTED_SEED_IP}:8080
#Sandbox 1
#SafeLogging 1
#ClientUseIPv6 0
```

### 9. Restart Tor

```bash
sudo systemctl restart tor
```

### 10. Verify Hidden Service

```bash
sudo cat /var/lib/tor/${REDACTED_PROJECT}/hostname
sudo cat /var/lib/tor/${REDACTED_PROJECT}/hs_ed25519_secret_key
```

## Configure Network

### 11. Modify Network Configuration

```bash
sudo vim /etc/netplan/01-netcfg.yaml
#network:
#	version: 2
#	ethernets:
#		enp0s3:
#			dhcp4: no
#			dhcp6: no
#			addresses:
#				- ${REDACTED_PEEL_IP}/24
#		enp0s8:
#			dhcp4: yes
#			dhcp6: no
```

Apply Network Changes:

```bash
sudo chown root:root /etc/netplan/01-netcfg.yaml
sudo chmod 600 /etc/netplan/01-netcfg.yaml
sudo netplan apply
```

### 12. Edit Tor Service for Security

```bash
sudo systemctl edit tor@default.service
#[Service]
#NoNewPrivileges=yes
#PrivateTmp=yes
#ProtectSystem=strict
#ProtectHome=yes
#ProtectClock=yes
#ProtectKernelTunables=yes
#ProtectKernelModules=yes
#ProtectControlGroups=yes
#RestrictAddressFamilies=AF_INET AF_UNIX
#IPAddressDeny=any
#IPAddressAllow=${REDACTED_SEED_IP}
#SystemCallFilter=@system-service
#LockPersonality=yes
```

### 13. Restart Tor Service

```bash
sudo systemctl daemon-reload
sudo systemctl restart tor@default
```

## RouteSeed (Virtual Machine 2) Configuration

### 14. Flush `nftables` and Configure Network Filters

```bash
sudo nft flush ruleset
sudo tee /etc/nftables.conf >/dev/null <<'EOF'
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    ct state established,related accept
    iif lo accept
    ip saddr ${REDACTED_PEED_IP} tcp dport 8080 accept
  }
  chain forward { type filter hook forward priority 0; policy drop; }
  chain output { type filter hook output priority 0; policy drop; }
}
EOF
sudo systemctl enable --now nftables
```

### 15. Install NGINX and Configure Static Files

```bash
sudo apt update && sudo apt install -y nginx
sudo mkdir -p /var/www/${REDACTED_PROJECT}
# static files dir, rotate constantly for personal security
sudo chown -R www-data:www-data /var/www/${REDACTED_PROJECT}
```

Create NGINX Site Configuration:

```bash
sudo vim /etc/nginx/sites-available/${REDACTED_PROJECT}
#server {
#	listen ${REDACTED_SEED_IP}:8080;
#	server_name _;
#
#	server_tokens off;
#
#	add_header X-Content-Type-Options nosniff;
#	add_header X-Frame-Options DENY;
#	add_header Referrer-Policy no-referrer;
#	add_header Permissions-Policy "interest-cohort=()";
#	add_header Content-Security-Policy "default-src 'self'; base-uri 'none'; form-action 'self'; frame-ancestors 'none'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self' data:" always;
#
#	root /var/www/${REDACTED_PROJECT};
#	index index.html;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#
#	access_log off;
#}
```

Link and Reload NGINX:

```bash
sudo ln -s /etc/nginx/sites-available/${REDACTED_PROJECT} /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 16. Update Network Configuration

```bash
sudo vim /etc/netplan/01-netcfg.yaml
#network:
#	version: 2
#	ethernets:
#		enp0s3:
#			dhcp4: no
#			dhcp6: no
#			addresses:
#				- ${REDACTED_SEED_IP}/24
sudo chown root:root /etc/netplan/01-netcfg.yaml
sudo chmod 600 /etc/netplan/01-netcfg.yaml
sudo netplan apply
```

### 17. Secure NGINX

```bash
sudo systemctl edit nginx
#[Service]
#NoNewPrivileges=yes
#PrivateTmp=yes
#ProtectSystem=strict
#ProtectHome=yes
#ProtectClock=yes
#ProtectKernelTunables=yes
#ProtectKernelModules=yes
#ProtectControlGroups=yes
#RestrictAddressFamilies=AF_UNIX AF_INET
#ReadWritePaths=/var/log/nginx /var/lib/nginx /var/cache/nginx /run/nginx
#LockPersonality=yes
#CapabilityBoundingSet=
```

### 18. Manage Logs and Permissions

```bash
sudo mkdir -p /var/log/nginx /var/lib/nginx /var/cache/nginx /run/nginx
sudo chown -R root:adm /var/log/nginx
sudo chmod 750 /var/log/nginx
sudo touch /var/log/nginx/error.log /var/log/nginx/access.log
sudo chown root:adm /var/log/nginx/error.log
sudo chown root:adm /var/log/nginx/access.log
sudo chmod 640 /var/log/nginx/error.log
sudo chmod 640 /var/log/nginx/access.log
sudo chown -R www-data:www-data /var/lib/nginx /var/cache/nginx /run/nginx
sudo rm -f /etc/nginx/sites-available/default
sudo rm -f /etc/nginx/sites-enabled/default
```

### 19. Restart NGINX

```bash
sudo systemctl daemon-reexec
sudo systemctl restart nginx
```

## Maintenance

### 20. System Updates and Tor Restart

```bash
sudo apt update && sudo apt -y upgrade
sudo systemctl restart tor
```

### 21. Check Service Logs

```bash
journalctl -u tor -u nginx -u app.service --no-pager
```

---

This guide should help set up and maintain your server with secure configurations for both RoutePeel and RouteSeed services. Be sure to replace the `${REDACTED_*}` placeholders with the appropriate values before executing commands.
