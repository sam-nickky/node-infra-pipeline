## Node.js Demo REST API

This is a simple RESTful API built with Node.js and Express.js. It demonstrates basic application structure, testing, environment configuration, and Docker-based deployment.

##  Features

- **API Endpoints** with basic endpoints:
  - `GET /health` – Health check
  - `GET /users` – Mock user data
- **Unit Testing** Unit tests using Jest for API functionality.
- **Environment Variable Support**  Dynamic configuration using environment variables

## Getting Started

## Project Setup & Usage (Step-by-Step)


1. **Clone the Repository**
   - Run the following commands:
     ```bash
     git clone https://github.com/sam-nickky/node-demo-app.git
     cd node-demo-app
     ```

2. **Install Project Dependencies**
   - Use `npm` to install all required packages:
     ```bash
     npm install
     ```

3. **Configure Environment Variables**
   - Create a `.env` file in the project root with the following content:
     ```env
     PORT=3000
     
     ```
   - Alternatively, you can store secrets in the `secrets/` directory:
     - `db_user.txt`
     - `db_password.txt`
     - `db_name.txt`

4. **Run Unit Tests**
   - Use the following command to execute tests written with Jest:
     ```bash
     npm test
     ```
   - Tests are located in the `test/` folder and validate endpoints like `/health` and `/users`.

