#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================="
echo "🚀 Starting Automated K3s Installation"
echo "=========================================="

# 1. Update and install dependencies
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install curl wget -y

# 2. Disable Swap
echo "🛑 Disabling swap space (required for Kubernetes)..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# 3. Install K3s Server
echo "📥 Downloading and installing K3s Control Plane..."
curl -sfL https://get.k3s.io | sh -

# 4. Configure permissions for the current non-root user
echo "🔑 Configuring kubectl permissions for user: $USER..."
mkdir -p "$HOME/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$HOME/.kube/config"
sudo chown "$USER:$USER" "$HOME/.kube/config"
chmod 600 "$HOME/.kube/config"

# Add environment variable to bashrc if not already present
if ! grep -q "KUBECONFIG" "$HOME/.bashrc"; then
    echo "export KUBECONFIG=\$HOME/.kube/config" >> "$HOME/.bashrc"
fi
export KUBECONFIG="$HOME/.kube/config"

# 5. Verification
echo "🔍 Verifying node installation..."
sleep 5 # Wait a moment for components to initialize
kubectl get nodes

echo "=========================================="
echo "✅ K3s Installation Completed Successfully!"
echo "=========================================="
echo "📝 Note: To use kubectl right now, run: export KUBECONFIG=\$HOME/.kube/config"
echo "📌 Worker Node Connection Token:"
sudo cat /var/lib/rancher/k3s/server/node-token
echo "=========================================="
