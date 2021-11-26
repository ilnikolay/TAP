#!/usr/bin/env bash
#set -x

#Creating arrays from the commands output
mountpoint=(`df -h | awk '{print $6}' | grep -v Mounted`)
diskusage=(`df -h | awk '{print $5}' | grep -v Use% | cut -d% -f1`)


count=0
arrayleng=${#diskusage[@]}


while [ $count -lt $arrayleng ]
do
if [ ${diskusage[$count]} -lt 20 ]; then
	echo -e "${mountpoint[$count]} \t Low"
	elif [ ${diskusage[$count]} -lt 40 ] && [ ${diskusage[$count]} -ge 20 ]; then
		echo -e "${mountpoint[$count]} \t Average"
	elif [ ${diskusage[$count]} -lt 60 ] && [ ${diskusage[$count]} -ge 40 ]; then
		echo -e "${mountpoint[$count]} \t High"
	elif [ ${diskusage[$count]} -lt 90 ] && [ ${diskusage[$count]} -ge 60 ]; then
		echo -e "${mountpoint[$count]} \t Warning"
	else
		echo "${mountpoint[$count]} Danger"
fi
	((count++))
done
