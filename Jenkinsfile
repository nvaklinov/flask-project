pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..',
		./pip install -r requirements.txt
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..',
		./start.sh
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
