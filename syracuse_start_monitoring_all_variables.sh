#!/bin/bash

# start grafana cloud
# make sure to save the grafana-cloud token as an environment variable
# > export MY_GRAFANA_CLOUD_TOKEN="the-secret-token"
MY_GRAFANA_CLOUD_TOKEN=$(<.token)
gnome-terminal -- bash -c "echo 'Start Grafana Cloud'; source start_grafana_cloud.sh; exec bash"

# monitor variables from labjack
gnome-terminal -- bash -c "echo 'Start collecting data from LabJack'; cd /home/syr-neutrino/Desktop/Longevity_Test; source larpix/bin/activate; cd larpix-5x5-test; python3 monitor_labjack.py --sleeptime 10; exec bash"

# monitor variables from ctc100
gnome-terminal -- bash -c "echo 'Start collecting data from CTC100'; sudo chmod a+rw /dev/ttyUSB0; cd /home/syr-neutrino/Desktop/Longevity_Test; source larpix/bin/activate; cd larpix-5x5-test; python3 monitor_ctc100.py --sleeptime 10; exec bash"

# monitor variables from compressor
gnome-terminal -- bash -c "echo 'Start collecting data from Compressor'; cd /home/syr-neutrino/Desktop/Longevity_Test; source larpix/bin/activate; cd larpix-5x5-test; python3 monitor_compressor.py --sleeptime 10; exec bash"
