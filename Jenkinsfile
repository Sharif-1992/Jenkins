pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Checkov') {
            steps {
                sh 'pip3 install --upgrade checkov'
            }
        }

        stage('Run Checkov') {
            steps {
                sh 'checkov -d .'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution complete.'
        }
    }
}