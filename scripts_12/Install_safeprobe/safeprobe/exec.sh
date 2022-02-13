#!/bin/bash
tar -xvzf /home/smart/safeprobe/linx-intranet-monitor-1.0+6.0.80_amd64_2.5.5.tar.gz -C /opt/
cd  /opt/linx-intranet-monitor-1.0+6.0.80_amd64_2.5.5
./linx.sh install
./linx.sh status
#输入序列号
vim /etc/linxsn/security_sn.conf
#配置探针
agent_manage
#清除安装文件
cd /home/smart
rm -rf safeprobe


