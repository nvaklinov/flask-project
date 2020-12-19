pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'echo "Starting Jenkins pipeline"'
                sh 'echo "Building the application"'
                sh '''
                    echo "Multiline Jenkins Pipeline steps executed..."
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 637927395305.dkr.ecr.us-east-1.amazonaws.com
                    docker build -f Dockerfile -t "final_project2:$GIT_COMMIT"
                    docker tag "final_project2:$GIT_COMMIT" 637927395305.dkr.ecr.us-east-1.amazonaws.com/final_project2:latest
                    docker push 637927395305.dkr.ecr.us-east-1.amazonaws.com/final_project2:latest
                '''
            }
        }
    stage('Test') {
            steps { 
               sh 'echo "Testing the application"'
            }     
        }
    stage('Deploy') {
            steps { 
               sh 'echo "Deploying the application in production"'
            }     
        }
    }
    post {
        always {
            echo 'One way or another, I have finished'
            deleteDir() /* clean up our workspace */
        }
        success {
            echo 'I succeeded!'
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before...'
        }
            
        success {
             slackSend channel: '#automate-aws-ec2-with-terraform',
                  color: 'good',
                  message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
             }
        
        failure {
             slackSend channel: '#automate-aws-ec2-with-terraform',
                  color: 'RED',
                  message: "The pipeline ${currentBuild.fullDisplayName} failed."
             }
        
    
        аborted {
             slackSend channel: '#automate-aws-ec2-with-terraform',
                 color: 'RED',
                  message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
             }
       }
}

