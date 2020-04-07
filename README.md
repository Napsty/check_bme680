# check_bme680
Monitoring plugin for Bosch BME680 gas sensor

This plugin comes in two parts: `bsec_bme680` binary (which needs to be compiled) and the plugin itself `check_bme680.sh`. 

## bsec_bme680
The BME680 sensor needs to be constantly queried in order to calibrate itself and output correct raw values. This is where the `bsec_bme680` binary comes into play. Once compiled, it needs to be run on the system where the sensor is connected to (via I2C bus), for example on a Raspberry Pi. The data will be written into a log file (default: /var/log/bsec_bme680.log, can be adjusted in bsec_bme680.c). 

This binary was created by GitHub user alexh-name. The repository can be found on https://github.com/alexh-name/bsec_bme680_linux. The C file in this repository was slightly adjusted, mainly to log the results into a log file.

To compile bsec_bme680, the Bosch BSEC libary (a closed-source library) is needed and needs to be placed in the `src` folder. Please check the README file inside `src` for more information.

## check_bme680
The plugin itself is run through a monitoring agent (e.g. NRPE) and reads the last (current) line of the log file (default: /var/log/bsec_bme680.log). 
