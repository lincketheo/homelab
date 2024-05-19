#!/bin/bash

namespace=homelab
source ./scripts/k8_vars.sh

pod=$(get_pod_name $1)
[[ $? -eq 0 ]] && kubectl exec -it $pod -n $namespace -- bash || echo "$pod"
