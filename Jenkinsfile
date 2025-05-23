pipeline {
    agent any

    environment {
        GH_TOKEN = credentials('github-pat') // Your GitHub token stored in Jenkins credentials
    }

    stages {
        stage('Post PR Comment') {
            steps {
                script {
                    // Extract PR number from environment or change manually
                    def prNumber = env.CHANGE_ID

                    if (prNumber) {
                        sh """
                            echo "Posting comment to PR #${prNumber}"
                            gh pr comment ${prNumber} --repo Sharif-1992/Azure --body 'Hello from Jenkins!'
                        """
                    } else {
                        echo "No PR number found. Not a PR build."
                    }
                }
            }
        }
    }
}