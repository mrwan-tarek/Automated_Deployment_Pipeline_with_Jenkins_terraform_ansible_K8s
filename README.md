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
   - Jenkins installed and running .
   - Jenkins agents configured to run Docker commands and Terraform scripts.
   
2. **AWS Account**:
   - Access credentials (AWS Access Key ID and Secret Access Key).
   - Terraform AWS provider setup with appropriate permissions to create resources (VPC, subnets, EC2 instances, etc.).

3. **Docker Hub Account**:
   - Docker Hub credentials stored in Jenkins as a credential (named `docker-hub`).

4. **Terraform**:
   - Terraform installed on Jenkins agents to provision infrastructure.

5. **openJDK and maven**:
   - openJDK and maven installed on Jenkins agents to test and package the app .

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
   - The Ansible playbook is triggered as a local execute inside Terraform.
   - The Ansible playbook install Kubernetes prerequisites, install kubeadm, kubectl, kubelet and initiate cluster  
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

### 1. install Prerequisites

Make sure that all the Prerequisites mentioned before is installed, running and have permission to all of them.


### 2. Jenkins Configuration

#### Create Jenkins Pipeline:
- Set up a new **Pipeline** job in Jenkins.
- In the **Pipeline Script from SCM** section, paste this github repo.

#### Docker Hub Credentials:
- Add a Jenkins credential for Docker Hub:
  - Go to **Jenkins > Credentials > (Your Store)**.
  - Add a **Username and Password** credential with the ID `docker-hub` (as referenced in the Jenkinsfile).

#### Terraform and AWS Configuration:
- Ensure that your Terraform AWS provider is properly configured (AWS access credentials, profile name).
- Verify that your AWS account has permissions to create VPCs, subnets, EC2 instances, and EKS clusters.

---

### 3. Trigger the Pipeline

- Once your Jenkins job is configured, trigger the pipeline manually or automatically based on source code changes.
- The pipeline will build the Java application, create a Docker image, push it to Docker Hub, provision AWS infrastructure using Terraform, and deploy the application to Kubernetes.

---

### Kubernetes Deployment

#### Kubernetes YAML File:
- The `default-node-Deployment.yaml` file is used to configure the Kubernetes deployment.
- The image that is deployed to Kubernetes will be automatically replaced with the image pushed to Docker Hub.

---

### Additional Notes

- **Error Handling**: The pipeline currently runs `terraform destroy --auto-approve` to clean up old infrastructure before provisioning new resources. Ensure that this behavior aligns with your use case, as it will destroy all resources.

- **Scaling**: Adjust the `worker_count` parameter to scale the number of worker nodes in your Kubernetes cluster.

- **Customization**: You can modify the Jenkinsfile to include additional stages (e.g., integration tests, security scans, etc.) or further customize the deployment process.



