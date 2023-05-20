#!/bin/sh

echo "Building $NUMBER_OF_CONNECTIONS connections starting at port $STARTING_PORT_NUMBER"

# Remove any existing connections first
sed -i '/^  server/d' /usr/etc/haproxy/haproxy.cfg
sed -i '/^ SocksPort/d' /usr/etc/tor/torrc

# Build new connections
i=0
while [ $i -le "$NUMBER_OF_CONNECTIONS" ]; do
  PORT=$((STARTING_PORT_NUMBER + i))
  echo "  server $PORT 127.0.0.1:$PORT check inter 15s fall 1 rise 1" >> /usr/etc/haproxy/haproxy.cfg
  echo " SocksPort 0.0.0.0:$PORT" >> /usr/etc/tor/torrc
  i=$(( i + 1 ))
done
