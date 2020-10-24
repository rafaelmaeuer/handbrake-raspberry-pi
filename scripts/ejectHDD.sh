#!/bin/bash

drive="Name of HDD"
mount=`df -h | grep "$drive" | head -c 9`
parm=`echo "$mount" | head -c 8`

echo "unmount $mount"
sudo umount -f "$mount"
sleep 1

echo "spindown $parm"
sudo hdparm -y "$parm"
sleep 1
