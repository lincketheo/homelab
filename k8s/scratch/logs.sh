#!/bin/bash

source ./scripts/k8_vars.sh
namespace=homelab

pod=$(get_pod_name $1)
[[ $? -eq 0 ]] && kubectl logs $pod -n $namespace -f || echo "$pod"
