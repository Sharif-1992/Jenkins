pipeline {
    agent any

    environment {
        GH_TOKEN = credentials('github-token') // GitHub Personal Access Token stored in Jenkins credentials
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run TFLint') {
            steps {
                script {
                    def lintOutput = sh(script: 'tflint --format=github || true', returnStdout: true).trim()

                    echo "TFLint Output:\n${lintOutput}"

                    def prNumber = env.CHANGE_ID
                    if (prNumber) {
                        def comment = """### TFLint Report ${lintOutput.take(6000)}"""
                        sh """
                            gh pr comment ${prNumber} --repo Sharif-1992/Azure --body '${comment}'
                        """
                    }
                }
            }
        }
    }
}