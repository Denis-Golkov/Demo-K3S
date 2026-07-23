#!/bin/bash
set -e

rm -rf k8s
git clone https://github.com/Denis-Golkov/k8s.git
cd k8s/k8s/

sudo kubectl apply -f postgres-pv.yaml
sudo kubectl apply -f db.yaml
sudo kubectl apply -f be.yaml
sudo kubectl apply -f fe.yaml
sudo kubectl apply -f tppfe-nodeport.yaml
sleep 35
sudo kubectl get pod