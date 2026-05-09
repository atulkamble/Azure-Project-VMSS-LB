# Azure Virtual Machine Scale Set (VMSS) with Public Load Balancer

This document explains how to deploy a highly available web application using:

* Azure Virtual Machine Scale Set (VMSS)
* Azure Standard Public Load Balancer
* Apache Web Server
* Custom Script / Cloud-Init
* Azure Virtual Network

The setup automatically installs Apache on VMSS instances and distributes traffic using Azure Load Balancer. 

---

# 📖 What is VMSS?

Azure Virtual Machine Scale Set (VMSS) is a service that helps deploy and manage a group of identical virtual machines.

VMSS provides:

* High Availability
* Automatic Scaling
* Load Balancing
* Centralized Management
* Fault Tolerance

VMSS is commonly used for:

* Web Applications
* APIs
* Microservices
* CI/CD Agents
* Enterprise Workloads

---

# 🏗️ Architecture

```text
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

Before starting, ensure you have:

* Azure Subscription
* Azure Portal Access
* Azure CLI Installed
* Existing Resource Group
* Existing Virtual Network
* SSH Key Pair (Optional)

---

# 📌 Components Used

| Service       | Purpose                       |
| ------------- | ----------------------------- |
| VMSS          | Deploy identical VM instances |
| Load Balancer | Distribute incoming traffic   |
| VNet          | Private networking            |
| NSG           | Security rules                |
| Apache        | Web server                    |
| Cloud-Init    | Bootstrap automation          |

---

# 📂 Project Structure

```text
vmss-project/
│
├── script.sh
└── README.md
```

---

# 📜 Minimal Apache Installation Script

## script.sh

```bash
#!/bin/bash

apt update -y
apt install apache2 -y

systemctl enable apache2
systemctl start apache2

HOSTNAME=$(hostname)

echo "<h1>Webserver: $HOSTNAME</h1>" > /var/www/html/index.html
```

---

# 🚀 Deployment Using Azure Portal

# Step 1 — Create Resource Group

Azure Portal →

```text
Resource Groups → Create
```

Example:

| Setting        | Value        |
| -------------- | ------------ |
| Resource Group | rg-vmss-demo |
| Region         | East US      |

Click:

```text
Review + Create
```

---

# Step 2 — Create Virtual Network

Azure Portal →

```text
Virtual Networks → Create
```

Example:

| Setting       | Value       |
| ------------- | ----------- |
| VNet Name     | vnet-vmss   |
| Address Space | 10.0.0.0/16 |
| Subnet Name   | subnet-web  |
| Subnet Range  | 10.0.1.0/24 |

---

# Step 3 — Create VM Scale Set

Azure Portal →

```text
Virtual Machine Scale Sets → Create
```

---

# 🔹 Basic Settings

| Setting            | Value               |
| ------------------ | ------------------- |
| Resource Group     | rg-vmss-demo        |
| VMSS Name          | vmss-demo           |
| Region             | East US             |
| Orchestration Mode | Uniform             |
| Security Type      | Standard            |
| Image              | Ubuntu Server 22.04 |
| Size               | Standard_B2s        |
| Authentication     | SSH Public Key      |
| Instance Count     | 2                   |

---

# 🔹 Administrator Account

| Setting             | Example   |
| ------------------- | --------- |
| Username            | azureuser |
| Authentication Type | SSH Key   |

---

# 🔹 Networking Settings

Select:

* Existing VNet
* Existing Subnet

Example:

| Setting         | Value      |
| --------------- | ---------- |
| Virtual Network | vnet-vmss  |
| Subnet          | subnet-web |

---

# 🔹 Load Balancer Settings

Enable:

```text
Use a Load Balancer
```

Select:

| Setting            | Value               |
| ------------------ | ------------------- |
| Load Balancer Type | Azure Load Balancer |
| Type               | Public              |
| SKU                | Standard            |

---

# 🔹 Frontend IP Configuration

Create:

```text
frontend-ip
```

---

# 🔹 Backend Pool

Create:

```text
backend-pool
```

---

# 🔹 Health Probe Configuration

| Setting  | Value |
| -------- | ----- |
| Protocol | TCP   |
| Port     | 80    |

Health probes verify VM health before sending traffic.

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

```bash
#!/bin/bash

apt update -y
apt install apache2 -y

systemctl enable apache2
systemctl start apache2

HOSTNAME=$(hostname)

echo "<h1>Webserver: $HOSTNAME</h1>" > /var/www/html/index.html
```

---

# Step 4 — Review and Create

Click:

```text
Review + Create
```

Then:

```text
Create
```

Deployment takes several minutes.

---

# 🌐 Access Application

Copy:

```text
Load Balancer Public IP
```

Open browser:

```text
http://<LoadBalancer-Public-IP>
```

Example:

```html
Webserver: vmss_abcd1234
```

Refresh browser multiple times to observe traffic reaching different VM instances.

---

# 🚀 Deployment Using Azure CLI

---

# Step 1 — Login to Azure

```bash
az login
```

---

# Step 2 — Create Resource Group

```bash
az group create \
  --name rg-vmss-demo \
  --location eastus
