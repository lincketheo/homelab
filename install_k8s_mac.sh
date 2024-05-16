#!/bin/bash

source ./bash/lib.sh

function install_minikube() {
  guard_root
  continue_wait "Installing Minikube"

  echo "Installing minikube"
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-arm64
  install minikube-darwin-arm64 /usr/local/bin/minikube
  rm minikube-darwin-arm64
}

function install_k8s() {
  guard_root
  continue_wait "Installing K8s"

  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl.sha256"

  echo "$(cat kubectl.sha256)  kubectl" | shasum -a 256 --check

  continue_wait "Validate K8s install"

  chmod +x ./kubectl
  mv ./kubectl /usr/local/bin/kubectl
  chown root: /usr/local/bin/kubectl

  kubectl version --client --output=yaml
  rm kubectl.sha256
}

install_minikube
install_k8s


