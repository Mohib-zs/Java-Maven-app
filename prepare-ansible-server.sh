#!/usr/bin/env bash

export MY_CRED_CLIENT_ID=$1
export MY_CRED_CLIENT_SECRET=$2
export MY_CRED_TENANT_ID=$3

sudo apt update
sudo apt install python3.12-venv -y
python3 -m venv ~/venv
source ~/venv/bin/activate
pip install ansible --no-input
pip install setuptools --no-input
pip install azure-cli --no-input
az login --service-principal -u $MY_CRED_CLIENT_ID -p $MY_CRED_CLIENT_SECRET -t $MY_CRED_TENANT_ID
ansible-galaxy collection install azure.azcollection --force
pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt --no-input
