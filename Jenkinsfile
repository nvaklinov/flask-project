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

        PROJECT = 'tap_sample'

        IMAGE = 'tap_sample:latest'

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

                    // login to ECR - for now it seems that that the ECR Jenkins plugin is not performing the login as expected. I hope it will in the future.

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

            sh "docker rmi $IMAGE | true"

        }

    }

} 
