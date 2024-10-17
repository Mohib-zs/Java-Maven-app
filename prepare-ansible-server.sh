#!/usr/bin/env bash

sudo apt update
sudo apt install python3.12-venv -y
python3 -m venv ~/venv
source ~/venv/bin/activate
pip install ansible --no-input
ansible-galaxy collection install azure.azcollection --force
pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt --no-input
pip install azure-cli==2.61.0 --no-input
pip install setuptools --no-input
pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt --no-input

