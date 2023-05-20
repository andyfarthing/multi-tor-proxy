#!/bin/sh

echo "Creating $NUMBER_OF_CONNECTIONS connections starting at port $STARTING_PORT_NUMBER"

i=0
while [ $i -le "$NUMBER_OF_CONNECTIONS" ]; do
  PORT=$((STARTING_PORT_NUMBER + i))
  echo "  server connection-$i 127.0.0.1:$PORT check inter 15s fall 1 rise 1" >> /usr/etc/haproxy/haproxy.cfg
  echo " SocksPort 0.0.0.0:$PORT" >> /usr/etc/tor/torrc
  i=$(( i + 1 ))
done

haproxy -f /usr/etc/haproxy/haproxy.cfg && privoxy /usr/etc/privoxy/privoxy.cfg && tor -f /usr/etc/tor/torrc
