#!/bin/bash

source ./scripts/k8_vars.sh

function start_service() {
	kubectl apply -f ./k8s/$1.yaml -n todo-app
	kubectl apply -f ./k8s/services.yaml -n todo-app
}

start_service $1 || echo "$deployment"
