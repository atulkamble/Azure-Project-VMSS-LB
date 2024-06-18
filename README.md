# Azure-Project-VMSS-LB
Creating a project to set up an Azure Virtual Machine Scale Set (VMSS) and a Public Load Balancer for a web server involves several steps. Below are the steps and example code to guide you through the process.

# Clone This Project Codes
```
git clone https://github.com/atulkamble/Azure-Project-VMSS-LB.git
cd Azure-Project-VMSS-LB
```
### Prerequisites
1. **Azure Subscription**: Ensure you have an active Azure subscription.
2. **Azure CLI**: Install the Azure CLI on your local machine. [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

### Steps and Code

#### 1. **Login to Azure**
First, log in to your Azure account using the Azure CLI.

```sh
az login
```

#### 2. **Create a Resource Group**
Create a resource group to hold all the resources for your project.

```sh
az group create --name MyResourceGroup --location eastus
```

#### 3. **Create a Virtual Network and Subnet**
Create a virtual network and a subnet within that network.

```sh
az network vnet create \
  --resource-group MyResourceGroup \
  --name MyVNet \
  --address-prefix 10.0.0.0/16 \
  --subnet-name MySubnet \
  --subnet-prefix 10.0.0.0/24
```

#### 4. **Create a Public IP Address**
Create a public IP address for the load balancer.

```sh
az network public-ip create \
  --resource-group MyResourceGroup \
  --name MyPublicIP \
  --sku Standard \
  --allocation-method Static
```

#### 5. **Create a Load Balancer**
Create the load balancer and its front-end IP configuration.

```sh
az network lb create \
  --resource-group MyResourceGroup \
  --name MyLoadBalancer \
  --sku Standard \
  --frontend-ip-name MyFrontEndPool \
  --public-ip-address MyPublicIP
```

#### 6. **Create a Backend Pool**
Create a backend pool for the load balancer.

```sh
az network lb address-pool create \
  --resource-group MyResourceGroup \
  --lb-name MyLoadBalancer \
  --name MyBackEndPool
```

#### 7. **Create a Health Probe**
Create a health probe for the load balancer to monitor the status of the VMs.

```sh
az network lb probe create \
  --resource-group MyResourceGroup \
  --lb-name MyLoadBalancer \
  --name MyHealthProbe \
  --protocol Tcp \
  --port 80 \
  --interval 15 \
  --threshold 4
```

#### 8. **Create a Load Balancer Rule**
Create a load balancer rule to distribute traffic.

```sh
az network lb rule create \
  --resource-group MyResourceGroup \
  --lb-name MyLoadBalancer \
  --name MyLoadBalancerRuleWeb \
  --protocol Tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name MyFrontEndPool \
  --backend-pool-name MyBackEndPool \
  --probe-name MyHealthProbe \
  --idle-timeout 4 \
  --enable-tcp-reset true
```

#### 9. **Create a Virtual Machine Scale Set**
Create a VM scale set and configure it to use the backend pool.

```sh
az vmss create \
  --resource-group MyResourceGroup \
  --name MyVMSS \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name MyVNet \
  --subnet MySubnet \
  --backend-pool-name MyBackEndPool \
  --lb-name MyLoadBalancer \ 
  --instance-count 2
```

#### 10. **Install a Web Server on the VMSS Instances**
Use a custom script extension to install a web server on the VM instances.
Login to account | pop up from browser | paste code 

VMSS >> Extensions >> Custom Script for Linux >> Storage Account >> Container >> script.sh
sh script.sh

```
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
```

#### 11. **Test the Load Balancer**
Finally, get the public IP address of the load balancer and test it in your browser.

```sh
az network public-ip show \
  --resource-group MyResourceGroup \
  --name MyPublicIP \
  --query ipAddress \
  --output tsv
```

Use the IP address to verify the setup by navigating to `http://<PublicIP>` in your web browser. You should see the default web page served by Apache.

### Conclusion
By following these steps, you set up an Azure VM Scale Set with a Public Load Balancer to host a web server. This setup ensures high availability and scalability for your web application.
