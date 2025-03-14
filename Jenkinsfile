pipeline {
    agent any

    environment {
        IMAGE_NAME = "your-dockerhub-username/java-microservice"
        KUBE_DEPLOYMENT = "java-microservice-deployment"
        SERVICE_PORT = "8080"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: 'github-pat-id', url: 'https://github.com/baburaj50/skillupjava.git'
            }
        }

        stage('Build and Test') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: '94b1f578-fc47-4f2d-b19e-2a94a1682447', url: '']) {
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl create deployment $KUBE_DEPLOYMENT --image=$IMAGE_NAME || \
                kubectl set image deployment/$KUBE_DEPLOYMENT java-microservice=$IMAGE_NAME

                kubectl expose deployment $KUBE_DEPLOYMENT --type=NodePort --port=$SERVICE_PORT
                """
            }
        }

        stage('Create Additional Pod') {
            steps {
                sh """
                kubectl run extra-pod --image=$IMAGE_NAME --port=$SERVICE_PORT
                """
            }
        }
    }
}
