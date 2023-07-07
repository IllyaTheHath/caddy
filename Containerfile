FROM golang:1.20 as build

ENV CADDY_VERSION="v2.6.4"

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest \
    && xcaddy build \
        --with github.com/caddy-dns/cloudflare \
        --with github.com/caddy-dns/dnspod \
        --with github.com/caddy-dns/route53 \
        --with github.com/mholt/caddy-l4 \
        --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive \
        --output caddy

FROM alpine:latest

COPY --from=build /go/caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]

CMD ["run", "--config", "/etc/caddy/Caddyfile"]
