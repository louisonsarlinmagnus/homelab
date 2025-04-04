---
title: Architecture and hardware overview
draft: true 
date: 2025-04-04
pin: false
# links:
#   - Test: setup/setting-up-site-search.md
# tags:
#     - test
authors:
    - louison
---

This article explores the architecture and hardware of a scalable hosting service that utilizes Docker Swarm for efficient container orchestration and a Network-Attached Storage (NAS) system for centralized data management. It outlines essential design principles and evaluates various hardware options, including servers, networking equipment, and storage solutions.

<!-- more -->

# Introduction

A complete satisfying homelab is more complex to setup than a Raspberry Pi, Docker and a domain name (even if it can suffice). For my project I have to think about the case/rack, the network hardware (router, switch and cable) and software (VPN), the computing hardware (SBC like RaspberryPi, TinyMiniMicro PC like Dell Optiplex, Mini-ITX motherboard with CPU, ~~a big ass rackable 19" Threadripper~~), the storage for OS and media and always keep an eye on the budget, which is not infinite.

# Needs

Before emptying the bank account with useless stuff, I have to clearly define what I want my homelab to be capable of.  


# Computing unit

To define most of the hardware we first have to fin 

https://jellyfin.org/docs/general/administration/hardware-selection/#server-with-integrated-graphics

# Storage

In this project, we're going to have two main types of storage.  

Since the recommended memory for most OS + tools will be 32 Go and the need for fast drive, any kind of SSD compatible with the node's hardware will suffice.  

And for "media storage", a RAID 5 array with 4 $\times$ 2 To WD Red Plus 2 To 3.5" HDD at 5400 RPM disks is used today on the current homelab.
This kind of RAID is convenient because this kind of array combines flexibility, security and the can easily be expanded.  

# Backup

In my homelab I will try to implement the well known 3-2-1-0-0 golden backup rule.

> 3 copies of the data (live copy, local backup and offsite backup)  
> 2 different media (HHD powered RAID, SSD)  
> 1 copy offsite (Remote external SSD)  
> 1 copy offline (Local external SSD)  
> 0 corrupted backup

To do this I will have to choose a strategy, tool and network protocol (for offsite) :

| Strategy | Full backup                                                                          | Incremental backup                                                                                                               |
| -------- | ------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| **Pros** | Easy to setup and restore. Each backup is autonomous, reducing the risk of data loss | Space, time and bandwidth efficient because it only backed up changed and new files                                              |
| **Cons** | Consumes more storage space, time and bandwidth                                      | More prone to corruption and more complex to restore. Often requires the last full backup and all subsequent incremental backups |

| Tool     | Dedicated tool (restic, duplicati, etc.)                                                            | Scripts (using rsync for example)                                                                                                                   |
| -------- | --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Pros** | More feature rich (encryption, deduplication, version management), user interfaces and more secured | Flexible, requires fewer system resources and could be more performant                                                                              |
| **Cons** | May be more complex to setup and more resource-intensive                                            | Less feature rich (encryption, deduplication, version management to be developed), requires additional tools to secure data in transit (SSH or VPN) |

| Network  | SSH                                                                                                                | VPN                                                                      |
| -------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------ |
| **Pros** | Highly secure **for point-to-point connections**, easy to configure for specific tasks and more resource efficient | For securing a whole network traffic between two sites and more flexible |
| **Cons** | Not suitable for securing a whole network traffic between two sites                                                | More complex to configure, manage and more resource-intensive            |




# Hardware

## Case/Rack

https://www.amazon.fr/GeeekPi-RackMate-Rackmount-Equipment-Aluminium/dp/B0CS6MHCY8?__mk_fr_FR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=RDCS8HEO8HJU&dib=eyJ2IjoiMSJ9.f_miWmhZCSaGYhNWf7Lh5zcqSO3cfHLtE8_ihwUSjzFPwgx6F-RMH_TLpSmMN-JNrFwVw9km3IH4m9tXAMx9vJjtBo-vGlgtDJUEdF2BMjNmilN7bMCm0spqmNAoTgBdUgQ6ldm2bHumToCys9VnGIb9td8C3prj7ekj2j1zBpb0iq2P0HYWxYhCBi1FrWymdvxkpvuzEBrtai2OkF7nElJi2s1_lHKEsSMt6GksCd4G_fsbbZsGrl7RQ3Tzi95CnKXeoyq1T_Pv4SsVk6EOqRFcqhB0GSOLh4AjLW1kapzxtkx5xYLEqwtl9fQtP8fp2I8QsMk3FArWTN3kBAW1HbnkcrGIcCpBPk5TX7BNe3I.31kix-MdoGpWJOnqxllc9Dx9xZNs-Wt0DYN4IuX4GKQ&dib_tag=se&keywords=mini+rack+t2&qid=1742373051&s=computers&sprefix=mini+rack+t2%2Ccomputers%2C74&sr=1-2

https://www.amazon.fr/DIGITUS-Armoire-r%C3%A9seau-pouces-592x312x300mm/dp/B08XJL6KK8?__mk_fr_FR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=2YFKF1P6PDIQ5&dib=eyJ2IjoiMSJ9.wlYF-AEd_GIZWobQp-gjQ1ntEDa-HtutA_YjcGp7mT52TQQVD-K6MB2YNhYcx4bgjOT7NU5jJXjCFitB0Q3WQh8TNy6QDLCW78RKvA26CZZI6docC5mjcnaIHXoJSb-VXgKwYoqOTYp_ynLe6RWzMLIbJkbB-AL-mrcdE_4GLkb2_3K-6yq3O6ATmHc2HSCEeRKqwKJQzPyJto65G4gzH8vOCKTpGe1aCmdJ-EfaDQM60NZTLYzKKwwctPzGMAp7Q7WiRnk8LpLZ2qtJvOkpiUV-EuoHxQxTIEpPiXy9RcAQPZXarRHMRQMnza8gFc3ZuEXF6CPKIu9k-4YjtXQ7mfLgvDA8De8Ot74fBfwan1Y.CmZVi-3MEEri1OWQIghM1S7i2ulbuDHpwotMCEdHYkU&dib_tag=se&keywords=10%2Binch%2Brack&qid=1742389797&refinements=p_85%3A20934937031&rnid=20934936031&rps=1&s=computers&sprefix=10%2Binch%2Brack%2Ccomputers%2C84&sr=1-17&th=1

## PEO switch

https://www.amazon.fr/Digitus-Professional-95317-Gigabit-Ethernet/dp/B079J62RX8?__mk_fr_FR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3MLMC03IU7X9A&dib=eyJ2IjoiMSJ9.l-udsaTc51EvKX3S-Ui_dTVcEKlg2xdKmrS_Sr3tubt5Ga5IsyfYQtQNqc1PCl4gkKq6S7Lg6jjlkHs-1Qs1SNNQCXg6qVtREM1aIRtJ35UhvtGI_QP8ekTJ7A6Xg6RGUJ16NITu8iNSYtvw3WGEbOxcIldvNOYGQYuoMTX10bt4VhVEc5o_m8WElEx0Rhlq8t3DyfCZuI0znedLtsehu1xoBZq5Q6n8axl94B7ciJ4ScpzQtQoLAXEtcNiWMPaPjCbcWhCwod_pNjyktgfAAwowU-xLy5EQ-PBKdDTe8Dqp9Kk94ZC3iIwzhJRICtOoA6CXgDf3nJDyFvaWEq7Vckc6_vHZkyF4iGwYzlkqORI.-2Gjc9sanssFoIBCiQZ41y-KJJuqu7KX8312QKTD_hQ&dib_tag=se&keywords=10%2Binch%2Bswitch%2Bpoe%2B8%2Bports&qid=1742397683&s=computers&sprefix=10%2Binch%2Bswitch%2Bpoe%2B8%2Bports%2Ccomputers%2C80&sr=1-3&th=1

https://www.amazon.fr/Mercusys-Installation-Surveillance-Polyvalent-MS108GP/dp/B0C3D21DKJ?crid=1KJCJ86YOSWTU&dib=eyJ2IjoiMSJ9.1GrVl7xz9USSXOYJqmc9CbjdBAP08ozmc4a9vHJfEqL7-zWfeRd6aUX7EECkwib3g4MkM_7a917EpqrsUYXm2Xd80AVaAU6M182InI02p7EhvtGI_QP8ekTJ7A6Xg6RGATB2kUmC9mfbv3sjcnj_uMsOUVQz1ppq6fVTb2L1eFqkpoSr6uWcUxUKPhRZzG0JcBLqYQlrOj7SOoN7xRm57bi7k8TDOTz3aC1L2ORHBMEM4aVGHqrwYd3dDC0lKG_F2t5ccwlMVir4im7futWwbjojK_-um6BqQ1hmfqs8xof3ZfCnJuElmVCe2s_GbWxE0HMphv_-VFNH9nQKhOg5aSPJmwkr7KUhHYLDPEBbQAM.b3_VM4VXYDvJe_A580UgtXdnuIglBvErZk5W7hAghFg&dib_tag=se&keywords=switch%2Bpoe%2B8%2Bports&qid=1742392409&s=computers&sprefix=poe%2Bswitch%2Ccomputers%2C206&sr=1-3&th=1

# Conclusion
