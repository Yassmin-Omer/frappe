# frappe
markdown

# Frappe/ERPNext Kubernetes Deployment

## Overview

This guide provides step-by-step instructions for setting up the environment, building and pushing the Docker image, modifying the Helm chart, deploying the application, and verifying the deployment.

## Prerequisites

1. Docker
2. Minikube (or any other local Kubernetes cluster such as Kind)
3. Helm
4. Git

## Step 1: Setting Up the Environment

### Install Docker

Follow the instructions on the [official Docker installation guide](https://docs.docker.com/get-docker/) to install Docker on your machine.

### Install Minikube

Follow the instructions on the [official Minikube installation guide](https://minikube.sigs.k8s.io/docs/start/) to install Minikube on your machine.

Start Minikube:

minikube start
### Install Helm
Follow the instructions on the official Helm installation guide to install Helm on your machine.

Initialize Helm:



helm repo add frappe https://helm.erpnext.com
helm repo update
## Step 2: Building and Pushing the Docker Image
Clone the Repository
Clone your Frappe/ERPNext repository:



git clone https://github.com/your-username/your-repo.git
cd your-repo
### Build the Docker Image



docker-compse  build -t yassmin970/frappe:latest .
Push the Docker Image
Push the Docker image to your registry:
docker push yassmin970/frappe:latest
## Step 3: Modifying the Helm Chart
Clone the Helm Chart Repository
Clone the Frappe Helm chart repository and navigate to the chart directory:


git clone https://github.com/frappe/helm.git
cd helm
Update the values.yaml File
Edit the values.yaml file to use your custom Docker image

yaml

images:
  frappe:
    repository: yassmin970/frappe
    tag: latest


## Step 4: Deploying the Application
Install the Helm Chart
Navigate to the helm directory and install the Helm chart:



helm install frappe ./charts/frappe -f ./charts/frappe/values.yaml
## Step 5: Verifying the Deployment
Check the Status of Your Deployment
Use kubectl to check the status of your deployment:


kubectl get pods
kubectl get services
Access the Application
To access the application, use the Minikube service command to get the URL:


minikube service frappe
This command will open the Frappe application in your default web browser.





