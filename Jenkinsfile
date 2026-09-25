pipeline {
    agent any

    tools {
        jdk 'JDK17'   // nom exact configuré dans Jenkins > Tools (adapte la version)
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/youssefbenlallahom/devops.git'
            }
        }

        stage('Give exec permission') {
            steps {
                sh 'chmod +x mvnw'   // nécessaire si l'agent est sous Linux
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
