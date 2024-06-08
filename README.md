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

```sh
minikube start
Install Helm
Follow the instructions on the official Helm installation guide to install Helm on your machine.

Initialize Helm:

sh

helm repo add frappe https://helm.erpnext.com
helm repo update
Step 2: Building and Pushing the Docker Image
Clone the Repository
Clone your Frappe/ERPNext repository:

sh

git clone https://github.com/your-username/your-repo.git
cd your-repo
Build the Docker Image
Build your custom Docker image:

sh

docker build -t your-docker-registry/your-custom-image:latest .
Push the Docker Image
Push the Docker image to your registry:

sh

docker push your-docker-registry/your-custom-image:latest
Step 3: Modifying the Helm Chart
Clone the Helm Chart Repository
Clone the Frappe Helm chart repository and navigate to the chart directory:

sh

git clone https://github.com/frappe/helm.git
cd helm
Update the values.yaml File
Edit the values.yaml file to use your custom Docker image:

yaml

images:
  frappe:
    repository: your-docker-registry/your-custom-image
    tag: latest
If you need to pull from a private Docker registry, create a Kubernetes secret for your Docker registry credentials:

sh

kubectl create secret docker-registry myregistrykey \
  --docker-server=DOCKER_REGISTRY_SERVER \
  --docker-username=DOCKER_USER \
  --docker-password=DOCKER_PASSWORD \
  --docker-email=DOCKER_EMAIL
Reference this secret in the values.yaml:

y

imagePullSecrets:
  - name: myregistrykey
Step 4: Deploying the Application
Install the Helm Chart
Navigate to the helm directory and install the Helm chart:

sh

helm install your-release-name ./charts/frappe -f ./charts/frappe/values.yaml
Step 5: Verifying the Deployment
Check the Status of Your Deployment
Use kubectl to check the status of your deployment:

sh

kubectl get pods
kubectl get services
Access the Application
To access the application, use the Minikube service command to get the URL:

sh

minikube service your-release-name-frappe
This command will open the Frappe application in your default web browser.

Additional Configuration
You can customize the deployment further by modifying other values in the values.yaml file, such as configuring persistent storage, ingress settings, and environment variables.

Example values.yaml File
Here is an example of a customized values.yaml:

yaml

images:
  frappe:
    repository: your-docker-registry/your-custom-image
    tag: latest

mariadb:
  enabled: true
  rootUser:
    password: root_password

redis:
  enabled: true

ingress:
  enabled: false
  annotations: {}
  hosts:
    - host: chart-example.local
      paths: []

persistence:
  enabled: true
  storageClass: ""
  accessMode: ReadWriteOnce
  size: 8Gi

frappe:
  replicas: 1
  sites:
    - name: site1.local
      dbRootPassword: root
      adminPassword: admin
      installApps: erpnext

imagePullSecrets:
  - name: myregistrykey
Conclusion
By following these steps, you should have your custom Frappe/ERPNext application deployed to a local Kubernetes cluster using Helm.

arduino


This README file provides comprehensive instructions for setting up the environment, building and pushing the Docker image, modifying the Helm chart, deploying the application, and verifying the deployment. Adjust the repository names, Docker image paths, and other specifics as necessary for your particular setup.




