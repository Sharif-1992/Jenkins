pipeline {
    agent any

    environment {
        GH_TOKEN = credentials('github-token') // GitHub token stored in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Initialize TFLint Plugins') {
            steps {
                dir('Jenkins') {
                    sh 'tflint --init'
                }
            }
        }

        stage('Run TFLint') {
            steps {
                dir('Jenkins') {
                    script {
                        def lintOutput = sh(script: 'tflint --format=default || true', returnStdout: true).trim()
                        echo "TFLint Output:\n${lintOutput}"

                        // Count warnings and errors
                        def warningCount = lintOutput.readLines().count { it.contains("Warning:") }
                        def errorCount = lintOutput.readLines().count { it.contains("Error:") }

                        echo "Warning count: ${warningCount}"
                        echo "Error count: ${errorCount}"

                        def prNumber = env.CHANGE_ID
                        if (prNumber) {
                            def comment = """### TFLint Report

\`\`\`
${lintOutput.take(6000)}
\`\`\`

- ❗ Warnings: ${warningCount}
- ❌ Errors: ${errorCount}
"""

                            // Post comment on PR
                            sh """gh pr comment ${prNumber} --repo Sharif-1992/Azure --body '${comment}'"""

                            // Close PR if thresholds are exceeded
                            if (warningCount > 1 || errorCount > 0) {
                                def rejectMsg = "PR auto-closed: TFLint failed (Warnings: ${warningCount}, Errors: ${errorCount}). Please fix the issues."
                                sh """gh pr close ${prNumber} --repo Sharif-1992/Azure --comment '${rejectMsg}'"""
                                error("PR closed due to TFLint issues.")
                            }
                        }
                    }
                }
            }
        }
    }
}
