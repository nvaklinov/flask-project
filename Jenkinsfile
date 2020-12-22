pipeline{
    agent{
      dockerfile true
    }
    stages{
        stage("A"){
            steps{
                echo "========executing A========"
                sh '''#!/bin/bash
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
