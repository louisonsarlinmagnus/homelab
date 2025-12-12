---
title: Backup
draft: true
date: 2025-12-12
pin: false
# links:
#   - Test: setup/setting-up-site-search.md
# tags:
#     - test
authors:
    - louison
---

Storing and serving data is the main goal, but that data is precioussss and it would be awful to lose it.

<!-- more -->

# Backup

In my homelab I will try to implement the well known 3-2-1-0-0 golden backup rule.

> 3 copies of the data (live copy, local backup and offsite backup)  
> 2 different media (HHD powered RAID, SSD)  
> 1 copy offsite (Remote external SSD)  
> 1 copy offline (Local external SSD)  
> 0 corrupted backup  
> 0 data loss

To do this I will have to choose a strategy, tool and network protocol (for offsite) :

| Strategy | Full backup                                                                          | Incremental backup                                                                                                               |
| -------- | ------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| **Pros** | Easy to setup and restore. Each backup is autonomous, reducing the risk of data loss | Space, time and bandwidth efficient because it only backed up changed and new files                                              |
| **Cons** | Consumes more storage space, time and bandwidth                                      | More prone to corruption and more complex to restore. Often requires the last full backup and all subsequent incremental backups |

| Tool     | Dedicated tool (restic, duplicati, etc.)                                                            | Scripts (using rsync for example)                                                                                                                   |
|----------|-----------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| **Pros** | More feature rich (encryption, deduplication, version management), user interfaces and more secured | Flexible, requires fewer system resources and could be more performant                                                                              |
| **Cons** | May be more complex to setup and more resource-intensive                                            | Less feature rich (encryption, deduplication, version management to be developed), requires additional tools to secure data in transit (SSH or VPN) |

| Network  | SSH                                                                                                                | VPN                                                                      |
| -------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------ |
| **Pros** | Highly secure **for point-to-point connections**, easy to configure for specific tasks and more resource efficient | For securing a whole network traffic between two sites and more flexible |
| **Cons** | Not suitable for securing a whole network traffic between two sites                                                | More complex to configure, manage and more resource-intensive            |
