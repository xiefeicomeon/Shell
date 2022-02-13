#!/bin/bash
tar -xvzf /home/smart/jdk-8u301-linux-x64.tar.gz -C /opt/
sed -i "\$a export JAVA_HOME=/opt/jdk1.8.0_301" /etc/profile
sed -i "\$a export JRE_HOME=/opt/jdk1.8.0_301/jre" /etc/profile
sed -i "\$a export CLASSPATH=\$JAVA_HOME/lib:\$CLASSPATH" /etc/profile
sed -i "\$a export PATH=\$JAVA_HOME/bin:\$PATH" /etc/profile
source /etc/profile
java -version

