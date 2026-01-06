---
title: RAID 5 relocation
draft: false 
date: 2026-01-06
pin: false
# links:
#   - Test: setup/setting-up-site-search.md
# tags:
#     - test
authors:
    - louison
---
It's time to relocate the good old RAID 5 to the new homelab server
<!-- more -->

# Definition

RAID 5 consists of block-level striping with distributed parity. Unlike in RAID 4, parity information is distributed among the drives. It requires that all drives but one be present to operate. Upon failure of a single drive, subsequent reads can be calculated from the distributed parity such that no data is lost.

# Context

The RAID5 is constituted of four 2To HDD NAS Hard drive (WD Red Plus 2TB Internal Hard Drive 3.5" Dedicated NAS, 5400 RPM Class, SATA 6 GB/s, CMR, 64MB Cache).
The RAID is known under the name md0.

!!! tip "To add a bit of challenge, thee server is randomly rebooting for unknown reasons"

# Procedure

First let's retrieve some informations about the actual installation

```console linenums="0"
louison@turbonas:~/turbonas$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Wed Nov  2 23:45:02 2022
        Raid Level : raid5
        Array Size : 5860144128 (5588.67 GiB 6000.79 GB)
     Used Dev Size : 1953381376 (1862.89 GiB 2000.26 GB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sat Jan  3 22:06:21 2026
             State : clean 
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

              Name : turbonas:0  (local to host turbonas)
              UUID : 694560c2:f5cfb9ed:f9b426fe:a0647876
            Events : 167869

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       3       8       65        2      active sync   /dev/sde1
       5       8        1        3      active sync   /dev/sda1
```

```console linenums="0"
louison@turbonas:~/turbonas$ cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/ubuntu-vg/ubuntu-lv during curtin installation
/dev/disk/by-id/dm-uuid-LVM-kGozoEGlUCJzlum3ZYoECbC80V2ffiJ22ewGtR7F8qJaMheALEnxEst1ZJd02LMS / ext4 defaults 0 1
# /boot was on /dev/sdb2 during curtin installation
/dev/disk/by-uuid/514a4d2e-8fe6-4202-9579-927d20091322 /boot ext4 defaults 0 1
# /boot/efi was on /dev/sdb1 during curtin installation
/dev/disk/by-uuid/1767-5EBF /boot/efi vfat defaults 0 1
#/swap.img      none    swap    sw      0       0
/dev/md0    /media/raid    ext4    defaults    0    1
```

When I plugged the disks into the new server, I faced an issue with one disk. After testing data cable and power cable, I concluded that the issue was comming from the chinese M2 6SATA adapter.

Once I get all the disks connected, by some miracle, when I found out that the RAID had been automatically assemnbled.

Finally, I had to mount the RAID to the desired location and persist this mount in fstab.