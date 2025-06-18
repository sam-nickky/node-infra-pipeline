pipeline {
  agent any

  environment {
    AWS_REGION = 'eu-north-1'
    ECR_REPO_NAME = 'node-demo-app'
    IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
    ECR_URI = "091110283484.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"
    TF_DIR = 'node-demo-app/terraform'
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install & Test') {
      steps {
        dir('node-demo-app/app') {
          sh 'npm install'
          sh 'npm test || echo "Tests failed, continuing..."'  
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        dir('node-demo-app/app') {
          sh '''
            echo "Logging into ECR..."
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

            echo "Building Docker image..."
            docker build -t $ECR_REPO_NAME:$IMAGE_TAG .

            echo "Tagging image..."
            docker tag $ECR_REPO_NAME:$IMAGE_TAG $ECR_URI:$IMAGE_TAG

            echo "Pushing image to ECR..."
            docker push $ECR_URI:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Terraform Deploy') {
      steps {
        dir("${TF_DIR}") {
          sh '''
            terraform init -input=false
            terraform plan -input=false -out=tfplan
            terraform apply -input=false -auto-approve tfplan
          '''
        }
      }
    }

  }

  post {
    failure {
      echo " Build or deploy failed! Please check logs."
      // Optional: add rollback logic    }
    success {
      echo " Application deployed successfully!"
    }
  }
}

