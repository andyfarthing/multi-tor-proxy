FROM alpine:3.21.3
LABEL maintainer="Andy Farthing <contact@andyfarthing.com>"
LABEL name="tor-multi-proxy"
LABEL version="1.0.1"

ENV NUMBER_OF_CONNECTIONS=5
ENV STARTING_PORT_NUMBER=9050

RUN echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/testing'   >> /etc/apk/repositories && \
    apk -U update && \
    apk -U upgrade && \
    apk -v add --no-cache curl tor@edge obfs4proxy@edge haproxy@edge privoxy@edge dumb-init

COPY --chown=tor:root torrc /usr/etc/tor/
COPY --chown=tor:root haproxy.cfg /usr/etc/haproxy/
COPY --chown=tor:root privoxy.cfg /usr/etc/privoxy/
COPY --chown=tor:root build_connections.sh /usr/local/bin/
COPY --chown=tor:root connection_check_amazon.sh /usr/local/bin/

RUN chmod 700 /var/lib/tor && \
    chmod +x /usr/local/bin/build_connections.sh && \
    chmod +x /usr/local/bin/connection_check_amazon.sh

USER tor

EXPOSE 80 8118

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["sh", "-c", "/usr/local/bin/build_connections.sh && haproxy -f /usr/etc/haproxy/haproxy.cfg && privoxy /usr/etc/privoxy/privoxy.cfg && tor -f /usr/etc/tor/torrc"]
