def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline {

    agent any
    environment {
        GIT_REPO = 'https://github.com/Eco-PowerHub/Back-end.git'
        BRANCH = 'Dev'
        EC2_USER = 'ubuntu'
        IMAGE_NAME = 'khaledmahmoud7/eco-back'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOTNET_CLI_HOME = "${env.WORKSPACE}"
        SONAR_SCANNER_HOME = tool 'SonarQube-Scanner'
        SONAR_SERVER = 'SonarQube'
        PROJECT_KEY = 'ecopower-back'
        PROJECT_NAME = 'EcoPowerHub-Backend'
    }

    stages {
        stage("Fetch Git Repo") {
            steps {
                git branch: "${BRANCH}", url: "${GIT_REPO}"
            }    
        }

        stage("Copy EmailService") {
            steps {
                sh 'cp /var/jenkins_home/ecofiles/EmailTemplateService.cs /var/jenkins_home/workspace/Eco-PowerHub/Backend-Dev/Repositories/Services/EmailTemplateService.cs'
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

        // stage('Code Analysis') {
        //     steps {
        //         // Run SonarQube analysis without quality gate check
        //         withSonarQubeEnv(credentialsId: 'SonarQube', installationName: "${SONAR_SERVER}") {
        //             sh """
        //                 ${SONAR_SCANNER_HOME}/bin/sonar-scanner \
        //                 -Dsonar.projectKey=${PROJECT_KEY} \
        //                 -Dsonar.projectName="${PROJECT_NAME}" \
        //                 -Dsonar.sources=. \
        //                 -Dsonar.cs.opencover.reportsPaths=**/coverage.opencover.xml \
        //                 -Dsonar.cs.vstest.reportsPaths=**/TestResults/*.trx
        //             """
        //         }
        //         // No quality gate check
        //     }
        // }

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
        always {
            echo 'Slack Notification'
            slackSend channel: '#cicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}"
            sh 'docker logout'
        }
    }
}