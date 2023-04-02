FROM alpine:3.17
LABEL maintainer="Andy Farthing <contact@andyfarthing.com>"
LABEL name="tor-multi-proxy"
LABEL version="1.0.0"

ENV NUMBER_OF_CONNECTIONS=5
ENV STARING_PORT_NUMBER=9050

RUN echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/testing'   >> /etc/apk/repositories && \
    apk -U update && \
    apk -U upgrade && \
    apk -v add --no-cache tor@edge obfs4proxy@edge haproxy@edge

COPY --chown=tor:root torrc /etc/tor
COPY --chown=tor:root haproxy.cfg /etc/haproxy
COPY --chown=tor:root entrypoint.sh /usr/local/bin

RUN chmod 700 /var/lib/tor && \
    chmod +x /usr/local/bin/entrypoint.sh

USER tor

EXPOSE 80 16859

CMD ["entrypoint.sh"]