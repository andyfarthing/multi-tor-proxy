#!/bin/sh

echo "Creating $NUMBER_OF_CONNECTIONS connections starting at port $STARING_PORT_NUMBER"

i=0
while [ $i -le "$NUMBER_OF_CONNECTIONS" ]; do
  PORT=$((STARING_PORT_NUMBER + i))
  echo "  server connection-$i 127.0.0.1:$PORT check inter 15s fall 1 rise 1" >> /etc/haproxy/haproxy.cfg
  echo "HTTPTunnelPort 0.0.0.0:$PORT" >> /etc/tor/torrc
  i=$(( i + 1 ))
done

haproxy -f /etc/haproxy/haproxy.cfg && tor -f /etc/tor/torrc
