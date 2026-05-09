# Azure VMSS with Public Load Balancer
* Create Resource Group
* Create Virtual Network and Subnet
* Create `script.sh`
```bash
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
HOSTNAME=$(hostname)
echo "<h1>Webserver: $HOSTNAME</h1>" > /var/www/html/index.html
```
* Go to Azure Portal
* Open VM Scale Sets
* Click Create
* Select Ubuntu 22.04
* Select VM Size
* Set Instance Count = 2
* Select Uniform Orchestration
* Select Existing VNet and Subnet
* Enable Azure Load Balancer
* Select Public Standard Load Balancer
* Create Frontend IP
* Create Backend Pool
* Create Health Probe Port 80
* Create Load Balancing Rule 80:80
* Advanced → Custom Data
* Paste `script.sh`
* Review + Create
* Create VMSS
* Copy Load Balancer Public IP
* Open Browser
```text
http://<LoadBalancer-Public-IP>
```
* Refresh browser multiple times
* Observe different VM hostnames
* Validate Apache
```bash
sudo systemctl status apache2
```
* Check Port 80
```bash
sudo ss -tunlp | grep 80
```
* Check Cloud Init Logs
```bash
cat /var/log/cloud-init-output.log
```
* VMSS provides High Availability
* Load Balancer distributes traffic
* Health Probe checks VM health
* Supports Autoscaling
* Standard Load Balancer recommended for Production
