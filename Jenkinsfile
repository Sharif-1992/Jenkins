pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Terratest') {
            steps {
                // Load the SSH public key from Jenkins credentials (Secret File)
                withCredentials([file(credentialsId: 'vm_ssh_key_pub', variable: 'PUB_KEY')]) {
                    dir('terratest') {
                        script {
                            // Initialize Go module (skip error if already initialized)
                            sh 'go mod init tests || true'

                            // Fetch Terratest module
                            sh 'go get github.com/gruntwork-io/terratest/modules/terraform'

                            // Run Terratest with TF variable pointing to the injected SSH public key
                            sh '''
                                export TF_VAR_public_key_path=$PUB_KEY
                                export TF_VAR_client_id=$TF_VAR_client_id
                                export TF_VAR_client_secret=$TF_VAR_client_secret
                                export TF_VAR_tenant_id=$TF_VAR_tenant_id
                                export TF_VAR_subscription_id=$TF_VAR_subscription_id
                                go test -v
                            '''
                        }
                    }
                }
            }
        }
    }
}