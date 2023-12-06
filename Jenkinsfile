pipeline {
    agent any

    environment {
        image_name="058302395964.dkr.ecr.eu-central-1.amazonaws.com/nikdevops"
        region="eu-central-1"
    }
    stages {
        stage ("Build") {
            steps {
                sh '''
                  docker build -t "${image_name}:$GIT_COMMIT .
                '''
            }
        }
        stage ("Test") {
            steps {
                sh '''
                port=$(shuf -i 3000-10000 -n 1)
                container_name=$(echo $RANDOM)
                docker run --name $container_name -dit -p $port:5000 $image_name:$GIT_COMMIT
                sleep 5
                curl http://localhost:$port
                exit_status=$?
                if [[ $exit_status == 0 ]]
                then echo "SUCCESSFUL TESTS" && docker stop $container_name
                else echo "TESTS FAILED" && docker stop $container_name && exit 1
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
        stage ("Deploy") {
            steps {
                sh '''
                aws eks update-kubeconfig --name nikdevops-cluster --region $region
                source ../../assume_role.sh
                helm upgrade flask helm/ --install --wait --atomic --set deployment.tag=$GIT_COMMIT
                '''
            }
        }
    }
}