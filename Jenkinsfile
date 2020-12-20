pipeline {

  agent any

   stages {

    stage("build") {
        
        steps {

       slackSend message: "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
     }
   }
    stage('Test stage') {
      steps {
        dir(srcDir){
        sh 'cdr=$(pwd); $cdr/script.sh "build.sh"'
     }
    }
  }
    stage ('Cucumber Slack Notification') {
     steps {
      cucumberSlackSend 'https://hooks.slack.com/services/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'
     }
    }
   }
}

