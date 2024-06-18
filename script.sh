#!/bin/bash
dpkg --configure -a
apt-get -y update

# install Apache2
apt-get -y install apache2
apt-get -y update
apt-get -y install mysql-server
apt-get -y install php libapache2-mod-php php-mysql
# write some HTML
cd /var/www/html/
echo "<h1>hello from $(hostname -f)</h1>">/var/www/html/index.html

# restart Apache
apachectl restart