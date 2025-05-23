stage('Comment on PR') {
  when {
    expression { env.CHANGE_ID != null }
  }
  environment {
    GH_REPO = 'your-org/your-repo' // Replace with actual GitHub repo
  }
  steps {
    script {
      withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
        sh '''
          jq -r '.issues[] | "- [" + .severity + "] " + .message + " (" + .range.filename + ":" + (.range.start.line|tostring) + ")"' tflint_output.json > tflint_summary.txt || echo "No issues found." > tflint_summary.txt
        '''
        def issueSummary = readFile('tflint_summary.txt').trim()
        def totalIssues = sh(script: "jq '.issues | length' tflint_output.json || echo 0", returnStdout: true).trim()

        def summaryToPost = issueSummary.length() > 3000 ? issueSummary.take(3000) + "\n\n...truncated" : issueSummary

        def commentBody = env.TFLINT_FAIL == 'true' ? """\
🛑 **TFLint Scan Report - FAILED**
Total Issues: ${totalIssues}

${summaryToPost}
""" : """\
✅ **TFLint Scan Report - PASSED**
Total Issues: ${totalIssues}

No critical issues found. Good job! 🎉
"""

        writeFile file: 'comment_body.md', text: commentBody

        withEnv(["GH_TOKEN=${GITHUB_TOKEN}"]) {
          sh "gh pr comment ${env.CHANGE_ID} --repo ${env.GH_REPO} --body-file comment_body.md"
        }
      }
    }
  }
}