pipeline {
    agent any
    stages {
        stage('Check TFLint Error Count') {
            steps {
                script {
                    def errorCount = readFile('tflint_output.txt').readLines().size()
                    echo "TFLint Errors: ${errorCount}"
                    if (errorCount > 5) {
                        def prId = env.CHANGE_ID
                        def repo = env.CHANGE_URL.split('/').takeRight(2).join('/').replace('.git', '')
                        def message = "❌ TFLint check failed with ${errorCount} errors. Please fix the issues before merging."

                        sh "gh pr comment ${prId} --repo ${repo} --body \"${message}\""

                        error("TFLint error threshold exceeded")
                    }
                }
            }
        }
    }
}