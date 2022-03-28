pipeline {
    agent any


    stages {
        stage('Build') {
            steps {
                sh ''
            }
        }
        stage('Push') {
            steps {
               sh ''
            }
        }
        stage('Deploy') {
            steps {
                sh 'helm upgrade flaskapp helm/ --install --set deployment.tag=$GIT_COMMIT'
            }
        }
    }
}
