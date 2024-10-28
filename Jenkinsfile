pipeline {
    agent any

    environment {
        DOCKER_USERNAME = 'ajain30'
        DOCKER_IMAGE = 'ajain30/survey'
        DOCKER_TAG = 'latest'
        DEPLOYMENT_YAML_PATH = 'deployment.yaml'
        SERVICE_YAML_PATH = 'service.yaml'
        DOCKER_CREDENTIALS_ID = 'dockerhub_cred'
        GITHUB_CREDENTIALS_ID = 'github'
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: GITHUB_CREDENTIALS_ID,
                        passwordVariable: 'GIT_PASSWORD',
                        usernameVariable: 'GIT_USERNAME'
                    )]) {
                        // Remove directory if it exists
                        sh 'rm -rf SWE645-HW2 || true'

                        // Clone the repository
                        sh "git clone https://${GIT_USERNAME}:${GIT_PASSWORD.toString()}@github.com/AradhyaJain/SWE645-HW2.git"
                        sh 'cd SWE645-HW2'
                    }
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
                    withCredentials([usernamePassword(
                        credentialsId: DOCKER_CREDENTIALS_ID,
                        passwordVariable: 'DOCKER_PASSWORD',
                        usernameVariable: 'DOCKER_USERNAME'
                    )]) {
                        sh 'docker buildx create --use'
                        sh "echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USERNAME} --password-stdin"
                        sh "docker buildx build --platform linux/amd64 -t ${DOCKER_IMAGE}:${DOCKER_TAG} --push ."
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
