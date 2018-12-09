#!/bin/bash

printf "Gandi LiveDNS API key: "
read APIKEY
printf "Domain:                "
read DOMAIN
printf "Hostname:              "
read RECORD

echo "# gandi-liveddns configuration file
# https://github.com/fmasclef/gandi-liveddns
APIKEY=${APIKEY}
DOMAIN=${DOMAIN}
RECORD=${RECORD}
" > gandi-liveddns.conf
