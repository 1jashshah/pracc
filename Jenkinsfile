pipeline {
    agent any

    environment {
        registry = 'docker.io'
        registryCredentials = 'dockerid'
        dockerImage = '1jashshah/pythonapp'
    }

    stages {
        stage("Checkout") {
            steps {
                git url: 'https://github.com/1jashshah/pracc.git', credentialsId: 'gitid', branch: 'main'
            }
        }

        stage("Docker Build") {
            steps {
                script {
                    sh 'docker build -t ${dockerImage} .'
                }
            }
        }

        stage("Push Docker Image") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: registryCredentials, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh 'docker push ${dockerImage}'
                    }
                }
            }
        }

        stage("Deploy Container") {
            steps {
                script {
                    // Stop the running container if any
                    sh '''
                        if [ "$(docker ps -q -f name=pythonapp)" ]; then
                            docker stop pythonapp
                            docker rm pythonapp
                        fi
                    '''
                    // Deploy the new container
                    sh 'docker run -d -p 8089:8080 --name pythonapp ${dockerImage}'
                }
            }
        }
    }

    post {
        always {
            // Clean up dangling images to save space
            sh 'docker image prune -f'
        }
    }
}
