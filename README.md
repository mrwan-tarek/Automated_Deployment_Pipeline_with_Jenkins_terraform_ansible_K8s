# **DevOps Pipeline for Java Application Deployment**

## **Overview**
This repository contains a DevOps pipeline that builds and deploys a Java application using Jenkins, Docker, Kubernetes (K8s), Terraform, and Ansible. The pipeline automates the following tasks:

- **Build**: Compiles the Java application and creates a Docker image.
- **Push**: Pushes the Docker image to Docker Hub.
- **Infrastructure**: Uses Terraform to provision and manage AWS infrastructure (VPC, subnets, EC2 instances).
- **Deployment**: Deploys the Dockerized application to a Kubernetes cluster.

This pipeline leverages Jenkins to automate the entire process, triggered by code commits.

## **Technologies Used**
- **Jenkins**: Continuous Integration/Continuous Deployment (CI/CD) tool.
- **Docker**: Containerizes the Java application.
- **Kubernetes**: Manages the deployment and scaling of Docker containers.
- **Terraform**: Infrastructure provisioning and management.
- **Ansible** (if needed, optional): Configuration management for deployment.
- **AWS** (or another cloud provider): Cloud infrastructure where the app is deployed.

## **Requirements**

Before running the pipeline, make sure you have the following installed and configured:

1. **Jenkins**: A Jenkins server (can be local or cloud-based).
   - **Jenkins Plugins**: Ensure the following Jenkin
