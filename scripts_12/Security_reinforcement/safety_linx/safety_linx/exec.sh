#!/bin/bash
cp Linx80-complete-security-config_1.5_amd64.deb /opt
cd /opt

dpkg -i Linx80-complete-security-config_1.5_amd64.deb
rm Linx80-complete-security-config_1.5_amd64.deb
cd /opt/security
bash complete_security_config.sh

#删除执行文件夹
cd /home/smart
rm -rf safety_linx
