pipeline {
    agent any

    tools{
       dotnetsdk 'my-netsdk' 
    }
     parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')

        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

        booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')

        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')

        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')

        string(name: 'MYNAME', defaultValue: 'Dat', description: 'my name is Dat')
    }
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
        NAME='PHAM Dat'
        ADDRESS='VIET NAM'
    }
    stages {
        stage('build'){
           steps{
               echo "Hello ${params.PERSON}"

               echo "Biography: ${params.BIOGRAPHY}"

               echo "Toggle: ${params.TOGGLE}"

               echo "Choice: ${params.CHOICE}"

               echo "Password: ${params.PASSWORD}"
               echo "Myname is : ${params.MYNAME}"
               echo 'Building image..'
               sh 'docker build -t datbk58/apidemo:1.7 -f Dockerfile .'
               echo "${env.NAME}"
            }
         }
         stage('Pushing image') {
            steps {
                echo 'Start pushing.. with credential'
                sh 'echo $DOCKERHUB_CREDENTIALS'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push datbk58/apidemo:1.7'
                
            }
        }
        stage('Deploying and Cleaning') {
            agent{
                node{
                    label 'ubuntu'
                }
            }
            steps {
                echo "${env.ADDRESS}"
                echo 'Deploying and cleaning'
                sh 'docker image rm datbk58/apidemo:1.7 || echo "this image does not exist" '
                sh 'docker container stop my-demo-apidemo || echo "this container does not exist" '
                sh 'docker network create jenkins || echo "this network exists"'
                sh 'echo y | docker container prune '
                sh 'echo y | docker image prune'
                sh 'docker container run -d --name my-demo-apidemo -p 8082:80 --network jenkins datbk58/apidemo:1.7'
            }
        }
        
    }
}
