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
    if [ ! -d ./backup2 ]; then
        mkdir ./backup2
        cp -av /etc ./backup2 >/dev/null 2>&1

        netstat -unlapt > ./backup2/port
		echo -en "Please keep the backup catalogue properly"

    else
        echo "ERROR:already update!"
        exit 0
    fi
}

function Logon_timeout_lock()
{
    sed -i "/^.*pam_tally.so.*$/d" /etc/pam.d/common-auth
    sed -i "/^.*pam_tally2.so.*$/d" /etc/pam.d/common-auth
    sed -i "/^# pam-auth-update(8)/a\auth required pam_tally.so per_user unlock_time=60 onerr=succeed audit deny=5 even_deny_root root_unlock_time=60" /etc/pam.d/common-auth
}

function Change_pw_regularly()
{
	sed -i '/^PASS_MAX_DAYS/cPASS_MAX_DAYS   90' /etc/login.defs
	sed -i '/^PASS_WARN_AGE/cPASS_WARN_AGE   10' /etc/login.defs
}

function close_mail()
{
    /etc/init.d/postfix stop
    systemctl disable postfix
    sed -i '/^exit/i\iptables -A INPUT -p tcp --dport 25 -j DROP'  /etc/rc.local
}

function prohibit_telnet_swat()
{
	sed -i '/telnet/c#telnet         stream  tcp     nowait  telnetd /usr/sbin/tcpd  /usr/sbin/in.telnetd' /etc/inetd.conf
	sed -i '/swat/c#swat            stream  tcp     nowait.400      root    /usr/sbin/tcpd  /usr/sbin/swat' /etc/inetd.conf
	systemctl restart openbsd-inetd
    systemctl stop openbsd-inetd
}

function Password_complexity()
{
	sed -i '/pam_cracklib.so/cpassword  required    pam_cracklib.so retry=3 minlen=8 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1  reject_username enforce_for_root' /etc/pam.d/common-password
	sed -i "/^.*pam_unix.so.*$/c\password	[success=2 default=ignore]	pam_unix.so obscure use_authtok try_first_pass sha512 remember=1" /etc/pam.d/common-password
}

test_root
system_version_check
backup

Logon_timeout_lock
close_mail
prohibit_telnet_swat
Password_complexity
Change_pw_regularly

modprobe -r sr_mod
chmod +x ./remove_built-in_cdrom
./remove_built-in_cdrom start

cat <<EOF > Readme.txt

===========================================
注意：以下为手动操作内容：
===========================================
添加默认路由：
route add default via 192.168.161.11 dev ens33

添加正常路由：
route add -net 192.168.62.11 netmask 255.255.255.0 gw 192.168.1.1

删除路由：（删除的时候不用写网关）
route del -net 192.168.62.11 netmask 255.255.255.0

设置永久路由的方法：
在/etc/rc.local里添加下列路由规则：
route add -net 192.168.3.0/24 dev eth0
route add -net 192.168.2.0/24 gw 192.168.3.254
===========================================

EOF
cat Readme.txt

