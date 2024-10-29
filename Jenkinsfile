pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ajain30/survey'      // Docker image name
        DOCKER_TAG = 'latest'                // Tag for the Docker image; change to '${env.BUILD_ID}' for unique tags per build
        DOCKER_USERNAME = 'ajain30'          // Docker Hub username
        DEPLOYMENT_YAML_PATH = 'deployment.yaml'  // Path to deployment YAML in the repository
        SERVICE_YAML_PATH = 'service.yaml'   // Path to service YAML in the repository
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository containing Jenkinsfile, Dockerfile, and YAML files
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image from the Dockerfile
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Use Jenkins credentials for secure login and push to Docker Hub
                    withCredentials([string(credentialsId: 'docker_hub_pass', variable: 'DOCKER_PASSWORD')]) {
                        // Login to Docker Hub
                        sh "echo \$DOCKER_PASSWORD | docker login --username \$DOCKER_USERNAME --password-stdin"
                        
                        // Push the Docker image
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply the Kubernetes YAML files to deploy to the cluster
                    sh "kubectl apply -f ${DEPLOYMENT_YAML_PATH} --kubeconfig /var/lib/jenkins/.kube/config"
                    sh "kubectl apply -f ${SERVICE_YAML_PATH} --kubeconfig /var/lib/jenkins/.kube/config"

                    // Force rollout restart to ensure latest image is pulled
                    sh 'kubectl rollout restart deployment student-survey-deployment --kubeconfig /var/lib/jenkins/.kube/config'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
