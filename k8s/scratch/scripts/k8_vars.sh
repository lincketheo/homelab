#!/bin/bash

function validate_app_arg() {
	valid_values=("todo" "authentication" "frontend" "user")

	if [ -z "$1" ]; then
		echo "Please provide an app name. Must be either ${valid_values[@]}"
		exit 1
	fi
	
	if [[ ! "${valid_values[@]}" =~ "$1" ]]; then
		echo "Invalid argument: $1. Must be either ${valid_values[@]}"
		exit 1
	fi
}

function get_pod_name() {
	validate_app_arg $1
	echo $(kubectl get pods -n $namespace -l app=$1 -o jsonpath="{.items[0].metadata.name}")
}

function get_deployment_name() {
	validate_app_arg $1
	echo $(kubectl get deployments -n $namespace -l app=$1 -o jsonpath="{.items[0].metadata.name}")
}

