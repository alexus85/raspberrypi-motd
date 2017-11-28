#!/bin/bash
LOG_DIR="/home/pi/piStats/logs/";
LOG_TSTMP=$(date +%d"-"%Y);
LOG_NAME="gpu-temp-$LOG_TSTMP.log";

gpuTemp0=$(/opt/vc/bin/vcgencmd measure_temp) # 
gpuTemp0=${gpuTemp0//\'C/} # remove 'C from string
gpuTemp0=${gpuTemp0//temp=/} # remve temp= from string

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

showTemperature "GPU" $gpuTemp0

echo -e "\e[39m"

if [ -z $1 ] || [ $1 != "--no-log" ]; then
	echo $(date +" [ "%d-%m-%Y" "%T" ]")"- GPU: $gpuTemp0"$'\xc2\xb0'C >> $LOG_DIR$LOG_NAME
fi