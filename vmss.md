```
// VMSS

1. Create VMSS
2. OS >> Size

Custom Data

#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
cd /var/www/html || exit
rm -f index.html
hostname=$(hostname)
echo "<h1>Webserver: $hostname</h1>" > index.html

3. attach existing LB
4. vm count = 4
5. cutom policy - desired capacity - 2
6. check number of VMs
7. LB URL Check
```
