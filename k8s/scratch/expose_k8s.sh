#!/bin/bash

# Forwards traffic from host 8080 to ingress controller port internal to k8s (80)
kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8080:80
