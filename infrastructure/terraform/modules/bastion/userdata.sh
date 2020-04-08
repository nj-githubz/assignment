#!/bin/sh
set -e
sudo apt-get update
#install aws cli
sudo apt-get install awscli -y
sudo apt-get install unzip -y
sudo apt install python3-pip -y
pip3 install --upgrade awscli

#install terraform
#curl -O https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip && unzip terraform_0.12.3_linux_amd64.zip -d /usr/bin/

#install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && sudo chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl

#install aws-iam-authenticator
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && sudo chmod +x ./aws-iam-authenticator && sudo mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

#install helm
curl -O https://get.helm.sh/helm-v3.0.0-rc.4-linux-amd64.tar.gz && sudo tar -xzvf helm-v3.0.0-rc.4-linux-amd64.tar.gz && sudo mv linux-amd64/helm /usr/local/bin/helm

sudo apt install default-jre -y
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo groupadd docker
sudo usermod -aG docker ubuntu

sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo chown root:docker /var/run/docker.sock

sudo systemctl restart jenkins
