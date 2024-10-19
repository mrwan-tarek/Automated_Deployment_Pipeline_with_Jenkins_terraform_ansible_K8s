# Java Application CI/CD Pipeline

This project sets up a CI/CD pipeline for a Java application using **Jenkins**, **Docker**, **Terraform**, **Kubernetes**, and **AWS**. The pipeline automates building the Java application, creating a Docker image, pushing it to Docker Hub, and deploying it to a Kubernetes cluster on AWS.

## Technologies Used

- **Jenkins**: CI/CD automation server.
- **Docker**: Containerization of the Java application.
- **Terraform**: Infrastructure as Code (IaC) for provisioning AWS resources.
- **Kubernetes**: Orchestration and deployment of Docker containers.
- **AWS**: Cloud provider for managing infrastructure.

## Prerequisites

Before running the pipeline, ensure the following prerequisites are in place:

1. **Jenkins Server**:
   - Jenkins installed and running with necessary plugins (e.g., Docker, Terraform, AWS).
   - Jenkins agents configured to run Docker commands and Terraform scripts.
   
2. **AWS Account**:
   - Access credentials (AWS Access Key ID and Secret Access Key).
   - Terraform AWS provider setup with appropriate permissions to create resources (VPC, subnets, EC2 instances, etc.).

3. **Docker Hub Account**:
   - Docker Hub credentials stored in Jenkins as a credential (named `docker-hub`).

4. **Terraform**:
   - Terraform installed on Jenkins agents to provision infrastructure.

5. **Kubernetes Cluster**:
   - AWS EKS (Elastic Kubernetes Service) or a self-hosted Kubernetes cluster.
   - `kubectl` configured to access your cluster.

---

## Pipeline Overview

The pipeline has the following stages:

### 1. **Test Application**
   - The Java application is built and unit tests are run using Maven (`mvn test`).
   
### 2. **Build Jar**
   - The Maven `package` command builds a JAR file for the Java application.

### 3. **Build Docker Image**
   - The application is containerized into a Docker image using a `Dockerfile` located in the `./code` directory.
   
### 4. **Push Docker Image to Docker Hub**
   - The Docker image is pushed to Docker Hub under the specified repository name (`$USER/${params.IMAGE_NAME}`).

### 5. **Create `.tfvars` file**
   - Terraform variables (`region`, `profile`, `worker_count`, etc.) are written into a `terraform.tfvars` file used to configure infrastructure.

### 6. **Destroy Existing Infrastructure**
   - Before building new infrastructure, any existing AWS resources (VPC, subnet, instances) are destroyed using `terraform destroy`.

### 7. **Deploy Kubernetes Cluster**
   - The Kubernetes cluster is created using Terraform (`terraform apply`).
   - The Docker image is deployed to the Kubernetes cluster using the Kubernetes Deployment YAML file (`deploy/default-node-Deployment.yaml`).
   
---

## Jenkins Pipeline Parameters

These parameters can be specified in the Jenkins job configuration for your pipeline:

| Parameter Name          | Default Value     | Description                                                   |
|-------------------------|-------------------|---------------------------------------------------------------|
| `IMAGE_NAME`            | `trial_maven`     | The name of the Docker image to build and push.                |
| `region`                | `us-west-2`       | The AWS region where the resources will be provisioned.        |
| `profile`               | `default`         | The AWS profile to use for accessing the AWS account.          |
| `worker_count`          | `2`               | Number of worker nodes to create in the Kubernetes cluster.    |
| `cidr_vpc`              | `10.0.0.0/16`     | CIDR block for the VPC.                                       |
| `cidr_subnet`           | `10.0.1.0/24`     | CIDR block for the subnet in the VPC.                         |
| `instance_type`         | `t2.medium`       | Instance type for the EC2 nodes in the cluster.                |
| `public_key_path`       | `~/.ssh/id_rsa.pub` | Path to the public SSH key used for EC2 instances.            |
| `private_ssh_key`       | `~/.ssh/id_rsa`   | Path to the private SSH key for accessing EC2 instances.      |
| `key_pair_name`         | `cluster_key`     | Name of the SSH key pair to be created for EC2 instances.     |

---

## Setup Instructions

### 1. Clone the Repository

Clone the repository that contains the Java application and the pipeline.

```bash
git clone <your-repo-url>
cd <your-repo-directory>
