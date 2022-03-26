FROM caddy:2.4.6-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-webdav

FROM caddy:2.4.6

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN adduser -D caddy && wget https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64 -O /usr/local/bin/gosu && chmod +x /usr/local/bin/gosu

CMD set -xe && \
        /usr/local/bin/gosu caddy caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
