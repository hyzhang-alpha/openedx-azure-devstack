#!/bin/bash

# Copyright (c) Microsoft Corporation. All Rights Reserved.
# Licensed under the MIT license. See LICENSE file on the project webpage for details.

# print commands and arguments as they are executed
set -x

echo "starting open edx devstack provision on pid $$"
date
ps axjf

#############
# Parameters
#############

AZUREUSER=$1
HOMEDIR="/home/$AZUREUSER"
VMNAME=`hostname`
echo "User: $AZUREUSER"
echo "User home dir: $HOMEDIR"
echo "vmname: $VMNAME"

###################
# Common Functions
###################

ensureAzureNetwork()
{
  # ensure the host name is resolvable
  hostResolveHealthy=1
  for i in {1..120}; do
    host $VMNAME
    if [ $? -eq 0 ]
    then
      # hostname has been found continue
      hostResolveHealthy=0
      echo "the host name resolves"
      break
    fi
    sleep 1
  done
  if [ $hostResolveHealthy -ne 0 ]
  then
    echo "host name does not resolve, aborting install"
    exit 1
  fi

  # ensure the network works
  networkHealthy=1
  for i in {1..12}; do
    wget -O/dev/null http://bing.com
    if [ $? -eq 0 ]
    then
      # hostname has been found continue
      networkHealthy=0
      echo "the network is healthy"
      break
    fi
    sleep 10
  done
  if [ $networkHealthy -ne 0 ]
  then
    echo "the network is not healthy, aborting install"
    ifconfig
    ip a
    exit 2
  fi
}
ensureAzureNetwork

###################################################
# Update Ubuntu and install prereqs
###################################################

time sudo apt-get -y update && sudo apt-get -y upgrade
time sudo apt-get install -y build-essential software-properties-common python-software-properties curl git-core libxml2-dev libxslt1-dev libfreetype6-dev python-pip python-apt python-dev libxmlsec1-dev swig
time sudo pip install --upgrade pip
time sudo pip install --upgrade virtualenv

###################################################
# Pin specific version of Open edX (named-release/cypress for now)
###################################################
export OPENEDX_RELEASE='named-release/ginkgo.2'
EXTRA_VARS="-e edx_platform_version=$OPENEDX_RELEASE \
  -e certs_version=$OPENEDX_RELEASE \
  -e forum_version=$OPENEDX_RELEASE \
  -e xqueue_version=$OPENEDX_RELEASE \
  -e configuration_version=appsembler/azureDeploy \
  -e edx_ansible_source_repo=https://github.com/appsembler/configuration \
"

###################################################
# Download configuration repo and start ansible
###################################################

cd /tmp
time git clone https://github.com/appsembler/configuration.git
cd configuration
time git checkout appsembler/azureDeploy
time sudo pip install -r requirements.txt
cd playbooks

sudo ansible-playbook -i localhost, -c local vagrant-devstack.yml $EXTRA_VARS

date
echo "completed open edx devstack provision on pid $$"
