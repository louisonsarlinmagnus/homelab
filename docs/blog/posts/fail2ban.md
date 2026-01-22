---
title: Fail2Ban installation and setup
draft: false 
date: 2026-01-22
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

![Test](../../resources/img/fail2ban_geoip_screenshot.png)


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

# Visualisation

With Alloy it is really easy to extract some data from a file. Luckily fail2ban stores everything we need in it's fail2ban.log file !

```log title="/var/log/fail2ban.log" linenums="0"
2026-01-18 00:03:52,228 fail2ban.filter         [2140643]: INFO    [sshd] Found 176.120.22.47 - 2026-01-18 00:03:51
2026-01-18 00:04:13,306 fail2ban.filter         [2140643]: INFO    [sshd] Found 176.120.22.47 - 2026-01-18 00:04:13
2026-01-18 00:05:02,978 fail2ban.filter         [2140643]: INFO    [sshd] Found 176.120.22.47 - 2026-01-18 00:05:02
2026-01-18 00:05:14,955 fail2ban.filter         [2140643]: INFO    [sshd] Found 176.120.22.47 - 2026-01-18 00:05:14
2026-01-18 00:05:27,767 fail2ban.filter         [2140643]: INFO    [sshd] Found 176.120.22.47 - 2026-01-18 00:05:27
2026-01-18 00:05:27,919 fail2ban.actions        [2140643]: NOTICE  [sshd] Ban 176.120.22.47
2026-01-18 00:15:27,472 fail2ban.actions        [2140643]: NOTICE  [sshd] Unban 176.120.22.47
```

## Obtain the logs

The first step is to locate and scarpe the file, this is easily done with the following components :  

```alloy title="config.alloy" linenums="0"
// Retrieve fail2ban logfile
local.file_match "fail2ban" {
    path_targets        = [{
    __address__         = "localhost",
    __path__            = "/var/log/fail2ban.log",
    // __path_exclude__  = "/var/log/fail2ban.log.*.gz",
    instance            = "homelab",
    job                 = "fail2ban",
  }]
}

// Scrape the file and send it to loki
loki.source.file "fail2ban" {
    targets    = local.file_match.fail2ban.targets
    forward_to = [loki.process.fail2ban_get_ip.receiver]
}
```

## Extract the data from every line

Fail2Ban does not build it's log with a convinient JSON format but with a regex we can extract the data we want and appending those data in labels to every log entry.

```alloy title="config.alloy" linenums="0"
// Process the log entries to extract data
loki.process "fail2ban_get_ip" {
    forward_to = [loki.process.fail2ban_geoip_lookup.receiver]

    // Store in group desired data
    stage.regex {
        expression = "^(?P<time>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2},\\d{3})\\s+(?P<fail2ban_component>fail2ban\\.\\w+)\\s+\\[(?P<pid>\\d+)\\]:\\s+(?P<level>\\w+)\\s+\\[(?P<jail>[^\\]]+)\\]\\s+(?P<action>\\w+)\\s+(?P<ip>(?:\\d{1,3}\\.){3}\\d{1,3})?"
    }

    // Define the time format for the "time" data retrieve in the log entry
    stage.timestamp {
        source = "time"
        format = "2006-01-02 15:04:05,000"
    }

    // Natively associate every regex group with a label with the same name
    stage.labels {
        values = {
            time      = "",
            fail2ban_component = "",
            jail      = "",
            ip        = "",
            action    = "",
        }
    }

}
```

## From IP to Location

Thankfully Alloy already has `stage.geoip` within the `loki.process` component ! With this it's child's play :

```alloy title="config.alloy" linenums="0"
// Process the log entries to lookup data
loki.process "fail2ban_geoip_lookup" {
    forward_to = [loki.write.default.receiver]

    // Lookup for each ip entry within the GeoLite2 database
    stage.geoip {
        db      = "/usr/share/GeoLite2/GeoLite2-City.mmdb"
        source  = "ip"
        db_type = "city"
    }

    // Natively associate every geoip output with a label with the same name
    stage.labels {
        values = {
            geoip_city_name          = "",
            geoip_country_name       = "",
            // geoip_country_code       = "",
            geoip_continent_name     = "",
            // geoip_continent_code     = "",
            geoip_location_latitude  = "",
            geoip_location_longitude = "",
        }
    }
}
```

!!! tip "You can only set 15 labels for each entry, remove the useless ones"

## Result overview

