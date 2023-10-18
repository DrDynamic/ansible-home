#!/bin/bash
set -e
echo $(whoami)

if ! [ -x "$(command -v ansible)" ]; then
    echo "Installing Ansible"
    sudo apt-get install ansible -yqq
    echo "done"
else
    echo "Ansible already installed"
fi

if ! [ -x "$(command -v pip)" ]; then
    echo "Installing pip"
    sudo apt-get install python3-pip
    echo "done"
fi
sudo apt-get install python3-psutil

if [[ -f "./requirements.yml" ]]; then
    ansible-galaxy install -r requirements.yml
fi

ANSIBLE_LOCALHOST_WARNING=False \
ANSIBLE_INVENTORY_UNPARSED_WARNING=False \
ansible-playbook tasks/debug.yml