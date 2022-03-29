pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
		sh 'docker build -t "269333532645.dkr.ecr.eu-central-1.amazonaws.com/flaskapp:$GIT_COMMIT" .'
            }
        }
        stage('Push') {
            steps {
                echo 'Pushing..'
		sh 'aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 269333532645.dkr.ecr.eu-central-1.amazonaws.com'
		sh 'docker push 269333532645.dkr.ecr.eu-central-1.amazonaws.com/flaskapp:$GIT_COMMIT'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
		sh 'helm upgrade flaskapp helm/ --install --atomic --wait --set deployment.tag=$GIT_COMMIT'
            }
        }
    }
}
