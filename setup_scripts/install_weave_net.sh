## Install weave net

IP_MASTER=$1

sudo curl -L git.io/weave -o /usr/local/bin/weave
sudo chmod a+x /usr/local/bin/weave

weave launch ${IP_MASTER}