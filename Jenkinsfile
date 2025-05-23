pipeline {
    agent any

    environment {
        TF_WORKING_DIR = 'Jenkins'  // Updated path to match your repo structure
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install TFLint') {
            steps {
                sh '''
                    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
                    tflint --version
                '''
            }
        }

        stage('Initialize TFLint') {
            steps {
                dir("${env.TF_WORKING_DIR}") {
                    sh 'tflint --init || true'  // TFLint init is optional unless using plugins
                }
            }
        }

        stage('Run TFLint') {
            steps {
                dir("${env.TF_WORKING_DIR}") {
                    sh 'tflint -f compact'
                }
            }
        }
    }

    post {
        success {
            echo '✅ TFLint check passed!'
        }
        failure {
            echo '❌ TFLint check failed!'
        }
        always {
            echo '🔍 TFLint scan completed.'
        }
    }
}