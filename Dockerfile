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
    apk -v add --no-cache curl tor@edge obfs4proxy@edge haproxy@edge privoxy@edge

COPY --chown=tor:root torrc /usr/etc/tor/
COPY --chown=tor:root haproxy.cfg /usr/etc/haproxy/
COPY --chown=tor:root privoxy.cfg /usr/etc/privoxy/
COPY --chown=tor:root entrypoint.sh /usr/local/bin/
COPY --chown=tor:root connection_check_amazon.sh /usr/local/bin/

RUN chmod 700 /var/lib/tor && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/connection_check_amazon.sh

USER tor

EXPOSE 80 8118

CMD ["entrypoint.sh"]