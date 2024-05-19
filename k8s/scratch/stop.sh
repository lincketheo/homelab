#!/bin/bash

namespace=homelab
source ./scripts/k8_vars.sh

deployment=$(get_deployment_name $1)
[[ $? -eq 0 ]] && kubectl delete deployment $deployment -n $namespace || echo "$deployment"
