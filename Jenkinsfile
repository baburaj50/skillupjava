pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'baburajkm'
        IMAGE_NAME = 'java-microservice'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', 
                    credentialsId: '5dab2fe5-40fd-408a-a735-dfb6c26c122c', 
                    url: 'https://github.com/baburaj50/skillupjava.git'
            }
        }

        stage('Build and Test') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $DOCKERHUB_USER/$IMAGE_NAME .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: '94b1f578-fc47-4f2d-b19e-2a94a1682447', url: '']) {
                    sh 'docker push $DOCKERHUB_USER/$IMAGE_NAME'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                '''
            }
        }

        stage('Scale Deployment') {
            steps {
                sh 'kubectl scale deployment java-microservice-deployment --replicas=3'
            }
        }
    }
}
