################################
#  Mesos master setup script   #
#    with weave net & scope    #
# Currently with 1 master node #
################################

### Prep

# iTerm2 shell integration
curl -L https://iterm2.com/misc/install_shell_integration.sh | bash

# Get current ip - this is the master ip
IP_MASTER=`ip route get 8.8.8.8 | awk '{print $NF; exit}'`

# and hostname
HOSTNAME=`hostname`

echo "Setting up mesos master on ${IP_MASTER}"

# get familiar with the hostname to avoid 'sudo' warnings
sudo sh -c "echo 127.0.0.1 ${HOSTNAME} >> /etc/hosts"

### Prerequisites

# Java
sudo sh setup_scripts/install_java_ubuntu1404.sh

# Docker
sudo sh setup_scripts/install_docker_ubuntu1404.sh

# Weave net - master
sudo sh setup_scripts/install_weave_net.sh

# Weave scope - master
sudo sh setup_scripts/install_weave_scope.sh

# Mesos repo
sudo sh setup_scripts/add_mesos_repo.sh

### Install and configure mesosphere
sudo apt-get -y install mesosphere

# zookeeper configuration
sudo sh -c "echo zk://${IP_MASTER}:2181/mesos > /etc/mesos/zk"
sudo sh -c "echo 1 > /etc/zookeeper/conf/myid"
sudo sh -c "echo server.1=${IP_MASTER}:2888:3888 > /etc/zookeeper/conf/zoo.cfg"
sudo sh -c "echo dataDir=/var/lib/zookeeper >> /etc/zookeeper/conf/zoo.cfg"
sudo sh -c "echo clientPort=2181 >> /etc/zookeeper/conf/zoo.cfg"

# mesos master configuration
sudo sh -c "echo 1 > /etc/mesos-master/quorum"
sudo sh -c "echo ${IP_MASTER} > /etc/mesos-master/ip"
sudo sh -c "echo ${IP_MASTER} > /etc/mesos-master/hostname"

# marathon configuration
sudo mkdir -p /etc/marathon/conf
sudo sh -c "echo ${IP_MASTER} > /etc/marathon/conf/hostname"
sudo sh -c "echo zk://${IP_MASTER}:2181/marathon > /etc/marathon/conf/zk"

### Start necessary services, disable services that are not needed

# disable mesos-slave
sudo stop mesos-slave
sudo sh -c "echo manual > /etc/init/mesos-slave.override"

# zookeeper
sudo service zookeeper restart

# mesos-master
sudo service mesos-master start

# marathon
sudo service marathon start


