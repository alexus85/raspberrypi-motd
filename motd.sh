let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

scriptdir=`dirname "$BASH_SOURCE"`

read one five fifteen rest < /proc/loadavg

echo -e "\e[32m
   .~~.   .~~.    `date +"%A, %e %B %Y, %r"`
  '. \ ' ' / .'   `uname -srmo`\e[31m
   .~ .~~~..~.    
  : .~.'~'.~. :   \e[39m Uptime: \e[96m[ ${UPTIME} ]\e[31m
 ~ (   ) (   ) ~ $($scriptdir/piStats/cpu_stat.sh)\e[31m
( : '~'.~.'~' : )$($scriptdir/piStats/mem_stat.sh)\e[31m
 ~ .~ (   ) ~. ~ $($scriptdir/piStats/cpu_temp_stat.sh)\e[31m
  (  : '~' :  )  $($scriptdir/piStats/gpu_temp_stat.sh)\e[31m
   '~ .~~~. ~'    
       '~'
\e[39m"