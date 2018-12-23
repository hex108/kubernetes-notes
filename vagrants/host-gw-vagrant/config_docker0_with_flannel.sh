#!/bin/bash

set -e
set -x

source /run/flannel/subnet.env

# configure docker daemon
cat > /etc/docker/daemon.json << EOF
{
	"bip": "$FLANNEL_SUBNET",
	"mtu": $FLANNEL_MTU
}
EOF
systemctl daemon-reload
systemctl restart docker
