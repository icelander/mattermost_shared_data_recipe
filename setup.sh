#!/bin/bash

apt-get -q -y update

# Sets the root password for MariaDB
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -q -y install mysql-server nginx samba

# Allows cluster to connect to MySQL
sed -i 's|bind-address|#bind-address|g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
mysql -uroot -proot < /vagrant/db_setup.sql

mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig
cp /vagrant/nginx.conf /etc/nginx/sites-available/default
service nginx restart

mkdir -p /shared/mmst-data

adduser --no-create-home --disabled-password --disabled-login --gecos "" mattermost

chown -R mattermost:mattermost /shared/mmst-data
mv /etc/samba/smb.conf /etc/samba/orig.smb.conf
ln -s /vagrant/smb.conf /etc/samba/smb.conf
cat /etc/passwd | mksmbpasswd > /etc/smbpasswd
(echo samba_password; echo samba_password) | smbpasswd -a mattermost
service smbd restart