FROM alpine:edge

MAINTAINER ihciah <ihciah@gmail.com>
COPY ./script /script
RUN set -xe && \
        apk update && \
        apk add --no-cache --update aria2 && \
        apk add --no-cache --update python3 && \
        apk add --no-cache --update py3-pip && \
        pip3 install subtitle && \
        aria2c https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64 -o /usr/local/bin/gosu && \
        chmod +x /usr/local/bin/gosu && \
        adduser -D aria2 && \
	chmod +x /script/*.sh 

VOLUME /data /aria2-data /etc/aria2

CMD set -xe && \
        gosu aria2 touch /aria2-data/aria2.session && \
        gosu aria2 aria2c --conf-path=/etc/aria2/aria2.conf \
                        --dir=/data \
                        --on-bt-download-complete=/script/bt-complete.sh \
                        --on-download-complete=/script/complete.sh \
                        --on-download-error=/script/error.sh \
                        --on-download-pause=/script/pause.sh \
                        --on-download-start=/script/start.sh \ 
                        --on-download-stop=/script/stop.sh

