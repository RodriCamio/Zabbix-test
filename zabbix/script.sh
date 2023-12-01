# Install Zabbix 5.0 LTS CentOS 7 Server, Frontend, Agent PostgresSQL Apache
# Install Zabbix repository
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
yum clean all
# Install Zabbix server, frontend, agent
yum install -y zabbix-server-pgsql zabbix-agent
# Install Zabbix frontend
yum install -y centos-release-scl
# Edit file /etc/yum.repos.d/zabbix.repo and enable zabbix-frontend repository.
cp /vagrant/zabbix.repo /etc/yum.repos.d/zabbix.repo
chmod 755 /etc/yum.repos.d/zabbix.repo
# Install Zabbix frontend packages.
yum install -y zabbix-web-pgsql-scl zabbix-apache-conf-scl

# Create initial database
# Definir la contraseña como variable de entorno
sudo -u postgres createuser -ew zabbix
sudo -u postgres createdb -O zabbix zabbix

zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix psql zabbix

# Configure the database for Zabbix server
# Edit file /etc/yum.repos.d/zabbix.repo and enable zabbix-frontend repository.
cp /vagrant/zabbix_server.conf /etc/zabbix/zabbix_server.conf
chmod 755 /etc/zabbix/zabbix_server.conf
# Edit file /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf uncomment and set the right timezone for you.
cp /vagrant/zabbix.conf /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
chmod 755 /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
# Start Zabbix server and agent processes
systemctl restart zabbix-server zabbix-agent httpd rh-php72-php-fpm
systemctl enable zabbix-server zabbix-agent httpd rh-php72-php-fpm

# # Configuración de SNMP Traps en Zabbix
# yum install -y net-snmp-utils net-snmp-perl net-snmp
# mkdir -p /var/log/snmptrap
# chmod 750 /var/log/snmptrap
# chown zabbix:zabbix /var/log/snmptrap
# cp /vagrant/snmptrapd.conf /etc/snmp/snmptrapd.conf
# wget -O /usr/bin/zabbix_trap_reciver.pl https://git.zabbix.com/projects/ZBX/repos/zabbix/raw/misc/snmptrap/zabbix_trap_receiver.pl
# chmod 755 /usr/bin/zabbix_trap_reciver.pl
# systemctl restart zabbix-server
# systemctl enable snmptrapd
# systemctl start snmptrapd
# cp /vagrant/zabbix_traps /etc/logrotate.d/zabbix_traps
# logrotate -v -f /etc/logrotate.d/zabbix_traps 