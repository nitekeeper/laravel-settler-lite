#!/usr/bin/bash

read -p "Enter PHP version (7.4 | 8.0 | 8.1 | 8.2): " _PHP_VERSION
read -p "Choose the type of your webserver (apache | nginx): " SERVER_TYPE
read -p "Do you want to enable XDEBUG? (yes | no): " ENABLE_XDEBUG

sudo systemctl disable apache2
sudo systemctl disable nginx

sudo systemctl disable php7.4-fpm
sudo systemctl disable php8.0-fpm
sudo systemctl disable php8.1-fpm
sudo systemctl disable php8.2-fpm

if [ "$_PHP_VERSION" = "7.4" ]
then
    PHP_VERSION=7.4
elif [ "$_PHP_VERSION" = "8.0" ]
then
    PHP_VERSION=8.0
elif [ "$_PHP_VERSION" = "8.1" ]
then
    PHP_VERSION=8.1
else
    PHP_VERSION=8.2
fi

sudo systemctl enable php$PHP_VERSION-fpm

sudo update-alternatives --set php /usr/bin/php$PHP_VERSION
sudo update-alternatives --set php-config /usr/bin/php-config$PHP_VERSION
sudo update-alternatives --set phpize /usr/bin/phpize$PHP_VERSION
sudo update-alternatives --set php-cgi /usr/bin/php-cgi$PHP_VERSION
sudo update-alternatives --set phpdbg /usr/bin/phpdbg$PHP_VERSION

if [ "$ENABLE_XDEBUG" = "yes" ]
then    
    sudo phpenmod xdebug opcache
else
    sudo phpdismod xdebug opcache
fi

if [ "$SERVER_TYPE" = "nginx" ]
then
    sudo systemctl enable nginx
else
    sudo systecmtl enable apache2
fi
