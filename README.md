DevOps Pipeline for Java Application Deployment
Overview

This repository contains a DevOps pipeline that builds and deploys a Java application using Jenkins, Docker, Kubernetes (K8s), Terraform, and Ansible. The pipeline automates the following tasks:

    Build: Compiles the Java application and creates a Docker image.
    Push: Pushes the Docker image to Docker Hub.
    Infrastructure: Uses Terraform to provision and manage AWS infrastructure (VPC, subnets, EC2 instances).
    Deployment: Deploys the Dockerized application to a Kubernetes cluster.

This pipeline leverages Jenkins to automate the entire process, triggered by code commits.
Technologies Used

    Jenkins: Continuous Integration/Continuous Deployment (CI/CD) tool.
    Docker: Containerizes the Java application.
    Kubernetes: Manages the deployment and scaling of Docker containers.
    Terraform: Infrastructure provisioning and management.
    Ansible (if needed, optional): Configuration management for deployment.
    AWS (or another cloud provider): Cloud infrastructure where the app is deployed.

Requirements

Before running the pipeline, make sure you have the following installed and configured:

    Jenkins: A Jenkins server (can be local or cloud-based).
        Jenkins Plugins: Ensure the following Jenkins plugins are installed:
            Docker Pipeline Plugin
            AWS CodePipeline Plugin (if using AWS)
            Terraform Plugin (optional)
            Kubernetes CLI Plugin (optional)

    Docker: Docker should be installed on the Jenkins agent, as it will be used to build and push images.

    AWS CLI: AWS CLI should be installed and configured on the Jenkins agents with the required permissions for creating resources.

    Terraform: Ensure Terraform is installed and accessible on the Jenkins agent.

    Kubernetes Cluster: You will need a running Kubernetes cluster to deploy the application. You can use a managed K8s service like EKS, GKE, or AKS, or manage your own.

    Credentials:
        Docker Hub credentials (docker-hub) stored in Jenkins' credentials manager.
        AWS access key/secret key with sufficient permissions to create and destroy infrastructure.
        SSH keys for the VPC (e.g., key pair for EC2 instances).

Pipeline Configuration

The pipeline has several parameters you can configure when triggering the build. You can customize these in Jenkins when running the job:

    IMAGE_NAME: Name of the Docker image to build and push (e.g., my-java-app).
    region: AWS region for infrastructure provisioning (e.g., us-west-2).
    profile: AWS profile for authentication (e.g., default).
    worker_count: Number of worker nodes to provision in the Kubernetes cluster.
    cidr_vpc: VPC CIDR block (e.g., 10.0.0.0/16).
    cidr_subnet: Subnet CIDR block (e.g., 10.0.1.0/24).
    instance_type: Instance type for EC2 instances (e.g., t2.medium).
    public_key_path: Path to the public SSH key for EC2 instances.
    private_ssh_key: Path to the private SSH key for connecting to the instances.
    key_pair_name: Key pair name for the EC2 instances.

Pipeline Stages

The Jenkins pipeline is divided into several stages:

    Test App: Runs unit tests for the Java application using Maven.

    Build Jar: Compiles the Java application into a JAR file using Maven.

    Build Docker Image: Builds the Docker image for the application.

    Push Docker Image to Docker Hub: Pushes the Docker image to Docker Hub for use in Kubernetes.

    Create Terraform Variables: Creates a terraform.tfvars file for the infrastructure provisioning with the provided parameters.

    Destroy Previous Infrastructure: Destroys any existing infrastructure before applying the new configuration. This ensures clean deployments.

    Deploy to Kubernetes: Uses Terraform to provision the infrastructure and deploys the Docker image to the Kubernetes cluster.

Setup Instructions
Step 1: Jenkins Configuration

    Create a New Pipeline Job:
        Open Jenkins and create a new pipeline job.
        Link this job to the repository where the Jenkinsfile is located.

    Configure Pipeline Parameters:
        Add the pipeline parameters (IMAGE_NAME, region, profile, etc.) as needed. These parameters can be customized when triggering the job.

    Add Docker Hub Credentials:
        Go to Jenkins > Manage Jenkins > Manage Credentials.
        Add your Docker Hub credentials (docker-hub), including the username and password.

    Configure AWS Credentials:
        Store your AWS credentials (AWS Access Key ID and Secret Access Key) in Jenkins credentials as aws-credentials.

    Configure SSH Keys:
        Make sure the SSH key pair used for EC2 instances is properly configured and available on the Jenkins agent.

Step 2: AWS Infrastructure

Ensure your AWS environment is ready. Terraform will provision the following:

    VPC with CIDR block.
    Subnets.
    EC2 instances for the worker nodes.
    Any other AWS resources required for the deployment.

Step 3: Kubernetes Cluster Setup

If you're using an existing Kubernetes cluster (EKS, GKE, AKS):

    Ensure the cluster is accessible from the Jenkins agent (use kubectl to verify connectivity).

If you need Terraform to provision the K8s cluster:

    Make sure the necessary Terraform configurations for the cluster are in place.

Step 4: Running the Pipeline

    Trigger the pipeline job from Jenkins.
    Fill out the necessary parameters when starting the job.
    The pipeline will run through each stage automatically.
    Once the job finishes, the application should be deployed to your Kubernetes cluster.

Troubleshooting

    Docker Image Push Failure:
        Ensure the Docker Hub credentials are correct.
        Verify the image name is valid and properly formatted.

    Terraform Errors:
        Check Terraform logs to ensure your AWS credentials have the necessary permissions.
        Verify that your AWS region and other parameters are correctly set.

    Kubernetes Deployment Issues:
        Check the K8s logs (kubectl logs <pod-name>) for any issues with the deployed pods.
        Ensure the image exists in Docker Hub and the Kubernetes configuration is correct.

Additional Notes

    Infrastructure Cleanup: This pipeline automatically destroys the infrastructure before re-deploying to ensure a clean environment. You may want to adjust this behavior for production deployments.
    Monitoring and Alerts: You can integrate monitoring tools like Prometheus and Grafana for real-time performance metrics and alerts.