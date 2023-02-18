#!/bin/bash

mkdir ~/.playbooks
cp /vagrant/playbooks/installation_playbook.yml ~/.playbooks/
ansible-playbook ~/.playbooks/installation_playbook.yml
