pipeline {
    agent any

    environment {
        // Define the environment variables for your pipeline
        DOCKER_IMAGE = 'ajain30/survey'  // Replace with your Docker image name
        DOCKER_TAG = 'latest'            // You can change it to '${env.BUILD_ID}' if needed for unique tagging
        DEPLOYMENT_YAML_PATH = 'deployment.yaml'  // Path to deployment YAML in your repo
        SERVICE_YAML_PATH = 'service.yaml'  // Path to service YAML in your repo
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository containing your Jenkinsfile, YAML files, and Dockerfile
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image from the Dockerfile in the repo
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Use the saved Docker Hub credentials to log in and push the image
                    withCredentials([string(credentialsId: 'c86da864-8d8c-4b80-bf92-c4f0d151d616', variable: 'DOCKER_PASSWORD')]) {
                        // Login to Docker Hub
                        sh "echo \$DOCKER_PASSWORD | docker login --username ajain30 --password-stdin"

                        // Push the Docker image to Docker Hub
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply the deployment and service YAML files to the Kubernetes cluster
                    sh "kubectl apply -f ${DEPLOYMENT_YAML_PATH} --kubeconfig /var/lib/jenkins/.kube/config"
                    sh "kubectl apply -f ${SERVICE_YAML_PATH} --kubeconfig /var/lib/jenkins/.kube/config"
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
