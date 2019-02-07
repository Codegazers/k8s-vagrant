#!/bin/bash -x
umount /dev/sdb && true
mkdir -p $1
mkfs.xfs -f /dev/sdb
mount /dev/sdb $1
chmod -R 777  $1
[ $(grep -c /dev/sdb /etc/fstab) -eq 0 ] \
&& echo "/dev/sdb $1 xfs defaults 0 1" >> /etc/fstab

exit 0

