## Install weave scope

IP_MASTER=$1

sudo wget -O /usr/local/bin/scope https://git.io/scope
sudo chmod a+x /usr/local/bin/scope
sudo scope launch ${IP_MASTER}