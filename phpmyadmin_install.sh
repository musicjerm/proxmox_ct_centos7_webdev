#!/usr/bin/env bash

# create www directory if it does not already exist
if [ ! -d "/var/www" ]; then
    mkdir /var/www
fi

# back up default nginx conf
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.confbak

# get hostname and copy nginx config
echo "Enter hostname:"
read hostname

sed -i "s/HOSTNAME/$hostname/g" ./phpmyadmin.conf
mv ./phpmyadmin.conf /etc/nginx/conf.d/default.conf

# install phpmyadmin
cd /var/www
composer create-project phpmyadmin/phpmyadmin

# update phpmyadmin
cd phpmyadmin
composer update

# set permissions
chown -R nginx:nginx /var/www/phpmyadmin
chmod -R 755 /var/www/phpmyadmin

# echo complete message
echo "All done, run \"nginx -t\" to test config - then \"systemctl restart nginx\"."
echo "Navigate to $hostname/setup to configure server(s)."