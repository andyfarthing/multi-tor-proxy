#!/bin/sh

DOMAIN="amazon.co.uk"

RESPONSE=$(
    curl https://www.${DOMAIN} \
    --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" \
    --header "Accept-Encoding: gzip, deflate, br" \
    --header "Accept-Language: en-GB,en;q=0.5" \
    --header "Connection: keep-alive" \
    --header "DNT: 1" \
    --header "Host: www.${DOMAIN}" \
    --header "Origin: https://www.${DOMAIN}" \
    --header "Referer: https://www.${DOMAIN}/" \
    --header "Sec-Fetch-Dest: document" \
    --header "Sec-Fetch-Mode: navigate" \
    --header "Sec-Fetch-Site: same-origin" \
    --header "Sec-Fetch-User: ?1" \
    --header "TE: trailers" \
    --header "Upgrade-Insecure-Requests: 1" \
    --header "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/112.0" \
    --compressed \
    --proxy "http://${HAPROXY_SERVER_ADDR}:${HAPROXY_SERVER_PORT}"
  )

if echo "${RESPONSE}" | grep -q "/errors/validateCaptcha"; then
  echo "Captcha detected"
  exit 1
else
  echo "No captcha detected"
  exit 0
fi
