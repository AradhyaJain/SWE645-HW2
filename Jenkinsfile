pipeline {
    agent any

    environment {
        DOCKER_USERNAME = 'ajain30'
        DOCKER_IMAGE = 'ajain30/survey'
        DOCKER_TAG = 'latest'
        DEPLOYMENT_YAML_PATH = 'deployment.yaml'
        SERVICE_YAML_PATH = 'service.yaml'
        DOCKER_CREDENTIALS_ID = '87dfce82-60bc-4e66-ad52-b443bb2a5569' // Docker credentials ID
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the GitHub repository
                checkout scm
            }
        }

        stage('Enable BuildKit') {
            steps {
                script {
                    // Enable BuildKit for Docker
                    sh 'export DOCKER_BUILDKIT=1'
                }
            }
        }

        stage('Build Docker Image with Buildx') {
            steps {
                script {
                    // Use Buildx to build the Docker image
                    sh 'docker buildx create --use'
                    sh "docker buildx build --platform linux/amd64 -t ${DOCKER_IMAGE}:${DOCKER_TAG} --push ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub and push the image
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, 
                        usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USERNAME} --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy the app using the provided Kubernetes YAML files
                    sh "kubectl apply -f ${DEPLOYMENT_YAML_PATH}"
                    sh "kubectl apply -f ${SERVICE_YAML_PATH}"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
