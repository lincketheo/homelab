#!/bin/bash

source ./scripts/k8_vars.sh
namespace=homelab

function start_service() {
	kubectl apply -f ./k8s/$1.yaml -n $homelab
	kubectl apply -f ./k8s/services.yaml -n $homelab
}

start_service $1 || echo "$deployment"
