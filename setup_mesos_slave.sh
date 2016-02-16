#!/usr/bin/env bash

################################
#  Mesos slave setup script    #
#    with weave net & scope    #
# Currently with 1 master node #
################################

### Prep

# settings
IP_MASTER=10.2.124.12

# slave ip
IP_SLAVE=`ip route get 8.8.8.8 | awk '{print $NF; exit}'`

# hostname
HOSTNAME=`hostname`

echo "Setting up mesos slave on ${IP_SLAVE} with master ${IP_MASTER}"

# get familiar with the hostname to avoid 'sudo' warnings
sudo sh -c "echo 127.0.0.1 ${HOSTNAME} >> /etc/hosts"

#### Prerequisites

# Java
sudo sh setup_scripts/install_java_ubuntu1404.sh

# Docker
sudo sh setup_scripts/install_docker_ubuntu1404.sh

# Weave net - 'slave'
sudo sh setup_scripts/install_weave_net.sh ${IP_MASTER}

# Weave scope - 'slave'
sudo sh setup_scripts/install_weave_scope.sh ${IP_MASTER}

# Mesos repo
sudo sh setup_scripts/add_mesos_repo.sh

### Install and configure mesos
sudo apt-get -y install mesos

# disable zookeeper
sudo service zookeeper stop
sudo sh -c "echo manual > /etc/init/zookeeper.override"

# disable mesos-master
sudo service mesos-master stop
sudo sh -c "echo manual > /etc/init/mesos-master.override"

# zk config
sudo sh -c "echo zk://${IP_MASTER}:2181/mesos > /etc/mesos/zk"

# mesos slave config
sudo sh -c "echo ${IP_SLAVE} > /etc/mesos-slave/ip"
sudo sh -c "echo ${IP_SLAVE} > /etc/mesos-slave/hostname"
sudo sh -c "echo docker,mesos > /etc/mesos-slave/containerizers"
sudo sh -c "echo /var/run/weave/weave.sock > /etc/mesos-slave/docker_socket"
sudo sh -c "echo 5mins > /etc/mesos-slave/executor_registration_timeout"
sudo sh -c "echo '{\"DOCKER_HOST\": \"unix:///var/run/weave/weave.sock\"}' > /etc/mesos-slave/executor_environment_variables"

### Start necessary services

# mesos-slave
sudo service mesos-slave start
