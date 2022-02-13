#!/bin/bash
#获取A网参数，用于后续计算其他网口IP
read -p "please input IP address:" IP
read -p "please input netmask:" netmask
read -p "please input network:" network
read -p "please input gateway:" gateway
#IP=192.10.10.30
#netmask=255.255.0.0
#network=192.10.0.0
#gateway=192.10.0.254

#保留A网相关网络参数
# IP_A=IP
# netmask_A=netmask
# network_A=network
# gateway_A=gateway

#正则匹配网口参数，得到网口字符串
 eths=$(ifconfig -a | grep 'eth.'|awk '{printf $1 "\t"}')
 #得到网口数组以及数量用变量num存储
 eths_Array=($eths)

 num_eths=${#eths_Array[@]}
 #打印网口数量及名称
#  echo ${#eths_Array[@]}
#  echo ${eths_Array[@]}
 

#对读取的IP、netmask、network、gateway参数进行分解得到操作数组
IFS='.'
IP_Arraynum=($IP);
network_Arraynum=($network)
gateway_Arraynum=($gateway)
#echo ${gateway_Arraynum[@]}


unset IFS
#定义 IP、network、gateway数组用来存储各个网口的相关参数
IP_Array=($IP)
network_Array=($network)
gateway_Array=($gateway)
#采用for循环来实现各个网口的相关参数的值并将其存入上面定义的数组中
#获取需要变更的第二位的值，并用num_2存储以及对应变更的网络参数用_Change存储
num_2=${IP_Arraynum[1]}
IP_Change=""
network_Change=""
gateway_Change=""
for(( i=1;i<num_eths;i++ ));do
num_2=$((num_2+1))
IP_Arraynum[1]=$num_2
IP_Change="${IP_Arraynum[0]}.${IP_Arraynum[1]}.${IP_Arraynum[2]}.${IP_Arraynum[3]}"
IP_Array=("${IP_Array[@]}" $IP_Change)

network_Arraynum[1]=$num_2
network_Change="${network_Arraynum[0]}.${network_Arraynum[1]}.${network_Arraynum[2]}.${network_Arraynum[3]}"
network_Array=("${network_Array[@]}" $network_Change)

gateway_Arraynum[1]=$num_2
gateway_Change="${gateway_Arraynum[0]}.${gateway_Arraynum[1]}.${gateway_Arraynum[2]}.${gateway_Arraynum[3]}"
gateway_Array=("${gateway_Array[@]}" $gateway_Change)
done
#echo ${gateway_Array[@]}




#操作interfaces文件
#网口参数总的存在eths变量中，单个参数存在eths_array中
#IP存储在IP_Array中，子网掩码存储在netmask中，子网存在network_Array中0
#网关参数存储在gateway_Array中

cp /etc/network/interfaces $(pwd)
#清空interfaces文件的内容，只保留1-6行
sed -i '2,$d' interfaces
sed -i "\$a# This file describes the network interfaces available on your system" interfaces
sed -i "\$a# and how to activate them. For more information, see interfaces(5)." interfaces
sed -i "\$asource /etc/network/interfaces.d/*" interfaces
sed -i "\$a# The loopback network interface" interfaces

str7="auto lo $eths"
sed -i "\$a$str7" interfaces

sed -i "\$aiface lo inet loopback" interfaces
sed -i "\$a# The primary network interface" interfaces
for (( i=0;i<num_eths; i++ ));do

ap_eth="allow-hotplug ${eths_Array[i]}"
sed -i "\$a$ap_eth" interfaces

iface_eth="iface ${eths_Array[i]}  inet static"
sed -i "\$a$iface_eth" interfaces

address_eth="address ${IP_Array[i]}"
sed -i "\$a$address_eth" interfaces

netmask_eth="netmask $netmask"
sed -i "\$a$netmask_eth" interfaces



network_eth="network ${network_Array[i]}"
sed -i "\$a$network_eth" interfaces

gateway_eth="gateway ${gateway_Array[i]}"
sed -i "\$a$gateway_eth" interfaces
sed -i '$G' interfaces
done
sed -i '1d' interfaces
#cat interfaces
 mv interfaces /etc/network
/etc/init.d/networking restart

#修改hostname文件
read -p "please input hostname:" Hostname
sed -i "\$a$Hostname" /etc/hostname
sed -i '1d' /etc/hostname

#修改hosts文件
cp /etc/hosts $(pwd)
sed -i  '2d' hosts
host1="${IP_Array[0]}    $Hostname"
host2="${IP_Array[1]}    $Hostname"
sed -i "1a$host1" hosts
sed -i "2a$host2" hosts
#cat hosts
 mv hosts /etc/hosts











