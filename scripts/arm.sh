#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

sudo mv /home/vagrant/select-php.sh /usr/local/bin/select-php
sudo chmod u+x /usr/local/bin/select-php

ARCH=$(arch)

SKIP_PHP=false
SKIP_MYSQL=false
DEFAULT_PHP_VERSION=8.1

echo "### Settler Build Configuration ###"
echo "ARCH             = ${ARCH}"
echo "SKIP_PHP         = ${SKIP_PHP}"
echo "SKIP_MYSQL       = ${SKIP_MYSQL}"
echo "### Settler Build Configuration ###"

# Update Package List
apt-get update

# Update System Packages
apt-get upgrade -y

# Force Locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8

apt-get install -y software-properties-common curl gnupg debian-keyring debian-archive-keyring apt-transport-https ca-certificates net-tools

# Install Some PPAs
apt-add-repository ppa:ondrej/php -y

# NodeJS
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

## Update Package Lists
apt-get update -y

# Install Some Basic Packages
apt-get install -y build-essential dos2unix gcc git git-lfs libmcrypt4 libpcre3-dev libpng-dev chrony unzip make pv \
python3-pip re2c supervisor unattended-upgrades whois vim cifs-utils bash-completion zsh graphviz avahi-daemon tshark

# Set My Timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

if "$SKIP_PHP"; then
  echo "SKIP_PHP is being used, so we're not installing PHP"
