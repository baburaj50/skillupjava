pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "baburaj50/skillupjava:latest"
        KUBE_DEPLOYMENT = "skillupjava-deployment"
        APP_PORT = "8080"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/baburaj50/skillupjava.git'
            }
        }
        stage('Build Application') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %DOCKER_IMAGE% .'
            }
        }
        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    bat 'docker push %DOCKER_IMAGE%'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                bat '''
                echo Creating Kubernetes Deployment...
                kubectl apply -f - <<EOF
                apiVersion: apps/v1
                kind: Deployment
                metadata:
                  name: %KUBE_DEPLOYMENT%
                spec:
                  replicas: 1
                  selector:
                    matchLabels:
                      app: skillupjava
                  template:
                    metadata:
                      labels:
                        app: skillupjava
                    spec:
                      containers:
                      - name: skillupjava
                        image: %DOCKER_IMAGE%
                        ports:
                        - containerPort: %APP_PORT%
                ---
                apiVersion: v1
                kind: Service
                metadata:
                  name: skillupjava-service
                spec:
                  type: NodePort
                  selector:
                    app: skillupjava
                  ports:
                    - protocol: TCP
                      port: 80
                      targetPort: %APP_PORT%
                      nodePort: 30080
                EOF
                '''
            }
        }
    }
    post {
        success {
            echo "Deployment successful! Access the app at http://localhost:30080"
        }
    }
}
