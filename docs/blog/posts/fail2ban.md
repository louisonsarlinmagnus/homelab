---
title: Fail2Ban installation and setup
draft: true 
date: 2026-01-02
pin: false
# links:
#   - Test: setup/setting-up-site-search.md
# tags:
#     - test
authors:
    - louison
---
Fail2Ban scans log files like `/var/log/auth.log` and bans IP addresses conducting too many **failed login attempts**. It does this by updating system firewall rules to reject new connections from those IP addresses, for a configurable amount of time. Fail2Ban comes out-of-the-box ready to read many standard log files, such as those for sshd and Apache, and is easily configured to read any log file of your choosing, for any error you wish.
<!-- more -->

# Installation

Let's play a bunch of commands to install fail2ban !

```bash
sudo apt-get update
sudo apt upgrade -y

sudo apt install fail2ban
```

Fail2ban comes with default settings that work well for most users, but you can customize it to suit your needs. The main configuration file is located at /etc/fail2ban/jail.conf, but it’s better to create a local copy for your custom settings to prevent overwriting during updates. Create a new file called jail.local:
```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

# Configuration

## SSH

The default configuration is nice but let's twist it a bit !

Firstly, the conditions to meet to be temporarly ban :
```ini title="/etc/fail2ban/jail.local" linenums="101"
bantime  = 10m
findtime  = 10m
maxretry = 5
```

Then we can configure the sshd jail:
```ini title="/etc/fail2ban/jail.local" linenums="274"
[sshd]

port    = xxx # Being a custom port other than 22
logpath = /var/log/auth.log
backend = %(sshd_backend)s
```

By default, logs are handled by `journalctl`. We have to persist those logs :

```bash
cat /var/log/auth.log
sudo apt-get install rsyslog
cat /var/log/auth.log
```

!!! info "Failed tries on existing user will not trigger a fail2ban "fail""
    To prevent false-positive with user using multiple sshkeys

## Authelia

Firstly, let's create a filter to store our beautiful regex :

```ini title="/etc/fail2ban/filter.d/authelia.conf"
# Fail2Ban filter for Authelia

# Make sure that the HTTP header "X-Forwarded-For" received by Authelia's backend
# only contains a single IP address (the one from the end-user), and not the proxy chain
# (it is misleading: usually, this is the purpose of this header).

# the failregex rule counts every failed 1FA attempt (first line, wrong username or password) and failed 2FA attempt
# second line) as a failure.
# the ignoreregex rule ignores info and warning messages as all authentication failures are flagged as errors
# the third line catches incorrect usernames entered at the password reset form
# the fourth line catches attempts to spam via the password reset form or 2fa device reset form. This requires debug logging to be enabled

[Definition]
failregex = ^.*Unsuccessful (1FA|TOTP|Duo|U2F) authentication attempt by user .*remote_ip"?(:|=)"?<HOST>"?.*$
            ^.*user not found.*path=/api/reset-password/identity/start remote_ip"?(:|=)"?<HOST>"?.*$
            ^.*Sending an email to user.*path=/api/.*/start remote_ip"?(:|=)"?<HOST>"?.*$

ignoreregex = ^.*level"?(:|=)"?info.*
              ^.*level"?(:|=)"?warning.*
```

The we create and configure a new jail in `jail.local`

```ini title="/etc/fail2ban/jail.local" linenums="982"
[authelia]
enabled = true
port = http,https,9091
filter = authelia
logpath = /var/log/authelia/authelia.log
chain = DOCKER-USER
```

!!! tip "Don't forget to persist authelia logs"


Usefull commands :

```bash
#To restart fail2ban
sudo systemctl restart fail2ban.service

#To get jail status
sudo fail2ban-client status authelia
```

!!! bug "sshd works but not Authelia"
    It appears that sshd ban remote IP, but for some reason, the authelia jail bans a local ip "10.0.0.2" instead of the ip of the sender.  
    This issue has been addressed by setting the port mode to host for both 80 and 443 ports for the Traefik service.


## GeoIP
https://grafana.com/grafana/dashboards/22741-fail2ban/
https://medium.com/@bossm8/geoip-dashboards-in-grafana-from-iptables-logs-101a3b256d55

# Conclusion

