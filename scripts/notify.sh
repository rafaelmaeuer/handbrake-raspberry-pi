#!/bin/bash

timeout=10
event={event_name}
key={ifttt_key}

notify () {
    echo $(date +"%T") "send push notification before shutdown"
    curl https://maker.ifttt.com/trigger/"$event"/with/key/"$key"
    echo "\n"
}

for (( i=0 ; i <= $timeout ; i++ )) do 
    echo "# Benachrichtigung in $[ $timeout - $i ]..."
    echo $[ 100 * $i / $timeout ]    
    sleep 1
done | zenity  --progress --title="Automatische Push-Nachricht..."  \
    --window-icon=warning --width=400 --auto-close

if [ $? = 0 ] ; then
    notify
    sudo ./shutdown.sh
else 
    echo $(date +"%T") "notification cancelled"
fi