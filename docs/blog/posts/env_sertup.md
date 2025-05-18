---
title: Environment setup
draft: true 
date: 2025-05-18
pin: false
# links:
#   - Test: setup/setting-up-site-search.md
# tags:
#     - test
authors:
    - louison
---

Notes taken during the setup of the system

<!-- more -->

# The OS

For ease of use and support I will use Ubuntu Server 24.04.2 LTS even if alternative OS like nix are tempting.  
To get the smallest footprint as possible, I installed the minimal configuration of Ubuntu server without any additional package except OpenSSH for remote access right after the installation.

# The tools

## Docker

The first tool to install and Setup is Docker.  

### Docker installation

Following the [official documentation](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) :

Setup the apt repository :
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

!!! tip "At this step you should see an url from docker from the last command"

Install Docker package :
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Allowing non-root users to run docker commands ([from documentation](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)) :
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

??? tip "Click here if it worked?"
    ![Dancing cat](/docs/resources/gifs/meow-im-dancing-1227936665.gif)


### Docker swarm init

Let's initialize our Docker Swarm cluster :
```bash
docker swarm init
```

