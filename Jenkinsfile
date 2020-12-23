@Library('jenkins-devops-libs@v1.4.0')_

pipeline

{

    options

    {

        buildDiscarder(logRotator(numToKeepStr: '3'))

    }

    agent any
    
    parameters {
      string(name: 'SCM_URL', description: 'The URL (HTTPS or SSH URI) to the source repository containing the Dockerfile.')
      string(name: 'BRANCH', defaultValue: 'master', description: 'GIT SCM branch from repository to clone/pull.')
      string(name: 'APP', description: 'The application for which to build and push an image.')
      string(name: 'ORG', description: 'The organization for the application; used for Docker image repository prefix (if left blank defaults to Git server organization).')
      string(name: 'VERSION', defaultValue: "${env.BUILD_NUMBER.toInteger() + 1}", description: 'The version of the application for the Docker Image tag.')
      string(name: 'REGISTRY_URL', defaultValue: 'registry.hub.docker.com', description: 'The Docker Registry server URL (no URI; https:// is embedded in code and required for registries).')
    
    }

    environment 

    {

        VERSION = 'latest'

        PROJECT = 'final_project2'

        IMAGE = 'final_project2:latest'

        ECRURL = 'http://637927395305.dkr.ecr.us-east-1.amazonaws.com'

        ECRCRED = 'ecr:us-east-1:awscredentials'
        
        KUBECONFIG = '/path/to/.kube/config'

    }
    
    withCredentials([kubeconfigFile(credentialsId: 'mykubeconfig', variable: 'KUBECONFIG')]) {
        sh 'use $KUBECONFIG' // environment variable; not pipeline variable
    }

    stages

    {

        stage('Build preparations')

        {

            steps

            {

                script 

                {

                    // calculate GIT lastest commit short-hash

                    gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()

                    shortCommitHash = gitCommitHash.take(7)

                    // calculate a sample version tag

                    VERSION = shortCommitHash

                    // set the build display name

                    currentBuild.displayName = "#${BUILD_ID}-${VERSION}"

                    IMAGE = "$PROJECT:$VERSION"

                }
            }
        }
     

        stage('Docker build')

        {

            steps

            {

                script

                {

                    // Build the docker image using a Dockerfile

                    docker.build("$IMAGE")

                }
            }
        }

        agent { docker {
          image image_name
          args '-p 9000:9000'
        } }

        steps {
          script {
            
            // Validate Image
            
            sh 'curl localhost:9000'
        }
      }
      

      // scan image for vulnerabilities
      scanConfig = [
        'buildName':   buildInfo.name,
        'buildNumber': buildInfo.number
      ]
      xrayResults = xrayScanBuild(scanConfig)
      print xrayResults as String

        stage('Docker push')

        {

            steps

            {

                script

                {

                    // login to ECR 

                    sh("eval \$(aws ecr get-login --no-include-email | sed 's|https://||')")

                    // Push the Docker image to ECR

                    docker.withRegistry(ECRURL, ECRCRED)

                    {

                        docker.image(IMAGE).push()

                    }

                }
            }
        }
    }

    helm.setup('2.14.3')
    
    helm.lint(
      chart: params.APP,
      set:   ["image.tag=${params.VERSION}"]
    )

    helm.packages(
      chart:       "charts/${params.APP}",
      update_deps: true,
      version:     params.VERSION
    )
    
    helm.install(
      chart: "${params.APP}-chart",
      name:  "${params.APP}-${params.VERSION}"
    )

    helm.test(
      cleanup:  false,
      name:     "${params.APP}-${params.VERSION}",
      parallel: true
    )
    
    post

    {

        always

        {

            // make sure that the Docker image is removed

            sh "docker rmi $IMAGE | true" 
            
            // To be sure..
            
            sh "docker rmi -f ${image.id}"

            echo "========Pipeline started========"
            slackSend message: "Pipeline started...: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
       
        }

        success
         
        {
             sh "docker rmi -f ${image.id}"
             echo "========Pipeline successfully finished========"
             slackSend message: "Pipeline successfully finished - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
       
        }

        failure 
        
        {
             echo "========Pipeline failed========"
             slackSend message: "Pipeline was a  failure, hope Lord Vader will not notice...: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
       
        }
     
     }

}

 
