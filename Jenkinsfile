node ('master'){
    stage 'Checkout'
    // checout block
    checkout scm
    stage('Test stage') {
    // test block
    script{
        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 637927395305.dkr.ecr.us-east-1.amazonaws.com
        docker build -f Dockerfile -t "final_project2:$GIT_COMMIT"
        docker tag "final_project2:$GIT_COMMIT" 637927395305.dkr.ecr.us-east-1.amazonaws.com/final_project2:latest
        docker push 637927395305.dkr.ecr.us-east-1.amazonaws.com/final_project2:$GIT_COMMIT
 
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
