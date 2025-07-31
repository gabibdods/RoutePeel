# Deep Web Exploration with Tails and Tor Relays

# Private Cybersecurity Field Test: Exploring Onion Services via Tails OS

### Description

- A self-contained cybersecurity lab designed to explore and safely interact with .onion websites using Tails OS, Tor relays, and digital signature verification practices
- The project includes configuring a secure USB boot drive, verifying image integrity with OpenPGP, and browsing anonymously via DuckDuckGo’s onion mirror

---

## NOTICE

- Please read through this `README.md` to better understand the project's source code and setup instructions
- Also, make sure to review the contents of the `License/` directory
- Your attention to these details is appreciated — enjoy exploring the project!

---

## Problem Statement

- Theoretical knowledge of Tor and privacy tools is not enough — hands-on application is crucial for real cybersecurity learning
- This project was created to gain practical experience with anonymous browsing, system-level privacy measures, and relay-based routing

---

## Project Goals

### Securely Access Onion Websites

- Establish connections to onion services through layered Tor relays and verify functionality using DuckDuckGo’s hidden service

### Use Tails OS for Anonymity

- Operate within a bootable Linux distribution (Tails) designed for non-persistent, encrypted, and anonymous computing

---

## Tools, Materials & Resources

### Tools

- Tor Browser, Tails OS, Balena Etcher, OpenPGP

### Materials

- USB boot drive (min. 8GB), Tails ISO image, .sig verification file

### Resources

- [tails.net](https://tails.net), David Bombal tutorials, TCM Security training, OpenPGP documentation

---

## Design Decision

### Use Tails Instead of Installing Tor Locally

- Ensures a clean, ephemeral OS each boot, dramatically reducing digital traceability

### Flash and Verify the OS with Balena Etcher + OpenPGP

- Verifies authenticity of the ISO and builds confidence in OS trustworthiness

### Limit Exploration to DuckDuckGo’s Onion Mirror

- Demonstrates functional access while minimizing risk by using a reputable onion service

---

## Features

### Anonymous Boot Environment

- All system state runs from memory and is erased upon shutdown

### Verified System Integrity

- ISO signature verification prevents tampered OS installation

### Live .onion Browsing via Tor

- Full support for secure, multi-relay access to the dark web

---

## Block Diagram

### Tails + Tor Browsing Architecture

```plaintext
+--------------------------+
|  Bootable USB Drive      |
|  (Tails OS Environment)  |
+-----------+--------------+
            |
            v
+--------------------------+
|     Tails OS Boots       |
| RAM-based, non-persistent|
+-----------+--------------+
            |
            v
+--------------------------+
|   Tor Browser Launches   |
|   Built-in to Tails OS   |
+-----------+--------------+
            |
            v
+--------------------------+
| Connect to Tor Network   |
| - Entry Guard Node       |
| - Middle Relay Node      |
| - Exit Node (N/A for .onion) |
+-----------+--------------+
            |
            v
+--------------------------+
| .onion Request Routed    |
|  via Hidden Service Dir  |
+-----------+--------------+
            |
            v
+--------------------------+
| DuckDuckGo .onion Server |
| (3g2upl4pq6kufc4m.onion) |
+--------------------------+

```

---

## Functional Overview

- The reader prepares a Tails boot drive, verifies it, connects to the Tor network, and explores .onion services from a live session environment with no local persistence

---

## Challenges & Solutions

### Understanding how to verify the authenticity of downloaded ISO files

- Used OpenPGP signatures provided by the Tails developers to validate the download

### Configuring BIOS/UEFI settings to recognize the USB drive

- Used Balena Etcher and consulted Tails boot documentation to ensure compatibility

---

## Lessons Learned

### Security Procedures in Practice

- Gained a real understanding of Tor routing layers, encrypted traffic, and .onion address resolution through experimentation

### Verified Boot Hygiene

- Importance of boot-only OS designs for privacy — no residual data or file traces after shutdown

---

## Project Structure

```plaintext
root/
├── License/
│   ├── LICENSE.md
│   │
│   └── NOTICE.md
│
├── .gitattributes
│
├── .gitignore
│
└── README.md

```

---

## Future Enhancements

- Create a basic .onion service for hosting anonymous content
- Configure and run a non-exit relay node on a remote VPS
- Test Whonix and Qubes OS as alternatives to Tails
- Conduct penetration testing inside isolated environments (Metasploit, Nmap)
