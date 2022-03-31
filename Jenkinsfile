pipeline {
	agent any

	stages {
		stage('Build') {
			steps {
				sh 'docker build -t  "978746379266.dkr.ecr.eu-central-1.amazonaws.com/devops_ecr:$GIT_COMMIT" .'
			}
		}
		stage('Push') {
			steps {
				sh 'docker login -u AWS -p $(aws ecr get-login-password --region the-region-you-are-in) 978746379266.dkr.ecr.eu-central-1.amazonaws.com/devops_ecr'
				sh 'docker build -t "978746379266.dkr.ecr.eu-central-1.amazonaws.com/devops_ecr:$GIT_COMMIT" .'
			}
		}
		stage('Deploy') {
			steps {
				sh 'helm upgrade flaskapp helm/ --install --set deployment.tag=$GIT_COMMIT'
			}
		}
	}
}
