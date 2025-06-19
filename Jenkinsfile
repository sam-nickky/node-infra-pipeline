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
        git url: 'https://github.com/sam-nickky/node-infra-pipeline.git', branch: 'main', credentialsId: 'git-crd'
      }
    }

    stage('Install & Test') {
      steps {
        dir('node-demo-app/app') {
          catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
            sh 'npm install'
            sh 'npm test'
          }
        }
      }
    }

    stage('Terraform Deploy Infra & App') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'aws-creds',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )
        ]) {
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

    stage('Docker Build & Push to ECR') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: 'aws-creds',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )
        ]) {
          dir('node-demo-app/app') {
            sh '''
              aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

              docker build -t $ECR_REPO_NAME:$IMAGE_TAG .
              docker tag $ECR_REPO_NAME:$IMAGE_TAG $ECR_URI:$IMAGE_TAG
              docker push $ECR_URI:$IMAGE_TAG
            '''
          }
        }
      }
    }
  }

  post {
    success {
      echo " Deployment successful."
    }
    failure {
      echo " Deployment failed. Check logs."
    }
  }
}
