pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'backend-app'
    }

    tools {
        maven 'M2_HOME'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare') {
            steps {
                sh 'java -version'
                sh 'chmod +x mvnw || true'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t "$DOCKER_IMAGE:$BUILD_NUMBER" -t "$DOCKER_IMAGE:latest" .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKERHUB_USERNAME',
                    passwordVariable: 'DOCKERHUB_TOKEN'
                )]) {
                    sh '''
                        echo "$DOCKERHUB_TOKEN" | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
                        docker tag "$DOCKER_IMAGE:$BUILD_NUMBER" "$DOCKERHUB_USERNAME/$DOCKER_IMAGE:$BUILD_NUMBER"
                        docker tag "$DOCKER_IMAGE:latest" "$DOCKERHUB_USERNAME/$DOCKER_IMAGE:latest"
                        docker push "$DOCKERHUB_USERNAME/$DOCKER_IMAGE:$BUILD_NUMBER"
                        docker push "$DOCKERHUB_USERNAME/$DOCKER_IMAGE:latest"
                        docker logout
                    '''
                }
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml'
        }
        failure {
            echo 'Les tests ont échoué ❌'
        }
        success {
            echo 'Tous les tests sont passés ✅'
        }
    }
}
