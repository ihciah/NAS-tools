FROM alpine:latest

LABEL maintainer "ihciah <ihciah@gmail.com>"

COPY ./overture  /bin/overture

RUN set -ex && \
    apk --no-cache add ca-certificates && \
    chmod +x /bin/overture

ENV PATH /bin:$PATH

CMD ["overture", "-c", "/etc/overture/config.json"]

