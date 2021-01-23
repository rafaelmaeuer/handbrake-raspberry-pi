#!/bin/bash

file=/home/pi/HDD.mount
mount=`cat "$file"`
disk=`echo "$mount" | head -c 8`
log=/home/pi/HDD.log

echo $(date +"%T") "unmount $mount" &> "$log"
sudo umount -f "$mount" &>> "$log"
sleep 1

echo $(date +"%T") "spindown $disk" &>> "$log"
sudo hdparm -y "$disk" &>> "$log"
sleep 1
