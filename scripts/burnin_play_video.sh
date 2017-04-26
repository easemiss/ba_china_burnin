#!/bin/bash

mountpoint=/usr/advtest/tool/burnin/log

mkdir -p ${mountpoint}/play_video
testTime=`date +%Y%m%d.%H.%M.%S`
LOGFILE="${mountpoint}/play_video/${testTime}.txt"

VIDEO_FILE="/usr/advtest/tool/burnin/data/video/Film2.AVI"

export GSTL=gst-launch-1.0
export PLAYBIN=playbin



play_video() {
        declare -i count
        count=0
	echo -n 0 > /sys/class/graphics/fb2/blank
	sleep 1
        if [[ $2 -eq 0 ]]; then
                while true
                do
                        ((count++))
                        echo "[`date +%Y%m%d.%H.%M.%S`]    (count:$count / infinite)" >> $LOGFILE
			$GSTL $PLAYBIN uri=file://$1 1>/dev/null 2>/dev/null
                        sleep 5

                done
        else
                for ((j=0; j<$2; j++))
                do
                        ((count++))
                        echo "[`date +%Y%m%d.%H.%M.%S`]    (count:$count / $2)" >> $LOGFILE
			$GSTL $PLAYBIN uri=file://$1 1>/dev/null 2>/dev/null
                        sleep 5
                done
                echo "Test is completed!!!" >> $LOGFILE
        fi
}

play_video $VIDEO_FILE $1
