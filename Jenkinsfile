pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t "250408828727.dkr.ecr.eu-central-1.amazonaws.com/flaskapp:$GIT_COMMIT" .'
            }
        }
        stage('Push') {
            steps {
                sh 'aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 250408828727.dkr.ecr.eu-central-1.amazonaws.com'
                sh 'docker push 250408828727.dkr.ecr.eu-central-1.amazonaws.com/flaskapp'
            }
           }
         stage('Deploy') {
            steps {
                sh 'helm upgrade flaskapp helm/ --install --atomic --wait --set deployment.tag=$GIT_COMMIT'
            }
        }
     }
  }
