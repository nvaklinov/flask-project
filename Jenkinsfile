pipeline {
    agent any

    stages {
        stage('Clone project from repo') {
            steps {
                echo git clone git@github.com:nvaklinov/flaskproject.git
            }
        }
        stage('Install Requirements') {
            steps {
                bash -x /var/lib/jenkins/pipeline.sh
            }
        }
        stage('Dockerize') {
            steps {
                bash -x /var/lib/jenkins/pipeline2.sh
            }
        }
		stage('Deploy') {
            steps {
                bash -x /var/lib/jenkins/pipeline3.sh
            }
        }
    }
}
