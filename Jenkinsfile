pipeline {
    agent any

    tools{
       .NET SDK  'my-netsdk' 
    }
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }
    stages {
        stage('build'){
           steps{
               echo 'Building image..'
               sh 'docker build -t datbk58/apidemo:1.0 .'
            }
         }
         stage('Pushing image') {
            steps {
                echo 'Start pushing.. with credential'
                sh 'echo $DOCKERHUB_CREDENTIALS'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push datbk58/apidemo:1.0'
                
            }
        }
        stage('Deploying and Cleaning') {
            steps {
                echo 'Deploying and cleaning'
                sh 'docker image rm datbk58/apidemo:1.0 || echo "this image does not exist" '
                sh 'docker container stop my-demo-apidemo || echo "this container does not exist" '
                sh 'docker network create jenkins || echo "this network exists"'
                sh 'echo y | docker container prune '
                sh 'echo y | docker image prune'
                sh 'docker container run -d --rm --name my-demo-apidemo -p 8081:8080 --network jenkins datbk58/apidemo:1.0'
            }
        }
        
    }
}