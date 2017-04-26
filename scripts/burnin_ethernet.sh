#!/bin/bash


mountpoint=/usr/advtest/tool/burnin/log

mkdir -p ${mountpoint}/ethernet
testTime=`date +%Y%m%d.%H.%M.%S`
LOGFILE="${mountpoint}/ethernet/$1_${testTime}.txt"
Google=216.239.32.6


ethernet_test() {
	declare -i count                                                        
        count=0
	
	if [[ ! -e "/usr/advtest/tool/burnin/scripts/burnin_ping_IP_config.sh" ]]; then 
		
		#WEBSERVER=`ifconfig $1 |grep 'inet addr' |cut -d : -f2 | awk '{print $1}'`
		HOST_IP=$Google
		echo "Don't edit Ping IP test configuration in main menu, currently use default $1 ping Google IP \"$HOST_IP\" "  
		echo "[`date +%Y%m%d.%H.%M.%S`]    use default $1 ping IP \"$HOST_IP\" " >> $LOGFILE
	else                                                                            
        HOST_IP=`cat /usr/advtest/tool/burnin/scripts/burnin_ping_IP_config.sh |grep "$3_IP" |awk 'BEGIN {FS="="} {print $2}'`
		eth_IP=`cat /usr/advtest/tool/burnin/scripts/burnin_ping_IP_config.sh |grep "$1_IP" |awk 'BEGIN {FS="="} {print $2}'` 	
		echo "Currently use $eth_IP ping IP $HOST_IP that has been configured in ./scripts/burnin_ping_IP_config.sh "
		echo "[`date +%Y%m%d.%H.%M.%S`]    use $eth_IP ping $HOST_IP" >> $LOGFILE

	fi
	
	ifconfig $1 $eth_IP up

	if [[ $2 -eq 0 ]]; then
		while true;do
			((count++))
			echo "[`date +%Y%m%d.%H.%M.%S`]    (count:$count / infinite)" >> $LOGFILE
			(ping $HOST_IP -I $1 -c 1 2>&1 | tee -a $LOGFILE) 2>&1 > /dev/null
			#ping $HOST_IP -I $1 -c 1 
		done
	else	
		for((i=1;i<=$2;i++)) do
			((count++))
			echo "[`date +%Y%m%d.%H.%M.%S`]    (count:$count / $2)" >> $LOGFILE
			(ping $HOST_IP -I $1 -c 1 2>&1 | tee -a $LOGFILE) 2>&1 > /dev/null
		done
		echo "Test is completed!!!" >> $LOGFILE
	fi	     
}
echo "Ethernet Log file : ${LOGFILE}"
echo "${LOGFILE} \\" >> ./cache.txt
ethernet_test $1 $2 $3
