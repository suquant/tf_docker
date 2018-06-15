#!/bin/sh
set -e

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

cat <<EOF > /etc/apt/sources.list.d/docker-ce.list
deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable
EOF

apt update
DEBIAN_FRONTEND=noninteractive apt install -yq docker-ce