!!! example "This is what the above parts do"
    === "Raw entry"
        ```log linenums="0"
        2026-01-22 13:32:42,616 fail2ban.filter         [2140643]: INFO    [sshd] Found 91.202.233.33 - 2026-01-22 13:32:42
        ```
    === "Scraped entry"
        ```json linenums="0"
        timestamp: 2026-01-22T13:32:42.616669492Z,
        entry: 2026-01-22 13:32:42,616 fail2ban.filter         [2140643]: INFO    [sshd] Found 91.202.233.33 - 2026-01-22 13:32:42,
        labels: {
            filename="/var/log/fail2ban.log",
            instance="homelab",
            job="fail2ban"
            },
        structured_metadata: {}
        ```
    === "IP extracted"
        ```json linenums="0"
        timestamp: 2026-01-22T13:32:42.616669492Z,
        entry: 2026-01-22 13:32:42,616 fail2ban.filter         [2140643]: INFO    [sshd] Found 91.202.233.33 - 2026-01-22 13:32:42,
        labels: {
            action="Found",
            fail2ban_component="fail2ban.filter",
            filename="/var/log/fail2ban.log",
            instance="homelab",
            ip="91.202.233.33",
            jail="sshd",
            job="fail2ban",
            time="2026-01-22 13:32:42,616"
        }, structured_metadata: {}
        ```
    === "Location extracted"
        ```json linenums="0"
        timestamp: 2026-01-22T13:32:42.616669492Z,
        entry: 2026-01-22 13:32:42,616 fail2ban.filter         [2140643]: INFO    [sshd] Found 91.202.233.33 - 2026-01-22 13:32:42,
        labels: {
            action="Found",
            fail2ban_component="fail2ban.filter",
            filename="/var/log/fail2ban.log",
            geoip_continent_name="Europe"
            geoip_country_name="Russia"
            geoip_location_latitude="55.7386"
            geoip_location_longitude="37.6068"
            instance="homelab",
            ip="91.202.233.33",
            jail="sshd",
            job="fail2ban",
            time="2026-01-22 13:32:42,616"
        },
        structured_metadata: {}
        ```

## Display on Grafana

For Grafana it's not hard, just some config and toggling the right settings!

!!! tip "Do not forget to extract labels, and convert lat and long to number in "Transformations" !"

??? note "The JSON for a neat Heatmap"
    ```json
    {
    "id": 48,
    "type": "geomap",
    "title": "Fail2Ban GeoIP",
    "gridPos": {
        "x": 0,
        "y": 0,
        "h": 16,
        "w": 18
    },
    "fieldConfig": {
        "defaults": {
        "custom": {
            "hideFrom": {
            "tooltip": false,
            "viz": false,
            "legend": false
            }
        },
        "mappings": [],
        "thresholds": {
            "mode": "absolute",
            "steps": [
            {
                "color": "green",
                "value": null
            }
            ]
        },
        "color": {
            "mode": "thresholds"
        }
        },
        "overrides": []
    },
    "transformations": [
        {
        "id": "extractFields",
        "options": {
            "delimiter": ",",
            "source": "labels"
        }
        },
        {
        "id": "convertFieldType",
        "options": {
            "conversions": [
            {
                "destinationType": "number",
                "targetField": "geoip_location_latitude"
            }
            ],
            "fields": {}
        }
        },
        {
        "id": "convertFieldType",
        "options": {
            "conversions": [
            {
                "destinationType": "number",
                "targetField": "geoip_location_longitude"
            }
            ],
            "fields": {}
        }
        }
    ],
    "pluginVersion": "12.3.0",
    "targets": [
        {
        "datasource": {
            "type": "loki",
            "uid": "P8E80F9AEF21F6940"
        },
        "direction": "backward",
        "editorMode": "builder",
        "expr": "{job=\"fail2ban\", action=\"Found\"}",
        "hide": false,
        "legendFormat": "",
        "queryType": "range",
        "refId": "A"
        }
    ],
    "datasource": {
        "type": "loki",
        "uid": "P8E80F9AEF21F6940"
    },
    "options": {
        "view": {
        "allLayers": true,
        "id": "coords",
        "lat": 45,
        "lon": 0,
        "noRepeat": true,
        "zoom": 2,
        "shared": false
        },
        "controls": {
        "showZoom": false,
        "mouseWheelZoom": true,
        "showAttribution": false,
        "showScale": false,
        "showMeasure": false,
        "showDebug": false
        },
        "tooltip": {
        "mode": "none"
        },
        "basemap": {
        "config": {
            "showLabels": true,
            "theme": "auto"
        },
        "layer-tooltip": true,
        "name": "Layer 0",
        "noRepeat": true,
        "type": "carto"
        },
        "layers": [
        {
            "config": {
            "blur": 20,
            "radius": 15,
            "weight": {
                "fixed": 1,
                "max": 1,
                "min": 0
            }
            },
            "filterData": {
            "id": "byRefId",
            "options": "A"
            },
            "layer-tooltip": true,
            "location": {
            "latitude": "geoip_location_latitude",
            "longitude": "geoip_location_longitude",
            "mode": "coords"
            },
            "name": "Found",
            "opacity": 1,
            "tooltip": true,
            "type": "heatmap"
        }
        ]
    }
    }
    ```

