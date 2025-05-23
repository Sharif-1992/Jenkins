stage('Comment on PR') {
  when {
    expression { env.CHANGE_ID != null }
  }
  steps {
    script {
      withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
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

        writeFile file: 'comment_body.md', text: commentBody

        sh '''
          echo $GITHUB_TOKEN | gh auth login --with-token
          gh pr comment ${CHANGE_ID} --repo ${GH_REPO} --body-file comment_body.md
        '''
      }
    }
  }
}