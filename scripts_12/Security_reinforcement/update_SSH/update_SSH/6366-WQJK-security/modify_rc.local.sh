#!/bin/bash
sed -i '/exit 0/i /etc/init.d/ntp restart' /etc/rc.local
sed -i '/exit 0/i iptables -A INPUT -p icmp --icmp-type time-exceeded -j DROP'  /etc/rc.local
sed -i '/exit 0/iiptables -A OUTPUT -p icmp --icmp-type time-exceeded -j DROP' /etc/rc.local

sed -i '/exit 0/i iptables -A INPUT -p icmp --icmp-type 13 -j DROP' /etc/rc.local
sed -i '/exit 0/i iptables -A OUTPUT -p icmp --icmp-type 13 -j DROP' /etc/rc.local

sed -i '/exit 0/i iptables -A INPUT -p icmp --icmp-type 14 -j DROP' /etc/rc.local
sed -i '/exit 0/i iptables -A OUTPUT -p icmp --icmp-type 14 -j DROP' /etc/rc.local

sed -i '/exit 0/i iptables -A INPUT -p icmp --icmp-type 17 -j DROP' /etc/rc.local
sed -i '/exit 0/i iptables -A OUTPUT -p icmp --icmp-type 17 -j DROP' /etc/rc.local

