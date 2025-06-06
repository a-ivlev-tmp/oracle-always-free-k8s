#!/bin/bash

[ -f "$1" ] || exit

if [[ $1 =~ \.(crt|pem)$ ]]; then
 openssl x509 -in "$1" -text -noout
fi

if [[ $1 =~ \.conf$ ]]; then
 certfile=$(mktemp)
 grep 'client-certificate-data:' "$1"| awk '{ print $2}' | base64 -d > "$certfile"
 openssl x509 -in "$certfile" -text -noout
 rm -f "$certfile"
fi