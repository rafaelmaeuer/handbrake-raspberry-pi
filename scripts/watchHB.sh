#!/bin/bash

init=true
refresh=10
limit=400

# Start HandBrake GUI
echo $(date +"%T") "Start HandBrake GUI"
ghb %f &

# Monitor HandBrake
while [ true ]; do
    pid=`pidof ghb`
    if [ "$init" = false ] && [ -z $pid ]; then
        echo $(date +"%T") "HandBrake Stopped - shutting down"
        sudo ./notify.sh
    elif [ $pid ]; then
        if [ "$init" = true ]; then
            echo $(date +"%T") "HandBrake Running - limit CPU to" $limit
            init=false
            # Limit CPU usage
            sudo cpulimit -b -l $limit -p $pid
        fi
    else
        echo $(date +"%T") "Handbrake Starting - wait"
    fi
    sudo ./temperature.sh
    sleep $refresh
done