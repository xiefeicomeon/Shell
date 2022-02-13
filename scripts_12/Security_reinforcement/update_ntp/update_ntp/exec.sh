#!/bin/bash
unzip /home/smart/update_ntp/ntp.zip 
cd ntp
dpkg -i *.deb
cd /home/smart
rm -rf update_ntp 

