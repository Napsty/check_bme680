#!/bin/bash
################################################################################
# Script:       check_bme680.sh                                                #
# Author:       Claudio Kuenzler (www.claudiokuenzler.com)                     #
# Purpose:      Monitor Bosch BME680 sensor                                    #
# Full Doc:     claudiokuenzler.com/monitoring-plugins/check_bme680.php        #
#                                                                              #
# License:      GNU General Public Licence (GPL) http://www.gnu.org/           #
# This program is free software; you can redistribute it and/or                #
# modify it under the terms of the GNU General Public License                  #
# as published by the Free Software Foundation; either version 2               #
# of the License, or (at your option) any later version.                       #
#                                                                              #
# This program is distributed in the hope that it will be useful,              #
# but WITHOUT ANY WARRANTY; without even the implied warranty of               #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                 #
# GNU General Public License for more details.                                 #
#                                                                              #
# You should have received a copy of the GNU General Public License            #
# along with this program; if not, see <https://www.gnu.org/licenses/>.        #
#                                                                              #
# Copyright 2020 Claudio Kuenzler                                              #
#                                                                              #
# History:                                                                     #
# 20200407 Development started (not finished!)                                 #
################################################################################
# Usage:
################################################################################
# Definition of variables
version="0.1"
STATE_OK=0              # define the exit code if status is OK
STATE_WARNING=1         # define the exit code if status is Warning
STATE_CRITICAL=2        # define the exit code if status is Critical
STATE_UNKNOWN=3         # define the exit code if status is Unknown
PATH=/usr/local/bin:/usr/bin:/bin # Set path
bsec_logfile=/var/log/bsec_bme680.log
################################################################################
# Mankind needs help
help="$0 v ${version} (c) 2020-$(date +%Y) Claudio Kuenzler and contributors (open source rulez!).
Usage: $0 [-l /path/to/logfile.log]"
################################################################################
# Get user-given variables
while getopts "l:" Input;
do
       case ${Input} in
       l)      bsec_logfile=${OPTARG};;
       *)      echo -e "${help}"; exit $STATE_UNKNOWN;;
       esac
done
################################################################################
# Sanity checks
if ! [[ -f $bsec_logfile ]]; then 
  echo "BME680 CRITICAL - Cannot read logfile $bsec_logfile"; exit $STATE_CRITICAL
fi
################################################################################
# Log parsing
lastresult=$(tail -n 1 ${bsec_logfile} | sed "s/\n//g" | sed "s/\r//g")
sensor_time=$(echo "$lastresult"|awk -F';' '{print $1}')
sensor_iaq_accuracy=$(echo "$lastresult"|awk -F';' '{print $2}')
sensor_iaq_value=$(echo "$lastresult"|awk -F';' '{print $3}')
sensor_temperature=$(echo "$lastresult"|awk -F';' '{print $4}')
sensor_humidity=$(echo "$lastresult"|awk -F';' '{print $5}')
sensor_pressure=$(echo "$lastresult"|awk -F';' '{print $6}')
sensor_gas=$(echo "$lastresult"|awk -F';' '{print $7}')
sensor_co2=$(echo "$lastresult"|awk -F';' '{print $8}')
sensor_bvoc=$(echo "$lastresult"|awk -F';' '{print $9}')

echo "BME680 OK - Air Quality is good (${sensor_iaq_value}), Gas: ${sensor_gas}ohm, Temp: ${sensor_temperature} C, Humidity: ${sensor_humidity}%, Pressure: ${sensor_pressure}hPa, CO2: ${sensor_co2}, bVOCe: ${sensor_bvoc} |iaq_score=${sensor_iaq_value};;;0;500 gas=${sensor_gas};;;; temp=${sensor_temperature};;;; humidity=${sensor_humidity};;;0;100 pressure=${sensor_pressure};;;; iaq_accuracy=${sensor_iaq_accuracy};;;0;3"
exit $STATE_OK