else

  # Install Generic PHP packages
  apt-get install -y --allow-change-held-packages \
  php-imagick php-memcached php-redis php-xdebug php-dev imagemagick mcrypt

  # PHP 7.4
  apt-get install -y --allow-change-held-packages \
  php7.4 php7.4-bcmath php7.4-bz2 php7.4-cgi php7.4-cli php7.4-common php7.4-curl php7.4-dba php7.4-dev \
  php7.4-enchant php7.4-fpm php7.4-gd php7.4-gmp php7.4-imap php7.4-interbase php7.4-intl php7.4-json php7.4-ldap \
  php7.4-mbstring php7.4-mysql php7.4-odbc php7.4-opcache php7.4-pgsql php7.4-phpdbg php7.4-pspell php7.4-readline \
  php7.4-snmp php7.4-soap php7.4-sqlite3 php7.4-sybase php7.4-tidy php7.4-xdebug php7.4-xml php7.4-xmlrpc php7.4-xsl \
  php7.4-zip php7.4-imagick php7.4-memcached php7.4-redis

  # Configure php.ini for CLI
  sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/cli/php.ini
  sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/cli/php.ini
  sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.4/cli/php.ini
  sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.4/cli/php.ini

  # Configure Xdebug
  echo "xdebug.mode = debug" >> /etc/php/7.4/mods-available/xdebug.ini
  echo "xdebug.discover_client_host = true" >> /etc/php/7.4/mods-available/xdebug.ini
  echo "xdebug.client_port = 9003" >> /etc/php/7.4/mods-available/xdebug.ini
  echo "xdebug.max_nesting_level = 512" >> /etc/php/7.4/mods-available/xdebug.ini
  echo "opcache.revalidate_freq = 0" >> /etc/php/7.4/mods-available/opcache.ini

  # Configure php.ini for FPM
  sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/fpm/php.ini
  sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/fpm/php.ini
  sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.4/fpm/php.ini
  sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.4/fpm/php.ini
  sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.4/fpm/php.ini
  sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.4/fpm/php.ini
  sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.4/fpm/php.ini

  printf "[openssl]\n" | tee -a /etc/php/7.4/fpm/php.ini
  printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.4/fpm/php.ini
  printf "[curl]\n" | tee -a /etc/php/7.4/fpm/php.ini
  printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.4/fpm/php.ini

  # Configure FPM
  sed -i "s/user = www-data/user = vagrant/" /etc/php/7.4/fpm/pool.d/www.conf
  sed -i "s/group = www-data/group = vagrant/" /etc/php/7.4/fpm/pool.d/www.conf
  sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/7.4/fpm/pool.d/www.conf
  sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/7.4/fpm/pool.d/www.conf
  sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.4/fpm/pool.d/www.conf

  # PHP 8.0
  apt-get install -y --allow-change-held-packages \
  php8.0 php8.0-bcmath php8.0-bz2 php8.0-cgi php8.0-cli php8.0-common php8.0-curl php8.0-dba php8.0-dev \
  php8.0-enchant php8.0-fpm php8.0-gd php8.0-gmp php8.0-imap php8.0-interbase php8.0-intl php8.0-ldap \
  php8.0-mbstring php8.0-mysql php8.0-odbc php8.0-opcache php8.0-pgsql php8.0-phpdbg php8.0-pspell php8.0-readline \
  php8.0-snmp php8.0-soap php8.0-sqlite3 php8.0-sybase php8.0-tidy php8.0-xdebug php8.0-xml php8.0-xmlrpc php8.0-xsl \
  php8.0-zip php8.0-imagick php8.0-memcached php8.0-redis

  # Configure php.ini for CLI
  sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/cli/php.ini
  sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/cli/php.ini
  sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.0/cli/php.ini
  sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.0/cli/php.ini

  # Configure Xdebug
  echo "xdebug.mode = debug" >> /etc/php/8.0/mods-available/xdebug.ini
  echo "xdebug.discover_client_host = true" >> /etc/php/8.0/mods-available/xdebug.ini
  echo "xdebug.client_port = 9003" >> /etc/php/8.0/mods-available/xdebug.ini
  echo "xdebug.max_nesting_level = 512" >> /etc/php/8.0/mods-available/xdebug.ini
  echo "opcache.revalidate_freq = 0" >> /etc/php/8.0/mods-available/opcache.ini

  # Configure php.ini for FPM
  sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/fpm/php.ini
  sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/fpm/php.ini
  sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.0/fpm/php.ini
  sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.0/fpm/php.ini
  sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.0/fpm/php.ini
  sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.0/fpm/php.ini
  sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.0/fpm/php.ini

  printf "[openssl]\n" | tee -a /etc/php/8.0/fpm/php.ini
  printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.0/fpm/php.ini
  printf "[curl]\n" | tee -a /etc/php/8.0/fpm/php.ini
  printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.0/fpm/php.ini

  # Configure FPM
  sed -i "s/user = www-data/user = vagrant/" /etc/php/8.0/fpm/pool.d/www.conf
  sed -i "s/group = www-data/group = vagrant/" /etc/php/8.0/fpm/pool.d/www.conf
  sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/8.0/fpm/pool.d/www.conf
  sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/8.0/fpm/pool.d/www.conf
  sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.0/fpm/pool.d/www.conf

  # PHP 8.1
  apt-get install -y --allow-change-held-packages \
  php8.1 php8.1-bcmath php8.1-bz2 php8.1-cgi php8.1-cli php8.1-common php8.1-curl php8.1-dba php8.1-dev \
  php8.1-enchant php8.1-fpm php8.1-gd php8.1-gmp php8.1-imap php8.1-interbase php8.1-intl php8.1-ldap \
  php8.1-mbstring php8.1-mysql php8.1-odbc php8.1-opcache php8.1-pgsql php8.1-phpdbg php8.1-pspell php8.1-readline \
  php8.1-snmp php8.1-soap php8.1-sqlite3 php8.1-sybase php8.1-tidy php8.1-xdebug php8.1-xml php8.1-xmlrpc php8.1-xsl \
  php8.1-zip php8.1-imagick php8.1-memcached php8.1-redis

  # Configure php.ini for CLI
  sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/cli/php.ini
  sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/cli/php.ini
  sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/cli/php.ini
  sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/cli/php.ini

  # Configure Xdebug
  echo "xdebug.mode = debug" >> /etc/php/8.1/mods-available/xdebug.ini
  echo "xdebug.discover_client_host = true" >> /etc/php/8.1/mods-available/xdebug.ini
  echo "xdebug.client_port = 9003" >> /etc/php/8.1/mods-available/xdebug.ini
  echo "xdebug.max_nesting_level = 512" >> /etc/php/8.1/mods-available/xdebug.ini
  echo "opcache.revalidate_freq = 0" >> /etc/php/8.1/mods-available/opcache.ini

  # Configure php.ini for FPM
  sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/fpm/php.ini
  sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/fpm/php.ini
  sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.1/fpm/php.ini
  sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/fpm/php.ini
  sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.1/fpm/php.ini
  sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.1/fpm/php.ini
  sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/fpm/php.ini

  printf "[openssl]\n" | tee -a /etc/php/8.1/fpm/php.ini
  printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.1/fpm/php.ini
  printf "[curl]\n" | tee -a /etc/php/8.1/fpm/php.ini
  printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.1/fpm/php.ini

  # Configure FPM
  sed -i "s/user = www-data/user = vagrant/" /etc/php/8.1/fpm/pool.d/www.conf
  sed -i "s/group = www-data/group = vagrant/" /etc/php/8.1/fpm/pool.d/www.conf
  sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/8.1/fpm/pool.d/www.conf
  sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/8.1/fpm/pool.d/www.conf
  sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.1/fpm/pool.d/www.conf

  # PHP 8.2
  apt-get install -y --allow-change-held-packages \
  php8.2 php8.2-bcmath php8.2-bz2 php8.2-cgi php8.2-cli php8.2-common php8.2-curl php8.2-dba php8.2-dev \
  php8.2-enchant php8.2-fpm php8.2-gd php8.2-gmp php8.2-imap php8.2-interbase php8.2-intl php8.2-ldap \
  php8.2-mbstring php8.2-mysql php8.2-odbc php8.2-opcache php8.2-pgsql php8.2-phpdbg php8.2-pspell php8.2-readline \
  php8.2-snmp php8.2-soap php8.2-sqlite3 php8.2-sybase php8.2-tidy php8.2-xdebug php8.2-xml php8.2-xmlrpc php8.2-xsl \
  php8.2-zip php8.2-imagick php8.2-memcached php8.2-redis

  # Configure php.ini for CLI
  sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.2/cli/php.ini
  sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.2/cli/php.ini
  sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.2/cli/php.ini
  sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.2/cli/php.ini

  # Configure Xdebug
  echo "xdebug.mode = debug" >> /etc/php/8.2/mods-available/xdebug.ini
  echo "xdebug.discover_client_host = true" >> /etc/php/8.2/mods-available/xdebug.ini
  echo "xdebug.client_port = 9003" >> /etc/php/8.2/mods-available/xdebug.ini
  echo "xdebug.max_nesting_level = 512" >> /etc/php/8.2/mods-available/xdebug.ini
  echo "opcache.revalidate_freq = 0" >> /etc/php/8.2/mods-available/opcache.ini

  # Configure php.ini for FPM
  sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.2/fpm/php.ini
  sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.2/fpm/php.ini
  sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.2/fpm/php.ini
  sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.2/fpm/php.ini
  sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.2/fpm/php.ini
  sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.2/fpm/php.ini
  sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.2/fpm/php.ini

  printf "[openssl]\n" | tee -a /etc/php/8.2/fpm/php.ini
  printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.2/fpm/php.ini
  printf "[curl]\n" | tee -a /etc/php/8.2/fpm/php.ini
  printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.2/fpm/php.ini

  # Configure FPM
  sed -i "s/user = www-data/user = vagrant/" /etc/php/8.2/fpm/pool.d/www.conf
  sed -i "s/group = www-data/group = vagrant/" /etc/php/8.2/fpm/pool.d/www.conf
  sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/8.2/fpm/pool.d/www.conf
  sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/8.2/fpm/pool.d/www.conf
  sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.2/fpm/pool.d/www.conf

  # Disable old PHP FPM
  if [ $DEFAULT_PHP_VERSION != 7.4 ]
  then
    systemctl disable php7.4-fpm
  fi
  if [ $DEFAULT_PHP_VERSION != 8.0 ]
  then
    systemctl disable php8.0-fpm
  fi
  if [ $DEFAULT_PHP_VERSION != 8.1 ]
  then
    systemctl disable php8.1-fpm
  fi
  if [ $DEFAULT_PHP_VERSION != 8.2 ]
  then
    systemctl disable php8.2-fpm
  fi

  update-alternatives --set php /usr/bin/php$DEFAULT_PHP_VERSION
  update-alternatives --set php-config /usr/bin/php-config$DEFAULT_PHP_VERSION
  update-alternatives --set phpize /usr/bin/phpize$DEFAULT_PHP_VERSION
  update-alternatives --set php-cgi /usr/bin/php-cgi$DEFAULT_PHP_VERSION
  update-alternatives --set phpdbg /usr/bin/phpdbg$DEFAULT_PHP_VERSION

  # Install Composer
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  chown -R vagrant:vagrant /home/vagrant/.config

  # Install Global Packages
  sudo su vagrant << EOF
  /usr/local/bin/composer global require "laravel/envoy=^2.0"
  /usr/local/bin/composer global require "laravel/installer=^4.0.2"
