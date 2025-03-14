pipeline {
    agent any

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
                sh 'docker build -t your-dockerhub-username/java-microservice .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: '94b1f578-fc47-4f2d-b19e-2a94a1682447', url: '']) {
                    sh 'docker push your-dockerhub-username/java-microservice'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl create deployment java-microservice-deployment --image=your-dockerhub-username/java-microservice || \
                kubectl set image deployment/java-microservice-deployment java-microservice=your-dockerhub-username/java-microservice
                """
            }
        }

        stage('Create Additional Pod') {
            steps {
                sh 'kubectl run extra-pod --image=your-dockerhub-username/java-microservice --port=8080'
            }
        }
    }
}
