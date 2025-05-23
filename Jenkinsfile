pipeline {
  agent any

  environment {
    GH_TOKEN = credentials('github-token') // create a Jenkins secret with your GitHub PAT
    REPO = "Sharif-1992/Azure"
    PR_NUMBER = sh(script: "gh pr view --json number -q .number", returnStdout: true).trim()
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Run TFLint') {
      steps {
        sh 'tflint --init'
        sh 'tflint --format json > tflint_output.json'
      }
    }

    stage('Parse Issues') {
      steps {
        script {
          def issueCount = sh(script: "jq '.issues | length' tflint_output.json", returnStdout: true).trim().toInteger()
          currentBuild.description = "TFLint found ${issueCount} issue(s)"
          env.TFLINT_ISSUE_COUNT = issueCount.toString()

          def summary = sh(
            script: '''
              if [ "$TFLINT_ISSUE_COUNT" -eq 0 ]; then
                echo "✅ TFLint found no issues."
              else
                jq -r '.issues[] | "- [\(.severity)] \(.message) (\(.range.filename):\(.range.start.line))"' tflint_output.json
              fi
            ''',
            returnStdout: true
          ).trim()

          writeFile file: 'tflint_summary.txt', text: summary
        }
      }
    }

    stage('Comment on PR') {
      steps {
        script {
          def body = new File('tflint_summary.txt').text
          sh """
            gh pr comment ${env.PR_NUMBER} \\
              --repo ${env.REPO} \\
              --body "### 🧪 TFLint Scan Result\\n${body.replaceAll('"', '\\"')}"
          """
        }
      }
    }
  }

  post {
    failure {
      echo '❌ Build failed'
    }
    success {
      echo '✅ Build succeeded'
    }
    always {
      echo "🔁 Commented on PR #${env.PR_NUMBER}"
    }
  }
}