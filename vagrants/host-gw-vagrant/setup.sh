#/bin/sh
set -x

#source /vagrant/proxy_on.sh

apt-get update

# install some tools
apt-get install -y bridge-utils

# install docker
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

# start docker service
service docker restart

rm -rf get-docker.sh
