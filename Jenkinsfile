pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'habibanader' 
        IMAGE_NAME      = 'jenkins-website'
        FULL_IMAGE_NAME = "${DOCKER_HUB_USER}/${IMAGE_NAME}"
    }

    stages {
        stage('Build Image') {
            steps {
                // Now that docker is installed, this simple command will work
                sh "docker build -t ${FULL_IMAGE_NAME}:latest ."
            }
        }

        stage('Push image') {
            steps {
                script {
                    // This uses your Docker Hub credentials you saved in Jenkins
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        sh "docker push ${FULL_IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                // This removes the old container so the new one can start without a name conflict
                sh "docker rm -f ${IMAGE_NAME} || true"
                sh "docker run -d --name ${IMAGE_NAME} -p 8081:80 ${FULL_IMAGE_NAME}:latest"
            }
        }
    }
}
