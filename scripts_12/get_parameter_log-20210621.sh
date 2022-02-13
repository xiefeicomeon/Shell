#!/bin/bash 
#
#################################################
# FileName: get_paramater_log.sh
# Date: 2020-10-12
# Usage: ./get_patamater_log.sh -somelog|-alllog
# Description: get system infomation
#
#################################################

export LANG=C
E_BADARGS=65

echo_fail() {
	echo -e "\\033[1;31m" "failed"
}

reset_color() {
	echo -en "\\033[0;39m"
}

if [ $# -lt 1 -o "x$1" != "x-somelog" -a "x$1" != "x-alllog" ];then
	echo "usage: `basename $0` -somelog bond0"
	echo "usage: `basename $0` -somelog eth0"
	echo "or"
	echo "usage: `basename $0` -alllog bond0"
	echo "usage: `basename $0` -alllog eth0"
	exit $E_BADARGS
fi
DATE=$(date +%Y%m%d%H%M%S)
hostname=$(uname -n)
d5000_home=`grep d5000 /etc/passwd | cut -d : -f6`


test -d /tmp/${hostname} || mkdir /tmp/${hostname} 
cd /tmp/${hostname}


ifconfig eth0> ./${hostname}.eth0-mac-address 2>&1
echo $DISPLAY> ./${hostname}.$USER.DISPLAY 2>&1


cp_list="
/etc/fstab
/etc/mcelog/mcelog.conf
/etc/ipwatchd.conf
/etc/csh.cshrc
/etc/profile
/root/.profile
/root/.bashrc 
/etc/exports
/etc/security/LinxSetupSign
/etc/hosts
/etc/issue
/etc/hosts.deny
/etc/hosts.allow
/etc/sysconfig/network
/etc/hostname
/etc/passwd
/etc/group
/etc/shadow
/etc/network/interfaces
/etc/network/routes
/etc/rc.d/rc.local
/etc/rc.local
/etc/crontab
/etc/X11/xorg.conf
/etc/cgconfig.conf
/etc/cgrules.conf
/etc/ntp.conf
/etc/resolv.conf
/etc/drbd.conf
/etc/proftpd/proftpd.conf
/etc/ssh/sshd_config
/etc/named.conf
/etc/bind/named.conf
/etc/ssh/ssh_config
/etc/inetd.conf
/etc/inittab
/etc/ntp/ntp.conf
/etc/linxsn/cgroup_sn.conf
/etc/linxsn/HA_sn.conf
/etc/linxsn/multipath_sn.conf
/etc/sysctl.conf
/etc/syslog.conf
/etc/rsyslog.conf
/etc/logrotate.conf
/var/lib/logrotate/status
/var/lib/logrotate.status
/usr/share/config/kdm/kdmrc
/usr/share/config/kdm/Xsession
/etc/gdm3/daemon.conf
$d5000_home/conf/nic/sys_netcard_conf.txt
/etc/modprobe.conf
/etc/default/grub
/etc/sysconfig/modules
/etc/modules
/etc/ld.so.conf
/usr/sbin/update_time.sh
/usr/sbin/get_max_mem_process.sh
/usr/sbin/get_parameter_log.sh
/boot/grub/grub.conf
/boot/grub/menu.lst
/boot/grub/grub.cfg
/usr/share/smp/linx_config
/etc/linxsn/smp_sn.conf
/etc/ld.so.conf.d/smp.conf
/etc/corosync/corosync.conf
/etc/corosync/lxha_clientlist.conf
/etc/corosync/lxha_iplist.conf
/etc/multipath.conf
/opt/smp.bak
/etc/crontab
/proc/cmdline
/proc/cpuinfo
/proc/meminfo
/tmp/lsmp
"
for i in $cp_list
do
	if [ -f $i ]
	then
		cp $i  ./${hostname}${i//\//.}  2>&1
	fi
done

ls_al_list="
/sys/kernel/security/linx
/dev/mapper
/dev/disk/by-uuid
/dev/disk/by-id
/var/log
/var/run
~d5000/.ssh
 /boot
/tmp
"

for i in $ls_al_list
do
	if [ -d $i ]
	then
		ls -al $i  >./${hostname}.ls.-al${i//\//.} 2>&1
	fi
done


id oms >/dev/null 2>&1
if [ $? -eq 0 ];then
	oms_home=`grep oms /etc/passwd | cut -d : -f6`
	cat_list="
	/lxcg/oms_limits/tasks
	$oms_home/.tcshrc
	$oms_home/cgroup_limits/oms_limits/tasks
	$oms_home/.cshrc
	$oms_home/.login
	"
	for i in $cat_list
	do
		if [ -f $i ]
		then
			cat $i >./${hostname}${i//\//.} 2>&1
		fi
	done
fi


id ems >/dev/null 2>&1
if [ $? -eq 0 ];then
	ems_home=`grep ems /etc/passwd | cut -d : -f6`
	cat_list="
	/lxcg/ems_limits/tasks
	$ems_home/.tcshrc
	$ems_home/.cshrc
	$ems_home/.login
	$ems_home/cgroup_limits/ems_limits/tasks
	"
	for i in $cat_list
	do
		if [ -f $i ]
		then
			cat $i > ./${hostname}${i//\//.} 2>&1
		fi
	done

fi


for (( i=0; i<16; i++ ))
do
	ETH_NIC=eth"$i"
	BOND_NIC=bond"$i"
	ETH_MAC=$(ifconfig ${ETH_NIC} 2>/dev/unll| awk '/HWaddr/{ print $5 }')
	BOND_MAC=$(ifconfig ${BOND_NIC} 2>/dev/unll| awk '/HWaddr/{ print $5 }')
	if [ -n "${ETH_MAC}" ]; then
	     ethtool ${ETH_NIC} > ./${hostname}.ethtool.${ETH_NIC} 2>&1
	     ethtool -i ${ETH_NIC} >./${hostname}.ethtool.-i.${ETH_NIC} 2>&1
	     ethtool -S ${ETH_NIC} > ./${hostname}.ethtool.-S.${ETH_NIC} 2>&1
	fi
	if [ -n "${BOND_MAC}" ]; then
	     ethtool ${BOND_NIC} > ./${hostname}.ethtool.${BOND_NIC} 2>&1
	     ethtool -i ${BOND_NIC} > ./${hostname}.ethtool.-i.${BOND_NIC} 2>&1
	     ethtool -S ${BOND_NIC} > ./${hostname}.ethtool.-S.${BOND_NIC} 2>&1
	fi
done

tar_list="
etc/sysctl.d
etc/linxsn
var/spool/cron/crontabs
etc/cron
etc/logrotate.d
sys/devices/system/edac
etc/lvm
sys/block/
etc/modprobe.d
etc/ld.so.conf.d
etc/sysconfig/network-devices
etc/udev
dev/mapper
etc/udev/rules.d
etc/rc.d 
etc/init.d 
etc/rc.d/init.d 
etc/security
etc/pam.d
etc/security
etc/ssh
"

for i in $tar_list
do
	if [ -d /$i ] ;then
		
		tar czf ./${hostname}${i//\//.}.tgz -C /  $i 
	fi
done

d5000_file_list="
var/log/netcard
.ssh
.cshrc
"

for i in $d5000_file_list
do
	if [ -f $d5000_home/$i ];then
		tar czf ./${hostname}${i//\//.}.tgz -C $d5000_home  $i 
	fi

done

command_list="
lsusb
date
locale
lastlog
dmesg
numastat
mii-tool
sas2ircu-status
pvdisplay
iptables-save
free
dmidecode
pvscan
vgdisplay
lvdisplay
lsmod
"

for command in $command_list
do
	if which $command >/dev/null 2>&1 || type $command >/dev/null 2>&1 ;then
		$command >./$hostname.$command  2>&1
	fi
done

ps eauxf>./${hostname}.ps.eauxf 2>&1
ps auxww>./${hostname}.ps.auxww 2>&1

for i in a b c d 
do
	if [ -f /dev/sd$i ];then
		smartctl -a /dev/sd$i  >./${hostname}.smartctl.sd$i  2>&1
	fi
done

parameter_list1="
vvnn
kvvnn
mvvnn
tvvnn
mnn
"
for i in $parameter_list1
do
	lspci -$i>./${hostname}.lspci.$i 2>&1 
done

if which lscpu ;then
	lscpu >./${hostname}.lscpu 2>&1
	lscpu -p >./${hostname}.lscpu.-p 2>&1
fi


for i in `seq 0 4`
do
	if which smartctl >/dev/null 2&>1
	then
		smartctl -a -d megaraid,$i /dev/sda >./${hostname}.smartctl.-a.-d.megarai.$i.sda 2>&1
	fi
done

ldconfig -p > ./${hostname}.ldconfig.-p  2>&1
df -h >./${hostname}.df.-h 2>&1
df -ih >./${hostname}.df.-ih 2>&1
du -sh /var/spool/postfix/maildrop >./${hostname}.du.sh.var.spool.postfix.maildrop 2>&1

hwclock -r >./${hostname}.hwclock.-r 2>&1
grep -i commit /proc/meminfo >./${hostname}.CommitLimit-Committed_AS 2>&1
grep -i -A2 -B2 -i "Machine check events logged" /var/log/kern* >./${hostname}.var.log.kern.MCE 2>&1
grep -i -A2 -B2 -i "Machine check events logged" /var/log/old/kern* >./${hostname}.var.log.old.kern.MCE 2>&1
last -i >./${hostname}.last.-i.wtmp 2>&1
last -i -f /var/log/btmp >./${hostname}.last.-i.btmp 2>&1

if which ipmitool;then
	ipmitool -I open sel list>./${hostname}.ipmitool.i.open.sel.list   2>&1
	ipmitool -I open sel elist>./${hostname}.ipmitool.i.open.sel.elist   2>&1
	ipmitool -I open sdr>./${hostname}.ipmitool.i.open.sdr  2>&1
	ipmitool -I open sensor list>./${hostname}.ipmitool.i.open.sensor.list 2>&1
	ipmitool -I open chassis restart_cause>./${hostname}.ipmitool.i.open.chassis.restart_cause  2>&1
	ipmitool -I open chassis policy list>./${hostname}.ipmitool.i.open.chassis.policy.list 2>&1
fi


IP=`ifconfig bond0|grep 'inet addr'|awk -F: '{print $2}'|awk '{print $1}'`
#arp -a >./${hostname}.arp.-a
arp-scan -I bond0 -l >./${hostname}.arp-scan.-I.bond0.-l 2>&1
arping -I bond0 -c 3 -f -D ${IP} >./${hostname}.arping.-I.bond0.-c.3.-f.-D.bond0_IP 2>&1
#append history into ~root/.bash_history or ~sysadmin/.bash_history
history -a
#clear history
history -c
#read ~root/.bash_history or ~sysadmin/.bash_history
history -r
#将~root/.bash_history文件中的unix时间格式转换成可正常显示的格式并保存到./${hostname}.history.root文件中
(perl -pe 's/(\d+)/localtime($1)/e' ~root/.bash_history)>./${hostname}.history.root
#将~sysadmin/.bash_history文件中的unix时间格式转换成可正常显示的格式并保存到./${hostname}.history.sysadmin文件中
(perl -pe 's/(\d+)/localtime($1)/e' ~sysadmin/.bash_history)>./${hostname}.history.sysadmin
mkdir .history_log
id d5000   >/dev/null 2&>1
if [ $? -eq 0 ];then
	#su - d5000 -c "history -M;history -S"
	mkdir .history_log/d5000
	for filename in `ls ~d5000/.history_log`
	do
		(perl -pe 's/(\d+)/localtime($1)/e' ~d5000/.history_log/${filename})>.history_log/d5000/${filename}.bak
		mv .history_log/d5000/${filename}.bak  .history_log/d5000/${filename}
	done
	chown -R d5000.d5000 .history_log/d5000 
fi

id root   >/dev/null 2&>1
if [ $? -eq 0 ];then
	mkdir .history_log/root
	for filename in `ls ~root/.history_log`
	do
		cp ~root/.history_log/${filename} .history_log/root/${filename}
	done
	chown -R root.root .history_log/root 
fi

id ems   >/dev/null 2&>1
if [ $? -eq 0 ];then
	#su - ems -c "history -M;history -S"
	mkdir .history_log/ems
	for filename in `ls ~ems/.history_log`
	do
		(perl -pe 's/(\d+)/localtime($1)/e' ~ems/.history_log/${filename})>.history_log/ems/${filename}.bak
		mv .history_log/ems/${filename}.bak  .history_log/ems/${filename}
	done
	chown -R ems.ems .history_log/ems 
fi

id oms   >/dev/null 2&>1
if [ $? -eq 0 ];then
	#su - oms -c "history -M;history -S"
	#(perl -pe 's/(\d+)/localtime($1)/e' ~oms/.history)>./${hostname}.history.oms
	mkdir .history_log/oms
	for filename in `ls ~oms/.history_log`
	do
		(perl -pe 's/(\d+)/localtime($1)/e' ~oms/.history_log/${filename})>.history_log/oms/${filename}.bak
		mv .history_log/oms/${filename}.bak  .history_log/oms/${filename}
	done
	chown -R oms.oms .history_log/oms 
fi

id kingsoft >/dev/null 2&>1
if [ $? -eq 0 ];then
	su - kingsoft -c "history -a;history -c;history -r"
	(perl -pe 's/(\d+)/localtime($1)/e' ~kingsoft/.bash_history)>./${hostname}.history.kingsoft
fi

if which numactl   >/dev/null 2&>1 ;then
	numactl --show >./${hostname}.numactl.--show 2>&1
	numactl --hardware >./${hostname}.numactl.--hardware 2>&1
fi


lspci -vvnn |egrep -i "1002:68a9" >/dev/null 2>&1
if [ $? -ne 0 ];then
	lshw>./${hostname}.lshw 2>&1
else
	cat /dev/null > ./${hostname}.lshw 2>&1
fi

#which iostat >/dev/null 2&>1  && iostat -d -x -k 1 10 > ./${hostname}.iostat.-d.-x.-k.1-10
#which sar >/dev/null 2&>1  && sar -n DEV 1 10 > ./${hostname}.sar.-n.DEV.1.10
which pkginfo && pkginfo -i > ./${hostname}.pkginfo.-i  2>&1
which dpkg >/dev/null 2>&1  && dpkg -l > ./${hostname}.dpkg.-l  2>&1
which fc-list >/dev/null 2>&1 && fc-list > ./${hostname}.fc-list  2>&1
#top -bn10 >./${hostname}.top.-bn10
#iotop -bn6 >./${hostname}.iotop.-bn6
fdisk -l >./${hostname}.fdisk.-l 2>&1
iptables -nL >./${hostname}.iptables.-nL 2>&1
iptables -t nat -nL >./${hostname}.iptables.-t.nat.-nL  2>&1

grep '6.0.3' /etc/issue  >/dev/null 2>&1 
if [ $? -ne 0 ];then
	parted  -l >./${hostname}.parted.-l 2>&1  
fi


top -bn1 -H >./${hostname}.top.-bn1.-H 2>&1
#vmstat 1 10 >./${hostname}.vmstat.1_10
uname -a >./${hostname}.uname.-a 2>&1

which crm >/dev/null 2>&1
if [ $? -eq 0 ];then
	crm configure show>./${hostname}.crm.configure.show 2>&1
	crm_mon -1>./${hostname}.crm_mon.-1 2>&1
	crm status>./${hostname}.crm.status 2>&1
	corosync-cfgtool -s >./${hostname}.corosync-cfgtool.-s 2>&1
fi

which upadm >/dev/null 2>&1  && upadm show version >./${hostname}.huawei.upadm.show.version  2>&1
which multipath >/dev/null 2>&1  && multipath -ll >./${hostname}.multipath-ll  2>&1
which multipath >/dev/null 2>&1  && multipath -v6 >./${hostname}.multipath-v6  2>&1

lsmod |grep -i "os_sec" >./${hostname}.lsmod.kxht.module.name  2>&1
sysctl -a>./${hostname}.sysctl.-a  2>&1
ulimit -a>./${hostname}.ulimit.-a  2>&1

if id d5000;then
	lsof +c 0 >./${hostname}.lsof  2>&1
	lsof |grep d5000|awk '{print $2}'|uniq|wc -l >./${hostname}.d5000.running.nproc  2>&1
	su - d5000 -c limit>./${hostname}.d5000.su.-d5000.-c.limit  2>&1
	su - d5000 -c "echo $DISPLAY">./${hostname}.d5000.su.-d5000.-c.echo.DISPLAY  2>&1
	crontab -u d5000 -l>./${hostname}.var.spool.cron.crontabs.d5000 2>&1
	ps -u d5000 --sort minflt > ./${hostname}.ps.-u.d5000.sort.minflt 2>&1
fi

faillog -a > ./${hostname}.faillog.-a  2>&1
netstat -anp>./${hostname}.netstat.-anp 2>&1

ps auxww|grep -i "os_master">./${hostname}.ps.auxww.kxht.process.name 2>&1
ps auxww|sort -k 3 -r -n>./${hostname}.ps.auxww.cpu_load_high_low 2>&1
ps auxww|sort -k 4 -r -n>./${hostname}.ps.auxww.mem_percent_greater_less 2>&1
ps auxww|sort -k 5 -r -n>./${hostname}.ps.auxww.mem_virtual_greater_less 2>&1
ps auxww|sort -k 6 -r -n>./${hostname}.ps.auxww.mem_physical_greater_less 2>&1

ps -efL>./${hostname}.ps.-efL  2>&1
ps -eo pid,args:50,psr>./${hostname}.ps.-eo.pid.args.psr  2>&1
ps -o majflt,minflt -C program >./${hostname}.ps.-o.majflt.minflt.-C.program 2>&1
ps -oe minflt,rss,pmem,pcpu,args,user,etime > ./${hostname}.ps.-eo.minflt.rss.pcpu 2>&1
ps -u root  --sort minflt > ./${hostname}.ps.-u.root.sort.minflt 2>&1
pstree >./${hostname}.pstree  2>&1
ifconfig -a>./${hostname}.ifconfig.-a 2>&1
route -n >./${hostname}.route 2>&1
ip route show>./${hostname}.ip.route.show 2>&1 
ntpq -np>./${hostname}.ntpq.-np  2>&1
ntpdc -np>./${hostname}.ntpdc.-np 2>&1


if which megacli ;then
	#get megaraid's message
	#查raid级别
	megacli -LDInfo -Lall -aALL>./${hostname}.megacli.-LDInfo.-Lall.-aALL 2>&1
	#查raid卡信息
	megacli -AdpAllInfo -aALL>./${hostname}.megacli.-AdpAllInfo.-aALL 2>&1
	#显示所有的物理磁盘信息
	megacli -PDList -aALL>./${hostname}.megacli.-PDList.-aALL 2>&1
	#查看电池信息
	megacli -AdpBbuCmd  -aALL>./${hostname}.megacli.-AdpBbuCmd.-aALL 2>&1
	#查看raid卡日志
	megacli -FwTermLog -Dsply  -aALL>./${hostname}.megacli.-FwTermLog.-Dsply.-aALL 2>&1
	#查看显示适配器个数
	megacli -adpCount>./${hostname}.megacli.adpCount 2>&1
	#查看显示适配器时间
	megacli -AdpGetTime -aALL>./${hostname}.megacli.AdpGetTime.-aALL 2>&1
	#显示所有适配器信息
	megacli -AdpAllInfo -aALL>./${hostname}.megacli.AdpAllInfo.-aALL 2>&1
	#显示所有逻辑磁盘组信息
	megacli -LDInfo -LALL -aALL>./${hostname}.megacli.-LDInfo.LALL.-aALL 2>&1
	#查看充电状态
	megacli -AdpBbuCmd -GetBbuStatus -aALL|grep 'Charger Status'>./${hostname}.megacli.-AdpBbuCmd.-GetBbuStatus.-aALL-grep-Charger_Status 2>&1
	#显示BBU状态信息
	megacli -AdpBbuCmd -GetBbuStatus -aALL>./${hostname}.megacli.-AdpBbuCmd.-GetBbuStatus.-aALL 2>&1
	#显示BBU容量信息
	megacli -AdpBbuCmd -GetBbuCapacityInfo -aALL>./${hostname}.megacli.-AdpBbuCmd.-GetBbuCapacityInfo.-aALL 2>&1
	#显示BBU设计参数
	megacli -AdpBbuCmd -GetBbuDesignInfo -aALL>./${hostname}.megacli.-AdpBbuCmd.-GetBbuDesignInfo.-aALL 2>&1
	#显示当前BBU属性
	megacli -AdpBbuCmd -GetBbuProperties -aALL>./${hostname}.megacli.-AdpBbuCmd.-GetBbuProperties.-aALL 2>&1
	#显示Raid卡型号，Raid设置，Disk相关信息
	megacli -cfgdsply -aALL>./${hostname}.megacli.-cfgdsply.-aALL 2>&1
	#显示mega Raid卡的Cache Policy,在没有电池（BBU），是否打开了Write Cache
	megacli -LDGetProp -Cache -Lall -aALL>./${hostname}.megacli.-LDGetProp.-Cache.-Lall.-aALL 2>&1
fi


if which sas2ircu ; then
	sas2ircu LIST >./${hostname}.sas2ircu.LIST   2>&1
	sas2ircu 0 DISPLAY >./${hostname}.sas2ircu.0.DISPLAY 2>&1 
fi

modprobe sg 
ls /dev/sg* >./${hostname}.ls.dev.sgn 2>&1
SGX=$(ls -al /dev/sg*|wc -l)
for ((i=0;i<$SGX;i++))
do
	smartctl -a /dev/sg$i >./${hostname}.smartctl.-a.dev.sg$i  2>&1
done


lsmod |grep -v Module|awk '{ print $1 }'| while read MODNAME
do
	modinfo ${MODNAME} >./${hostname}.modinfo.${MODNAME} 2>&1
done


#wmli@linx-info.com,2013-05-20,get disk parameter
DISK=$(fdisk -l|grep Disk|grep dev|awk -F':' '{print $1}'|awk '{print $NF}')
DF=$(hostname).Diskinfo
echo 'DiskInfo' > $DF
echo "======================================================"|tee -a $DF
if [ $(which hdparm)  ];then
	for i in $DISK
	do
		#echo -n "$i "|tee -a $DF
		#echo "$(hdparm -I $i 2>/dev/null|grep 'device size with M = 1000\*1000:'|awk '{print $(NF-1),$NF}')"|tee -a $DF  2>&1
		#echo "$(hdparm -I $i 2>/dev/null|grep 'Model Number:')"|tee -a $DF  2>&1
		#echo "$(hdparm -I $i 2>/dev/null|grep 'Serial Number:')"|tee -a $DF 2>&1
		#echo "$(hdparm -I $i 2>/dev/null|grep 'Transport:')"|tee -a $DF  2>&1
		#echo "$(hdparm -I $i 2>/dev/null|grep 'Form Factor:')"|tee -a $DF 2>&1
		#echo "$(hdparm -I $i 2>/dev/null|grep 'Nominal Media Rotation Rate: 7200')"|tee -a $DF  2>&1
		#echo "------------------------------------------------------"|tee -a $DF  2>&1
		echo -n "$i "|tee -a $DF
		echo "$(hdparm -I $i 2>/dev/null|grep 'device size with M = 1000\*1000:'|awk '{print $(NF-1),$NF}')" | tee -a $DF  2>&1
		echo "$(hdparm -I $i 2>/dev/null|grep 'Model Number:')" | tee -a  $DF  2>&1
		echo "$(hdparm -I $i 2>/dev/null|grep 'Serial Number:')" | tee -a  $DF 2>&1
		echo "$(hdparm -I $i 2>/dev/null|grep 'Transport:')"  | tee -a  $DF  2>&1
		echo "$(hdparm -I $i 2>/dev/null|grep 'Form Factor:')" | tee -a  $DF 2>&1
		echo "$(hdparm -I $i 2>/dev/null|grep 'Nominal Media Rotation Rate: 7200')" | tee -a   $DF  2>&1
		echo "------------------------------------------------------"|tee -a $DF  2>&1
	done
else
	echo "hdparm: command not found!">>${DF}
fi


if [ "x$1" = "x-alllog" ];then
	tar czf /tmp/$(hostname)/${hostname}.var.log.tgz -C  /  var/log 
elif [ "x$1" = "x-somelog" ];then
	tail -160000 /var/log/messages >./${hostname}.var.log.messages.160000 2>&1
	tail -160000 /var/log/mcelog >./${hostname}.var.log.mcelog.160000  2>&1
	tail -160000 /var/log/messages.1 >./${hostname}.var.log.messages.1.160000 2>&1
	tail -160000 /var/log/kernel >./${hostname}.var.log.kernel.160000  2>&1
	tail -160000 /var/log/kernel.1 >./${hostname}.var.log.kernel.1.160000  2>&1
	tail -160000 /var/log/kern.log >./${hostname}.var.log.kern.log.160000  2>&1
	tail -160000 /var/log/kern.log.1 >./${hostname}.var.log.kern.log.1.160000  2>&1
	tail -160000 /var/log/errors >./${hostname}.var.log.errors.160000 2>&1
	tail -160000 /var/log/errors.1 >./${hostname}.var.log.errors.1.160000  2>&1
	tail -160000 /var/log/syslog >./${hostname}.var.log.syslog.160000  2>&1
	tail -160000 /var/log/syslog.1 >./${hostname}.var.log.syslog.1.160000  2>&1
	tail -160000 /var/log/auth >./${hostname}.var.log.auth.160000  2>&1
	tail -160000 /var/log/auth.1 >./${hostname}.var.log.auth.1.160000 2>&1 
	tail -160000 /var/log/audit/audit.log >./${hostname}.var.log.audit.audit.log.160000  2>&1
	tail -160000 /var/log/audit/audit.log.1 >./${hostname}.var.log.audit.audit.log.1.160000  2>&1
	tail -160000 /var/log/auth.log >./${hostname}.var.log.auth.log.160000  2>&1
	tail -160000 /var/log/auth.log.1 >./${hostname}.var.log.auth.log.1.160000  2>&1
	tail -160000 /var/log/corosync.log >./${hostname}.var.log.corosync.log.160000 2>&1
	tail -160000 /var/log/corosync.log.1 >./${hostname}.var.log.corosync.log.1.160000  2>&1
	tail -160000 /var/log/corosync/corosync.log >./${hostname}.var.log.corosync.corosync.log.160000  2>&1
	tail -160000 /var/log/corosync/corosync.log.1 >./${hostname}.var.log.corosync.corosync.log.1.160000  2>&1
	tail -160000 /tmp/corosync.log >./${hostname}.tmp.corosync.log.160000  2>&1
	tail -160000 /tmp/corosync.log.1 >./${hostname}.tmp.corosync.log.1.160000 2>&1
	tail -160000 /var/log/Xorg.0.log >./${hostname}.var.log.Xorg.0.log.160000 2>&1
	tail -160000 /var/log/Xorg.1.log >./${hostname}.var.log.Xorg.1.log.160000 2>&1
	tail -160000 /var/log/kdm.log >./${hostname}.var.log.kdm.log.160000  2>&1
	tail -160000 /var/log/temperature_sensors.log >./${hostname}.var.log.temperature_sensors.log.160000  2>&1
	tail -160000 /var/log/temperature_rdmsr.log >./${hostname}.var.log.temperature_rdmsr.log.160000   2>&1
	tail -160000 /var/log/cpu_iotop.log >./${hostname}.var.log.cpu_iotop.log.160000  2>&1 
	# linx_smp infomation
	tail -160000 /var/log/linx_smp.log >./${hostname}.var.log.linx_smp.log.160000   2>&1
	tail -160000 /var/log/linx_smp.err >./${hostname}.var.log.linx_smp.err.160000  2>&1
	tail -160000 /var/log/msmp.log >./${hostname}.var.log.msmp.log.160000   2>&1
fi


#The use of statistical swap partition

cd /proc
for pid in [0-9]*; do
    command=$(cat /proc/$pid/cmdline)
    swap=$(
        awk '
            BEGIN  { total = 0 }
            /Swap/ { total += $2 }
            END    { print total }
        ' /proc/$pid/smaps
    )
    if [[ "${head}" != "yes" ]]; then
	    #echo -e "PID\tSWAP\tCOMMAND"|tee /tmp/$(hostname)/${hostname}.swap_use.txt 
	    echo -e "PID\tSWAP\tCOMMAND" > /tmp/$(hostname)/${hostname}.swap_use.txt 
            head="yes"
    fi
    #echo -e "${pid}\t${swap}\t${command}"|tee -a /tmp/$(hostname)/${hostname}.swap_use.txt
    echo -e "${pid}\t${swap}\t${command}"> /tmp/$(hostname)/${hostname}.swap_use.txt
done

less /tmp/${hostname}/${hostname}.swap_use.txt|grep -v SWAP|sort -k 2 -r -n > /tmp/$(hostname)/${hostname}.swap_greater_less

# get mcelog'message

if which mcelog;then
	mcelog  --help 2>&1 | grep -i "Valid CPUs" > /tmp/${hostname}/mcelog.hlp 2>&1
	[ -f /tmp/${hostname}/mcelog.hlp ] && less /tmp/${hostname}/mcelog.hlp |grep -i "valid cpus:"|awk -F":" '{print $2}'>/tmp/${hostname}/mcelog.cpu
	cat /dev/null > /tmp/${hostname}/${hostname}.mcelog.txt
	for i in  $(cat /tmp/${hostname}/mcelog.cpu)
	do    
		mcelog --cpu $i --syslog | tee -a /tmp/${hostname}/${hostname}.mcelog.txt 2>&1
	done
else
	echo "no command mcelog" > /tmp/${hostname}/${hostname}.mcelog.txt
fi


#Generated compression package
cd /tmp
if [ -f ./${hostname}*.tgz  ] ;then
    rm ./${hostname}*.tgz
fi

serialFileList="
/etc/default/grub
/boot/grub/grub.cfg
/boot/grub/grub.conf
"
for file in $serialFileList
do
	if test -f $file && grep -q "linx_serial=" $file;then
		serial=$(awk -F'linx_serial=' '/linx_serial/{print $2}' $file | cut -d' ' -f 1) 
		if [ -n $serial ];then
			break
		fi
	fi
done

#if test -f /etc/default/grub && grep -q linx_serial /etc/default/grub;then
#	serial=$(awk -F'linx_serial=' '/linx_serial/{print $2}' /etc/default/grub | cut -d' ' -f 1) 
#elif test -f /boot/grub/grub.cfg && grep -q linx_serial /boot/grub/grub.cfg;then
#	serial=$(awk -F'linx_serial=' '/linx_serial/{print $2}' /boot/grub/grub.cfg | cut -d' ' -f 1) 
#elif test -f /boot/grub/grub.conf && grep -q linx_serial /boot/grub/grub.conf;then
#	serial=$(awk -F'linx_serial=' '/linx_serial/{print $2}' /boot/grub/grub.conf | cut -d' ' -f 1) 
#fi

tar czf /tmp/${hostname}.${serial:=null}.${DATE}.tgz  -C  /  tmp/${hostname}

if [ -d /tmp/${hostname} ];then
	rm -rf /tmp/${hostname}
fi

export LANG=zh_CN.utf-8
reset_color
echo "Ending......"
