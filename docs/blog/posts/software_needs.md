---
title: Software need definition
draft: true 
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

# The services I want to host

## The cool tools and fun stuff

- Dashboard : [Homepage](https://github.com/gethomepage/homepage)
- Password manager : [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
- Media server : [Jellyfin](https://github.com/jellyfin/jellyfin)
- The *arr suite
  - Requests : [Jellyseerr](https://github.com/fallenbagel/jellyseerr)
  - TV shows : [Sonarr](https://github.com/Sonarr/Sonarr)
  - Movies : [Radarr](https://github.com/Radarr/Radarr)
  - Indexer manager : [Jackett](https://github.com/Jackett/Jackett)
  - Torrent client : [qBittorrent](https://github.com/qbittorrent/qBittorrentFlareSolverr)
  - Solve challenges : [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr)
  - Stalled torrents remover : [Decluttarr](https://github.com/ManiMatter/decluttarr)
  - Profile manager : [Profilarr](https://github.com/Dictionarry-Hub/profilarr)
  - Tdarr/transcoderr (for transcoding automation)
- Recipe book : [Mealie](https://github.com/mealie-recipes/mealie/)
- Photo manager : [Immich](https://immich.app/) : A photo and video management tool
- Home automation : [home-assistant](https://github.com/home-assistant/home-assistant.io) Can it replace Alexa ?
- PDF tool : [Stirling PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- Ad blocker : [Pi-hole](https://github.com/pi-hole/pi-hole) ou [Blocky ?](https://github.com/0xERR0R/blocky)
- Document manager : [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)
- Picture share : [WeddingShare](https://github.com/Cirx08/WeddingShare)
 

## The admin and monitoring things

- Reverse-proxy : [Traefik](https://github.com/traefik/traefik)
- Monitoring and logging stack
  - [Grafana](https://github.com/grafana/grafana)
  - [Prometheus](https://github.com/prometheus/prometheus)
  - [cAdvisor](https://github.com/google/cadvisor)
  - [node-exporter](https://github.com/prometheus/node_exporter)
  - [fail2ban-prometheus-exporter](https://github.com/hctrdev/fail2ban-prometheus-exporter)
  - Promtail
  - [Loki](https://github.com/grafana/loki)
- Centralized logging : [Dozzle](https://github.com/amir20/dozzle)
- Notifying tool : [Gotify](https://github.com/gotify/server)
- Identity provider : [LLDAP](https://github.com/lldap/lldap)
- SSO (single-sign on) : [Authelia](https://github.com/authelia/authelia)
- Updates : [Watchtower](https://github.com/containrrr/watchtower)
- Uptime monitoring : [uptime-kuma](https://github.com/louislam/uptime-kuma)
- Auto-pause Container : [Sablier](https://github.com/sablierapp/sablier)
- Remote desktop gateway : [Guacamole](https://github.com/apache/guacamole-server)
- Remote automation : [OliveTin](https://github.com/OliveTin/OliveTin)
- Protection against malicious IPs : [crowdsec](https://github.com/crowdsecurity/crowdsec) => https://docs.crowdsec.net/docs/next/appsec/intro/#introduction

- Network security daemon  : [fail2ban](https://github.com/fail2ban/fail2ban)
