FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends tor ca-certificates dumb-init && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/tor && chown -R debian-tor:debian-tor /var/lib/tor

COPY tor-entrypoint.sh /usr/local/bin/tor-entrypoint

RUN chmod +x /usr/local/bin/tor-entrypoint

USER debian-tor:debian-tor

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/tor-entrypoint"]
