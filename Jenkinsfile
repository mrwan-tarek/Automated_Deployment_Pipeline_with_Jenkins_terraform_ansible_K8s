
pipeline {
    agent any
    parameters {
            string(name: 'IMAGE_NAME', defaultValue: '${params.IMAGE_NAME}', description: 'The name of the Docker image to build and push')
            string(name: 'PORT_MAPPING', defaultValue: '8090', description: 'Port mapping for the container (e.g., xxxx:8080)')
        }


    stages {
        stage(' Test App ') {
            steps {
                script {
                   echo " testing the application ...."
                    sh 'mvn test'
                }
            }
        }
        stage(' Build Jar ') {
            steps {
                script {
                    echo 'building the application ....'
                    sh 'mvn package'
                }
            }
        }
        stage(' Build Docker Image ') {
            steps {
                script {
                    echo 'building the docker image...'
                    sh "docker build -t ${params.IMAGE_NAME}."
                    
                }
            }
        }
        stage(' Push Docker Image to Docker Hub ') {
            steps {
                script {
                    echo 'pushing the image to docker hub...'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh "echo $PASS | docker login -u $USER --password-stdin "
                        sh "docker tag ${params.IMAGE_NAME} $USER/${params.IMAGE_NAME}"
                        sh "docker push $USER/${params.IMAGE_NAME}"
                    }
                    
                }
            }
        }
        stage(' Deploy the application on a container ') {
            steps {
                script {
                    echo ' deploying the application ....'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh " docker run -d -p ${params.PORT_MAPPING}:8080 $USER/${params.IMAGE_NAME} "                        
                    }
                }
            }
        }
    }   
}
