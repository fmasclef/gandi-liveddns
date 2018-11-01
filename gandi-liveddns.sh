#!/bin/bash

# source config file
source gandi-liveddns.conf
# get current wan address
IPv4=`dig myip.opendns.com A +short @resolver1.opendns.com`
IPv6=`dig myip.opendns.com AAAA +short @resolver1.opendns.com`
# get declared IP address for record
RECORDv4=`dig ${RECORD}.${DOMAIN} A +short @resolver1.opendns.com`
RECORDv6=`dig ${RECORD}.${DOMAIN} AAAA +short @resolver1.opendns.com`

echo "v4: $IPv4 | $RECORDv4"
echo "v6: $IPv6 | $RECORDv6"

if [ "${IPv4}" == "" ]
then
  echo "Remove A record"
  curl -X DELETE \
       -H "Content-Type: application/json" \
       -H "X-Api-Key: ${APIKEY}" \
       https://dns.api.gandi.net/api/v5/domains/${DOMAIN}/records/${RECORD}/A
else
  echo "Update A record"
  if [ ! "${RECORDv4}" == "${IPv4}" ]
  then
     curl -X PUT \
       -H "Content-Type: application/json" \
       -H "X-Api-Key: ${APIKEY}" \
       -d "{\"rrset_ttl\": 10800, \"rrset_values\":[\"${IPv4}\"]}" \
       https://dns.api.gandi.net/api/v5/domains/${DOMAIN}/records/${RECORD}/A
  fi
fi

if [ "${IPv6}" == "" ]
then
  echo "Remove AAAA record"
  curl -X DELETE \
       -H "Content-Type: application/json" \
       -H "X-Api-Key: ${APIKEY}" \
       https://dns.api.gandi.net/api/v5/domains/${DOMAIN}/records/${RECORD}/AAAA
else
  echo "Update AAAA record"
  if [ ! "${RECORDv6}" == "${IPv6}" ]
  then
     curl -X PUT \
       -H "Content-Type: application/json" \
       -H "X-Api-Key: ${APIKEY}" \
       -d "{\"rrset_ttl\": 10800, \"rrset_values\":[\"${IPv6}\"]}" \
       https://dns.api.gandi.net/api/v5/domains/${DOMAIN}/records/${RECORD}/AAAA
  fi
fi
