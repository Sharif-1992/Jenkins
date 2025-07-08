pipeline {
    agent any

    environment {
        GH_TOKEN = credentials('github-token') // GitHub PAT stored in Jenkins credentials
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Terratest') {
            steps {
                dir('tests') {
                    script {
                        // Initialize Go module (first time only)
                        sh 'go mod init tests || true'
                        // Install Terratest dependency
                        sh 'go get github.com/gruntwork-io/terratest/modules/terraform'

                        // Run tests and capture output
                        def output = sh(script: 'go test -v || true', returnStdout: true).trim()
                        def failed = output.contains("--- FAIL")
                        def prNumber = env.CHANGE_ID

                        echo "Terratest Output:\n${output}"

                        if (prNumber) {
                            def comment = """### ✅ Terratest Report

\`\`\`
${output.take(6000)}
\`\`\`

- Status: ${failed ? "❌ Failed" : "✔️ Passed"}
"""

                            // Post PR comment using GitHub CLI
                            sh """
                                echo \$GH_TOKEN | gh auth login --with-token
                                gh pr comment ${prNumber} --repo Sharif-1992/Azure --body '${comment}'
                            """
                        }
                    }
                }
            }
        }
    }
}