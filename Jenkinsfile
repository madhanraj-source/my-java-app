peline {
    agent {
        docker {
            image 'maven:3.8.1-openjdk-11'
            args '-v /root/.m2:/root/.m2 -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    environment {
        GIT_CREDENTIALS_ID = 'GIT_CREDENTIALS_ID' // Replace with your actual SSH credentials ID
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'git@github.com:madhanraj-source/my-java-app.git',
                    credentialsId: "${env.GIT_CREDENTIALS_ID}"
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
                script {
                    docker.build("my-java-app:${env.BUILD_ID}").inside {
                        sh 'echo Image built successfully'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "${env.GIT_CREDENTIALS_ID}", keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    # Clone the repository
                    git clone git@github.com:madhanraj-source/my-java-app.git repo
                    cd repo
                    
                    # Save Docker image to a tar file
                    docker save my-java-app:${env.BUILD_ID} > Dockerfile/my-java-app.tar
                    
                    # Configure Git
                    git config --global user.email "maddy.akm@gmail.com"
                    git config --global user.name "madhanraj-source"
                    
                    # Commit and push the Docker image tar file
                    git add Dockerfile/my-java-app.tar
                    git commit -m "Add Docker image for build ${env.BUILD_ID}"
                    git push origin main
                    '''
                }
            }
        }
    }
}

