#!/bin/bash
yum update -y
yum install -y mariadb mariadb-server

/usr/bin/mysql_install_db --user=mysql

systemctl start mariadb
systemctl enable mariadb.service

mysql -uroot<<EOM
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
quit;
EOM

yum install -y http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm

#yum install -y zabbix-server-mysql zabbix-web-mysql
yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-get

zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql -uzabbix -pzabbix zabbix

cat >> /etc/zabbix/zabbix_server.conf <<EOF

DBHost=localhost
#DBName=zabbix
#DBUser=zabbix
DBPassword=zabbix

EOF

systemctl start zabbix-server

sed -i '/\<IfModule mod_php5.c\>/a php_value date.timezone Europe\/Minsk' /etc/httpd/conf.d/zabbix.conf

systemctl start httpd

