# node-infra-pipeline

# How to deploy infrastructure using Terraform.

Directory Structure
Terraform configuration files are located at:
node-demo-app/terraform

Includes:
  provider.tf – AWS provider config
  variables.tf – Input variables
  terraform.tfvars – Variable values
  main.tf – Resource definitions
  outputs.tf – Output values

Resources Managed
  VPC and Subnets
  Security Groups
  EC2 Instance
  Load Balancer and Auto Scaling Group
  IAM Roles & Policies
  ECR Repository

Deploy Steps
Initialize Terraform
    terraform init
Validate Configuration
    terraform validate
Preview Resources
    terraform plan
Apply Infrastructure
    terraform apply
![Screenshot 2025-06-18 092203](https://github.com/user-attachments/assets/febc371b-1cd0-4b7d-9608-12aa37d5b02d)
![Screenshot 2025-06-18 092203](https://github.com/user-attachments/assets/febc371b-1cd0-4b7d-9608-12aa37d5b02d)

After successful apply, AWS resources will be provisioned automatically as defined in  Terraform code.



  
