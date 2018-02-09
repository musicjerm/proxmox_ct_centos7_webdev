#!/usr/bin/env bash

# update
yum -y update

# install dependencies
yum -y groupinstall "Development Tools"

# add repo
echo "# Nginx repo for Centos 7" > /etc/yum.repos.d/nginx.repo
echo "[nginx]" >> /etc/yum.repos.d/nginx.repo
echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
echo "baseurl=http://nginx.org/packages/centos/y/\$basearch/" >> /etc/yum.repos.d/nginx.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
echo "enabled=1" >> /etc/yum.repos.d/nginx.repo

# install nginx
yum -y install nginx

# enable nginx
systemctl enable nginx

# create dhparam for secure SSL
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# create directory for ssl cert
mkdir /etc/ssl/private

# create self-signed ssl cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt