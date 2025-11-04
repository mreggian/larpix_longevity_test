# Initial requirements

You should have the following files in your directory:

- Install virtual environment with all packages:
  ```
  python3 -m venv my_new_env
  source my_new_env/bin/activate
  pip install -r /path/to/requirements.txt
  ```

- `.token`. It is a file that simply contains the grafana-cloud token.

- `influxdb_config.py`. This is a python script with the following variables: `token`, `ORG`, `url` and `BUCKET`, which are all information about your InfluxDB database.

# Files in the repository

Find below a brief description of the files in this repository:

- `monitor_compressor.py`. This script retrieves information from the compressor and saves it to a database. Please make sure the compressor is connected to the network, otherwise the connection to the computer cannot be established -- this is often done by forwarding the network from the computer via an ethernet cable.

- `monitor_ctc100.py`. This script retrieves information from the ctc100 device and saves it to a database. Please make sure the usb port used by the ctc100 device is set to executable, otherwise the connection to the computer cannot be established.

- `monitor_labjack.py`. This script retrieves information from the labjack device and saves it to a database.

# How to run scripts

- Start influxdb, grafana-cloud server and run the scripts that collect information from compressor, ctc100 and labjack, each one in a different terminal.
  ```
  source syracuse_start_monitoring_all_variables.sh
  ```

- If you want to run the scripts for the compressor, ctc100 and labjack individually, do the following:
  Make sure grafana-cloud is active
  ```
  source start_grafana_cloud.sh
  ```
  Then, on a different terminal, prepare environment and run the script you want:
  ```
  # set the environment
  source /home/syr-neutrino/Desktop/Longevity_Test/larpix/bin/activate

  # activate InfluxDB server
  sudo systemctl start influxdb
  sudo systemctl enable influxdb

  # set usb port to executable (only for compressor)
  sudo chmod a+rw /dev/ttyUSB0

  # run python script, make sure the name is correct
  python3 monitor_compressor.py
  ```
