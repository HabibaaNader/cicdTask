pipeline {
    agent any

    // This tells Jenkins to use the Docker tool you named 'default' in Global Tool Configuration
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
            // This manually adds the Docker tool path to the environment for this step
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
                    // This matches the Credential ID you created in Jenkins
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        sh "docker push ${FULL_IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Added a 'rm' command to delete the old container before starting a new one
                    // This prevents the "name already in use" error on build #3, #4, etc.
                    sh "docker rm -f ${IMAGE_NAME} || true"
                    sh "docker run -d --name ${IMAGE_NAME} -p 8081:80 ${FULL_IMAGE_NAME}:latest"
                }
            }
        }
    }
}
