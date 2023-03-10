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
pip install psutil

if ! [[ -f "$HOME/.ssh/id_rsa" ]]; then
    echo "Generating SSH Key"
    mkdir -p "$HOME/.ssh"
    ssh-keygen -b 4096 -t rsa -f "$HOME/.ssh/id_rsa" -N "" -C "$USER@$HOSTNAME"
    echo "Publishing Key to authorized keys"
    cat "$HOME/.ssh/id_rsa.pub" >> "$HOME/.ssh/authorized_keys"
    chmod 600 "~/.ssh/authorized_keys"
    echo "done"
else
    echo "SSH already generated"
fi

if [[ -f "./requirements.yml" ]]; then
    ansible-galaxy install -r requirements.yml
fi

ANSIBLE_LOCALHOST_WARNING=False \
ANSIBLE_INVENTORY_UNPARSED_WARNING=False \
ansible-playbook playbook.yml --ask-become-pass