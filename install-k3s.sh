#!/bin/bash

set -e

echo "Starting Automated K3s Installation"

sudo apt update && sudo apt upgrade -y && sudo apt install git -y
sudo apt install curl wget -y

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

curl -sfL https://get.k3s.io | sh -

mkdir -p "$HOME/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$HOME/.kube/config"
sudo chown "$USER:$USER" "$HOME/.kube/config"
chmod 600 "$HOME/.kube/config"

if ! grep -q "KUBECONFIG" "$HOME/.bashrc"; then
    echo "export KUBECONFIG=\$HOME/.kube/config" >> "$HOME/.bashrc"
fi
export KUBECONFIG="$HOME/.kube/config"

sleep 55 
kubectl get nodes

sudo cat /var/lib/rancher/k3s/server/node-token

