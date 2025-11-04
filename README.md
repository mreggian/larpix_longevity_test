# Files in the repository

Find below a brief description of the files in this repository:

- `monitor_compressor.py`. This script retrieves information from the compressor and saves it to a database. Please make sure the compressor is connected to the network, otherwise the connection to the computer cannot be established -- this is often done by forwarding the network from the computer via an ethernet cable.

- `monitor_ctc100.py`. This script retrieves information from the ctc100 device and saves it to a database. Please make sure the usb port used by the ctc100 device is set to executable, otherwise the connection to the computer cannot be established.

- `monitor_labjack.py`. This script retrieves information from the labjack device and saves it to a database.

- `syracuse_start_monitoring_all_variables.sh`. This script starts grafana-cloud server and runs the three scripts above, each one in a different terminal.
