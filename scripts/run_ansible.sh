#!/bin/bash

mkdir ~/.playbooks
cp /vagrant/playbooks/juno_playbook.yml ~/.playbooks/
ansible-playbook ~/.playbooks/juno_playbook.yml
