#!/bin/bash

echo "Installing MTProto Proxy..."

sudo apt update
sudo apt install docker.io -y

SECRET=$(openssl rand -hex 16)

sudo docker run -d \
  --name mtproxy \
  --restart unless-stopped \
  -p 443:443 \
  -e SECRET=$SECRET \
  telegrammessenger/proxy

echo "Proxy installed successfully"
echo "Secret: $SECRET"