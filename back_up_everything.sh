# Author: Marina Reggiani Guzzo
# Last modified: April 21, 2026
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
time_interval="start: 2025-12-15T14:00:00Z, stop: -0m" # everything from the beginning

# This tag allows you to add extra information on the file name, eg: myfile_60m.csv | You can leave it empty if you want
file_name_tag="2026-04-21"

# Please make sure the directory path is correct, and DO NOT include the last / in the path
dir_path="/home/syr-neutrino/Desktop/InfluxDB_Backups/csv_files" 

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
# 11 = pacman_boards | vdda all tiles
# 12 = pacman_boards | vddd all tiles
# 13 = pacman_boards | idda all tiles
# 14 = pacman_boards | iddd all tiles
# 15 = pacman_boards | mean_pedestal all tiles
# 16 = pacman_boards | packets all tiles
chosen_variables=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)

# Include here the ROOT token of the InfluxDB
export influx_token_marina=""

# ==================================== #
# No need to change anything from here #
# ==================================== #

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
    "r._measurement==\"pacman_boards\" and r._field==\"vdda\""
    "r._measurement==\"pacman_boards\" and r._field==\"vddd\""
    "r._measurement==\"pacman_boards\" and r._field==\"idda\""
    "r._measurement==\"pacman_boards\" and r._field==\"iddd\""
    "r._measurement==\"pacman_boards\" and r._field==\"mean_pedestal\""
    "r._measurement==\"pacman_boards\" and r._field==\"packets\""
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
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"tile\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"tile\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"tile\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"tile\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"tile\",\"channel_id\""
    "\"_time\",\"_value\",\"_field\",\"_measurement\",\"tile\",\"channel_id\""
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
    "pacman_boards_vdda_all_tiles"
    "pacman_boards_vddd_all_tiles"
    "pacman_boards_idda_all_tiles"
    "pacman_boards_iddd_all_tiles"
    "pacman_boards_mean_pedestal_all_tiles"
    "pacman_boards_packets_all_tiles"
)

# Loop over desired variables and run the command to create the backup for each of them
for i in "${chosen_variables[@]}"; do
    eval "influx query --org \"$org\" --token \"$influx_token_marina\" 'from(bucket:\"$bucket\") |> range($time_interval) |> filter(fn: (r) => ${variables[i]}) |> keep(columns:[${columns[i]}])' --raw > ${dir_path}/${file_name_tag}_${file_name[i]}.csv"
    echo ""
done
