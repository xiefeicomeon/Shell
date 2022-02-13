#!/bin/bash
dpkg --get-selections | grep mysql

apt-get --purge remove mysql-client-5.5 -y
apt-get --purge remove  mysql-server
apt-get --purge remove mysql-common -y
apt-get --purge remove  mysql-server-core-5.5 -y
apt-get autoremove -y
apt-get autoclean -y

dpkg --get-selections | grep mysql

cd /home/smart
rm -rf rm_mysql

