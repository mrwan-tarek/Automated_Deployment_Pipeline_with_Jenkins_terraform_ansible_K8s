
pipeline {
    agent any
    parameters {
            string(name: 'IMAGE_NAME', defaultValue: 'trial_maven', description: 'The name of the Docker image to build and push')
            string(name: 'PORT_MAPPING', defaultValue: '8090', description: 'Port mapping for the container (e.g., xxxx:8080)')
            
            string(name: 'region', defaultValue: 'us-west-2')
            string(name: 'profile', defaultValue: 'default' )
            string(name: 'worker_count', defaultValue: '2' )
            string(name: 'cidr_vpc', defaultValue: '10.0.0.0/16' )
            string(name: 'cidr_subnet', defaultValue: '10.0.1.0/24' )
            string(name: 'instance_type', defaultValue: 't2.medium' )            
            string(name: 'public_key_path', defaultValue: '/home/mrwan/.ssh/id_rsa.pub' )
            string(name: 'private_ssh_key', defaultValue: '/home/mrwan/.ssh/id_rsa' )
            string(name: 'key_pair_name', defaultValue: 'cluster_key' )


        }


    stages {
        stage(' Test App ') {
            steps {
                script {
                   echo " testing the application ...."
                    sh """
                    cd ./code
                    mvn test
                    """
                }
            }
        }
        stage(' Build Jar ') {
            steps {
                script {
                    echo 'building the application ....'
                    sh """
                    cd ./code
                    mvn package
                    """
                }
            }
        }
        stage(' Build Docker Image ') {
            steps {
                script {
                    echo 'building the docker image...'
                    sh "docker build -t ${params.IMAGE_NAME} ./code"
                    
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
    
        stage(' creating .tfvars file ') {
            steps {
                script {
                    sh "echo \"region = \\\"\${region}\\\" \"  > ./deploy/terraform-project/terraform.tfvars "
                    sh "echo \"profile = \\\"\${profile}\\\" \"  >> ./deploy/terraform-project/terraform.tfvars "
                    sh "echo \"worker_count = \\\"\${worker_count}\\\" \"  >> ./deploy/terraform-project/terraform.tfvars "
                    sh "echo \"cidr_vpc = \\\"\${cidr_vpc}\\\" \"  >> ./deploy/terraform-project/terraform.tfvars "
                    sh "echo \"vpc_CIDR = \\\"\${vpc_CIDR}\\\" \"  >> ./deploy/terraform-project/terraform.tfvars "
                    sh "echo \"cidr_subnet = \\\"\${cidr_subnet}\\\" \"  >> ./deploy/terraform-project/terraform.tfvars "
                    sh "echo \"instance_type = \\\"\${instance_type}\\\" \"  >> ./deploy/terraform-project/terraform.tfvars "
                    sh "echo \"public_key_path = \\\"\${public_key_path}\\\" \"  >> ./deploy/terraform-project/terraform.tfvars "
                    sh "echo \"private_ssh_key = \\\"\${private_ssh_key}\\\" \"  >> ./deploy/terraform-project/terraform.tfvars "
                    sh "echo \"key_pair_name = \\\"\${key_pair_name}\\\" \"  >> ./deploy/terraform-project/terraform.tfvars "
                }
            }
        }

        stage(' Deploy k8s cluster ') {
            steps {
                script {
                    echo 'deploying the application ....'
                    sh """
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /tmp/docker.gpg
                    cd ./deploy/terraform-project/
                    terraform init
                    terraform apply --auto-approve 
                    """
                }
            }
        }
    }   
}
