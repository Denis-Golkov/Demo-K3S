# K3s Kubernetes Installation Guide for Ubuntu

A quick, comprehensive guide to deploying a lightweight, production-ready K3s Kubernetes cluster on Ubuntu servers.

The entire installation and demo deployment process was performed on Google Cloud Platform (GCP).

---

## Prerequisites

Before starting, ensure your system meets the following minimum requirements:
* **OS:** Ubuntu 22.04 LTS, 24.04 LTS, or newer
* **Resources:** Minimum 1 CPU core, 512MB RAM (2GB recommended)
* **Networking:** Open inbound port `6443` for the Kubernetes API server
* https://docs.k3s.io/installation/requirements?os=debian

---

## Automated Setup

Run the repository-hosted scripts to install and configure K3s, then deploy the demo application.

### Install and Configure K3s

```bash
curl -sfL https://raw.githubusercontent.com/Denis-Golkov/Demo-K3S/refs/heads/main/install-k3s.sh | sudo sh
```

### Deploy the Demo Application

```bash
curl -sfL https://raw.githubusercontent.com/Denis-Golkov/Demo-K3S/refs/heads/main/DemoAppDeployment.sh | sudo sh
```

---

## Step 1: System Preparation

Log into your Ubuntu machine, update system packages, and install required dependencies.

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install curl wget -y
sudo apt install git -y
# Disable swap (Required for Kubernetes stability)
sudo swapoff -a
sudo sed -i '/ swap / s/^.*\$/#\1/g' /etc/fstab
```

---

## Step 2: Install K3s Server (Control Plane)

Execute the official Rancher utility script to download and initialize the K3s control plane.

```bash
curl -sfL https://get.k3s.io | sh -
```
*Note: This automatically configures a systemd service to manage K3s and ensures it restarts on host reboots.*

---

## Step 3: Configure Non-Root User Access

By default, cluster access is restricted to the root user. Run the following commands to grant your current Ubuntu user administrative permissions.

```bash
# Create local kube directory
mkdir -p ~/.kube

# Copy administrative configuration
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown USER:USER ~/.kube/config
chmod 600 ~/.kube/config

# Set environment variable
export KUBECONFIG=~/.kube/config
echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
```

---

## Step 4: Verify the Cluster

Test your connection to the cluster and check the health of your newly created node.

```bash
kubectl get nodes
```
**Expected Output:** Your host machine should be listed with a status of **`Ready`**.

---

## Optional: Add Worker Nodes

To scale your deployment into a multi-node cluster, expand your environment with worker nodes.

### 1. Retrieve the Node Token (From Master Node)
```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

### 2. Connect the Worker (From Worker Node)
Replace `<MASTER_IP>` with your master node's IP address and `<NODE_TOKEN>` with the token retrieved above.
```bash
curl -sfL https://k3s.io | K3S_URL=https://<MASTER_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -
```

---

## How to Uninstall

If you need to wipe the installation and reset your host machines, execute the native cleanup scripts.

* **On the Master Node:**
  ```bash
  sudo k3s-uninstall.sh
  ```
* **On Worker Nodes:**
  ```bash
  sudo k3s-agent-uninstall.sh
  ```
