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
                sh 'docker push 837347534425.dkr.ecr.us-east-1.amazonaws.com/flaskapp:$GIT_COMMIT'
            }
        }
        stage('Deploy') {
            steps {
                sh 'kubectl -n spinnaker get events --sort-by='{.lastTimestamp}''
                sh 'aws configure set aws_access_key_id AKIA4F5ONMZM5RX45MH6 && aws configure set aws_secret_access_key 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 && aws configure set region us-east-1 && aws configure set output "text"'
                sh 'helm upgrade flaskapp helm/flaskapp/ --install --atomic --wait --set deployment.tag=$GIT_COMMIT'
            }
        }
    }
  }