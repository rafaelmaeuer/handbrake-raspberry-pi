#!/bin/bash

timeout=120

for (( i=0 ; i <= $timeout ; i++ )) do 
    echo "# Ausschalten in $[ $timeout - $i ]..."
    echo $[ 100 * $i / $timeout ]    
    sleep 1
done | zenity  --progress --title="Automatisch Ausschalten..."  \
    --window-icon=warning --width=400 --auto-close

if [ $? = 0 ] ; then
    echo $(date +"%T") "shutdown now"
    sudo shutdown now
else 
    echo $(date +"%T") "shutdown cancelled"
fi