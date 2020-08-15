#!/usr/bin/env bash

#sudo yum -y update

# if we need any dependencies, install them here

#sudo yum -y update
sudo yum -y localinstall https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
sudo yum -y install mysql-community-server

# restart mysql
sudo service mysqld restart

TEMPPASS=$(sudo grep "password is generated for root@localhost:" /var/log/mysqld.log | awk '{ print $NF }')
pass="pass"
mysql -u root -p$TEMPPASS -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$pass';" --connect-expired-password

# Create user
mysql -u root -p$pass -e "CREATE USER 'root'@'%' IDENTIFIED BY '$pass'"
# allow remote access
mysql -u root -p$pass -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"

# flush
mysql -u root -p$pass -e "FLUSH PRIVILEGES;"

database="pollution"

# Create schema
mysql -u root -p$pass -e "CREATE DATABASE $database; use $database"

# restart
sudo service mysqld restart

# set to autostart
sudo chkconfig mysqld on
