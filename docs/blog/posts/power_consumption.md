---
title: Power consumption
draft: false 
date: 2026-02-03
pin: false
# links:
#   - Test: setup/setting-up-site-search.md
# tags:
#     - test
authors:
    - louison
---
With this beautiful monitoring stack and all the effort I put on the system optimisation to make the homelab power efficient, it is a nice feature to monitor the power draw from the wall.
<!-- more -->

# Measurment methods

To measure power consumption there is 2 main methods. The hardware one and the software extrapolation one.
The hardware measure is more accurate but it cost more and add add work to retrieve the data.  
The software method is cheaper but is not accurate and ask for a lot of tests combined with hardware to be sure that every component is taken into account in the measure (e.g. the motherboard can give a gross value but it did not include the psu)

**For reasons of accuracy I will do the hardware method.**

There is a lot of cheap and expensive powermeter with a wide range of feature. The key points for my project are that I don't want those data to end up on a proprietary cloud and I want something tinker-ready.

During my search I found [Shelly](https://www.shelly.com/). Shelly is a Bulgarian brand that produce a lot of range of smart things to automate your home (switches, plugs, sensors, etc.) with a heavy focus on :  
- **No cloud required**: Control your Shelly devices locally without connecting them to an external cloud or server  
- **Highly compatible**: Shelly devices are compatible with most home automation platforms, protocols and voice assistants

I choose the [Shelly Plug S Gen3](https://shelly-api-docs.shelly.cloud/gen2/Devices/Gen3/ShellyPlugSG3/) for it versatility.

# Collecting those data

## Relying on the api

Once setup, I can access the smart plug's web UI directly on the IP [http://192.168.1.45/#/scripts](http://192.168.1.45/). the purpose of this webUI is configuring the smart plug. However Shelly has thought of everything by giving us access to an API to interact directly with the plug [http://192.168.1.45/rpc/shelly.GetStatus](http://192.168.1.45/rpc/shelly.GetStatus).

Mainly because I'm lazy I tried to use alloy to retrieve the metrics directly using the API.

The most advanced step I went was retrieving a value but Alloy won't let me convert a float64 to a string :

```alloy title="config.alloy" linenums="0"
// Defining Shelly API
remote.http "shelly_api" {
  url = "http://192.168.1.45/rpc/Switch.GetStatus?id=0"
  poll_frequency = "10s"
  poll_timeout = "5s"
}

// Scraping Shelly API
prometheus.scrape "default" {
  targets    = json_path(remote.http.shelly_api.content, ".aenergy.total")
  forward_to = [prometheus.remote_write.default.receiver]

  scrape_interval = "10s"
}
```
Resulting in :

``` linenums="0"
Error: /etc/alloy/config.alloy:284:16: json_path(remote.http.shelly_api.content, ".aenergy.total")[0] target::ConvertFrom: conversion from 'float64' is not supported
283 | prometheus.scrape "default" {
284 |   targets    = json_path(remote.http.shelly_api.content, ".aenergy.total")
    |                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
285 |   forward_to = [prometheus.remote_write.default.receiver]
interrupt received

    ts=2026-02-03T09:08:48.062393434Z
    level=error
    msg=failed to evaluate config
    controller_path=/
    controller_id=
    node=prometheus.scrape.default
    err=decoding configuration: /etc/alloy/config.alloy:284:16: json_path(remote.http.shelly_api.content, \".aenergy.total\")[0] target::ConvertFrom: conversion from 'float64' is not supported

Error: could not perform the initial load successfully
```

## Setting up a script

Hopefully, Shelly make it possible to write script directly within the smart plug !
In the library I found a ready-to-use script that does exactly what I want. The problem is that the plug has a realy limited hardware and can't event run this little script. I had to optimize it the best I could.

```js linenums="0"
--8<--
scripts/shelly_prometheus_metrics/shelly_prometheus_metrics.js
--8<--
```

Once the metrics exposed, it's child's play to scrape it with Alloy :

```alloy title="config.alloy" linenums="0"
--8<--
stacks/monitoring/alloy/config.alloy:264:279
--8<--
```

# Conclusion

This little challenge was quite funny and I think this will evolve someday because I plan to dive in the domotic world !