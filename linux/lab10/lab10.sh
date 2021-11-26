#!/usr/bin/env bash

#Spawn watch in background with ps
watch ps &>/dev/null &

processid=`ps aux | grep "watch ps$" | awk '{print $2}'`

cat /proc/$processid/status | grep ctxt > processinfo.txt
cat /proc/$processid/status | grep VmPeak >> processinfo.txt

kill -15 $processid
