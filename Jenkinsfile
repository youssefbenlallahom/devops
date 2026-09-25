pipeline {
    agent any

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
