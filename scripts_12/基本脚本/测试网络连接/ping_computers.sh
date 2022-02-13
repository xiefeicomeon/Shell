#!/bin/bash

#一区服务器IP
  IP1_Array_f=("192.10.10.10"   "192.10.10.20"  "192.10.10.30"  "192.10.10.40"   "192.10.10.70"  "192.10.10.80")
#二区服务器IP
 IP2_Array_f=("192.10.20.50"  "192.10.20.60")  
#一区工作站IP
IP1_Array_g=(  "192.10.10.31"  "192.10.10.32" "192.10.10.33"  "192.10.10.71")


#测试一区服务器能否ping通
echo "测试一区服务器能否ping通"
    for ip in ${IP1_Array_f[@]}
    do
        output=$(ping -c 3 $ip | grep '.errors.')
                if [[ $output = "" ]] ; then
         echo "$ip is reachable"
         else
           echo "$ip is unreachable，请检查机器网络连接是否正常" 
        fi

    done

    #测试一区工作站能否ping通
    echo "测试一区工作站能否ping通"
    for ip in ${IP1_Array_g[@]}
    do
        output=$(ping -c 3 $ip | grep '.errors.')
        
        if [[ $output = "" ]] ; then
         echo "$ip is reachable"
         else
           echo "$ip is unreachable，请检查机器网络连接是否正常" 
        fi

    done
    #测试二区服务器能否ping通
    echo "测试二区服务器能否ping通"
    for ip in ${IP2_Array_f[@]}
    do
        output=$(ping -c 3 $ip | grep '.errors.')
       
        if [[ $output = "" ]] ; then
         echo "$ip is reachable"
         else
           echo "$ip is unreachable，请检查机器网络连接是否正常" 
        fi

    done

    