EOF

  # Install Apache
  apt-get install -y apache2 libapache2-mod-fcgid
  sed -i "s/www-data/vagrant/" /etc/apache2/envvars

  # Enable FPM
  for _version in 7.4 8.0 8.1 8.2
  do
    a2enconf php$_version-fpm
  done

  # Assume user wants mode_rewrite support
  sudo a2enmod rewrite

  # Turn on HTTPS support
  sudo a2enmod ssl

  # Turn on proxy & fcgi
  sudo a2enmod proxy proxy_fcgi

  # Turn on headers support
  sudo a2enmod headers actions alias

  # Add Mutex to config to prevent auto restart issues
  if [ -z "$(grep '^Mutex posixsem$' /etc/apache2/apache2.conf)" ]
  then
      echo 'Mutex posixsem' | sudo tee -a /etc/apache2/apache2.conf
  fi

  a2dissite 000-default
  systemctl disable apache2

  # Install Nginx
  apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages nginx

  rm /etc/nginx/sites-enabled/default
  rm /etc/nginx/sites-available/default

  # Create a configuration file for Nginx overrides.
  mkdir -p /home/vagrant/.config/nginx
  chown -R vagrant:vagrant /home/vagrant
  touch /home/vagrant/.config/nginx/nginx.conf
  ln -sf /home/vagrant/.config/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

  # Setup Some PHP-FPM Options
  for _version in 7.4 8.0 8.1 8.2
  do
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/$_version/fpm/php.ini
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/$_version/fpm/php.ini
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/$_version/fpm/php.ini
    sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/$_version/fpm/php.ini
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/$_version/fpm/php.ini
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/$_version/fpm/php.ini
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/$_version/fpm/php.ini
    printf "[openssl]\n" | tee -a /etc/php/$_version/fpm/php.ini
    printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/$_version/fpm/php.ini
    printf "[curl]\n" | tee -a /etc/php/$_version/fpm/php.ini
    printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/$_version/fpm/php.ini
  done

  # Disable XDebug On The CLI
  sudo phpdismod -s cli xdebug

  # Set The Nginx & PHP-FPM User
  sed -i "s/user www-data;/user vagrant;/" /etc/nginx/nginx.conf
  sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf
  for _version in 7.4 8.0 8.1 8.2
  do
    sed -i "s/user = www-data/user = vagrant/" /etc/php/$_version/fpm/pool.d/www.conf
    sed -i "s/group = www-data/group = vagrant/" /etc/php/$_version/fpm/pool.d/www.conf
    sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/$_version/fpm/pool.d/www.conf
    sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/$_version/fpm/pool.d/www.conf
    sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/$_version/fpm/pool.d/www.conf
  done
  service nginx restart
  service php$DEFAULT_PHP_VERSION-fpm restart

  # Add Vagrant User To WWW-Data
  usermod -a -G www-data vagrant
  id vagrant
  groups vagrant

  # Add Composer Global Bin To Path
  printf "\nPATH=\"$(sudo su - vagrant -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile
