#!/bin/bash -x

# Set up ssh keys and clone repos - one time operation
function setup_ssh() {
	if [ ! -z ~/.ssh/id_rsa.pub ]; then
		echo "Setting up ssh and installing git packages"
		read -p "Press Enter to continue" </dev/tty

		# Set up git
		git config --global user.email lincketheo@gmail.com
		git config --global user.name "Theo Lincke"
		ssh-keygen

		echo "Copy and paste the following key to github"
		echo "==================="
		cat ~/.ssh/id_rsa.pub
		echo "==================="
		read -p "Press Enter to continue" </dev/tty
	fi

	sudo systemctl enable ssh
}

setup_ssh
