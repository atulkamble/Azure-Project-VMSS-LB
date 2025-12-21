## 🔹 Option 1: Linux VM (Nginx – Recommended)

This works on **Ubuntu / Amazon Linux / Debian-based** Azure VMs.

### ✅ What it does

* Updates OS packages
* Installs **Nginx**
* Creates a basic `index.html`
* Starts & enables the web server

```bash
#!/bin/bash
apt-get update -y
apt-get install -y nginx

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Azure VM Web Server</title>
  <style>
    body { font-family: Arial; text-align: center; margin-top: 60px; }
    h1 { color: #0078D4; }
  </style>
</head>
<body>
  <h1>🚀 Welcome to Azure VM</h1>
  <p>Basic Website Hosted using Azure VM User Data</p>
  <p>Deployed automatically at VM startup</p>
</body>
</html>
EOF

systemctl enable nginx
systemctl restart nginx
```

### 🌐 Access

```
http://<VM-Public-IP>
```

> Make sure **NSG allows inbound HTTP (Port 80)**.

---

## 🔹 Option 2: Linux VM (Apache)

```bash
#!/bin/bash
apt-get update -y
apt-get install -y apache2

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Azure Apache Web</title>
</head>
<body>
  <h1>Hello from Azure VM</h1>
  <p>Apache installed via User Data</p>
</body>
</html>
EOF

systemctl enable apache2
systemctl restart apache2
```

---

## 🔹 Option 3: Windows VM (IIS – PowerShell User Data)

Use this for **Windows Server VM**.

```powershell
<powershell>
Install-WindowsFeature -name Web-Server -IncludeManagementTools

$webPath = "C:\inetpub\wwwroot\index.html"

@"
<!DOCTYPE html>
<html>
<head>
<title>Azure IIS Web</title>
</head>
<body>
<h1>Welcome to Azure IIS VM</h1>
<p>Website deployed using User Data</p>
</body>
</html>
"@ | Out-File $webPath -Encoding utf8

iisreset
</powershell>
```

### 🌐 Access

```
http://<VM-Public-IP>
```

> Ensure **NSG allows HTTP (Port 80)**.

---

## 🔹 How to Add User Data (Azure Portal)

![Image](https://learn.microsoft.com/en-us/azure/cyclecloud/images/cloud-init.png?view=cyclecloud-8\&utm_source=chatgpt.com)

![Image](https://azure.microsoft.com/en-us/blog/wp-content/uploads/2019/06/fce72507-b066-4cf5-999b-8be2920c26a9.webp?utm_source=chatgpt.com)

![Image](https://docs.nginx.com/nginx/images/azure-create-vm-ngx-plus-1.png?utm_source=chatgpt.com)

![Image](https://docs.nginx.com/nginx/images/azure-create-vm-deployment-complete.png?utm_source=chatgpt.com)

1. Azure Portal → **Create Virtual Machine**
2. Go to **Advanced** tab
3. Paste script into **User data**
4. Create VM
5. Open browser → Public IP

---

## 🔹 Azure CLI Example (Linux VM)

```bash
az vm create \
  --resource-group rg-web \
  --name webvm \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --custom-data cloud-init.sh
```

---

## 🔹 Common Interview / Real-World Notes

* User Data runs **only on first boot**
* Logs location:

  * Linux: `/var/log/cloud-init-output.log`
  * Windows: `C:\AzureData\CustomDataSetupLog.txt`
* Best for **bootstrap tasks**, not long-running jobs
* For updates later → use **Ansible / Azure Automation**

---
