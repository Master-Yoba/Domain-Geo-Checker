#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 domain.com"
  exit 1
fi

DOMAIN="$1"

# Resolve IPv4 addresses
IPS=$(dig +short A "$DOMAIN" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

if [ -z "$IPS" ]; then
  echo "No IPv4 addresses found for $DOMAIN"
  exit 1
fi

echo "Results for domain: $DOMAIN"
echo "-------------------------------------------------------------------------"
printf "%-15s | %-8s | %-15s | %-8s | %s\n" "IP" "Country" "City" "ASN" "Holder"
echo "-------------------------------------------------------------------------"

function lookup_ip {
  GEO_URL="https://stat.ripe.net/data/maxmind-geo-lite/data.json?resource=$1"
  RIR_GEO_URL="https://stat.ripe.net/data/rir-geo/data.json?resource=$1"
  ASN_URL="https://stat.ripe.net/data/prefix-overview/data.json?resource=$1"

  GEO_JSON=$(curl -s "$GEO_URL")
  ASN_JSON=$(curl -s "$ASN_URL")

  COUNTRY=$(echo "$GEO_JSON" | jq -r '.data.located_resources[0].locations[0].country // empty')

  if [ -z "$COUNTRY" ] || [ "$COUNTRY" == "null" ] || [ "$COUNTRY" == "?" ]; then
    RIR_GEO_JSON=$(curl -s "$RIR_GEO_URL")
    COUNTRY=$(echo "$RIR_GEO_JSON" | jq -r '.data.located_resources[0].location // "-"')
  fi

  [ -z "$COUNTRY" ] && COUNTRY="-"

  CITY=$(echo "$GEO_JSON" | jq -r '.data.located_resources[0].locations[0].city // "-"')
  [ -z "$CITY" ] && CITY="-"

  ASN=$(echo "$ASN_JSON" | jq -r '.data.asns[0].asn // "-"')
  HOLDER=$(echo "$ASN_JSON" | jq -r '.data.asns[0].holder // "-"')

  printf "%-15s | %-8s | %-15s | %-8s | %s\n" "$1" "$COUNTRY" "$CITY" "$ASN" "$HOLDER"
}

for IP in $IPS; do
  lookup_ip $IP
done

echo "-------------------------------------------------------------------------"
