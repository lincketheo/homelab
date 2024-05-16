#!/bin/bash

source ./scripts/k8_vars.sh

pod=$(get_pod_name $1)
[[ $? -eq 0 ]] && kubectl logs $pod -n todo-app -f || echo "$pod"
