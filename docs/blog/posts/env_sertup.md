---
title: Environment setup
draft: false 
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

# The System

## BIOS/UEFI

To begin, once the hardware thrown in the case, we have to tune the BIOS/UEFI to enable some features in the advanced pannel :  

  - CPU Configuration >  
    - CPU C States Support => Enabled
    - Enhanced Halt State (C1E) => Auto
    - Package C State Support => Enable
    - C6DRAM => Enable
  - Chipset Configuration >
    - PCI Express Native Control => Enabled
    - PCH PCIE ASPM Support => Auto
    - Restore on AC/Power Loss => Power On

## OS

For ease of use and support I will use Ubuntu Server 24.04.2 LTS even if alternative OS like nix are tempting.  
To get the smallest footprint as possible, I installed the minimal configuration of Ubuntu server without any additional package except OpenSSH for remote access right after the installation.

Once the BIOS configured and the OS installed, let's take a look at the power consumption by installing powertop : `sudo apt install powertop` .Here we can see that the CPU can't go deeper that C2.

The main suspect is the ethernet controller, to set ASPM L1 for this controller :  
```bash
echo 1 | sudo tee /sys/bus/pci/drivers/r8169/0000\:01\:00.0/link/l1_aspm
```

Then we can set the powersave mode for the PCI-e :  
```bash
echo "powersave" | sudo tee /sys/module/pcie_aspm/parameters/policy
cat /sys/module/pcie_aspm/parameters/policy # to confirm
```

We can also use `powertop --auto-tune` to tweak other things.

And to persist all those commands, let's add them to the reboot cron :  
```bash
# To persist those commands
(sudo crontab -l 2>/dev/null; echo "@reboot /usr/sbin/powertop --auto-tune") | sudo crontab -
(sudo crontab -l 2>/dev/null; echo "@reboot echo 1 | sudo tee /sys/bus/pci/drivers/r8169/0000\:01\:00.0/link/l1_aspm") | sudo crontab -
(sudo crontab -l 2>/dev/null; echo "@reboot echo "powersave" | sudo tee /sys/module/pcie_aspm/parameters/policy") | sudo crontab -
```

!!! example "Power consumption"
    At this point the server sips just bellow 12 Watts at idle with HX750i, the N100DC-ITX motherboard, 32 Go of RAM and a 256 Go SATA SSD.
    Adding 2 12x12 fans add 1.5 Watts for a total bellow 13.5 W.

## Networking

Let's change the SSH default port : 

- Open ssh config `sudo nano /etc/ssh/sshd_config`
- Edit #Port 22 to something else
- Adding new port to firewall `sudo ufw allow xxxx/tcp`
- Apply change by restarting SSH `sudo systemctl restart ssh.service`
- Test the connection `ssh <user>@<server_ip> -p xxxx`
- Removing port 22 to firewall `sudo ufw deny 22/tcp`

Let's disable password connection for SSH

- Open ssh config `sudo nano /etc/ssh/sshd_config`
- Setting `PasswordAuthentication no`
- Setting `PermitRootLogin prohibit-password`
- Apply change by restarting SSH `sudo systemctl restart ssh.service`

!!! tip "Tips"
    - `sudo ss -tulpn` to list all the open ports
    - Don't forget to fix the IP address of the homelab in the router

# The tools

## CLI utilities

```bash
sudo apt-get update
sudo apt install bash-completion
sudo apt install git
sudo apt install nano
sudo apt install cron
sudo apt install ufw
sudo apt install pipx && python3 -m pipx ensurepath && pipx install mkdocs && pipx inject mkdocs mkdocs-material
```

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

It's pretty usefull to get auto-completion on Docker CLI following the [official documentation]( https://docs.docker.com/engine/cli/completion/) :  

- Adding the right code snippet in the bashrc :  
```bash
cat <<EOT >> ~/.bashrc
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
EOT
```
- Reloading the shell : `source ~/.bashrc`
- Creating folder to store bash completion scripts `mkdir -p ~/.local/share/bash-completion/completions`
- Generating the bash completion script for Docker `docker completion bash > ~/.local/share/bash-completion/completions/docker`

??? tip "Click here if it worked"
    ![Dancing cat](../../resources/gifs/meow-im-dancing-1227936665.gif)

### Docker swarm init

Let's initialize our Docker Swarm cluster :
```bash
docker swarm init
```

Once the swarm cluster is setup we can start deploying things with ``