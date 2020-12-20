node ('master'){
    stage 'Checkout'
    // checout block
    checkout scm
    stage('Test stage') {
    // test block
    steps {
        script{
        sh "chmod +x -R ${env.WORKSPACE}"
        sh "chmod +x -R ${env.WORKSPACE}/../${env.JOB_NAME}@script"
        sh "${env.WORKSPACE}/../${env.JOB_NAME}@script/build.sh"
        }
      }
    }
}
