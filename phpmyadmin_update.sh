#!/usr/bin/env bash

# update phpmyadmin
cd /var/www/phpmyadmin
composer update

# set permissions
chown -R nginx:nginx /var/www/phpmyadmin
chmod -R 755 /var/www/phpmyadmin