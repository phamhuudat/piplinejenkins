pipeline {
    agent any
    tools{
       dotnetsdk 'my-netsdk' 
    }
     parameters {
        string(name: 'IMAGE_NAME', defaultValue: 'apidemo', description: 'What is this image\'s name?')
        string(name: 'IMAGE_TAG', defaultValue: '1.8', description: 'What is this image\'s tag?')
    }
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }
    stages {
        stage('Run app'){
           steps{
               echo "Run app ${params.IMAGE_NAME}:${params.IMAGE_TAG}"
               sh "cd APIDemo"
               sh "dotnet restore ./APIDemo.csproj"
               sh "dotnet publish ./APIDemo.csproj -c Release -o ./app/publish"
            }
         }
         stage("Build image"){
             steps{
                 sh "docker build -t datbk58/${params.IMAGE_NAME}:${params.IMAGE_TAG} -f Dockerfile ."
             }
         }
         stage('Pushing image') {
            steps {
                echo 'Start pushing.. with credential'
                sh 'echo $DOCKERHUB_CREDENTIALS'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh "docker push datbk58/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
                
            }
        }
        stage('Deploying and Cleaning') {
            steps {
                echo 'Deploying and cleaning'
                sh "docker image rm ${params.IMAGE_NAME}:${params.IMAGE_TAG} || echo \"this image does not exist\" "
                sh 'docker container stop my-demo-apidemo || echo "this container does not exist" '
                sh 'docker network create jenkins || echo "this network exists"'
                sh 'echo y | docker container prune '
                sh 'echo y | docker image prune'
                sh "docker container run -d --name my-demo-apidemo -p 8082:80 --network jenkins datbk58/${params.IMAGE_NAME}:${params.IMAGE_TAG}"
            }
        }
        
    }
}
