---
title: Hardware overview
draft: false 
date: 2025-05-13
pin: false
# links:
#   - Test: setup/setting-up-site-search.md
# tags:
#     - test
authors:
    - louison
---

This article explores the hardware of a scalable hosting service that use Docker Swarm for efficient container orchestration and a lot of storage for centralized data management. It evaluates various hardware options, including servers, networking equipment, and storage solutions.

<!-- more -->

# Introduction

A complete satisfying homelab is more complex to setup than a Raspberry Pi, Docker and a domain name (even if it can suffice). For my project I have to think about the case/rack, the network hardware (router, switch and cable) and software (VPN), the computing hardware (SBC like RaspberryPi, TinyMiniMicro PC like Dell Optiplex, Mini-ITX motherboard with CPU, ~~a big ass rackable 19" Threadripper~~), the storage for OS and media and always keep an eye on the budget, which is not infinite.


# Computing unit

To define most of the hardware we first have to find the processor we would like to use. The main concern is the power consumption and the capability to transcode video.
Diving in the documentation, [Jellyfin recommend](https://jellyfin.org/docs/general/administration/hardware-selection/#server-with-integrated-graphics) the use of few specific processors : Intel Core i5-11400, Intel Pentium Gold G7400, Intel N100, Apple M series or newer (excluding Intel J/M/N/Y series up to 11th gen). On top of being great at transcoding for it power consumption, the N100 is frequently available already mounted on a mini-ITX motherboard.  
Through my research I found a lot of cheap chinese micro PC with N100 but those are limited mostly allowing 16 Go of memory limit and not suitable for a raid due to the lack of sata connections without easy solution.

# Storage

In this project, we're going to have two main types of storage.  

Since the recommended memory for most OS + tools will be 32 Go and the need for fast drive, any kind of SSD will suffice.  

And for "media storage", a RAID 5 array with 4 $\times$ 2 To WD Red Plus 2 To 3.5" HDD at 5400 RPM disks is used today on the current homelab.
This kind of RAID is convenient because this kind of array combines flexibility, security and the can easily be expanded.  

# Hardware

## Already available hardware

Build 1 :
- case : Aerocool vs1
- psu : Corsair RM750x
- motherboard : MSI 990FXA gaming
- RAM : G.SKILL ripjawsZ DDR3 4 Go \times 4 = 16 Go
- GPU : MSI RX 480 4G
- CPU : AMD FX-8370 @4.00GHz
- CPU fan : be quiet Pure wings 2

Build 2 :
- case : Enermax Skalene 
- psu : Corsair HX750i
- motherboard : MSI Z97 Gaming 5
- RAM : G.SKILL ripjawsZ DDR3 4 Go \times 4 = 16 Go
- GPU : GTX 1060 3Go
- CPU : i7-4790 @ 3.60GHz
- CPU fan : be quiet

TurboNAS build :
- case : Zalman Z1 neo
- psu : Corsair CS650M
- motherboard : Asus Z97 pro gamer
- GPU : N/A
- RAM : 32 Go
- CPU : i7-4790K @ 4.00GHz
- CPU fan : Ventirad Noctua

Miscellaneous :
- Raspberry PI 2B
- Raspberry PI 4B 8Go
- Samsung SSD 850 Pro 256 Go
- 2 \times Seagate Desktop HDD 2 To
- DELL Vostro 200 (Intel Core 2 Duo E6320, 6 Go DDR2-SDRAM, HDD 160 Go)

## Possible hardware

GeeekPi 8U Server Rack DeskPi RackMate T1 for 170 €

DIGITUS Network cabinet 10 inch - 12U for 110 €

10" racks are cute but expensive and add a lot of constraints to be modular and as much dust-free as possible.

## Bought hardware

| Hardware                                     | Price     |
| -------------------------------------------- | --------- |
| Motherboard : ASRock N100DC-ITX              | 146 €     |
| DC jack 5,5 x 2,5 mm                         | 3 €       |
| Crucial RAM DDR4 32GB 3200MHz                | 57€       |
| M.2 to 6 SATA ports                          | 30 €      |
| 5.25 Inch to 5 X 3.5 Inch SATA HDD Cage Rack | 27 €      |
| **Total**                                    | **263 €** |


## Final hardware

- case : Aerocool vs1
- psu : Corsair HX750i
- motherboard : ASRock N100DC-ITX
- GPU : None
- RAM : Crucial RAM DDR4 32GB 3200MHz
- CPU : Intel N100
- CPU fan : Passive