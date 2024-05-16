#!/bin/bash

source ./scripts/k8_vars.sh

pod=$(get_pod_name $1)
[[ $? -eq 0 ]] && kubectl delete pod $pod -n todo-app || echo "$pod"
