pipeline

{

    options

    {

        buildDiscarder(logRotator(numToKeepStr: '3'))

    }

    agent any

    environment 

    {

        VERSION = 'latest'

        PROJECT = 'final_project2'

        IMAGE = 'final_project2:latest'

        ECRURL = 'http://637927395305.dkr.ecr.us-east-1.amazonaws.com'

        ECRCRED = 'ecr:us-east-1:awscredentials'

    }

    stages

    {

        stage('Build preparations')

        {

            steps

            {

                script 

                {

                    // calculate GIT lastest commit short-hash

                    gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()

                    shortCommitHash = gitCommitHash.take(7)

                    // calculate a sample version tag

                    VERSION = shortCommitHash

                    // set the build display name

                    currentBuild.displayName = "#${BUILD_ID}-${VERSION}"

                    IMAGE = "$PROJECT:$VERSION"

                }
            }
        }
     

        stage('Docker build')

        {

            steps

            {

                script

                {

                    // Build the docker image using a Dockerfile

                    docker.build("$IMAGE")

                }
            }
        }


        stage('Docker push')

        {

            steps

            {

                script

                {

                    // login to ECR 

                    sh("eval \$(aws ecr get-login --no-include-email | sed 's|https://||')")

                    // Push the Docker image to ECR

                    docker.withRegistry(ECRURL, ECRCRED)

                    {

                        docker.image(IMAGE).push()

                    }

                }
            }
        }
    }

    

    post

    {

        always

        {

            // make sure that the Docker image is removed

            sh "sudo -S jenkins  docker rmi $IMAGE | true"

            echo "========Pipeline started========"
            slackSend message: "Pipeline started...: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
       
        }

        success
         
        {
             echo "========Pipeline successfully finished========"
             slackSend message: "Pipeline successfully finished - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
       
        }

        failure 
        
        {
             echo "========Pipeline failed========"
             slackSend message: "Pipeline was a  failure, hope Lord Vader will not notice...: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
       
        }
     
     }

}




