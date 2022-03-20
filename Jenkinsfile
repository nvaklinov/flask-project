pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t "837347534425.dkr.ecr.us-east-1.amazonaws.com/flaskapp:$GIT_COMMIT" .'
                }
        }
        stage('Push') {
            steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 837347534425.dkr.ecr.us-east-1.amazonaws.com'
                sh 'docker push 837347534425.dkr.ecr.us-east-1.amazonaws.com/flaskapp:$GIT_COMMIT"'
            }
        }
        stage('Deploy') {
            steps {
                sh 'helm upgrade flaskapp helm/flaskapp/ --install --atomic --wait --set deployment.tag=$GIT_COMMIT'
            }
        }
    }
  }