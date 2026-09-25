pipeline {
    agent any

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
                sh './mvnw clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh './mvnw test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                sh './mvnw package -DskipTests'
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
