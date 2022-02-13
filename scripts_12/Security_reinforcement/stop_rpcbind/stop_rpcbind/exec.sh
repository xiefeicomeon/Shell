#!/bin/bash
netstat -anltp | grep rpcbind 
systemctl disable rpcbind.service
systemctl stop rpcbind.service


cd /home/smart
rm -rf stop_rpcbind

