# Author: Marina Reggiani Guzzo
# Last modified: Feb 19, 2026
#
# Description: this script saves the desired variables into a .csv file. You can choose
# the time interval you want to save the data from.
#
# How to run it:
# > source back_up_everything.sh

#!/bin/bash

# ======================================= #
# This is the only block you need to edit #
# ======================================= #

# Time interval you want to save data from.
# Option 1: Last 2 hours, time_interval="start:-2h"
# Option 2: Last 2 minutes, time_interval="start:-2m"
# Option 3: Last 3 days, time_interval="start:-3d"
# Option 4: Between timestamp1 and timestamp2, time_interval="start: YYYY-MM-DDHH:MM:SSZ, stop: YYY-MM-DDHH:MM:SSZ"
time_interval="start:-60m"

# This tag allows you to add extra information on the file name, eg: myfile_60m.csv | You can leave it empty if you want
file_name_tag="60m"

# Please make sure the directory path is correct, and DO NOT include the last / in the path
dir_path="/home/syr-neutrino/Desktop/InfluxDB_Backups" 

# Choose which variables you want to create a backup for. By default, back up all variables!
# 0 = labjack | room temperature
# 1 = labjack | room humidity
# 2 = labjack | cryostat temperature top
# 3 = labjack | cryostat temperature topmiddle
# 4 = labjack | cryostat temperature bottommiddle
# 5 = labjack | cryostat temperature bottom
# 6 = labjack | cryostat pressure
# 7 = ctc | temperature
# 8 = ctc | voltage
# 9 = ctc | pressure
# 10 = ctc | heater
chosen_variables=(1 2 3 4 5 6 7 8 9 10)

# ==================================== #
# No need to change anything from here #
# ==================================== #

export influx_token_marina="wR4Kffmpp_bveSSlp6Bf2nm2Qz_9lanCEQ4GHE7jqM_PQFkmxGgYMO3eLha2Cb7nB6ahYnwJBeIstSHzGBjueA=="
org="syracuse"
bucket="larpix_longevity_test"
variables=(
    "r._measurement==\"labjack\" and r._field==\"temperature\" and r.id==\"room\""
    "r._measurement==\"labjack\" and r._field==\"humidity\" and r.id==\"room\""
    "r._measurement==\"labjack\" and r._field==\"temperature\" and r.id==\"cryostat\" and r.location==\"top\""
    "r._measurement==\"labjack\" and r._field==\"temperature\" and r.id==\"cryostat\" and r.location==\"topmiddle\""
    "r._measurement==\"labjack\" and r._field==\"temperature\" and r.id==\"cryostat\" and r.location==\"bottommiddle\""
    "r._measurement==\"labjack\" and r._field==\"temperature\" and r.id==\"cryostat\" and r.location==\"bottom\""
    "r._measurement==\"labjack\" and r._field==\"pressure\" and r.id==\"cryostat\""
    "r._measurement==\"ctc\" and r._field==\"temperature\""
    "r._measurement==\"ctc\" and r._field==\"voltage\""
    "r._measurement==\"ctc\" and r._field==\"pressure\""
    "r._measurement==\"ctc\" and r._field==\"heater\""
)
columns=(
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"id\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"id\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"id\",\"location\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"id\",\"location\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"id\",\"location\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"id\",\"location\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"id\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\""
)
file_name=(
    "labjack_temperature_room"
    "labjack_humidity_room"
    "labjack_temperature_top"
    "labjack_temperature_topmiddle"
    "labjack_temperature_bottommiddle"
    "labjack_temperature_bottom"
    "labjack_pressure_cryostat"
    "ctc_temperature"
    "ctc_voltage"
    "ctc_pressure"
    "ctc_heater"
)

# Loop over desired variables and run the command to create the backup for each of them
for i in "${chosen_variables[@]}"; do
    eval "influx query --org \"$org\" --token \"$influx_token_marina\" 'from(bucket:\"$bucket\") |> range($time_interval) |> filter(fn: (r) => ${variables[i]}) |> keep(columns:[${columns[i]}])' --raw > ${dir_path}/${file_name[i]}_${file_name_tag}.csv"
    echo ""
done
