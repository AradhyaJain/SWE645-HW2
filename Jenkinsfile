pipeline {
    agent any

    environment {
        DOCKER_USERNAME = 'ajain30'
        DOCKER_PASSWORD = 'Aradhya@299'
        GITHUB_USERNAME = 'aradhya299@gmail.com'
        GITHUB_PASSWORD = 'Aradhya@299'
        DOCKER_IMAGE = 'ajain30/survey'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Clone the GitHub repository using hard-coded credentials
                    sh "git clone https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.com/AradhyaJain/SWE645-HW2.git"
                }
            }
        }

        stage('Enable BuildKit') {
            steps {
                script {
                    sh 'export DOCKER_BUILDKIT=1'
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub with hard-coded credentials
                    sh "echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USERNAME} --password-stdin"

                    // Build and push the Docker image using Buildx
                    sh 'docker buildx create --use'
                    sh "docker buildx build --platform linux/amd64 -t ${DOCKER_IMAGE}:${DOCKER_TAG} --push ."
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
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
