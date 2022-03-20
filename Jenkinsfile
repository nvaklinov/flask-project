pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t "147646245893.dkr.ecr.eu-central-1.amazonaws.com/flaskapp:$GIT_COMMIT" .'
            }
        }
        stage('Push') {
            steps {
               sh 'docker login   https://147646245893.dkr.ecr.eu-central-1.amazonaws.com'
               sh 'docker push 147646245893.dkr.ecr.eu-central-1.amazonaws.com/flaskapp:$GIT_COMMIT'
            }
        }
        stage('Deploy') {
            steps {
                sh 'helm upgrade flaskapp helm/ --install --atomic --wait --set deployment.tag=$GIT_COMMIT'
            }
        }
    }
}