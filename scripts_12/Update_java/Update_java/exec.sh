#!/bin/bash
#解压安装包到/opt目录下
tar -xvzf /home/smart/jdk-8u301-linux-x64.tar.gz -C /opt/

#更新java路径
update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_301/bin/java 1200
update-alternatives --install /usr/bin/java javac /opt/jdk1.8.0_301/bin/javac 1200

#在 /etc/profile 最下面添加环境变量参数
sed -i "\$a export JAVA_HOME=/opt/jdk1.8.0_301" /etc/profile
sed -i "\$a export JRE_HOME=/opt/jdk1.8.0_301/jre" /etc/profile
sed -i "\$a export CLASSPATH=\$JAVA_HOME/lib:\$CLASSPATH" /etc/profile
sed -i "\$a export PATH=\$JAVA_HOME/bin:\$PATH" /etc/profile
#使修改后的文件生效
source /etc/profile

#查看当前Java版本
java -version

#清除文件
cd /home/smart
rm -rf Update_java
