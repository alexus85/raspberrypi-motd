#!/bin/bash
LOG_DIR="/home/pi/piStats/logs/";
LOG_TSTMP=$(date +%d"-"%Y); 
LOG_NAME="cpu_usage-$LOG_TSTMP.log"

p=$( mpstat | awk '$12 ~ /[0-9.]+/ { print 100 - $13 }' );
int_p=`echo $p | awk '{ print int($1) }'`;
progress=$(( $int_p/10 ));
if [ $progress -lt 1 ]; then
        progress=1;
fi
echo -ne "\e[39m  CPU [ ";
for i in $(seq 1 10); do
        if [ $i -le $progress ]; then
                echo -ne "\e[31m#"
        else
                echo -ne "\e[32m#"
        fi
done
echo -ne "\e[39m ]"

if (( $(echo "$p > 80" |bc -l) )); then
	echo -ne " - \e[31m""$p%"
elif (( $(echo "$p > 60" |bc -l) )); then
	echo -ne " - \e[33m""$p%"
else
	echo -ne " - \e[32m""$p%"
fi

echo -e "\e[39m"

if [ -z $1 ] || [ $1 != "--no-log" ]; then
	echo $(date +" [ "%d-%m-%Y" "%T" ]")" - $p%" >> $LOG_DIR$LOG_NAME
fi