def Deploy(DeployEnv) {
    sh """
    #source ../../assume_role.sh
    #source assume_role.sh
    export AWS_ACCESS_KEY_ID='AKIA2CCSJJJN3MXJPLOP'
    export AWS_SECRET_ACCESS_KEY='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'

    aws eks update-kubeconfig --region us-east-1 --name cluster
    helm upgrade flask helm/ --atomic --wait --install --namespace "$DeployEnv" --create-namespace --set deployment.tag="$GIT_COMMIT" --set deployment.env="$DeployEnv"
    """
}

pipeline {
    agent any
    
    environment {
        image_name="691662309979.dkr.ecr.us-east-1.amazonaws.com/flask"
        region="us-east-1"
        account="691662309979"
        }
    
    stages {
        stage('Build') {
            steps {
                // Perform build steps here
                sh '''
                docker build -t "${image_name}:$GIT_COMMIT" . 
                '''
            }
        }
        
        stage('Test') {
            steps {
                // Perform testing steps here 1
                sh '''
                docker run -dit -p 5000:5000 "${image_name}:$GIT_COMMIT" || sudo docker stop $(docker ps -a -q)
                sleep 10
                curl http://localhost:5000
                exit_status=$?
                if [[ $exit_status == 0 ]]
                then echo "SUCCESFULL TESTS" && docker stop $(docker ps -a -q)
                else echo "TESTS FAILED" && docker stop $(docker ps -a -q) && exit 1
                fi
                '''
            }
        }
        
        stage('Push') {
            steps {
                // Perform push steps here
                sh '''
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 691662309979.dkr.ecr.us-east-1.amazonaws.com
                docker push ${image_name}:$GIT_COMMIT 
                '''
            }
        }
        
        stage("Deploy_Dev") {
                when {
                    expression {
                        env.BRANCH_NAME == "development"
                    }
                }
                steps {
                    Deploy("dev")
                }
            }
            stage("Deploy_Prod"){
                when {
                    expression {
                        env.BRANCH_NAME == "main"
                    }
                }
                steps {
                    Deploy("prod")
                }
            }
            stage("Deploy_Stage"){
                when {
                    expression {
                        env.BRANCH_NAME == "stage"
                    }
                }
                steps {
                    Deploy("stage")
                }
            }
        }
    }
