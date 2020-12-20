node ('master'){
    stage 'Checkout'
    // checout block
    checkout scm
    stage('Test stage') {
    // test block
    script {
        sh('cd /var/lib/jenkins/workspace/ject2_vladogospodinov_myflaskapp@tmp/durable-dd6d4787/ && chmod +x build.sh && ./build.sh')
        }
    }
}
