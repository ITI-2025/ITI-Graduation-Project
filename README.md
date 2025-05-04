# 🚀 Node.js Application Deployment on AWS EKS (CI/CD with Terraform, Jenkins, ArgoCD)

This project provisions and deploys a secure, production-grade CI/CD pipeline on AWS for a Node.js application using the following tools:

- 🛠 **Terraform** for infrastructure provisioning  
- ⚙️ **Jenkins** for Continuous Integration (CI)  
- 🔄 **ArgoCD + Argo Image Updater** for Continuous Deployment (CD)  
- 📦 **Helm** for Kubernetes resource management  
- 🌐 **Node.js App** deployed with **MySQL** and **Redis**  
- 🔒 **Cert-Manager + NGINX Ingress** for HTTPS

---

## 🌐 Architecture Diagram

> ![Architecture](architecture-diagram.png)  
> *(You can add your diagram here)*

---

## 📁 Project Structure

nodejs-eks-devops-pipeline/
│
├── terraform/ # Modular Terraform code for VPC, EKS, IAM
│ ├── vpc/
│ ├── eks/
│ ├── iam/
│ └── variables.tf
│
├── jenkins/ # Jenkins pipeline and Helm values
│ ├── Jenkinsfile
│ └── helm-values.yaml
│
├── argocd/ # ArgoCD & Argo Image Updater manifests
│ ├── applications.yaml
│ └── image-updater-config.yaml
│
├── manifests/ # Kubernetes Helm/Kustomize manifests
│ ├── nodejs/
│ ├── mysql/
│ ├── redis/
│ └── ingress/
│
├── Dockerfile # Docker image for Node.js app
├── README.md # This documentation
└── architecture-diagram.png # System architecture image

yaml
Copy
Edit

---

## 🧰 Prerequisites

Ensure you have the following tools installed and configured:

- ✅ AWS CLI (configured with admin access)
- ✅ Docker
- ✅ Terraform
- ✅ `kubectl`
- ✅ Helm v3

---

## 🚀 Setup Instructions

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/nodejs-eks-devops-pipeline.git
cd nodejs-eks-devops-pipeline
2️⃣ Configure AWS & Terraform Variables
Update the terraform/variables.tf and terraform.tfvars as needed (AWS region, VPC CIDRs, etc.).

3️⃣ Provision Infrastructure
bash
Copy
Edit
cd terraform
terraform init
terraform apply
This will:

Create a VPC (3 AZs, public/private subnets)

Set up EKS cluster and private node groups

Configure NAT Gateway, Internet Gateway, and route tables

Create required IAM roles and policies

⚙️ CI/CD Pipeline
CI with Jenkins
Jenkins installed via Helm in the EKS cluster

Triggered on push to GitHub

Jenkinsfile steps:

Clone Node.js app repository

Build and tag Docker image

Push image to Amazon ECR

CD with ArgoCD + Argo Image Updater
ArgoCD syncs K8s manifests from GitHub

Argo Image Updater watches ECR and updates image tags

Triggers Git commit → ArgoCD syncs → App updated (GitOps flow)

🌐 Application Stack
Component	Description
Node.js	Web app (from this repo)
MySQL	Pod with persistent storage
Redis	Pod for caching
NGINX	Ingress controller
CertMgr	TLS via DNS (Let's Encrypt)

All configurations externalized using environment variables managed securely in Kubernetes.

🌐 Ingress and HTTPS
NGINX Ingress Controller is installed via Helm.

Cert-Manager configured for automatic Let's Encrypt TLS.

The app is accessible via a secure HTTPS endpoint.

🎥 YouTube Demo
▶️ Watch the Full Demo Here
