node ('master'){
    stage 'Checkout'
    // checout block
    checkout scm
    stage('Test stage') {
    // test block
    steps {
        script{
        sh "chmod +x -R ${env.WORKSPACE}"
        sh "chmod +x -R ${env.WORKSPACE}/../${env.JOB_NAME}@script"
        sh "${env.WORKSPACE}/../${env.JOB_NAME}@script/build.sh"
        }
      }
    post {
      always {
        cleanWs()
      }
      failure {
          slackSend baseUrl: 'https://hooks.slack.com/services/',
          channel: '#automate-aws-ec2-with-terraform',
          iconEmoji: '',
          message: "CI failing for - #${env.BRANCH_NAME} - ${currentBuild.currentResult}  (<${env.BUILD_URL}|Open>)",
          teamDomain: 'final_project2',
          username: ''
        }
    }
    }
}
