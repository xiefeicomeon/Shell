#!/bin/bash

iptables -A INPUT -p icmp --icmp-type time-exceeded -j DROP
iptables -A OUTPUT -p icmp --icmp-type time-exceeded -j DROP

iptables -A INPUT -p icmp --icmp-type 13 -j DROP
iptables -A OUTPUT -p icmp --icmp-type 13 -j DROP

iptables -A INPUT -p icmp --icmp-type 14 -j DROP
iptables -A OUTPUT -p icmp --icmp-type 14 -j DROP

iptables -A INPUT -p icmp --icmp-type 17 -j DROP
iptables -A OUTPUT -p icmp --icmp-type 17 -j DROP
