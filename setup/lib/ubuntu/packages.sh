#!/bin/bash -x

function install_packages() {
	# Packages
	apt install tmux
	apt install neovim
	apt install iputils-ping
	apt install git
	apt install openssh-server
	apt install iptables
}

function install_docker() {
	if ! command -v docker &> /dev/null
	then
		echo "Installing docker"

		# Install Docker
		for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
		sudo apt-get update
		sudo apt-get install ca-certificates curl
		sudo install -m 0755 -d /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
		chmod a+r /etc/apt/keyrings/docker.asc
		echo \
		  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
		  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
		  tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo apt-get update
		sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

		# Set up rootless
		sudo apt-get install -y uidmap
		sudo systemctl disable --now docker.service docker.socket
		dockerd-rootless-setuptool.sh install -f
		# Do something with user start docker service
	fi
}

# Install kubectl
function install_kubectl() {
	if ! command -v kubectl &> /dev/null
	then
		echo "Installing kubectl"

		pushd ~
		curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
		sudo install kubectl /usr/local/bin/kubectl && rm kubectl
		popd
	fi
}


# Install minikube
function install_minikube() {
	if ! command -v minikube &> /dev/null
	then
		echo "Installing minikube"
		read -p "Press Enter to continue" </dev/tty

		pushd ~
		curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
		sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
		sudo systemctl daemon-reload
		minkube start --driver=docker --continer-runtime=containerd	
		popd
	fi
}


sudo install_packages
install_docker
install_kubectl
install_minikube
