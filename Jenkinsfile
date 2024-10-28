pipeline {
    agent any

    environment {
        DOCKER_USERNAME = 'ajain30'
        DOCKER_IMAGE = 'ajain30/survey'
        DOCKER_TAG = 'latest'
        DEPLOYMENT_YAML_PATH = 'deployment.yaml'
        SERVICE_YAML_PATH = 'service.yaml'
        DOCKER_CREDENTIALS_ID = 'dockerhub_cred'  // Update to your credentials ID
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Enable BuildKit') {
            steps {
                script {
                    // Enable BuildKit environment for Docker
                    sh 'export DOCKER_BUILDKIT=1'
                }
            }
        }

        stage('Build Docker Image with Buildx') {
            steps {
                script {
                    // Initialize and use Buildx to build the image
                    sh 'docker buildx create --use'
                    sh 'docker buildx build --platform linux/amd64 -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub_cred', variable: 'DOCKER_PASSWORD')]) {
                        // Login to Docker Hub
                        sh "echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USERNAME} --password-stdin"

                        // Push the Docker image to Docker Hub
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
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
