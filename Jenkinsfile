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
                withCredentials([
                    file(credentialsId: 'vm_ssh_key_pub', variable: 'PUB_KEY'),
                    string(credentialsId: 'azure-client-id', variable: 'CLIENT_ID'),
                    string(credentialsId: 'azure-client-secret', variable: 'CLIENT_SECRET'),
                    string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID'),
                    string(credentialsId: 'azure-subscription-id', variable: 'SUBSCRIPTION_ID')
                ]) {

                    dir('terratest') {
                        script {
                            // Initialize Go module (skip error if already initialized)
                            sh 'go mod init tests || true'

                            // Fetch Terratest module
                            sh 'go get github.com/gruntwork-io/terratest/modules/terraform'

                            // Run Terratest with TF variable pointing to the injected SSH public key
                            sh '''
                                echo "TF_VAR_client_id=$CLIENT_ID"
                                echo "TF_VAR_tenant_id=$TENANT_ID"
                                echo "TF_VAR_subscription_id=$SUBSCRIPTION_ID"
                                
                                export TF_VAR_public_key_path=$PUB_KEY
                                export TF_VAR_client_id=$CLIENT_ID
                                export TF_VAR_client_secret=$CLIENT_SECRET
                                export TF_VAR_tenant_id=$TENANT_ID
                                export TF_VAR_subscription_id=$SUBSCRIPTION_ID
                                terraform init
                                terraform plan
                                go test -v
                            '''
                        }
                    }
                }
            }
        }
    }
}