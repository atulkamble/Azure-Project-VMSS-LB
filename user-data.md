```
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
cd /var/www/html || exit
rm -f index.html
hostname=$(hostname)
echo "<h1>Webserver: $hostname</h1>" > index.html
```
