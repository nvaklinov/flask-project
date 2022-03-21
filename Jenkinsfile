pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t "147646245893.dkr.ecr.eu-central-1.amazonaws.com/flaskapp:$GIT_COMMIT" .'
            }
        }
        stage('Push') {
            steps {
               sh 'aws ecr --region eu-central-1 | docker login -u AWS -p QVdTOmV5SndZWGxzYjJGa0lqb2lVR1pRZEZaUWJGWnJkVUZaTkhaR05EbHdUSFJsYlhOaU0ycE5VMVU1Um1NNFdsVjZRMFYxYjJWV1RuaDRaa3BpVGpGMFNuZHJPV
                                                                          VZ3Umt4d1FYcDFSM0Z0UkdOdmNrdFhjbGhQU0VKS00yeFJOV2MxUTJRdk1GaDBjblZwYmxBek1pdDZhek50Wld4VVUzWlFPVVk0U1daQ09VSm1PRWxwYm14eFVFMWxhREpoWWpsS1NHeDVNMlJ4YkV0NWJEQk5
                                                                          VMngxT0V4cldsb3JTVzVwU21WQ1ZIbG5aVzlRYkVsbVZEQlVkRzE0Tm5WM1V6ZHdlVVpuUmpBNGFHaHFaSFozU0RkeFJFaFFRMkpKVGtKblkzQnBRVmd3T1dKbFJqbEhMekY1VTFOSVNVUjZXRWxLV214QksyZ
                                                                          FpRbFpZTlRod2VrWTFUV3hZTm5wTVZpdFZRVVUxYjI1RVpIWkNRV1prTVdsUFJtY3djMnB3TlZsRVN6SmphRmh1Y0ZKWU1tTTRkRWQ2U1RoT1JqUnpUakpQYUN0SU4zUnpVR1JGZWt0MVJWSjJObXhYUmxSQmR
                                                                          ERnlibEJvTmtsc1FVOHhWMFpGVG5walYyUXhVVzluTTNCMFp6UkNialZ3VWtVMVVVcEZZWGhvTW1aVmRFcHJOblJRVld3ekwyZDBLMUpCUkd0cmRFeGFPVzVqTWtsVmRtZHJVSGxvU0hwdlVuVnRNSGdyTWpOQ
                                                                          1MwSnZhRXRST0d0a2IwVk9VM28xVlhSTU5YbFdZbU5pVnpacFpHcEtOMWsyVmprM1VVRlVhM0psT0ZoSWJWaGthMng0UzA4NWJucEtUSFIwUm5oYVZtcHFibFJpTkd4dlYwTkZhMFp1WlRoSGRGaDJUMU5YTVd
                                                                          OT2JFVkpUVTVYT0ZKWFZrOXdZbWhRWVVkSFptOVJOR1pMTm5FelJtUk1aVWsyTVVKWU4xWjBjMHBpZGpnMk9XTTJPSGhVU2tObGN6aFlNR0p5VHk5bWFFSnljMUZpYlZoaWRrMUlabXhKSzBScFMyOVpSMmhvV
                                                                          EVwa1ZreEdRakZEWTI1RmEyRllUbk0wYmtwRGNYaHhSemxNZW1GV1owUTRLMUZzU1VwV05qVk5jakZHTm1WelRsTk1VMVJGU0VSeVR6WXZXa2RVZWxwbEwxaFZUMnRqY1hvM1JHdzNjVzVEVVVSaWFsTk5Oa3B
                                                                          DVkRZdlFYUnZSVUZMWlVacFNVNHlOR0ZRYm1ZMFF5OTBPV052VlVsbVIxUXZMMWhPUlc1UlRIaGhjMDlyTTBSblJIVnRNVTVSVkZCUk1WbFliVUZwV0c1bVpreDVSeXRPY2tKRU1raDFibEJLYVZBdmIxWkRke
                                                                          lpQZW5ZcmIwUkhaMVU1YkZkWFJ6Qm5iVU5pVjFWQ2J6Z3ZjMWxOTnpWT1IxcFdOWE5oWVZGNFZFNVFVVzA1SzJaYWNtdHljMDU0VTBSMGNHcFlVSEZhYVVaTU56YzNVMG8zWkZGeE5EZ3JUMmt6TVVaeFoxUkx
                                                                          XV05FWkdrNWJEaFBjbTU2T1ZsYVRYaGplakJSU0VWNWN6Wk5TV1p6V2taVlNqZE5PRUpuVkc5aVlTdGpjRTl3Y0dneFVWWXZRbk5XYVV4R1lrMUJaV2h6U3l0UFV6RndjVWh2VkM4MWVYVTRkVkF2T0ZoSFJYW
                                                                          nRZMUo2VW1GaFNqVkdMMHBTY1VOa1IxQmFkRVYxWmtwVVMzcEtNRzhyVDJWTmFHZDBaVmR6WVRnclJYZGFiRU4xWWpndlRsZEtZMHBZVTFkV2JpOVJLMEZ3ZW0xSEwyaDVUazR5V1RkTVlUSk5ZV05qYkVKbWF
                                                                          6QkZUVmhHTDJsS1dGRkxiRFpGUVRkR1ZUVjVTMXBEZVZoalFVdFViRFZaUTFOR0lpd2laR0YwWVd0bGVTSTZJa0ZSUlVKQlNHZ3plbGxQWkhSd1FrSlRWbmN2V1RKaGJqaENXRWxFTkd0M1RGRm1ibTlVYWpWN
                                                                          mQxcDBSMHBhYjFwUlFVRkJTRFIzWmtGWlNrdHZXa2xvZG1OT1FWRmpSMjlIT0hkaVVVbENRVVJDYjBKbmEzRm9hMmxIT1hjd1FrSjNSWGRJWjFsS1dVbGFTVUZYVlVSQ1FVVjFUVUpGUlVST1ZVTnFTSFJ5VW5
                                                                          SM1ZWQkZhMkpJWjBsQ1JVbEJOMWw1UkZGS1RtNUtPRkJZVTBvNVlXZERVSGN3VmtWdVJqSmpZMHRUVUVwd2NrVmlWRFpUVG05NVRrZGFWbVJqVmtGdVVFTXpXa2R5WkhaUVN6SllNbEYxVUZCQ1YwTXJaVUowY
                                                                          TI5NGRFRTlJaXdpZG1WeWMybHZiaUk2SWpJaUxDSjBlWEJsSWpvaVJFRlVRVjlMUlZraUxDSmxlSEJwY21GMGFXOXVJam94TmpRM09USTVNVEk1ZlE9PQ== 147646245893.dkr.ecr.eu-central-1.amazonaws.com/flaskapp'
               sh 'docker push 147646245893.dkr.ecr.eu-central-1.amazonaws.com/flaskapp:$GIT_COMMIT'
            }
        }
        stage('Deploy') {
            steps {
                sh 'helm upgrade flaskapp helm/ --install --atomic --wait --set deployment.tag=$GIT_COMMIT'
            }
        }
    }
}