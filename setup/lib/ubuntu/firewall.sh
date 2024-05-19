#!/bin/bash -x

# This should get better over time

function generous() {
	sudo iptables --flush
	sudo iptables --delete-chain
	sudo iptables -P INPUT ACCEPT 
	sudo iptables -P OUTPUT ACCEPT
	sudo iptables -P FORWARD ACCEPT
}

function setup_firewall() {
	# Reset
	sudo iptables --flush
	sudo iptables --delete-chain

	# Local traffic
	sudo iptables -A INPUT -i lo -j ACCEPT
	sudo iptables -A OUTPUT -o lo -j ACCEPT

	# Established connections
	sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	# ssh
	sudo iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT

	# Defaults
	sudo iptables -P INPUT DROP
	sudo iptables -P OUTPUT ACCEPT
}

#setup_firewall
generous
