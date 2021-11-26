#!/bin/sh
for i in $(seq 1 10)
do
	dd if=/dev/urandom of=10MB-$(date +%M-%S).file bs=1MB count=10
	sleep 1s
done

for j in $(seq -w 00 2 59)
do
	/bin/rm 10MB-??-$j.file 2> /dev/null
done
