#!/bin/sh

# use ansible-galaxy cmd to download roles from github/galaxy/etc
ansible-galaxy install --role-file requirements.yml --roles-path ./roles || exit 1

# run the playbook
ansible-playbook -i hosts "${@}" playbook.yml

