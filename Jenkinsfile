node ('master'){
    stage 'Checkout'
    checkout scm
    stage('Test stage') {
    steps {
        sh "chmod +x -R ${env.WORKSPACE}"
        sh "./build.sh"
          }
    }
}
