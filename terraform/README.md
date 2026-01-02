# Azure VMSS with Load Balancer - Terraform Configuration

This Terraform configuration creates an Azure Virtual Machine Scale Set (VMSS) with a Public Load Balancer for hosting a web server.

## Architecture Overview

This configuration deploys:
- Resource Group
- Virtual Network with Subnet
- Network Security Group (allows HTTP and SSH traffic)
- Public IP Address
- Standard Load Balancer with:
  - Frontend IP Configuration
  - Backend Address Pool
  - Health Probe (HTTP on port 80)
  - Load Balancer Rule
- Linux Virtual Machine Scale Set (Ubuntu 20.04 LTS)
- Custom Script Extension (installs Apache web server)

## Prerequisites

1. **Azure Subscription**: Ensure you have an active Azure subscription
2. **Azure CLI**: Install and configure Azure CLI
3. **Terraform**: Install Terraform (>= 1.0)
4. **SSH Key Pair**: Generate SSH keys for VM access

### Install Prerequisites

```bash
# Install Terraform (Windows with winget)
winget install Hashicorp.Terraform

# Install Azure CLI
az --version
# If not installed, follow: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

# Login to Azure
az login

# Generate SSH key pair (if you don't have one)
ssh-keygen -t rsa -b 4096 -C "your-email@domain.com"
```

## Quick Start

1. **Clone and Navigate**
   ```bash
   git clone https://github.com/atulkamble/Azure-Project-VMSS-LB.git
   cd Azure-Project-VMSS-LB/terraform
   ```

2. **Configure Variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Set SSH Public Key**
   ```bash
   # Get your public key
   cat ~/.ssh/id_rsa.pub
   # Copy the output and paste it in terraform.tfvars as ssh_public_key value
   ```

4. **Initialize and Deploy**
   ```bash
   # Initialize Terraform
   terraform init

   # Validate configuration
   terraform validate

   # Plan deployment
   terraform plan

   # Apply configuration
   terraform apply -auto-approve
   ```

5. **Access Your Web Application**
   ```bash
   # Get the public IP from outputs
   terraform output load_balancer_public_ip
   
   # Access the web application
   curl http://$(terraform output -raw load_balancer_public_ip)
   # Or open in browser: http://<public-ip>
   ```

## Configuration Options

### Key Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `resource_group_name` | MyResourceGroup | Name of the Azure resource group |
| `location` | East US | Azure region for deployment |
| `vm_sku` | Standard_B1s | VM size for scale set instances |
| `instance_count` | 2 | Initial number of VM instances |
| `admin_username` | azureuser | Admin username for VMs |
| `ssh_public_key` | "" | SSH public key for VM access |

### VM Size Options
- `Standard_B1s` (1 vCPU, 1 GB RAM) - Development
- `Standard_B2s` (2 vCPU, 4 GB RAM) - Small workloads
- `Standard_D2s_v3` (2 vCPU, 8 GB RAM) - Production

## File Structure

```
terraform/
├── main.tf                    # Main infrastructure resources
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output values
├── terraform.tf              # Provider and version constraints
├── terraform.tfvars.example   # Example variable values
├── README.md                  # This file
└── scripts/
    └── install-webserver.sh   # Web server installation script
```

## Deployment Steps (Detailed)

### 1. Validate Configuration
```bash
terraform validate
```

### 2. Plan Deployment
```bash
terraform plan -out=tfplan
```

### 3. Apply Configuration
```bash
terraform apply -auto-approve
```

### 4. Verify Deployment
```bash
# Check outputs
terraform output

# Test web server
curl http://$(terraform output -raw load_balancer_public_ip)
```

## Scaling Operations

### Manual Scaling
```bash
# Update instance_count in terraform.tfvars
instance_count = 5

# Apply changes
terraform apply -auto-approve
```

### Auto-scaling (Future Enhancement)
Auto-scaling rules can be added using `azurerm_monitor_autoscale_setting` resource.

## Monitoring and Management

### View Resources in Azure Portal
- Resource Group: Use the `azure_portal_resource_group_url` output
- Load Balancer: Navigate to Load Balancers in the portal
- VMSS: Navigate to Virtual Machine Scale Sets

### Health Checks
```bash
# Check load balancer health probe
az network lb probe show \
  --resource-group $(terraform output -raw resource_group_name) \
  --lb-name $(terraform output -raw load_balancer_name) \
  --name MyHealthProbe
```

## Troubleshooting

### Common Issues

1. **SSH Key Not Set**
   ```bash
   Error: ssh_public_key is required
   ```
   Solution: Set the SSH public key in terraform.tfvars

2. **Resource Name Conflicts**
   ```bash
   Error: Resource already exists
   ```
   Solution: Change resource names in terraform.tfvars

3. **Web Server Not Responding**
   - Check NSG rules allow port 80
   - Verify VMs are healthy in load balancer backend pool
   - Check custom script extension logs in Azure portal

### Debugging
```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
terraform apply

# Check Azure CLI configuration
az account show
az account list-locations --query "[].name" -o table
```

## Cleanup

```bash
# Destroy all resources
terraform destroy -auto-approve

# Clean up Terraform files (optional)
rm -rf .terraform/
rm terraform.tfstate*
rm tfplan
```

## Security Considerations

- SSH access is enabled through NSG rules
- Consider restricting SSH access to specific IP ranges
- Use Azure Key Vault for secrets management in production
- Enable Azure Security Center recommendations
- Consider using Managed Identity for VM authentication

## Cost Optimization

- Use `Standard_B1s` VMs for development (burstable performance)
- Enable VM auto-shutdown for non-production environments
- Consider spot instances for cost-sensitive workloads
- Monitor costs using Azure Cost Management

## Next Steps

1. **Enable Auto-scaling**: Add autoscale settings based on metrics
2. **Add Application Gateway**: For Layer 7 load balancing
3. **Implement CI/CD**: Use Azure DevOps or GitHub Actions
4. **Add Monitoring**: Integrate with Azure Monitor and Application Insights
5. **Enhance Security**: Implement Azure Security Center recommendations

## Support

For issues and questions:
- Check the [original Azure CLI version](../README.md)
- Review [Azure VMSS documentation](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/)
- Check [Terraform Azure Provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)