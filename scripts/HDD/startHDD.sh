#!/bin/bash

drive="{Name of Drive}"
mount=`df -h | grep "$drive" | head -c 9`
file=/home/pi/HDD.mount

echo "$mount" > "$file"
