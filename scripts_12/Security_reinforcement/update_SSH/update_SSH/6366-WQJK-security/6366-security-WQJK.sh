#!/bin/bash
#Author:cstian
#Time:2021-11-26 11:27:33
#Name:6366-security-WQJK.sh

function test_root(){
    if [ $UID != 0 ] ;then
        echo "ERROR: need root"
        exit 0
    fi
}

function system_version_check()
{
    if [ -e /etc/issue ];then
        if ! cat /etc/issue | grep "80" ;then
            echo "ERROR: System version ERROR!"
            exit 1
        fi
    else
        echo "ERROR:Can't find \"/etc/issue\""
        exit 1
    fi
}

function backup(){
    if [ ! -d ./backup ]; then
        mkdir ./backup
        cp -av /etc/ssh ./backup >/dev/null 2>&1

        netstat -unlapt > ./backup/port
		echo -en "Please keep the backup catalogue properly"

    else
        echo "ERROR:already update!"
        exit 0
    fi
}

test_root
system_version_check
backup

sed -i '/telnet/c#telnet         stream  tcp     nowait  telnetd /usr/sbin/tcpd  /usr/sbin/in.telnetd' /etc/inetd.conf
systemctl restart openbsd-inetd

dpkg -i ./ssh/*.deb
