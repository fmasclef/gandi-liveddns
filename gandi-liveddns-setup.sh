#!/bin/bash

printf "Gandi LiveDNS API key: "
read APIKEY
printf "Domain:                "
read DOMAIN
printf "Hostname:              "
read RECORD
printf "Record type:           "
read TYPE

echo "# gandi-liveddns configuration file
# https://github.com/fmasclef/gandi-liveddns
APIKEY=${APIKEY}
DOMAIN=${DOMAIN}
RECORD=${RECORD}
TYPE=${TYPE}
" > gandi-liveddns.conf
