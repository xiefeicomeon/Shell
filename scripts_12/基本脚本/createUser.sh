#!/bin/bash
echo "change root's password"
passwd root
echo "change sysadmin's password"
passwd sysadmin

#创建账户
groupadd kingbase
useradd -m -d /home/kingbase -s /bin/bash kingbase -g kingbase
echo "change kingbase's password"
passwd kingbase
groupadd smart
useradd -m -d /home/smart -s /bin/bash smart -g smart
echo "change smart's password"
passwd smart

