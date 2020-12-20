node ('master'){
    stage 'Checkout'
    // checout block
    checkout scm
    stage('Test stage') {
    // test block
    steps {
        sh "chmod +x -R ${env.WORKSPACE}"
        sh "./build.sh"
          }
    }
}

