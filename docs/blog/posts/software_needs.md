---
title: Software need definition
draft: false 
date: 2025-04-01
pin: false
# links:
#   - Test: setup/setting-up-site-search.md
# tags:
#     - test
authors:
    - louison
---

What is the purpose of a beautiful rack full of hardware without any software to run or service to host ?

<!-- more -->

# The Docker services I want to host

I will use Dowker Swarm as my orchestrator, here is the services I need split in stacks.

## admin stack

This stack contains the administration tool useful to secure the homelab and give access to users

- Reverse-proxy : [Traefik](https://github.com/traefik/traefik)
- Protection against malicious IPs : [crowdsec](https://github.com/crowdsecurity/crowdsec)
- SSO (single-sign on) : [Authelia](https://github.com/authelia/authelia)
- Identity provider : [LLDAP](https://github.com/lldap/lldap)

## core stack

This stack is dedicated to cool stuff to manage the homelab

- Dashboard : [Homepage](https://github.com/gethomepage/homepage)
- Notifying tool : [Gotify](https://github.com/gotify/server)
- Updates : [Watchtower](https://github.com/containrrr/watchtower)
- Remote automation : [OliveTin](https://github.com/OliveTin/OliveTin)
- Remote desktop gateway : [Guacamole](https://github.com/apache/guacamole-server)
- Auto-pause Container : [Sablier](https://github.com/sablierapp/sablier)

## pictures stack

This stack is for all my services related to pictures storing and sharing?

- Photo manager : [Immich](https://immich.app/docs/install/docker-compose)
  - [immich machine learning](https://immich.app/docs/guides/remote-machine-learning/)
  - [postgreSQL]()
  - [redis]()
- Picture share : [WeddingShare](https://github.com/Cirx08/WeddingShare)

## media stack

The stack to automate and serve media

- Media server : [Jellyfin](https://github.com/jellyfin/jellyfin)
- The *arr suite :
  - Requests : [Jellyseerr](https://github.com/fallenbagel/jellyseerr)
  - TV shows : [Sonarr](https://github.com/Sonarr/Sonarr)
  - Movies : [Radarr](https://github.com/Radarr/Radarr)
  - Indexer manager : [Jackett](https://github.com/Jackett/Jackett)
  - Torrent client : [qBittorrent](https://github.com/qbittorrent/qBittorrentFlareSolverr)
  - Solve challenges : [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr)
  - Stalled torrents remover : [Decluttarr](https://github.com/ManiMatter/decluttarr)
  - Profile manager : [Profilarr](https://github.com/Dictionarry-Hub/profilarr)
  - Transcoding automation : [Tdarr](https://home.tdarr.io/)

## documents stack

To manage PDF

- Document manager : [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)
  - [postgreSQL]()
- PDF tool : [Stirling PDF](https://github.com/Stirling-Tools/Stirling-PDF)

## networking stack

A little stack to do network stuff

- Ad blocker : [Blocky](https://github.com/0xERR0R/blocky)

## monitoring stack

To monitor my homelab

- [Grafana](https://github.com/grafana/grafana)
  - [Prometheus](https://github.com/prometheus/prometheus)
  - [cAdvisor](https://github.com/google/cadvisor)
  - [node-exporter](https://github.com/prometheus/node_exporter)
  - [fail2ban-prometheus-exporter](https://github.com/hctrdev/fail2ban-prometheus-exporter)
  - [Promtail]()
  - [Loki](https://github.com/grafana/loki)
- Centralized logging : [Dozzle](https://github.com/amir20/dozzle)
- Uptime monitoring : [uptime-kuma](https://github.com/louislam/uptime-kuma)

## miscellaneous stack

This stack will hold other services

- Password manager : [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
- Recipe book : [Mealie](https://github.com/mealie-recipes/mealie/)


# The system tools I need to install directly on the OS

- Network security daemon : [fail2ban](https://github.com/fail2ban/fail2ban)
- Driver to export system logs : [loki-docker-driver](https://grafana.com/docs/loki/latest/send-data/docker-driver/)