pipeline {

  agent any

   stages {

    stage("build") {
        
        steps {
          parallel("Build started":  {

       slackSend message: "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
     },
   
          "Build failed": {
     slackSend failOnError: true, message: "Build stopped due to Error : ${env.JOB_NAME} ${env.BUILD_NUMBER}"
     }
   )
  }
}

    stage('shell_cmd') {
            steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 637927395305.dkr.ecr.us-east-1.amazonaws.com'
                sh '''
                    docker build -f Dockerfile -t "final_project2:$GIT_COMMIT"
                    docker tag "final_project2:$GIT_COMMIT" 637927395305.dkr.ecr.us-east-1.amazonaws.com/final_project2:latest
                    docker push 637927395305.dkr.ecr.us-east-1.amazonaws.com/final_project2:latest
                '''
            }
        }
   }
}


