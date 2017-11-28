#!/bin/bash
LOG_DIR="/home/pi/piStats/logs/";
LOG_TSTMP=$(date +%d"-"%Y);
LOG_NAME="mem_usage-$LOG_TSTMP.log";

total_mem=$( free -m | grep "Mem" | awk '$2 ~ /[0-9.]+/ {print $2}' );
used_mem=$( free -m | grep "Mem" | awk '$2 ~ /[0-9.]+/ {print $3}' );
free_mem=$( free -m | grep "Mem" | awk '$2 ~ /[0-9.]+/ {print $4}' )

showMemUsage(){ # $1 label, $2 total, $3 cur_usage
	p=$( echo "scale=2;($3/$2)*100" | bc -l );
	int_p=`echo $p | awk '{ print int($1/10) }'`;
	echo -ne "\e[39m  $1 [ ";
	for i in $(seq 1 10); do
			if [ $i -le $int_p ]; then
					echo -ne "\e[31m#"
			else
					echo -ne "\e[32m#"
			fi
	done
	echo -ne "\e[39m ]"
	
	if (( $(echo "$p > 80" |bc -l) )); then
		echo -ne " - \e[31m$p"
	elif (( $(echo "$p > 55" |bc -l) )); then
		echo -ne " - \e[33m$p"
	else
		echo -ne " - \e[32m$p"
	fi
	echo -n "%"
}

showMemUsage "RAM" $total_mem $used_mem

echo -e "\e[39m"

if [ -z $1 ] || [ $1 != "--no-log" ]; then
	echo $(date +" [ "%d-%m-%Y" "%T" ]")" - $p%"  >> $LOG_DIR$LOG_NAME
fi
#echo "$total_mem MB - $used_mem MB - $free_mem MB"
