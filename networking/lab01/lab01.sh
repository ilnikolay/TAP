#!/usr/bin/env bash

macip=`ip addr show dev eth0 | grep -A1 "link/ether" | awk '{print $1 ": " $2}'`
gtway=`ip route | grep "default via" | awk '{print $3}'`
mask=`ip addr show dev eth0 | grep -w  "inet" | awk '{print $2}' | cut -d/ -f2`
hosts=$(((2**(32-$mask))-2))
wbsrvport=`sudo netstat -4tupan | grep "nginx: master"`

htmlinx="/home/ec2-user/websrv/index.html"

echo \<html\> > $htmlinx
echo \<body\> >> $htmlinx

echo "$macip<br>" >> $htmlinx
echo "default gateway: $gtway<br>" >> $htmlinx
echo "Hosts: $hosts<br>" >> $htmlinx
echo "Webserver ipv4 port: $wbsrvport<br>" >> $htmlinx

echo \<\/body\> >> $htmlinx
echo \<\/html\> >> $htmlinx
