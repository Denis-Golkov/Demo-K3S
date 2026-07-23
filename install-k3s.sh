#!/bin/bash

set -e

echo "Starting Automated K3s Installation"

sudo apt update && sudo apt upgrade -y && sudo apt install git -y
sudo apt install curl wget -y

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

curl -sfL https://get.k3s.io | sh -

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

mkdir -p "$REAL_HOME/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$REAL_HOME/.kube/config"
sudo chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.kube/config"
chmod 600 "$REAL_HOME/.kube/config"

if ! grep -q "KUBECONFIG" "$REAL_HOME/.bashrc"; then
    echo "export KUBECONFIG=$REAL_HOME/.kube/config" >> "$REAL_HOME/.bashrc"
fi
export KUBECONFIG="$REAL_HOME/.kube/config"

sleep 5
kubectl get nodes

sudo cat /var/lib/rancher/k3s/server/node-token