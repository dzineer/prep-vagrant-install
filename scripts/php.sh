#!/usr/bin/env bash

export LANG=C.UTF-8

PHP_TIMEZONE=$1
HHVM=$2
PHP_VERSION=$3

if [[ $HHVM == "true" ]]; then

    echo ">>> Installing HHVM"

    # Get key and add to sources
    wget --quiet -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
    echo deb http://dl.hhvm.com/ubuntu trusty main | sudo tee /etc/apt/sources.list.d/hhvm.list

    # Update
    sudo apt-get update

    # Install HHVM
    # -qq implies -y --force-yes
    sudo apt-get install -qq hhvm

    # Start on system boot
    sudo update-rc.d hhvm defaults

    # Replace PHP with HHVM via symlinking
    sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60

    sudo service hhvm restart
else
    sudo apt-get update
    sudo apt install software-properties-common
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt-get update
    
    sudo apt-get install -qq php7.3-common php7.3-mysql php7.3-sqlite php7.3-xml php7.3-xmlrpc php7.3-curl php7.3-gd php7.3-imagick php7.3-cli php7.3-dev php7.3-imap php7.3-mbstring php7.3-opcache php7.3-soap php7.3-zip php7.3-intl php7.3-bcmath -y

    sudo apt-get install -qq php7.3-fpm -y

    # Set PHP FPM to listen on Socket instead of TCP
    sudo sed -i "s/listen =.*/listen = \/run\/php\/php7.3-fpm.sock/" /etc/php/7.3/fpm/pool.d/www.conf

    # Set PHP FPM allowed clients IP address
    sudo sed -i "s/;listen.allowed_clients/listen.allowed_clients/" /etc/php/7.3/fpm/pool.d/www.conf

    # Set run-as user for PHP/7.3-FPM processes to user/group "vagrant"
    # to avoid permission errors from apps writing to files
    sudo sed -i "s/user = www-data/user = vagrant/" /etc/php/7.3/fpm/pool.d/www.conf
    sudo sed -i "s/group = www-data/group = vagrant/" /etc/php/7.3/fpm/pool.d/www.conf

    sudo sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/7.3/fpm/pool.d/www.conf
    sudo sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/7.3/fpm/pool.d/www.conf
    sudo sed -i "s/listen\.mode.*/listen.mode = 0666/" /etc/php/7.3/fpm/pool.d/www.conf

    sudo service php7.3-fpm restart
fi
