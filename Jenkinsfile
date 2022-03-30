pipeline {
    agent any

    stages {
	stage ('Build') {
	    steps {
		sh 'docker build -t "723243027772.dkr.ecr.eu-central-1.amazonaws.com/flaskapp:$GIT_COMMIT" .'
		}
	}
	stage('Push') {
	   steps {
		sh 'aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 723243027772.dkr.ecr.eu-central-1.amazonaws.com'
		sh 'docker push 723243027772.dkr.ecr.eu-central-1.amazonaws.com/flaskapp:latest'
		}
        } 		
	stage('Deploy') {
	    steps {
		sh 'helm upgrade flaskapp helm/ --install --atomic --wait --set deployment.tag=$GIT_COMMIT'
	    }
	}
    }	
