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
                        // Run TFLint and capture output
                        def lintOutput = sh(script: 'tflint --format=default || true', returnStdout: true).trim()

                        echo "TFLint Output:\n${lintOutput}"

                        // Count warnings and errors from output
                        def warningCount = 0
                        def errorCount = 0

                        lintOutput.eachLine { line ->
                            if (line =~ /Warning:/) {
                                warningCount++
                            }
                            if (line =~ /Error:/) {
                                errorCount++
                            }
                        }

                        def backticks = '```'
                        def prNumber = env.CHANGE_ID
                        if (prNumber) {
                            def comment = """### TFLint Report

${backticks}
${lintOutput.take(6000)}
${backticks}

- ❗ Warnings: ${warningCount}
- ❌ Errors: ${errorCount}
"""
                            sh """
                                gh pr comment ${prNumber} --repo Sharif-1992/Azure --body '${comment}'
                            """

                            // Auto reject logic
                            if (warningCount > 1 || errorCount > 0) {
                                error("PR rejected due to TFLint issues: Warnings=${warningCount}, Errors=${errorCount}")
                            }
                        }
                    }
                }
            }
        }
    }
}