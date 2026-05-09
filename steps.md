# Azure VM Scale Set (VMSS) with Public Load Balancer

## 📖 Overview

This project demonstrates deployment of:

* Azure Virtual Machine Scale Set (VMSS)
* Azure Standard Public Load Balancer
* Apache Web Server using Custom Script
* High Availability Web Application Architecture

Traffic is distributed across multiple VMSS instances using Azure Load Balancer.

---

# 🏗️ Architecture

```text id="cl3hry"
Internet
    │
    ▼
Azure Public Load Balancer
    │
    ▼
Backend Pool
    │
 ┌────────────────────┐
 │ Azure VM Scale Set │
 │ VM Instance 1      │
 │ VM Instance 2      │
 │ VM Instance N      │
 └────────────────────┘
```

---

# 📌 Prerequisites

* Azure Subscription
* Azure Portal Access
* Existing Resource Group
* Existing Virtual Network
* SSH Key Pair (optional)

---

# 🚀 Deployment Steps

# 1️⃣ Create Resource Group

Azure Portal → Resource Groups → Create

Example:

```text id="t9izlu"
rg-vmss-demo
```

---

# 2️⃣ Create Virtual Network

Create:

* VNet
* Subnet

Example:

```text id="13tq45"
VNet Name: vnet-vmss
Subnet Name: subnet-web
```

---

# 3️⃣ Create Storage Account

Azure Portal → Storage Accounts → Create

Example:

```text id="kzb91t"
stvmssdemo
```

---

# 4️⃣ Create Container

Storage Account →

```text id="f45n1x"
Containers → Create
```

Example:

```text id="jlwmkp"
scripts
```

Upload:

```text id="jlwmkp"
script.sh
```

---

# 5️⃣ Create Script File

## 📜 script.sh

```bash id="qq8qgq"
#!/bin/bash

apt update -y
apt install apache2 -y

systemctl enable apache2
systemctl start apache2

HOSTNAME=$(hostname)

echo "<h1>Webserver: $HOSTNAME</h1>" > /var/www/html/index.html
```

---

# 6️⃣ Create VM Scale Set

Azure Portal →

```text id="mlg45v"
Virtual Machine Scale Sets → Create
```

---

# 🔹 Basic Settings

| Setting        | Value               |
| -------------- | ------------------- |
| Resource Group | rg-vmss-demo        |
| VMSS Name      | vmss-demo           |
| Region         | East US             |
| Orchestration  | Uniform             |
| Image          | Ubuntu Server 22.04 |
| Size           | Standard_B2s        |
| Authentication | SSH Public Key      |
| Instance Count | 2                   |

---

# 🔹 Networking

Select:

* Existing VNet
* Existing Subnet

---

# 🔹 Load Balancer

Select:

| Setting       | Value               |
| ------------- | ------------------- |
| Load Balancer | Azure Load Balancer |
| Type          | Public              |
| SKU           | Standard            |

---

# 🔹 Frontend IP

Create:

```text id="u9k9dx"
frontend-ip
```

---

# 🔹 Backend Pool

Create:

```text id="g5n7up"
backend-pool
```

---

# 🔹 Health Probe

| Setting  | Value |
| -------- | ----- |
| Protocol | TCP   |
| Port     | 80    |

---

# 🔹 Load Balancing Rule

| Setting       | Value        |
| ------------- | ------------ |
| Protocol      | TCP          |
| Frontend Port | 80           |
| Backend Port  | 80           |
| Frontend IP   | frontend-ip  |
| Backend Pool  | backend-pool |

---

# 🔹 Advanced → Custom Data

Paste:

```text id="5c26h0"
script.sh
```

---

# 7️⃣ Review and Create

Click:

```text id="7sn0kx"
Review + Create
```

Then:

```text id="v12m9y"
Create
```

Deployment takes several minutes.

---

# 🌐 Access Application

Copy:

```text id="tquqhb"
Load Balancer Public IP
```

Open browser:

```text id="iwbbbx"
http://<LoadBalancer-Public-IP>
```

Example Output:

```html id="ccmrk4"
Webserver: vmss_abc123
```

Refresh browser multiple times to observe requests reaching different VMSS instances.

---

# 🔍 Verify VMSS Instances

Azure Portal →

```text id="8jlwm0"
VM Scale Sets → Instances
```

Check:

* Running Status
* Health Status
* Instance Count

---

# 🔐 NSG Rules Required

| Port | Protocol | Purpose |
| ---- | -------- | ------- |
| 22   | TCP      | SSH     |
| 80   | TCP      | HTTP    |

---

# 📂 Important Log File

## Linux Cloud Init Logs

```bash id="jlwmkp"
/var/log/cloud-init-output.log
```

---

# 🛠️ Azure CLI Example

## Create VMSS

```bash id="2lv8rx"
az vmss create \
  --resource-group rg-vmss-demo \
  --name vmss-demo \
  --image Ubuntu2204 \
  --instance-count 2 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name vnet-vmss \
  --subnet subnet-web \
  --lb lb-vmss-demo \
  --custom-data script.sh
```

---

# 🧪 Validation Commands

## Check Apache Status

```bash id="z0ndcu"
sudo systemctl status apache2
```

---

## Check Port 80

```bash id="t0cr4j"
sudo ss -tunlp | grep 80
```

---

## Verify Webpage

```bash id="1y7snw"
curl localhost
```

---

# 📌 Common Troubleshooting

## Apache Not Installed

```bash id="14bfuv"
sudo apt install apache2 -y
```

---

## Restart Apache

```bash id="8ukz1g"
sudo systemctl restart apache2
```

---

## Check Cloud Init Errors

```bash id="t8f4y6"
cat /var/log/cloud-init-output.log
```

---

# 📌 Important Points to Remember

* VMSS provides automatic scaling
* Load Balancer distributes traffic
* Health Probe checks VM health
* Custom Script runs during VM initialization
* Standard Load Balancer is recommended for production

---

# 🎯 Interview Questions

## What is VMSS?

Azure VMSS is a service that allows deployment and management of identical virtual machines with scaling capability.

---

## Why Use Load Balancer with VMSS?

To distribute incoming traffic across multiple VM instances.

---

## What is Health Probe?

Health Probe checks VM availability before routing traffic.

---

## Difference Between Availability Set and VMSS

| Availability Set | VMSS              |
| ---------------- | ----------------- |
| Manual Scaling   | Automatic Scaling |
| Fixed VM Count   | Dynamic Scaling   |
| Basic HA         | HA + Scaling      |

---

# ✅ Final Outcome

After deployment:

* Apache automatically installs on VMSS instances
* Azure Load Balancer distributes traffic
* Website becomes highly available
* VMSS enables scalability and centralized management
