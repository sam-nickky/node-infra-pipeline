# node-infra-pipeline

## How to deploy infrastructure using Terraform.

### Directory Structure

Terraform configuration files are located at:  
`node-demo-app/terraform`

Includes:
- `provider.tf` – AWS provider config  
- `variables.tf` – Input variables  
- `terraform.tfvars` – Variable values  
- `main.tf` – Resource definitions  
- `outputs.tf` – Output values  

### Resources Managed
- VPC and Subnets  
- Security Groups  
- EC2 Instance  
- Load Balancer and Auto Scaling Group  
- IAM Roles & Policies  
- ECR Repository  

### Deploy Steps

**Initialize Terraform**  
```bash
terraform init
```

**Validate Configuration**  
```bash
terraform validate
```

**Preview Resources**  
```bash
terraform plan
```

**Apply Infrastructure**  
```bash
terraform apply
```

![Screenshot 2025-06-18 092203](https://github.com/user-attachments/assets/03bc19d6-0efa-440a-a4e9-2bb1d5c82e27)

After successful apply, AWS resources will be provisioned automatically as defined in  Terraform code.



  
