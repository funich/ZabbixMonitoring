#!/bin/bash

#tomcat installing
yum install -y java tomcat tomcat-webapps tomcat-admin-webappsnginx
yum clean all
chown -R tomcat:tomcat /usr/share/tomcat
systemctl start tomcat
systemctl enable tomcat

#logstash installing
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
LSREPO="/etc/yum.repos.d/"
cat <<EOM >$LSREPO/logstash.repo
[logstash-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md

EOM

sudo yum install -y logstash
TSCONF="/etc/logstash/conf.d/"
cat <<EOM >$TSCONF/tomcatstash.conf
input{
 file{
  path => "/var/log/tomcat/catalina.out"
  start_position => "beginning"
 }
}

output{
 elasticsearch{
  hosts => ["172.33.33.33:9200"]
 }
 stdout{codec=>rubydebug}
}

EOM

systemctl start logstash
systemctl enable logstash