pipeline {
    agent any

    stages {
        stage('Initialize TFLint') {
            steps {
                sh 'tflint --init'
            }
        }

        stage('Run TFLint') {
            steps {
                sh 'tflint'
            }
        }
    }

    post {
        always {
            echo '🔍 TFLint scan completed.'
        }
        failure {
            echo '❌ TFLint check failed!'
        }
    }
}