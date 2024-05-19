# Install Useful stuff (optional?)

function install_useful_deps() {
	if ! command -v nvim &> /dev/null
	then
		echo "Installing useful tools"
		read -p "Press Enter to continue" </dev/tty

		sudo apt install neovim
		sudo apt install tmux
		sudo apt install make
	fi
}

function install_docker() {
	if ! command -v docker &> /dev/null
	then
		echo "Installing docker"
		read -p "Press Enter to continue" </dev/tty

		# Install Docker
		for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
		sudo apt-get update
		sudo apt-get install ca-certificates curl
		sudo install -m 0755 -d /etc/apt/keyrings
		sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
		sudo chmod a+r /etc/apt/keyrings/docker.asc
		echo \
		  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
		  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
		  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
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
		read -p "Press Enter to continue" </dev/tty

		pushd ~
		curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
		sudo install kubectl /usr/local/bin/kubectl && rm kubectl
		popd
	fi
}


# Install minikube
function install_minikubue() {
	if ! command -v minikube &> /dev/null
	then
		echo "Installing minikube"
		read -p "Press Enter to continue" </dev/tty

		pushd ~
		curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
		sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

		cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF

		sudo systemctl daemon-reload
		minkube start --driver=docker --continer-runtime=containerd	
		popd
	fi
}

# Set up ssh keys and clone repos - one time operation
function setup_ssh() {
	if [ ! -d ~/.ssh ]; then
		echo "Setting up ssh and installing git packages"
		read -p "Press Enter to continue" </dev/tty

		# Set up git
		git config --global user.email tjl@rincon.com
		git config --global user.name "Theo Lincke"
		ssh-keygen

		echo "Copy and paste the following key to gitlab:"
		echo "==================="
		cat ~/.ssh/id_rsa.pub
		echo "==================="
		read -p "Press Enter to continue" </dev/tty
	fi
}

function clone_dev_repos() {
	if [ ! -d ~/authentication ]; then
		echo "Cloning repos"
		read -p "Press Enter to continue" </dev/tty

		pushd ~
		git clone git@gitlab.rinconres.com:service-mesh-rd/mock-microservice/authentication.git
		git clone git@gitlab.rinconres.com:service-mesh-rd/mock-microservice/frontend.git
		git clone git@gitlab.rinconres.com:service-mesh-rd/mock-microservice/todo.git
		git clone git@gitlab.rinconres.com:service-mesh-rd/mock-microservice/user.git
		popd
	fi
}

# Install istio
function install_istio() {
	if ! command -v istioctl &> /dev/null
	then
		echo "Installing ISTIO"
		read -p "Press Enter to continue" </dev/tty

		pushd ~
		curl -L https://istio.io/downloadIstio | sh -
		pushd $(ls -d * | grep istio | head -n 1)
		export PATH=$PWD/bin:$PATH
		echo "export PATH=$PATH" >> ~/.bashrc
		istioctl install --set profile=demo -y
		kubectl label namespace default istio-injection=enabled
		popd
		popd
	fi
}

# Install NVM
function install_node_stuff() {
	if ! command -v npm &> /dev/null
	then
		echo "Installing node through nvm"
		read -p "Press Enter to continue" </dev/tty
		
		pushd ~
		# Install nvm
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

		# Install node
		nvm install node
		popd
	fi
}

function install_minimum() {
	install_docker
	install_kubectl
	install_minikubue
	install_istio
}

function install_dev_deps() {
	install_minimum
	install_useful_deps
	install_node_stuff
	clone_dev_repos
	setup_ssh
}
