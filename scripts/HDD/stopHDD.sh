#!/bin/bash

file=/home/pi/HDD.mount
mount=`cat "$file"`
parm=`echo "$mount" | head -c 8`
file=/home/pi/HDD.log

echo "unmount $mount" &> "$file"
sudo umount -f "$mount" &>> "$file"
sleep 1

echo "spindown $parm" &>> "$file"
sudo hdparm -y "$parm" &>> "$file"
sleep 1
