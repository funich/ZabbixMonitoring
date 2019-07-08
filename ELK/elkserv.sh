#!/bin/bash

#elasticsearch installing
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
ELKREPO="/etc/yum.repos.d/"
cat <<EOM >$ELKREPO/elasticsearch.repo
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md

EOM

ESCONF="/etc/elasticsearch/elasticsearch.yml"
cat <<EOM >$ESCONF
network.host: 172.33.33.33
http.port: 9200
cluster.initial_master_nodes: ["node-1"]
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch

EOM

sudo yum -y install elasticsearch
systemctl start elasticsearch.service
systemctl enable elasticsearch.service

#kibana installing
#rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
KIBANAREPO="/etc/yum.repos.d/"
cat <<EOM >$KIBANAREPO/kibana.repo
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md

EOM

KIBANACONF="/etc/kibana/kibana.yml"
cat <<EOM >$KIBANACONF
server.port: 5601
server.host: "172.33.33.33"
elasticsearch.hosts: ["http://172.33.33.33:9200"]

EOM

sudo yum install -y kibana
sudo systemctl start kibana.service
sudo systemctl enable kibana.service