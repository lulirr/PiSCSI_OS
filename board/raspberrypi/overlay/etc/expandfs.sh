#!/bin/sh

# First boot script to resize the filesystem

# Content of default fstab
# /dev/root	/			ext2	rw,noauto	0	1
# proc		/proc		proc	defaults	0	0
# devpts	/dev/pts	devpts	defaults,gid=5,mode=620,ptmxmode=0666	0	0
# tmpfs		/dev/shm	tmpfs	mode=0777	0	0
# tmpfs		/tmp		tmpfs	mode=1777	0	0
# tmpfs		/run		tmpfs	mode=0755,nosuid,nodev	0	0
# sysfs		/sys		sysfs	defaults	0	0

mount -a

fdisk /dev/mmcblk0 << EOF
d
2
n
p
2


w
EOF

resize2fs /dev/mmcblk0p2

mkdir -p /boot
mount /dev/mmcblk0p1 /boot

sed -i "s/init=\/etc\/resizefs.sh//g" /boot/cmdline.txt

reboot
