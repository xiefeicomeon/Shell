#!/bin/bash
cp /home/smart/update_sudo/sudo_1.9.5p2_amd64.deb /opt
cd /opt
dpkg -i sudo_1.9.5p2_amd64.deb
setcap "cap_dac_override,cap_setgid,cap_setuid,cap_setpcap,cap_audit_write+ep" /usr/bin/sudo
rm sudo_1.9.5p2_amd64.deb

cd /home/smart
rm -rf update_sudo

