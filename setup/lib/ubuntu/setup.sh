#!/bin/bash -x

source lib/ubuntu/packages.sh
source lib/ubuntu/firewall.sh
source lib/ubuntu/ssh_setup.sh
sudo apt update
sudo apt upgrade
