pipeline {
    agent any
    environment {
        image_name="058302395964.dkr.ecr.eu-central-1.amazonaws.com/flaskapp"
        region="eu-central-1"
        account="058302395964"
    }
    stages {
        stage("Build") {
            steps {
                sh '''
                docker build -t "${image_name}:$GIT_COMMIT" .
                '''
            }
        }
        stage("test") {
            steps {
                sh '''
                docker run -dit -p 5000:5000 "${image_name}:$GIT_COMMIT" || docker stop $(docker ps -a -q)
                sleep 10
                curl http://localhost:5000
                exit_status=$?
                if [[ $exit_status == 0]]
                then echo "SUCCESFULL TESTS" && docker stop $(docker ps -a -q)
                else echo "TESTS FAILED" && docker stop $(docker ps -a -q) && exit 1
                fi
                '''
            }
        }
        stage("Push") {
            steps {
                sh '''
                aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 058302395964.dkr.ecr.eu-central-1.amazonaws.com
                docker push ${image_name}:$GIT_COMMIT
                '''
            }
        }
    }
}
