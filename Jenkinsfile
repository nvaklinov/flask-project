node ('master'){
    stage 'Checkout'
    // checout block
    checkout scm
    stage('Test stage') {
    // test block
    script {
        sh('cd relativePathToFolder && chmod +x build.sh && ./build.sh')
        }
    }
}
