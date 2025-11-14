#!/bin/bash

# Set initial day
current_day=$(date +%Y-%m-%d)

while true; do 

    new_day=$(date +%Y-%m-%d)

    # Wait until a new day is detected
    if [["$new_day" != "$current_day"]]; then

        echo "New day detected. Collecting baseline information."

        # Update the day
        current_day="$new_day"

        # Set 8 samples to nominal voltage
        python3 power_on.py --vdda 51851 --pacman_tile 1,2,3,4,5,6,7,8

        # Set boards to pedestal mode
        python3 network_single_chip_pedestal.py --pacman_tile 1,2,3,4,5,6,7,8

        # Run baseline collection script. 
        # It collects vdda, idda, vddd, iddd and pedestal for all channels (daq=10min)
        # outloc options: 1=influxdb, 2=dictionary, 3=both
        python3 measure_baseline.py --daq 600 --outloc 2

        # For the rest pf the same day, run accelerated voltages test
        while [[ "$(date +%Y-%m-%d)" == "$current_day"]]; do

            # Set higher voltages, tile=1 is used as baseline with nominal voltage
            python3 power_on.py --pacman_tile 2,3 --vdda <3.75V> --vddd <1.8V>
            python3 power_on.py --pacman_tile 4,5 --vdda <4.38V> --vddd <2.10V>
            python3 power_on.py --pacman_tile 6,7,8 --vdda <4.5V> --vddd <2.40V>

            # Set boards to pedestal mode
            pyhton3 network_single_chip_pedestal.py --pacman_tile 1,2,3,4,5,6,7,8

            # Run baseline collection script
            python3 measure_baseline.py --daq 600 --outloc 2

            # Check for failure
            python3 failure_check.py

        done

    else

        # Still the same day, keep sleeping until the day changes
        sleep 60 # check once per minute

    fi 

done