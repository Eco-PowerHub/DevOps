def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline {
    agent any

    environment {
        NODEJS_HOME = '/usr/local/bin/node' 
        PATH = "${NODEJS_HOME}:${env.PATH}"
        EC2_USER = 'ubuntu'
        IMAGE_NAME = 'khaledmahmoud7/eco-front'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'Dev', url: 'https://github.com/Eco-PowerHub/Front-end.git' 
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    sh 'npm install --legacy-peer-deps'
                    // Ignoring dependencies conflicts 
                }
            }
        }

        stage('Build Angular App') {
            steps {
                script {
                    sh 'ng build --configuration=production'
                }
            }
        }

       // stage('Run Tests') {
       //     steps {
       //         script {
       //             sh 'npm run test -- --no-watch --browsers=ChromeHeadless --code-coverage'
       //         }
       //     }
       //}

        stage('Archive Build Artifacts') {
            steps {
                archiveArtifacts artifacts: 'dist/**', fingerprint: true
            }
        }

        stage('Dockerizing Angular App') {
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
                sh "ansible-playbook -i Ansible/inventory Ansible/deployAngTest.yaml --extra-vars 'docker_image=${IMAGE_NAME} docker_tag=${IMAGE_TAG}'"
            }
        }
    }

    post {
        always {
            echo 'Slack Notification'
            slackSend channel: '#cicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}"
            sh 'docker logout'
        }
    }
}