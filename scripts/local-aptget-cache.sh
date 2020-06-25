#!/usr/bin/env bash

echo ">>> Adding local apt-get cache server"

echo 'Acquire::http::Proxy "http://192.168.22.22:3142";' >> /etc/apt/apt.conf.d/02proxy

sed 's/deb http:\/\/security.ubuntu.com\/ubuntu bionic-security main restricted/deb http:\/\/192.168.22.22:3142\/ubuntu bionic-security main restricted/g' /etc/apt/sources.list
sed 's/deb http:\/\/security.ubuntu.com\/ubuntu bionic-security universe/deb http:\/\/192.168.22.22:3142\/ubuntu bionic-security universe/g' /etc/apt/sources.list
sed 's/deb http:\/\/security.ubuntu.com\/ubuntu bionic-security multiverse/deb http:\/\/192.168.22.22:3142\/ubuntu bionic-security multiverse/g' /etc/apt/sources.list
