#!/bin/bash

mountpoint=`mount |grep "/dev/mmcblk0p2" |awk '{print $3}'`
if [[ $mountpoint == "" ]]; then
	echo "The log partition has not been mounted, exit"
	exit 0
fi
mkdir -p ${mountpoint}/wifi
testTime=`date +%Y%m%d.%H.%M.%S`
LOGFILE="${mountpoint}/wifi/${testTime}.txt"

wifi_test() {	
	declare -i count                                                        
        count=0	
	if [[ ! -e "/usr/advtest/tool/burnin/scripts/burnin_ping_IP_config.sh" ]]; then
        	WEBSERVER=`ifconfig wlan0 |grep 'inet addr' |cut -d : -f2 | awk 'BEGIN {FS="."} {print $1 "." $2 "." $3 "."}'`1
		echo "Don't edit Ping IP test configuration in main menu, currently use default wlan0 ping IP \"$WEBSERVER\" "
		echo "[`date +%Y%m%d.%H.%M.%S`]    use default wlan0 ping IP \"$WEBSERVER\" " >> $LOGFILE	
	else
        	WEBSERVER=`cat /usr/advtest/tool/burnin/scripts/burnin_ping_IP_config.sh |grep 'wlan0_PING_IP' |awk 'BEGIN {FS="="} {print $2}'` 
       		echo "Currently use wlan0 ping IP \"$WEBSERVER\" that has been configured in ./scripts/burnin_ping_IP_config.sh "
		echo "[`date +%Y%m%d.%H.%M.%S`]    use wlan0 ping IP \"$WEBSERVER\" " >> $LOGFILE	
	fi
	
	if [[ $1 -eq 0 ]]; then		
		while true;do
			((count++))
			echo "[`date +%Y%m%d.%H.%M.%S`]    (count:$count / infinite)" >> $LOGFILE
			(ping $WEBSERVER -I wlan0 -c 1 2>&1 | tee -a $LOGFILE) 2>&1 > /dev/null
		done
	else			
		for((i=1;i<=$1;i++)) do
			((count++))
			echo "[`date +%Y%m%d.%H.%M.%S`]    (count:$count / $1)" >> $LOGFILE
			(ping $WEBSERVER -I wlan0 -c 1 2>&1 | tee -a $LOGFILE) 2>&1 > /dev/null
		done
		echo "Test is completed!!!" >> $LOGFILE
	fi	     
}

echo "Wifi Log file : ${LOGFILE}"
echo "${LOGFILE} \\" >> cache.txt
wifi_test $1
