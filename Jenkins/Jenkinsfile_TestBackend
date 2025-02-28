pipeline {

    agent any
    environment {
        GIT_REPO = 'https://github.com/Eco-PowerHub/Back-end.git'
        BRANCH = 'Dev'
        EC2_USER = 'ubuntu'
        IMAGE_NAME = 'khaledmahmoud7/eco-back'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    stages {
        stage("Fetch Git Repo") {
            steps {
                git branch: "${BRANCH}", url: "${GIT_REPO}"
            }    
        }

        stage("Restore Dependencies") {
            steps {
                sh 'dotnet restore'
            }
        }

        stage("Building") {
            steps {
                sh 'dotnet build --no-restore -c Release'
            }
        }

        // stage("Publish") {
        //     steps {
        //         sh 'dotnet publish -c Release -o publish'
        //     }
        // }

        stage('Run Unit Tests') {
            steps {
                sh 'dotnet test --no-build --verbosity normal'
            }
        }

        stage('Dockerizing .NET') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Ansible Deployment') {
            steps {
                sh "ansible-playbook -i Ansible/inventory Ansible/deployTestingEnv.yml --extra-vars 'docker_image=${IMAGE_NAME} docker_tag=${IMAGE_TAG}'"
            }
        }
    }

    post {
        success {
            echo 'Build and Tests completed successfully!'
        }
        failure {
            echo 'Build or Tests failed. Check the logs for details.'
        }
        always {
            sh 'docker logout'
        }
    }
}