fi

# Install Node
apt-get install -y nodejs
/usr/bin/npm install -g npm
/usr/bin/npm install -g gulp-cli
/usr/bin/npm install -g bower
/usr/bin/npm install -g yarn
/usr/bin/npm install -g grunt-cli

# Install SQLite
apt-get install -y sqlite3 libsqlite3-dev

if "$SKIP_MYSQL"; then
  echo "SKIP_MYSQL is being used, so we're not installing MySQL"
  apt-get install -y mysql-client
else
  # Install MySQL
  echo "mysql-server mysql-server/root_password password secret" | debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password secret" | debconf-set-selections
  apt-get install -y mysql-server

  # Configure MySQL 8 Remote Access and Native Pluggable Authentication
  cat > /etc/mysql/conf.d/mysqld.cnf << EOF
[mysqld]
bind-address = 0.0.0.0
default_authentication_plugin = mysql_native_password
EOF

  # Configure MySQL Password Lifetime
  echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf

  # Configure MySQL Remote Access
  sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
  service mysql restart

  export MYSQL_PWD=secret

  mysql --user="root" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';"
  mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
  mysql --user="root" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
  mysql --user="root" -e "CREATE USER 'homestead'@'%' IDENTIFIED BY 'secret';"
  mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'0.0.0.0' WITH GRANT OPTION;"
  mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'%' WITH GRANT OPTION;"
  mysql --user="root" -e "FLUSH PRIVILEGES;"
  mysql --user="root" -e "CREATE DATABASE homestead character set UTF8mb4 collate utf8mb4_bin;"

  sudo tee /home/vagrant/.my.cnf <<EOL
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_bin
EOL
  service mysql restart
fi

# Install Redis & Memcached
apt-get install -y redis-server memcached
systemctl enable redis-server
service redis-server start

# Install MailHog
apt-get -y install golang-go
ln -sf /usr/bin/go /usr/local/bin/go
sudo -u vagrant /usr/local/bin/go install github.com/mailhog/MailHog@latest

tee /etc/systemd/system/mailhog.service <<EOL
[Unit]
Description=Mailhog
After=network.target

[Service]
User=vagrant
ExecStart=/usr/bin/env /home/vagrant/go/bin/MailHog > /dev/null 2>&1 &

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable mailhog
sudo service mailhog restart

# Configure Supervisor
systemctl enable supervisor.service
service supervisor start

