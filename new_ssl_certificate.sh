#!/usr/bin/env bash

echo "Enter domain:"
read name

sudo certbot certonly --server https://acme-v02.api.letsencrypt.org/directory --manual --preferred-challenge dns -d $name