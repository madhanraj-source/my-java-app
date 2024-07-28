pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], userRemoteConfigs: [[url: 'https://github.com/madhanraj-source/my-java-app.git']]])
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-java-app:${env.BUILD_ID} .'
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                    sh '''
                    git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/madhanraj-source/my-java-app.git repo
                    cd repo
                    mkdir -p Dockerfile
                    docker save my-java-app:${env.BUILD_ID} > Dockerfile/my-java-app.tar
                    git add Dockerfile/my-java-app.tar
                    git commit -m "Add Docker image for build ${env.BUILD_ID}"
                    git push origin main
                    '''
                }
            }
        }
    }
}