# Install & Configure Postfix
echo "postfix postfix/mailname string homestead.test" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
apt-get install -y postfix
sed -i "s/relayhost =/relayhost = [localhost]:1025/g" /etc/postfix/main.cf
/etc/init.d/postfix reload

# Update / Override motd
echo "export ENABLED=1"| tee -a /etc/default/motd-news
sed -i "s/motd.ubuntu.com/homestead.joeferguson.me/g" /etc/update-motd.d/50-motd-news
sed -i "s/motd.ubuntu.com/homestead.joeferguson.me/g" /etc/default/motd-news
rm -rf /var/cache/motd-news
rm -rf /etc/update-motd.d/10-help-text
rm -rf /etc/update-motd.d/50-landscape-sysinfo
rm -rf /etc/update-motd.d/99-bento
service motd-news restart
bash /etc/update-motd.d/50-motd-news --force

# One last upgrade check
apt-get upgrade -y

# Clean Up
apt -y autoremove
apt -y clean
chown -R vagrant:vagrant /home/vagrant
chown -R vagrant:vagrant /usr/local/bin

# Perform some cleanup from chef/bento packer_templates/ubuntu/scripts/cleanup.sh
echo "remove linux-headers"
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-headers' \
  | xargs apt-get -y purge;

echo "remove specific Linux kernels, such as linux-image-3.11.0-15-generic but keeps the current kernel and does not touch the virtual packages"
dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-image-.*-generic' \
    | grep -v "$(uname -r)" \
    | xargs apt-get -y purge;

echo "remove old kernel modules packages"
dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-modules-.*-generic' \
    | grep -v "$(uname -r)" \
    | xargs apt-get -y purge;

echo "remove linux-source package"
dpkg --list \
    | awk '{ print $2 }' \
    | grep linux-source \
    | xargs apt-get -y purge;

echo "remove docs packages"
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-doc$' \
    | xargs apt-get -y purge;

echo "remove obsolete networking packages"
apt-get -y purge ppp pppconfig pppoeconf

# Configure chronyd to fix clock-drift when VM-host sleeps/hibernates.
sed -i "s/^makestep.*/makestep 1 -1/" /etc/chrony/chrony.conf

echo "remove packages we don't need"
apt-get -y purge command-not-found friendly-recovery laptop-detect usbutils grub-legacy-ec2

# 22.04+ don't have this
echo "remove the fonts-ubuntu-font-family-console"
apt-get -y purge fonts-ubuntu-font-family-console || true;

# 21.04+ don't have this
echo "remove the installation-report"
apt-get -y purge popularity-contest installation-report || true;

echo "remove the console font"
apt-get -y purge fonts-ubuntu-console || true;

echo "removing command-not-found-data"
# 19.10+ don't have this package so fail gracefully
apt-get -y purge command-not-found-data || true;

# Exclude the files we don't need w/o uninstalling linux-firmware
echo "Setup dpkg excludes for linux-firmware"
cat <<_EOF_ | cat >> /etc/dpkg/dpkg.cfg.d/excludes
#BENTO-BEGIN
path-exclude=/lib/firmware/*
path-exclude=/usr/share/doc/linux-firmware/*
#BENTO-END
_EOF_

echo "delete the massive firmware files"
rm -rf /lib/firmware/*
rm -rf /usr/share/doc/linux-firmware/*

echo "autoremoving packages and cleaning apt data"
apt-get -y autoremove;
apt-get -y clean;

echo "remove /usr/share/doc/"
rm -rf /usr/share/doc/*

echo "remove /var/cache"
find /var/cache -type f -exec rm -rf {} \;

echo "truncate any logs that have built up during the install"
find /var/log -type f -exec truncate --size=0 {} \;

# Disable sleep https://github.com/laravel/homestead/issues/1624
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# What are you doing Ubuntu?
# https://askubuntu.com/questions/1250974/user-root-cant-write-to-file-in-tmp-owned-by-someone-else-in-20-04-but-can-in
sysctl fs.protected_regular=0

echo "blank netplan machine-id (DUID) so machines get unique ID generated on boot"
truncate -s 0 /etc/machine-id
if test -f /var/lib/dbus/machine-id
then
  truncate -s 0 /var/lib/dbus/machine-id  # if not symlinked to "/etc/machine-id"
fi

# Enable Swap Memory
echo "enable swap memory"
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

echo "remove the contents of /tmp and /var/tmp"
rm -rf /tmp/* /var/tmp/*

echo "force a new random seed to be generated"
rm -f /var/lib/systemd/random-seed

echo "clear the history so our install isn't there"
rm -f /root/.wget-hsts
export HISTSIZE=0
