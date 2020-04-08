pipeline{
  options {
    timestamps ()
    ansiColor('xterm')
  }
  agent any
  stages{
    stage('checkout app repo') {
        steps {
             checkout([
                 $class: 'GitSCM',
                 branches: [[name: "${params.git_branch}"]],
                 doGenerateSubmoduleConfigurations: false,
                 extensions: [],
                 userRemoteConfigs: [[credentialsId: 'github', url: "git@github.com:nagarajujalpal/revolut-assignment.git"]]
            ])
    }
    }

    stage('get commit id'){
        steps {
            script {
                shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
            }
        }
     }

     stage(" Docker Build Image") {
         steps {
             script{
               IMAGE_TAG = sh(returnStdout: true, script: "echo 854293248838.dkr.ecr.eu-west-2.amazonaws.com/flask:${shortCommit}").trim()
               sh "docker build --no-cache -t $IMAGE_TAG -f Dockerfile . "
             }
         }
     }

     stage(" Docker Push Image") {
         steps {
             script{
               docker.withRegistry("https://854293248838.dkr.ecr.eu-west-2.amazonaws.com", "ecr:eu-west-2:ecr-credentials") {
                 sh "docker push $IMAGE_TAG"
                 sh "docker rmi $IMAGE_TAG"
               }

             }
         }
     }

     stage("Deployment") {
         steps {
           sh "helm install postgresql postgresql app/postgresql --kubeconfig /home/ubuntu/.kube"
           sh "helm install ingress app/ingress --kubeconfig --kubeconfig /home/ubuntu/.kube"
           sh "helm install flask app/flask --set-string pullimage=$IMAGE_TAG --kubeconfig --kubeconfig /home/ubuntu/.kube"
         }
     }
  }

}
