pipeline {

  agent any

   stages {

    stage("build") {
        
        steps {

       slackSend message: "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
     }
   }
    stage("failed") {
     slackSend failOnError: true, message: "Build Started: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
    }
    stage("Test stage") {
      steps {
        dir(srcDir){
        sh 'cdr=$(pwd); $cdr/jenkins.sh "build.sh"'
       }
      }
    }
   }
 }


