#!/usr/bin/bash

# DOCKER INSTALL
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh --dry-run
sudo sh get-docker.sh
# USE DOCKER WITHOUT SUDO
sudo groupadd docker
sudo usermod -aG docker vagrant
newgrp docker

# INSTALL KUBECTL
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# INSTALL MINIKUBE
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube