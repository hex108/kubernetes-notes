#!/bin/bash

set -e
set -x

if [ $# -ne 1 ]; then
  echo "Usage: $0 bridgeip"
  exit 1
fi

BRIDGE_IP=$1

# configure docker daemon
cat > /etc/docker/daemon.json << EOF
{
	"bip": "$BRIDGE_IP"
}
EOF
systemctl daemon-reload
systemctl restart docker
