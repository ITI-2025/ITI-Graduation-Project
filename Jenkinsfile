pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker:25.0.3-cli
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  - name: aws-cli
    image: amazon/aws-cli:2.15.30
    command:
    - cat
    tty: true
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
      type: Socket
  - name: workspace-volume
    emptyDir: {}
"""
        }
    }
    environment {
        AWS_REGION    = 'eu-central-1'
        ECR_REGISTRY  = '942114770456.dkr.ecr.eu-central-1.amazonaws.com'
        IMAGE_NAME    = 'nodejs-app'

    }
    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'node-js-app', url: 'https://github.com/ITI-2025/ITI-Graduation-Project.git'
                sh 'ls -la nodeapp/' // Debug: List contents of cloned repo
            }
        }
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh '''
                    docker --version # Debug: Verify Docker CLI
                    docker build -t $IMAGE_NAME nodeapp/
                    docker images # Debug: List images to confirm build
                    '''
                }
            }
        }
        stage('Login to ECR') {
            steps {
                container('aws-cli') {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'aws-credentials',
                            usernameVariable: 'AWS_ACCESS_KEY_ID',
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        )
                    ]) {
                        sh '''
                        aws --version # Debug: Verify AWS CLI
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set region $AWS_REGION
                        aws ecr get-login-password --region $AWS_REGION > /home/jenkins/agent/ecr-password.txt
                        ls -l /home/jenkins/agent # Debug: Verify ecr-password.txt exists
                        '''
                    }
                }
                container('docker') {
                    sh '''
                    docker --version # Debug: Verify Docker CLI
                    cat /home/jenkins/agent/ecr-password.txt # Debug: Check password file contents
                    docker login --username AWS --password-stdin $ECR_REGISTRY < /home/jenkins/agent/ecr-password.txt
                    rm /home/jenkins/agent/ecr-password.txt # Cleanup: Remove password file
                    '''
                }
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                container('docker') {
                    sh '''
                    docker images # Debug: List images before push
                    docker tag $IMAGE_NAME:latest $ECR_REGISTRY/$IMAGE_NAME:latest
                    docker push $ECR_REGISTRY/$IMAGE_NAME:latest
                    '''
                }
            }
        }
    }
}