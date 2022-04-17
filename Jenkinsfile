pipeline {
	agent any

	stages {
		stage('Build') {
			steps {
				sh 'aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin "978746379266.dkr.ecr.eu-central-1.amazonaws.com"'
				sh 'docker build -t devops_ecr .'
			}
		}
		stage('Push') {
			steps {
				sh 'docker tag devops_ecr:latest 978746379266.dkr.ecr.eu-central-1.amazonaws.com/devops_ecr:latest'
				sh 'docker push 978746379266.dkr.ecr.eu-central-1.amazonaws.com/devops_ecr:latest'
			}
		}
		stage('Deploy') {
			steps {
				sh 'kubectl config view --raw > ~/.kube/config'
				sh 'helm upgrade flaskapp helm/flaskapp/ --install --atomic --wait --set deployment.tag=latest'
			}
		}
	}
}
