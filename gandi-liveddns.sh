#!/bin/bash

#
# Gandi LiveDDNS
#
# This script will update A  and AAAA records on Gandi.net LiveDNS.  This is a
# dynamic DNS alternative intended for those who need their own domain name to
# point to a residential rolling IP address.
#
# Run this script once to configure it and add a cron job. Then forget it.
#
# https://github.com/fmasclef/gandi-liveddns
#
# CC BY-NC-ND 4.0
#


#
# variables
#

LIVE_API=
LIVE_FQDNS=
ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


#
# helper functions
#

setup() {
  echo "Gandi LiveDDNS setup"
  read -p "Gandi.net LiveDNS API key [${LIVE_API}]: " TEMP_API
  read -p "Space separated FQDNs [${LIVE_FQDNS}]: " TEMP_FQDNS
  echo "# gandi-liveddns configuration file
# https://github.com/fmasclef/gandi-liveddns
LIVE_API=${TEMP_API:-${LIVE_API}}
LIVE_FQDNS='${TEMP_FQDNS:-${LIVE_FQDNS}}'
" > ${DIR}/.config
  source ${DIR}/.config
  (crontab -l ; echo "*/5 * * * * ${ABSOLUTE_PATH}") | sort - | uniq - | crontab -
}

# @param: FQDN
# @param: record type (A|AAAA)
# @param: IP address
updateRecord() {
  echo "update $2 record for $1 with addr $3"
  curl -s -X PUT \
    -H "Content-Type: application/json" \
    -H "X-Api-Key: ${LIVE_API}" \
    -d "{\"rrset_ttl\": 300, \"rrset_values\":[\"${3}\"]}" \
    https://dns.api.gandi.net/api/v5/domains/${1#*.*}/records/${fqdn%%.*}/${2} \
    > /dev/null
}

# @param: FQDN
# @param: record type (A|AAAA)
deleteRecord() {
  echo "delete $2 record for $1"
  curl -s -X DELETE \
    -H "Content-Type: application/json" \
    -H "X-Api-Key: ${LIVE_API}" \
    https://dns.api.gandi.net/api/v5/domains/${1#*.*}/records/${fqdn%%.*}/${2} \
    > /dev/null
}

#
# main script
#

# source config file if exists, otherwise run setup
if [ -f ${DIR}/.config ]
then
  source ${DIR}/.config
else
  setup
fi

# if --reconfigure is passed, run setup
for i in "$@" ; do [[ $i == "--reconfigure" ]] && setup && break ; done

# die if no API key or FQDNs provided
if [ -z "${LIVE_API}" ]; then echo "No API key provided. Please reconfigure."; exit 1; fi
if [ -z "${LIVE_FQDNS}" ]; then echo "No FQDN provided. Please reconfigure."; exit 1; fi

# get current IPv4 and IPv6 address
IPv4=`dig myip.opendns.com A -4 +short +tries=2 +time=3 @resolver1.opendns.com`
IPv6=`dig myip.opendns.com AAAA -6 +short +tries=2 +time=3 @resolver1.opendns.com`
echo "> $IPv4 $IPv6"

# loop thru FQDNs and perform relevant API calls
for fqdn in ${LIVE_FQDNS}; do
  # get declared records
  RND=$(( ( RANDOM % 3 )  + 1 ))
  cIPv4=`dig ${fqdn} A -4 +short +tries=2 +time=3 @ns${RND}.gandi.net`
  cIPv6=`dig ${fqdn} AAAA -6 +short +tries=2 +time=3 @ns${RND}.gandi.net`
  echo "< $cIPv4 $cIPv6"

  # update IPv4 if needed
  if [ "${IPv4}" != "${cIPv4}" ]
  then
    if [ -z "${IPv4}" ]; then deleteRecord ${fqdn} 'A'; else updateRecord ${fqdn} 'A' ${IPv4}; fi
  fi
  # update IPv6 if needed
  if [ "${IPv6}" != "${cIPv6}" ]
  then
    if [ -z "${IPv6}" ]; then deleteRecord ${fqdn} 'AAAA'; else updateRecord ${fqdn} 'AAAA' ${IPv6}; fi
  fi
done