```

---

# Step 3 — Create Virtual Network

```bash
az network vnet create \
  --resource-group rg-vmss-demo \
  --name vnet-vmss \
  --subnet-name subnet-web
```

---

# Step 4 — Create script.sh

```bash
nano script.sh
```

Paste:

```bash
#!/bin/bash

apt update -y
apt install apache2 -y

systemctl enable apache2
systemctl start apache2

HOSTNAME=$(hostname)

echo "<h1>Webserver: $HOSTNAME</h1>" > /var/www/html/index.html
```

Save:

```text
CTRL + O
CTRL + X
```

---

# Step 5 — Create VM Scale Set

```bash
az vmss create \
  --resource-group rg-vmss-demo \
  --name vmss-demo \
  --image Ubuntu2204 \
  --instance-count 2 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --vnet-name vnet-vmss \
  --subnet subnet-web \
  --upgrade-policy-mode automatic \
  --lb lb-vmss-demo \
  --custom-data script.sh
```

---

# Step 6 — Open Port 80

```bash
az vmss open-port \
  --resource-group rg-vmss-demo \
  --name vmss-demo \
  --port 80
```

---

# Step 7 — Retrieve Load Balancer Public IP

```bash
az network public-ip list \
  --resource-group rg-vmss-demo \
  --output table
```

---

# 🌐 Access Website

Open:

```text
http://<Public-IP>
```

---

# 🔍 Validation Commands

## Check Apache Status

```bash
sudo systemctl status apache2
```

---

## Verify Port 80

```bash
sudo ss -tunlp | grep 80
```

---

## Test Website Locally

```bash
curl localhost
```

---

# 📂 Important Log File

## Cloud Init Logs

```bash
/var/log/cloud-init-output.log
```

---

# 🔐 Required NSG Rules

| Port | Protocol | Purpose |
| ---- | -------- | ------- |
| 22   | TCP      | SSH     |
| 80   | TCP      | HTTP    |

---

# 📌 VMSS Scaling Types

## Manual Scaling

Administrator manually increases or decreases VM instances.

---

## Auto Scaling

Automatically scales based on:

* CPU Usage
* Memory Usage
* Network Traffic
* Azure Monitor Metrics

---

# 📌 VMSS Modes

## Uniform Mode

* All VMs identical
* Best for stateless workloads
* Most commonly used

---

## Flexible Mode

* Different VM sizes supported
* Stateful workloads possible
* Greater customization

---

# 📌 Load Balancer Overview

Azure Load Balancer distributes traffic evenly across backend VM instances.

Supports:

* Layer 4 Load Balancing
* TCP
* UDP
* Health Probes
* High Availability

---

# 📌 Advantages of VMSS

* Automatic Scaling
* High Availability
* Easy Management
* Load Balancing Integration
* Fault Tolerance
* Cost Efficient

---

# 📌 Limitations

* Best suited for stateless workloads
* Stateful applications require external storage
* Uniform mode has limited customization

---

# 📌 VMSS vs Availability Set

| Availability Set   | VMSS              |
| ------------------ | ----------------- |
| Manual Scaling     | Automatic Scaling |
| Fixed VM Count     | Dynamic Scaling   |
| Basic HA           | HA + Scaling      |
| Limited Automation | Full Automation   |

---

# 🎯 Interview Questions

## What is VMSS?

Azure VMSS is a service used to deploy and manage multiple identical VMs with autoscaling and load balancing support.

---

## Why Use Load Balancer with VMSS?

To distribute traffic across multiple VM instances for high availability and fault tolerance.

---

## What is a Health Probe?

A Health Probe checks VM availability before routing traffic.

---

## What Happens if a VM Fails?

VMSS automatically replaces unhealthy or failed VM instances.

---

## Difference Between Uniform and Flexible Mode?

| Uniform        | Flexible           |
| -------------- | ------------------ |
| Identical VMs  | Different VM Types |
| Stateless Apps | Stateful Apps      |
| Simpler        | More Control       |

---

# 📌 Important Points to Remember

* VMSS supports autoscaling
* Standard Load Balancer is production recommended
* Health Probes are mandatory
* Cloud-init runs during first boot
* NSG must allow HTTP traffic
* VMSS integrates with Azure Monitor

---

# ✅ Final Outcome

After successful deployment:

* Apache installs automatically on VMSS instances
* Azure Load Balancer distributes traffic
* Web application becomes highly available
* VMSS enables centralized scaling and management
* Traffic is balanced across multiple VM instances
