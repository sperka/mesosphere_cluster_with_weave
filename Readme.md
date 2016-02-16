# Mesosphere with weave net

[AS OF 02/16/2016]

The goal of these scripts is to provide a quick installation of a mesosphere cluster that is able to deploy docker containers (from a private docker repo) with service isolation through parameterized subnets with weave on Ubuntu 14.04.



### Usage

To install master server:

    sudo sh setup_mesos_master.sh
    
To install slave servers:

__!! MAKE SURE `IP_MASTER` IS SET TO THE RIGHT IP ADDRESS !!__

    sudo sh setup_mesos_slave.sh

### Docker

#### Credentials

If you have already a docker `config.json` add it as `docker.config.json` to `docker_config` directory and the script will create a `.docker` dir and will put it as `config.json`.

If you're using private docker registry, add your `docker.tar.gz` to `docker_config` directory and the script will move it to `/etc/` (see _Using a Private Docker Registry_ in _References_).


#### Docker with weave

To utilize `weave` through mesos/marathon is solved with creating two extra files (filename/content below):

    /etc/mesos-slave/docker_socket ::
    /var/run/weave/weave.sock

and

    /etc/mesos-slave/executor_environment_variables ::
    {"DOCKER_HOST": "unix:///var/run/weave/weave.sock"}

#### _Sidenote_:

My original attempt to put `MESOS_DOCKER_SOCKET` and `MESOS_EXECUTOR_ENVIRONMENT_VARIABLES` to `/etc/environments/` did __NOT__ work and passed parameters to the docker container did __NOT__ count (like `-e WEAVE_CIDR=net:10.33.1.0/24`).


### References

  - [Install Docker on Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntulinux/)
  - [Setting up a Mesos and Marathon Cluster](https://open.mesosphere.com/getting-started/install/)
  - [Launch docker container on mesosphere](https://github.com/mesosphere/open-docs/blob/master/tutorials/launch-docker-container-on-mesosphere.md)
  - [Using a Private Docker Registry](https://mesosphere.github.io/marathon/docs/native-docker-private-registry.html)
  - [Weave.works](http://weave.works)