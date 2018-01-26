#!/bin/sh
#
# Copyright (c) 2018 Weitian LI
# MIT License
#
# Bootstrap the master and nodes for Ansible management.
#
# 2018-01-25
#

ROOTDIR="${0%/*}"
PLAYBOOK="${ROOTDIR}/bootstrap.yml"
echo "Playbook directory: ${ROOTDIR}"
echo "Playbook: ${PLAYBOOK}"

#
# master
#

SSHKEY="${ROOTDIR}/ssh/master.key"
if [ -f "${SSHKEY}" ]; then
    echo "ERROR: SSH key already exists: ${SSHKEY}"
    echo "Master already been bootstrapped?"
else
    ssh-keygen -t ed25519 -C "ansible@master" -f "${SSHKEY}" -N ""
    echo "Generated SSH key for master: ${SSHKEY}"
    ansible-playbook "${PLAYBOOK}" -v --diff \
        --extra-vars "bootstrap_host=master"
fi

#
# nodes
#

SSHKEY="${ROOTDIR}/ssh/nodes.key"
if [ -f "${SSHKEY}" ]; then
    echo "ERROR: SSH key already exists: ${SSHKEY}"
    echo "Nodes already been bootstrapped?"
else
    ssh-keygen -t ed25519 -C "ansible@nodes" -f "${SSHKEY}" -N ""
    echo "Generated SSH key for nodes: ${SSHKEY}"
    ansible-playbook "${PLAYBOOK}" -v --diff
fi

