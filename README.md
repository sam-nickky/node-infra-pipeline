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

## How the CI/CD pipeline works and how to trigger it.

The CI/CD pipeline automates the process of testing, building, and deploying your Node.js application to AWS EC2 using Jenkins.

### Workflow

1. **Code Push to GitHub/GitLab**
2. **Jenkins Trigger**  
   (via Webhook )

### Pipeline Stages

- **Test Stage:** Runs unit tests
- **Build Stage:** Creates Docker image
- **Push Stage:** Pushes image to Amazon ECR
- **Deploy Stage:** Uses Terraform + SSH or Ansible to update EC2 instances
- **Rollback Stage:** On failure, reverts to previous image

### Triggering the Pipeline

- **Automatically:** Through webhooks on Git push
- **Manually:**  
  From Jenkins dashboard → select job → click **“Build Now”**

### Jenkinsfile

You can find the working `Jenkinsfile` in the repository above.  
 It has been tested and is working as expected.  
The deployed application is accessible via the web.

## Monitoring and Alerts Setup

🎯 **Goals**  
Monitor system performance and receive alerts on failures or anomalies.

🛠️ **Tools Used**
- **Amazon CloudWatch:** For EC2/RDS metrics, logs, and custom dashboards
- **CloudWatch Alarms:** Trigger alerts based on thresholds
- **SNS (Simple Notification Service):** Sends alerts via email/SMS
- **Node.js App Monitoring:** Sends custom logs/metrics to CloudWatch

📌 **Steps**

1. **Enable CloudWatch Agent** on EC2 to collect CPU, memory, and disk metrics.
2. **Stream Logs** (application logs, system logs) to **CloudWatch Logs**.
3. **Create Alarms** for:
   - High CPU usage (>70%)
   - EC2 instance down
   - RDS storage nearing capacity
4. **Set Notifications** using **SNS** to trigger actions such as email or SMS alerts when alarms are triggered.


## Design Decisions, Architecture Trade-Offs & Challenges

 **Decisions**
- Used **Terraform** for repeatable infrastructure setup (Infrastructure as Code)
- Chose **EC2 + ALB** instead of ECS/EKS for simpler VM-based hosting
- Used **Amazon ECR** as a private container image registry
- Selected **Jenkins** for the CI/CD pipeline due to its flexibility and maturity

 **Architecture Trade-Offs**
- **EC2 vs ECS:**  
  EC2 offers full control and flexibility, but requires manual scaling and patching  
- **RDS vs Self-Hosted DB:**  
  RDS is managed and reliable, but slightly more expensive than a self-hosted alternative  
- **Jenkins on EC2 vs GitHub Actions:**  
  Jenkins requires ongoing maintenance but offers more customization and control

 **Challenges**
- Setting up secure **IAM roles and access policies**
- Managing **SSH keys** and **secrets** securely
- Implementing a robust **rollback strategy** in the CI/CD pipeline
- Monitoring **deployment issues in real-time**

