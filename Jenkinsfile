node ('master'){
    stage (){
       slackSend "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
     }
    stage 'Checkout'
    // checout block
    checkout scm
    stage('Test stage') {
    // test block
    dir(srcDir){
  sh 'cdr=$(pwd); $cdr/script.sh "build.sh"'
     }
    }
    stage ('Cucumber Slack Notification') {
    cucumberSlackSend 'https://hooks.slack.com/services/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'
     }
 }

