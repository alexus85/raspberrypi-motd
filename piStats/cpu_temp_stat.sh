#!/bin/bash
LOG_DIR="/home/pi/piStats/logs/";
LOG_TSTMP=$(date +%d"-"%Y);
LOG_NAME="cpu-temp-$LOG_TSTMP.log";

cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
cpuTemp1=$(($cpuTemp0/1000))
cpuTemp2=$(($cpuTemp0/100))
cpuTempM=$(($cpuTemp2 % $cpuTemp1))
cpuTempM="$cpuTemp1"."$cpuTempM";

showTemperature(){ # $1 label, $2 cur_temp
	int_p=`echo $2 | awk '{ print int($1/10) }'`;
	echo -ne "\e[39m  $1 [ ";
	for i in $(seq 1 10); do
			if [ $i -le $int_p ]; then
					echo -ne "\e[31m#"
			else
					echo -ne "\e[32m#"
			fi
	done
	echo -ne "\e[39m ]"
	
	if (( $(echo "$2 > 80" |bc -l) )); then
		echo -ne " - \e[31m$2"
	elif (( $(echo "$2 > 55" |bc -l) )); then
		echo -ne " - \e[33m$2"
	else
		echo -ne " - \e[32m$2"
	fi
	echo -n $'\xc2\xb0'C
}

showTemperature "CPU" $cpuTempM

echo -e "\e[39m"

if [ -z $1 ] || [ $1 != "--no-log" ]; then
	echo $(date +" [ "%d-%m-%Y" "%T" ]")" - CPU: $cpuTempM"$'\xc2\xb0'C >> $LOG_DIR$LOG_NAME
fi