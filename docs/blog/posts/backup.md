---
title: Backup
draft: true
date: 2026-01-23
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

# Backup methodology

In my homelab I will try to implement the well known 3-2-1-1-0-0 golden backup rule.

> 3 copies of the data (live copy, local backup and offsite backup)  
> 2 different media (Internal HHD, External HDD)  
> 1 copy offsite (External HDD)  
> 1 copy offline (External HDD)  
> 0 corrupted backup  
> 0 data loss

# Backup process

## Immich

```mermaid
sequenceDiagram
    box Local
        participant Internal HDD
        participant RAID5
    end
    box Remote
        participant External HDD1
        participant External HDD2
    end
    loop Every day
        RAID5->>Internal HDD: Copy raw files
    end
    loop Every odd month
        RAID5->>External HDD1: Complete backup (raw + database)
    end
    loop Every even month
        RAID5->>External HDD2: Complete backup (raw + database)
    end
```

## Vaultwarden

```mermaid
sequenceDiagram
    box Local
        participant Internal HDD
        participant RAID5
    end
    box Remote
        participant External HDD1
        participant External HDD2
    end
    loop Every day
        RAID5->>Internal HDD: Docker volume backup
    end
    loop Every odd month
        RAID5->>External HDD1: Docker volume backup
    end
    loop Every even month
        RAID5->>External HDD2: Docker volume backup
    end
```

## Paperless

To be implemented


--8<--
docs/scripts/backup.md
--8<--