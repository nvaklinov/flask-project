node ('master'){
    stage 'Checkout'
    // checout block
    checkout scm
    stage('Test stage') {
    // test block
    dir(srcDir){
  sh 'cdr=$(pwd); $cdr/script.sh "build.sh"'
         }
     }
 }

