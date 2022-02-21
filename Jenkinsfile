pipeline {
    agent any

    tools{
       dotnetsdk 'my-netsdk' 
    }
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
        NAME='PHAM Dat'
        ADDRESS='VIET NAM'
    }
    stages {
        stage('build'){
           steps{
               echo 'Building image..'
               sh 'docker build -t datbk58/apidemo:1.7 -f Dockerfile .'
               sh 'echo $NAME'
            }
         }
         stage('Pushing image') {
            steps {
                echo 'Start pushing.. with credential'
                sh 'echo $DOCKERHUB_CREDENTIALS'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push datbk58/apidemo:1.7'
                sh 'echo $ADDRESS'
                
            }
        }
        stage('Deploying and Cleaning') {
            steps {
                echo '$ADDRESS'
                echo 'Deploying and cleaning'
                sh 'docker image rm datbk58/apidemo:1.7 || echo "this image does not exist" '
                sh 'docker container stop my-demo-apidemo || echo "this container does not exist" '
                sh 'docker network create jenkins || echo "this network exists"'
                sh 'echo y | docker container prune '
                sh 'echo y | docker image prune'
                sh 'docker container run -d --name my-demo-apidemo -p 8082:80 --network host datbk58/apidemo:1.7'
            }
        }
        
    }
}
