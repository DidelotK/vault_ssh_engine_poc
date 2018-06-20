#!/usr/bin/env bash

if [ "$1" != "" ]; then
  ANSIBLE_DIR=$1
else
  ANSIBLE_DIR=.
fi

ansible-galaxy install -r $ANSIBLE_DIR/roles/roles_requirements.yml -p $ANSIBLE_DIR/roles/external
