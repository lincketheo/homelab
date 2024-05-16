#!/bin/bash

# Create namespaces if they don't exist
kubectl get namespace todo-app &> /dev/null || kubectl create namespace todo-app
kubectl get namespace ingress-nginx &> /dev/null && kubectl delete all --all -n ingress-nginx

# Start nginx-controller https://kubernetes.github.io/ingress-nginx/deploy/
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml

#echo "Waiting for ingress controller - this might take a minute"
#kubectl wait --namespace ingress-nginx \
#  --for=condition=ready pod \
#  --selector=app.kubernetes.io/component=controller \
#  --timeout=120s