5. **Start the Application Locally**
   - Run the app with:
     ```bash
     npm start
     ```
   - The app will be available at: [http://localhost:3000](http://localhost:3000)

![Screenshot 2025-06-17 094216](https://github.com/user-attachments/assets/195bac30-9db1-4853-b9ee-77eb25bca25b)




## Step 2: Containerization with Docker

1. **Create a Dockerfile**
   - Use a secure and minimal image like `node:20-alpine`.
   - The app runs as a non-root user and uses production-only dependencies.
   - Actual `Dockerfile` used:

     ```Dockerfile
     FROM node:20-alpine

     WORKDIR /usr/src/app

     COPY package*.json ./

     RUN npm ci --omit=dev

     COPY . .

     EXPOSE 3000

     RUN addgroup app && adduser -S -G app app
     USER app

     CMD [ "node", "src/index.js" ]
     ```

2. **Build the Docker Image**
   - Run the following command in your project root:
     ```bash
     docker build -t node-demo-app .
     ```

3. **Run the Docker Container Manually**
   - You can run it without Compose:
     ```bash
     docker run -p 8080:3000 node-demo-app
     ```
   - This maps your app's internal port `3000` to local port `8080`.

4. **Create a Docker Compose File**
   - Manage both app and database together using this `docker-compose.yml`:

     ```yaml
     version: "3.8"

     services:
       app:
         build: .
         ports:
           - "8080:3000"
         environment:
           - PORT=${PORT}
           - NODE_ENV=${NODE_ENV}
           - DB_HOST=db
           - DB_PORT=5432
           - DB_USER=${POSTGRES_USER}
           - DB_PASSWORD=${POSTGRES_PASSWORD}
           - DB_NAME=${POSTGRES_DB}
         depends_on:
           - db
         restart: unless-stopped

       db:
         image: postgres:15-alpine
         restart: unless-stopped
         environment:
           POSTGRES_USER: ${POSTGRES_USER}
           POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
           POSTGRES_DB: ${POSTGRES_DB}
         volumes:
           - pgdata:/var/lib/postgresql/data
         expose:
           - "5432"

     volumes:
       pgdata:
     ```

5. **Create a `.env` File for Docker Compose**
   - Store your environment variables securely in `.env` (in the same directory as `docker-compose.yml`):

     ```env
     PORT=3000
     NODE_ENV=production
     POSTGRES_USER=admin
     POSTGRES_PASSWORD=secret
     POSTGRES_DB=mydatabase
     ```

6. **Start with Docker Compose**
   - Launch the full stack (app + database) using:
     ```bash
     docker-compose up
     ```
   - The Node.js app will be available at: [http://localhost:8080](http://localhost:8080)

![Screenshot 2025-06-17 094229](https://github.com/user-attachments/assets/51b8d85e-eb47-49b9-aa4a-b48b6bb927df)


## Step 3: Infrastructure as Code (IaC) with Terraform (AWS)

This step provisions secure, scalable infrastructure on AWS using Terraform modules. It includes a VPC, EC2 Auto Scaling Group behind an ALB, RDS, ECR, and IAM roles.

---

1. **Initialize the Terraform Project**

   - Navigate to the Terraform directory and initialize the project:
     ```bash
     terraform init
     ```

---

2. **Configure AWS Provider**

   - Set the AWS region and credentials using a `provider.tf` file or environment variables:
     ```hcl
     provider "aws" {
       region = var.aws_region
     }
     ```

---

3. **Provision a VPC**

   - Define a Virtual Private Cloud (VPC) with:
     - Public subnets for load balancer
     - Private subnets for EC2 and RDS
   - This ensures secure network segmentation and scalability.

---

4. **Deploy an Application Load Balancer (ALB)**

   - Create an internet-facing ALB to handle HTTP/HTTPS traffic.
   - Add target groups and listeners to route requests to EC2 instances.
   - ALB distributes traffic across availability zones.

---

5. **Set Up EC2 Auto Scaling Group**

   - Provision EC2 instances using a launch template.
   - Auto Scaling Group automatically adjusts capacity based on demand.
   - Instances run the Node.js application Docker image pulled from ECR.

---

6. **Create and Configure Amazon RDS**

   - Launch a PostgreSQL or MySQL database instance in a private subnet.
   - RDS credentials and DB name are provided through Terraform variables.
   - Security groups restrict access to allow only EC2 instances to connect.

---

7. **Provision an ECR Repository**

   - Create a private Elastic Container Registry (ECR) for storing Docker images.
   - Used by EC2 or CI/CD pipelines to pull application images for deployment.

---

8. **Assign IAM Roles and Policies**

   - Create IAM roles with least-privilege policies:
     - EC2 role to pull images from ECR and send logs to CloudWatch
     - Optional: CI/CD role with limited permissions

---

9. **Customize Configuration with Variables**

   - Define configurable inputs such as:
     - AWS region
     - Instance type
     - DB name, user, password
   - Values are passed through `terraform.tfvars` for each environment.

---

10. **Output Key Infrastructure Values**

   - Use output blocks to expose useful information:
     - Load Balancer DNS
     - RDS endpoint
     - ECR repository URL

---

11. **Deploy the Infrastructure**

   - Run the following commands to apply the changes:

     ```bash
     terraform plan
     terraform apply
     ```

   - Review and confirm the plan to provision the infrastructure.
   - 
![Screenshot 2025-06-18 092203](https://github.com/user-attachments/assets/6d4ada43-9305-42ed-b9a3-26735a722f62)

---
## Step 4: CI/CD Pipeline (Jenkins)

This step sets up an automated CI/CD pipeline using **Jenkins**, which performs testing, infrastructure deployment with Terraform, Docker image builds, and ECR deployment.

---

1. **Pipeline Overview**

   - CI/CD is triggered on code changes from the GitHub repository.
   - The pipeline includes these automated stages:
     - Checkout the code
     - Install dependencies and run unit tests
     - Deploy infrastructure using Terraform
     - Build and push Docker image to AWS ECR
     - Handle success and failure events

---

2. **Set Up Jenkins Credentials**

   - Add the following credentials in Jenkins:
     - `git-crd`: GitHub credentials (username/password or token)
     - `aws-creds`: AWS access key ID and secret access key (for ECR and Terraform)

---

3. **Checkout Code from GitHub**

   - The pipeline starts by checking out the source code from GitHub:
     ```groovy
     git url: 'https://github.com/sam-nickky/node-infra-pipeline.git',
         branch: 'main',
         credentialsId: 'git-crd'
     ```

---

4. **Install Dependencies and Run Unit Tests**

   - Inside the `node-demo-app/app/` directory, the pipeline:
     - Installs dependencies using `npm install`
     - Runs tests using `npm test`
     - If tests fail, the stage is marked as failed using `catchError`
     ```bash
     npm install
     npm test
     ```

---

5. **Deploy Infrastructure and Application using Terraform**

   - The pipeline runs `terraform` commands in the `node-demo-app/terraform/` directory:
     
     ```bash
     terraform init -input=false
     terraform plan -input=false -out=tfplan
     terraform apply -input=false -auto-approve tfplan
     ```
   - AWS credentials are provided using Jenkins `withCredentials`.

---

6. **Build Docker Image and Push to AWS ECR**

   - The app is containerized and tagged using the Jenkins build number:
     - `IMAGE_TAG = v1.0.${BUILD_NUMBER}`
   - The pipeline logs in to ECR, builds the image, tags it, and pushes to ECR:
     ```bash
     aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

     docker build -t $ECR_REPO_NAME:$IMAGE_TAG .
     docker tag $ECR_REPO_NAME:$IMAGE_TAG $ECR_URI:$IMAGE_TAG
     docker push $ECR_URI:$IMAGE_TAG
     ```

---

7. **Post Build Actions**

   - On pipeline success:
     ```groovy
     echo "Deployment successful."
     ```
   - On failure:
     ```groovy
     echo "Deployment failed. Check logs."
     ```

---

8. **Environment Variables Used**

   These are declared in the pipeline’s `environment` block:

   ```groovy
   AWS_REGION     = 'eu-north-1'
   ECR_REPO_NAME  = 'node-demo-app'
   IMAGE_TAG      = "v1.0.${BUILD_NUMBER}"
   ECR_URI        = "091110283484.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"
   TF_DIR         = 'node-demo-app/terraform'
---

   
9. **Rollback and Failure Handling**
10. **Best Practices Followed**

   - ✅ Secure credentials via Jenkins Credentials Manager  
   - ✅ Isolated build steps per stage  
   - ✅ Full automation: test → infra → deploy  
   - ✅ Dynamic tagging of Docker images for traceability  
   - ✅ Terraform infra as code, integrated into CI/CD  
   - ✅ Error handling and rollback logic in place

 output log from a successful Jenkins build run is attached in the `documentation/` directory as reference.


## Step 5: High Availability and Load Balancing

This step ensures the application is fault-tolerant and scalable using an EC2 Auto Scaling Group and Application Load Balancer (ALB).

---

1. **Configure EC2 Auto Scaling Group**

   - Auto Scaling Group (ASG) automatically launches and terminates EC2 instances based on demand.
   - Ensures at least one instance is always available, and can scale out/in based on CPU, memory, or request load.

---

2. **Launch EC2 Instances via Launch Template**

   - Instances are created using a launch template 
   - Each instance:
     - Runs the containerized Node.js app
     - Pulls the Docker image from AWS ECR
     - Registers with the target group of the ALB

---

3. **Deploy Application Load Balancer (ALB)**

   - ALB is configured to:
     - Listen on port `80`
     - Forward incoming HTTP requests to healthy EC2 targets
     - Operate across multiple Availability Zones (multi-AZ)



---

4. **Set Up Health Checks**

   - Health checks are configured on the ALB target group to monitor the `/health` endpoint.
   - Only healthy EC2 instances will receive live traffic.

   Example:
   - Path: `/health`
   - Port: `3000`
   - Healthy threshold: `2`
   - Unhealthy threshold: `3`
  ![Screenshot 2025-06-18 144628](https://github.com/user-attachments/assets/c4e4bd7c-b3fd-4d8d-8fd9-6e732395c9dc)
  ![Screenshot 2025-06-18 144736](https://github.com/user-attachments/assets/3cf86cdc-679b-4e13-a198-a41de2f693e4)

---

5. **Enable Multi-AZ Deployment**

   - Auto Scaling Group is configured to launch instances in multiple Availability Zones.
   - ALB also spans multiple AZs to avoid a single point of failure.

---

6. **Monitor and Adjust Scaling Policies**

   - Auto Scaling policies can be based on:
     - Average CPU utilization
     - Request count per target
   - we can fine-tune thresholds for when to scale out or in depending on load patterns.

---

## Step 6: Security Best Practices

This step applies multiple layers of security across infrastructure and application components using AWS services, hardened containers, and IAM policies.

---

1. **Enable HTTPS with AWS ACM and ALB**

   - An **SSL certificate** was successfully created using **AWS ACM**.
   - It was attached to the **Route 53 hosted zone**.
   - However, the DNS validation record remains in a **pending state** even after 6 hours — this configuration is currently on hold.
![Screenshot 2025-06-18 151926](https://github.com/user-attachments/assets/929da477-7159-4d96-9c16-4979ff161afa)
![Screenshot 2025-06-18 152009](https://github.com/user-attachments/assets/b1966f33-6722-4b2e-90ee-ae831b1bd076)


---

2. **Restrict SSH Access Using Security Groups**

   - Inbound rules for the EC2 instance's Security Group were edited to:
     - Allow **only port 22** (SSH) from a trusted IP (e.g., your home IP).
     - Remove unnecessary inbound ports to minimize exposure.


---

3. **Secure Secrets Using AWS Secrets Manager**

   - Sensitive information like DB credentials and environment secrets are stored in **AWS Secrets Manager**.
   - Avoided hardcoding secrets in code or Terraform files.
   - Secrets Manager supports encryption and automatic rotation.


---

4. **Ensure Container Security**

   - Containers follow best practices for security:
     - **Run as non-root users**
     - Avoid `--privileged` mode entirely
     - Use a **minimal base image** (`node:alpine`)
     - A `.dockerignore` is used to exclude unnecessary files

   _ You can verify this in the [Dockerfile](../Dockerfile)._

---

5. **Enable RDS Encryption**

   - **Encryption at rest** is enabled using AWS KMS during RDS provisioning.
   - **Encryption in transit** is ensured via SSL connection settings.
   - SSL enforcement can be applied by modifying RDS parameter groups.



---

6. **Follow IAM Least Privilege Principles**

   - Fine-grained IAM roles are assigned to each service:
     - EC2 instances have access to only **ECR** and **CloudWatch**
     - CI/CD pipelines have permissions only for **deploying infrastructure** and **retrieving secrets**
   - No role or user is granted `AdministratorAccess`.



---

## Step 7: Monitoring and Alerts

This step implements monitoring and alerting to gain visibility into application health, system resource usage, and potential failures.

---

1. **Amazon CloudWatch Dashboard Configured**

   - A **custom dashboard** named `NodeCW` was created.
   - It includes visual monitoring for:
     - **CPU Usage (System, User, Idle)**  
       - `cpu_usage_system`: CPU used by system processes  
       - `cpu_usage_user`: CPU used by user-level processes  
       - `cpu_usage_idle`: Idle CPU time (target is high value like ~99%)  
     - **Memory Usage**  
       - `mem_used_percent`: Tracks how much memory is in use by the instance

![Screenshot 2025-06-19 101101](https://github.com/user-attachments/assets/d8bf7906-9e2c-460c-8a69-8e49ca80fda2)

2. **Enable Amazon CloudWatch Metrics**

   - EC2 instances, RDS, and ALB automatically publish metrics to **Amazon CloudWatch**.
   - Key default metrics tracked include:
     - **CPU utilization**
     - **Disk I/O**
     - **Network in/out**
     - **ALB request count and error rates**
     - **RDS CPU usage and DB connections**

---


3. **Configure CloudWatch Alarms**

   - Set up CloudWatch alarms for key thresholds:
     - EC2 CPU > 80% for 5 mins
     - ALB 5xx errors > 10 per minute
     - RDS CPU > 70% for 5 mins
     - Disk space < 10%
   - Alarms help automate detection of abnormal behavior.
![Screenshot 2025-06-19 070511](https://github.com/user-attachments/assets/8b9383b2-9f74-406e-b852-54c3b9afd621)

---

4. **Set Up Alert Notifications via SNS**

   - Create an **Amazon SNS topic** to deliver alert notifications.
   - Subscribe email addresses or Slack webhook URLs to the topic.
   - Link CloudWatch alarms to the SNS topic.

![Screenshot 2025-06-19 070448](https://github.com/user-attachments/assets/0254da80-e6ce-4c15-a6e4-cfe867b6208b)


---

## Step 8: Logging and Debugging  (incomplete)

This step focuses on capturing and centralizing logs from the application and infrastructure for better traceability, debugging, and operational insight.

---

1. **Use Amazon CloudWatch Logs (Primary Option)**

   - Application and system logs are streamed to **Amazon CloudWatch Logs** from EC2 instances.
   - Logs can be viewed in near real-time using the CloudWatch Logs Insights query tool.
   - Example sources:
     - Node.js application logs (`console.log`)
     - System logs (`/var/log/messages`, `docker logs`, etc.)

---

2. **Ensure Logs Are JSON Structured**

   - Application logs are written in **JSON format** to support structured logging and easier filtering.
   - Structured logs help with:
     - Full-text search
     - JSON key-based filtering
     - Visualization in dashboards

---

3. **Optional: Use ELK Stack for Advanced Log Analysis**

   - A self-hosted **ELK Stack** (Elasticsearch, Logstash, Kibana) can be used as an alternative or supplement to CloudWatch.
   - Useful for advanced filtering, full-text search, and custom visualization of logs.

---

4. **Ship Logs from EC2 Using Log Forwarders**

   - Tools like **Fluent Bit**, **Fluentd**, or **Logstash** can be used to:
     - Read log files from EC2 instances or containers
     - Parse and enrich logs (if needed)
     - Send to ELK or third-party services (e.g., Datadog, Logz.io)

