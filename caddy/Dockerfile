FROM caddy:2.10.0-builder AS builder

RUN XCADDY_SETCAP=1 xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-webdav

FROM caddy:2.10.0

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN adduser -D caddy && wget https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64 -O /usr/local/bin/gosu && chmod +x /usr/local/bin/gosu

CMD set -xe && \
        /usr/local/bin/gosu caddy caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
