pipeline {
    agent any

    // 1. Tell Jenkins to use the Docker tool you configured in 'Tools'
    tools {
        dockerTool 'default'
    }

    environment {
        DOCKER_HUB_USER = 'habibanader' 
        IMAGE_NAME      = 'jenkins-website'
        FULL_IMAGE_NAME = "${DOCKER_HUB_USER}/${IMAGE_NAME}"
    }

    stages {
        stage('Build Image') {
            steps {
                script {
                    // 2. Force the PATH so 'docker' is definitely found
                    def dockerHome = tool 'default'
                    withEnv(["PATH+DOCKER=${dockerHome}/bin"]) {
                        sh "docker build -t ${FULL_IMAGE_NAME}:latest ."
                    }
                }
            }
        }

        stage('Push image') {
            steps {
                script {
                    // Uses the Credential ID you created
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        def dockerHome = tool 'default'
                        withEnv(["PATH+DOCKER=${dockerHome}/bin"]) {
                            sh "docker push ${FULL_IMAGE_NAME}:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // 3. Remove existing container if it exists to avoid 'Name in use' errors
                    sh "docker rm -f ${IMAGE_NAME} || true"
                    sh "docker run -d --name ${IMAGE_NAME} -p 8081:80 ${FULL_IMAGE_NAME}:latest"
                }
            }
        }
    }
}
