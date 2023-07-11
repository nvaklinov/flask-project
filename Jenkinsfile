def Deploy(DeployEnv) {
    sh """
    source ../../assume_role.sh
    helm upgrade flaskapp helm/ --install --atomic --wait --create-namespace --namespace $DeployEnv --set deployment.tag=$GIT_COMMIT --set deployment.env=$DeployEnv
    """
}

pipeline {
    agent any
    environment {
        image_name="058302395964.dkr.ecr.eu-central-1.amazonaws.com/flaskapp"
        region="eu-central-1"
    }
    stages {
      stage ("Build") {
        steps {
            sh '''
            docker build -t "${image_name}:$GIT_COMMIT" .
            '''
        }
    }
      stage ("test") {
        steps {
            sh '''
            port=$(shuf -i 2000-10000 -n 1)
            docker run -dit -p $port:5000 $image_name:$GIT_COMMIT
            sleep 5
            curl http://localhost:$port
            exit_status=$?
            if [[ $exit_status == 0 ]]
            then echo "SUCCESFULL TESTS" && docker stop $(docker ps -a -q)
            else echo "TESTS FAILED" && docker stop $(docker ps -a -q) && exit 1
            fi
            '''
        }
      }
      stage ("Push") {
        steps {
            sh '''
            aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 058302395964.dkr.ecr.eu-central-1.amazonaws.com
            docker push $image_name:$GIT_COMMIT
            '''
        }
      }
      stage ("deploy") {
        steps {
            sh '''
            aws eks update-kubeconfig --name flaskapp-cluster --region eu-central-1

            '''
         }
      }
      stage ("Deploy_Dev") {
        when {
            expression {
                env.BRANCH_NAME == "development"
            }
        }
        steps {
            Deploy("dev")
        }
      }
      stage ("Deploy_Stage") {
        when {
            expression {
                env.BRANCH_NAME == "stage"
            }
        }
        steps {
            Deploy("stage")
        }
      }
      stage ("Deploy_Prod") {
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