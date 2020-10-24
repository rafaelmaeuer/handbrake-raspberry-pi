#!/bin/bash

show_delay () {
  # while [ true ]; do
    temp=`vcgencmd measure_temp`
    echo -ne "$temp\033[0K\r"
    # sleep 1
  # done
}

show_delay