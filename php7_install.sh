#!/usr/bin/env bash

# update
yum -y update

# set version of php to install
# check opcache extension directory if you change this
phpVersion='7.2.9'

# install dependencies
yum -y groupinstall "Development Tools"
yum -y install wget
yum -y install libcurl-devel
yum -y install libicu-devel
yum -y install libxml2-devel
yum -y install libpng-devel
yum -y install libjpeg-devel
yum -y install openssl-devel

# create working directory
mkdir working
cd working
workingDir=`pwd`

# install bzip
wget -O bzip.tar.gz http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
tar -zxvf bzip.tar.gz
cd bzip2-1.0.6
make
make install
cd ..

# install php
wget -O php.tar.gz http://us2.php.net/get/php-$phpVersion.tar.gz/from/this/mirror
tar -zxvf php.tar.gz
cd php-$phpVersion
./configure --with-curl --with-mysqli --with-pdo-mysql --with-openssl --with-bz2 --with-zlib --with-gd --enable-zip --enable-fpm --enable-mbstring --enable-intl --enable-opcache
make
make install

# update php configuration
# check timezone and set specific parameters here
# can be updated after install
file='php.ini-production'

repl='upload_max_filesize = 2M'
with='upload_max_filesize = 1024M'
sed -i "s/$repl/$with/g" $file

repl='post_max_size = 8M'
with='post_max_size = 1024M'
sed -i "s/$repl/$with/g" $file

repl='memory_limit = 128M'
with='memory_limit = 1024M'
sed -i "s/$repl/$with/g" $file

repl=';date.timezone ='
with='date.timezone = America\/New_York'
sed -i "s/$repl/$with/g" $file

repl='error_reporting = E_ALL \& \~E_DEPRECATED \& \~E_STRICT'
with='error_reporting = E_ALL \& \~E_NOTICE'
sed -i "s/$repl/$with/g" $file

repl='display_errors = Off'
with='display_errors = On'
sed -i "s/$repl/$with/g" $file

echo 'zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/opcache.so' >> $file

file='/usr/local/etc/php-fpm.conf.default'

repl='include=NONE\/etc\/php-fpm.d\/\*.conf'
with='include=\/usr\/local\/etc\/php-fpm.d\/\*.conf'
sed -i "s/$repl/$with/g" $file


file='/usr/local/etc/php-fpm.d/www.conf.default'

repl='user = nobody'
with='user = nginx'
sed -i "s/$repl/$with/g" $file

repl='group = nobody'
with='group = nginx'
sed -i "s/$repl/$with/g" $file

# copy new config file to application directory
cp php.ini-production /usr/local/lib/php.ini
cp sapi/fpm/php-fpm /usr/local/sbin
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf
cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf

chmod +x /etc/init.d/php-fpm

# navigate back to starting directory
cd $workingDir
cd ..
echo -e "all done, you may delete working directory\n $workingDir"

# enable php-fpm service
/sbin/chkconfig php-fpm on
