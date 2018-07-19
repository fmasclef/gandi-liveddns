#!/bin/bash

# source config file
source gandi-liveddns.conf
# get current wan address
IPADDR=`dig +short myip.opendns.com @resolver1.opendns.com`
# get declared IP address for record
CURRENT=`dig +short ${RECORD}.${DOMAIN} @resolver1.opendns.com`

# update record if needed
if [ ! "${CURRENT}" == "${IPADDR}" ]
then
  curl -X PUT \
       -H "Content-Type: application/json" \
       -H "X-Api-Key: ${APIKEY}" \
       -d "{\"rrset_ttl\": 10800, \"rrset_values\":[\"${IPADDR}\"]}" \
       https://dns.api.gandi.net/api/v5/domains/${DOMAIN}/records/${RECORD}/${TYPE}
fi
