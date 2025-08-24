#!/bin/sh -eu

PROJECT="${PROJECT}"
HIDDEN_SERVICE_PORT="${HIDDEN_SERVICE_PORT}"
SEED_HOST="${SEED_HOST}"
SEED_PORT="${SEED_PORT}"

TORRC="/var/lib/tor/torrc"

mkdir -p /var/lib/tor/${PROJECT}
chmod 0700 "/var/lib/tor/${PROJECT}"

cat > "$TORRC" <<EOF
RunAsDaemon 0
Log notice stderr
DataDirectory /var/lib/tor

SafeLogging 1
Sandbox 1
ClientUseIPv6 0
SocksPort 0

HiddenServiceDir /var/lib/tor/${PROJECT}
HiddenServiceVersion 3
HiddenServicePort ${HIDDEN_SERVICE_PORT} ${SEED_HOST}:${SEED_PORT}
EOF

exec /usr/bin/tor -f "$TORRC"
