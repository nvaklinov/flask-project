def Deploy(DeployEnv) {
    helm upgrade flask helm/ --atomic --wait --install --namespace "$DeployEnv" --create-namespace --set deployment.tag=$GIT_COMMIT --set deployment.env="$DeployEnv"
}

pipeline {
    agent any
    triggers {
        pollSCM('') // Enabling being build on Push
    }
    environment {
        image_name="058302395964.dkr.ecr.eu-central-1.amazonaws.com/flask"
        region="eu-central-1"
        account="058302395964"
    }
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t "${image_name}:$GIT_COMMIT" .
                '''
            }
        }
        stage('Test') {
            steps {
                sh '''
                docker run -dit -p 5000:5000 "${image_name}:$GIT_COMMIT"
                sleep 5
                curl localhost:5000
                exit_status=$?
                if [[ $exit_status == 0 ]]
                then echo "SUCCESSFUL TESTS" && docker stop $(docker ps -a -q)
                else echo "FAILED TESTS" && docker stop $(docker ps -a -q) && exit 1
                fi
                '''
            }
        }
        stage('Push') {
            steps {
                sh'''
                docker login -u AWS https://${account}.dkr.ecr.${region}.amazonaws.com -p $(aws ecr get-login-password --region ${region})
                docker push ${image_name}:$GIT_COMMIT
                '''
            }
        }
        stage("Deploy_Dev") {
            when {
                expression {
                    env.BRANCH_NAME == "dev"
                }
            }
            steps {
                Deploy("dev")
            }
        }
        stage("Deploy_Stage") {
            when {
                expression {
                    env.BRANCH_NAME == "stage"
                }
            }
            steps {
                Deploy("stage")
            }
        }
        stage("Deploy_Prod") {
            when {
                expression {
                    env.BRANCH_NAME == "master"
                }
            }
            steps {
                Deploy("prod")
            }
        }
    }
}
