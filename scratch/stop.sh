#!/bin/bash

source ./scripts/k8_vars.sh

deployment=$(get_deployment_name $1)
[[ $? -eq 0 ]] && kubectl delete deployment $deployment -n todo-app || echo "$deployment"
