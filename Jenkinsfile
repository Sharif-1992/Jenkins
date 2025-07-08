pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Terratest') {
            steps {
                dir('terratest') {
                    script {
                        // Initialize Go module (only needed the first time)
                        sh 'go mod init tests || true'

                        // Install Terratest module
                        sh 'go get github.com/gruntwork-io/terratest/modules/terraform'

                        // Run Terratest
                        sh 'go test -v'
                    }
                }
            }
        }
    }
}