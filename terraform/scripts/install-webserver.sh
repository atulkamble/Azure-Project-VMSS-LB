#!/bin/bash

# Log all activities
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update package lists
dpkg --configure -a
apt-get -y update

# Install Apache2
apt-get -y install apache2
apt-get -y update

# Install MySQL server
apt-get -y install mysql-server

# Install PHP and PHP modules
apt-get -y install php libapache2-mod-php php-mysql

# Create a simple HTML page with hostname
cd /var/www/html/
echo "<html><head><title>Azure VMSS Web Server</title></head><body>" > /var/www/html/index.html
echo "<h1>Hello from $(hostname -f)</h1>" >> /var/www/html/index.html
echo "<p>Server IP: $(hostname -I | awk '{print $1}')</p>" >> /var/www/html/index.html
echo "<p>Server Time: $(date)</p>" >> /var/www/html/index.html
echo "<p>Powered by Azure Virtual Machine Scale Set</p>" >> /var/www/html/index.html
echo "</body></html>" >> /var/www/html/index.html

# Set proper permissions
chown www-data:www-data /var/www/html/index.html
chmod 644 /var/www/html/index.html

# Enable and restart Apache
systemctl enable apache2
systemctl restart apache2

# Ensure Apache is running
systemctl status apache2

echo "Web server installation completed successfully!"