#### DOCKER
## install docker on Ubuntu 14.04

# add new gpg key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo sh -c "echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list"

sudo apt-get update --fix-missing
sudo apt-get purge lxc-docker -y
sudo apt-cache policy docker-engine

sudo apt-get update --fix-missing
sudo apt-get install docker-engine -y
sudo service docker start

sudo usermod -aG docker ubuntu

# docker_settings
DOCKER_CONFIG_JSON="docker_config/docker.config.json"
DOCKER_PRIV_REPO_CRED="docker_config/docker.tar.gz"

if [ -f $DOCKER_CONFIG_JSON ]; then
	mkdir ~/.docker
	cp $DOCKER_CONFIG_JSON ~/.docker/config.json
fi

if [ -f $DOCKER_PRIV_REPO_CRED ]; then
	sudo cp $DOCKER_PRIV_REPO_CRED /etc/
fi