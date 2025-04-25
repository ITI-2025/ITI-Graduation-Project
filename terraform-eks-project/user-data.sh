#!/bin/bash

yum update -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version



curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-03-06/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version


helm repo add jenkins https://charts.jenkins.io
helm repo54.242.227.216/32 update
kubectl create namespace jenkins || echo "Namespace already exists"
helm install jenkins jenkins/jenkins -n jenkins




# echo "Fetching Jenkins Admin Password:"
# kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
# echo
# ##############
# ssh -i /path/to/your-key.pem -L 8080:localhost:8080 ec2-user@<Bastion-Public-IP>
# kubectl port-forward svc/jenkins -n jenkins 8080:8080
# kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode 





# ##############

# on downloads 
#  ssh -i basion-key-2.pem ec2-user@<Bastion-Public-IP>
# try to get private ip 
# 
# try to get info about cluster using 
# aws eks describe-cluster --name my-eks-cluster --region us-east-1 

# edit cluster security group to the private ip of the bastion
#  try to curl the cluster endpoint
#  curl -k https://<cluster-endpoint> --insecure
#  to update configmap after eatch ta3del 
######### 






# # on your local machine
# ssh -i /path/to/key.pem -L 8080:localhost:8080 ec2-user@<Bastion-IP>


# #on basion  
# kubectl port-forward svc/jenkins -n jenkins 8080:8080
# kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode

# echo "Fetching Jenkins Admin Password:"
# kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
# echo
# ##############
# ssh -i /path/to/your-key.pem -L 8080:localhost:8080 ec2-user@<Bastion-Public-IP>
# kubectl port-forward svc/jenkins -n jenkins 8080:8080
# kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode 
