#!/usr/bin/bash

# Habilita SSH remoto
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PrintMotd yes/PrintMotd no/g' /etc/ssh/sshd_config
sed -i 's/PrintLastLog yes/PrintLastLog no/g' /etc/ssh/sshd_config
systemctl restart sshd

# Desactiva SELinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

# Detiene Firewall
systemctl stop firewalld && systemctl disable firewalld

# Actualiza e instala paqueteria adisional
yum update -y
yum install -y epel-release 
yum clean all
yum install -y git jq curl wget net-tools yum-utils bash-completion bash-completion-extras sysstat tree stress redhat-lsb* lsof

timedatectl set-timezone America/Buenos_Aires

# Personalizacion del entorno
cp /vagrant/update-motd.sh /etc/update-motd
chmod 755 /etc/update-motd
grep -qF 'update-motd' /etc/profile || echo "[ -x /etc/update-motd ] && /etc/update-motd" >>/etc/profile
grep -qxF "alias l='ls -la'" ~/.bashrc || echo "alias l='ls -la'" >>~/.bashrc
grep -qxF 'unalias ls' ~/.bashrc || echo "unalias ls" >>~/.bashrc

# Install Apache
yum install -y httpd

# Install PostgreSQL
yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install -y postgresql11 postgresql11-server
/usr/pgsql-11/bin/postgresql-11-setup initdb
cp /vagrant/pg_hba.conf /var/lib/pgsql/11/data/pg_hba.conf
chmod 755 /var/lib/pgsql/11/data/pg_hba.conf
systemctl enable postgresql-11
systemctl start postgresql-11
systemctl status postgresql-11

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
export PGPASSWORD=Z4bb1x
sudo -u postgres PGPASSWORD=$PGPASSWORD createuser --pwprompt zabbix
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