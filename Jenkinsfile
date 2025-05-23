pipeline {
  agent any

  environment {
    TFLINT_THRESHOLD = '2'
    GH_REPO = 'Sharif-1992/Azure' // Update if needed
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

          // Instead of error(), just mark build as failure but continue
          if (issueCount.toInteger() > env.TFLINT_THRESHOLD.toInteger()) {
            currentBuild.result = 'FAILURE'
            // Set a flag to use in next stage
            env.TFLINT_FAIL = 'true'
          } else {
            env.TFLINT_FAIL = 'false'
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
          sh '''
            jq -r '.issues[] | "- [" + .severity + "] " + .message + " (" + .range.filename + ":" + (.range.start.line|tostring) + ")"' tflint_output.json > tflint_summary.txt || true
          '''
          def issueSummary = readFile('tflint_summary.txt').trim()
          def totalIssues = sh(script: "jq '.issues | length' tflint_output.json", returnStdout: true).trim()

          def commentBody = ""

          if (env.TFLINT_FAIL == 'true') {
            commentBody = """\
🛑 **TFLint Scan Report - FAILED**
Total Issues: ${totalIssues}

${issueSummary.take(3000)}
"""
          } else {
            commentBody = """\
✅ **TFLint Scan Report - PASSED**
Total Issues: ${totalIssues}

No critical issues found. Good job! 🎉
"""
          }

          // Write comment body to file and post to avoid escaping problems
          writeFile file: 'comment_body.md', text: commentBody

          sh """
            gh pr comment ${CHANGE_ID} --repo ${GH_REPO} --body-file comment_body.md
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