# Node.js Application Deployment on AWS EKS

## 🎯 Overview

This project provisions and deploys a production-grade CI/CD pipeline on AWS using:

- **Terraform** for infrastructure
- **Jenkins** for CI
- **ArgoCD + Argo Image Updater** for CD (GitOps)
- **Helm** for K8s resource management
- **Node.js**, **MySQL**, and **Redis** deployed in EKS

## 🌐 Architecture Diagram
![Architecture Diagram](architecture-diagram.png)

## 📁 Project Structure
<include directory tree> ```
🚀 Prerequisites
AWS CLI configured

Docker

Terraform

kubectl

Helm v3

🔧 Setup Instructions
1. Clone the Repository
bash
Copy
Edit
> git clone https://github.com/ITI-2025/nodejs-app-config

> cd nodejs-app-config

2. Configure AWS & Terraform Variables
3. Provision Infrastructure
> cd terraform

> terraform init

> terraform apply
4. Deploy Jenkins and ArgoCD

#### Use Helm to install Jenkins and ArgoCD into EKS
5. Trigger Pipeline via GitHub Push

Jenkins builds Docker image and pushes to ECR.

ArgoCD syncs manifests and deploys Node.js, MySQL, Redis.

Argo Image Updater monitors and updates image tags.

🌐 Application Stack
Node.js App (GitHub Repo)

MySQL and Redis pods

📹 YouTube Demo
▶️ Watch the Demo

markdown
Copy
Edit

---

### 🎬 YouTube Video Guide

**Title**: *Deploy Node.js App with CI/CD on AWS EKS using Terraform, Jenkins & ArgoCD*

**Sections to Cover**:
1. **Intro** – What this project is and what tools are used
2. **Architecture Overview** – Use the diagram
3. **Infrastructure Setup** – Terraform apply walkthrough
4. **CI/CD Pipeline** – Show Jenkins & ArgoCD in action
5. **App Deployment** – Show the running app with Ingress + HTTPS
6. **Conclusion** – GitHub repo, link in description

