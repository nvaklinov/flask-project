pipeline{
   agent any {
    stages{
        stage("A"){
            steps{
                echo "========executing A========"
                sh ''''
                 "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 637927395305.dkr.ecr.us-east-1.amazonaws.com"
                 "docker build -f Dockerfile -t "final_project2:$GIT_COMMIT""
                 "docker tag final_project2:latest 637927395305.dkr.ecr.us-east-1.amazonaws.com/final_project2:$GIT_COMMIT"
                 "docker push 637927395305.dkr.ecr.us-east-1.amazonaws.com/final_project2:$GIT_COMMIT"
                 '''
            }
            post{
                always{
                    echo "Docker login in ECR; build from Dockerfile, docker tag and docker push to 637927395305.dkr.ecr.us-east-1.amazonaws.com/final_project2"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                    slackSend message: "Stage A failure - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                }
            }
        }
    }
    post{
        always{
            echo "Pipeline started for ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
            slackSend message: "Pipeline Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline failed ========"
            slackSend message: "Pipeline failure - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
    }
  }
}
