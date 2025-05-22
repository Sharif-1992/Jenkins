pipeline {
  agent any
  stages {
    stage('Pull Request Trigger') {
      steps {
        echo "Triggered by PR: ${env.CHANGE_ID} from ${env.CHANGE_BRANCH}"
      }
    }
  }
}