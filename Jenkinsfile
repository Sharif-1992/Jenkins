pipeline {
  agent any

  environment {
    TFLINT_THRESHOLD = '10'  // Maximum allowed issues
    GH_REPO = 'Sharif-1992/Azure' // Change to your GitHub repo (owner/repo)
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
          def issueCount = sh(script: "jq '.issues | length' tflint_output.json", returnStdout: true).trim()
          echo "TFLint reported ${issueCount} issue(s)."
          currentBuild.description = "TFLint Issues: ${issueCount}"

          if (issueCount.toInteger() > env.TFLINT_THRESHOLD.toInteger()) {
            currentBuild.result = 'FAILURE'
            error("Too many TFLint issues (${issueCount}). Threshold is ${env.TFLINT_THRESHOLD}.")
          }
        }
      }
    }

    stage('Comment on PR') {
      when {
        expression { env.CHANGE_ID != null }
      }
      steps {
        script {
          def issueSummary = sh(script: "jq -r '.issues[] | \"- [\(.severity)] \(.message) (\(.range.filename):\(.range.start.line))\"' tflint_output.json", returnStdout: true).trim()
          def body = """
          🧪 **TFLint Scan Report**
          Total Issues: $(jq '.issues | length' tflint_output.json)

          ${issueSummary.take(3000)}  // Trim if too long
          """

          sh """
            gh pr comment ${CHANGE_ID} \
              --repo ${GH_REPO} \
              --body '${body.replace("'", "'\\''")}'
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ TFLint check passed."
    }
    failure {
      echo "❌ TFLint check failed."
    }
  }
}