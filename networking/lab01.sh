#!/usr/bin/env bash

macip=`ip addr show dev eth0 | grep -A1 "link/ether" | awk '{print $1 ": " $2}'`
gtway=`ip route | grep "default via" | awk '{print $3}'`
mask=`ip addr show dev eth0 | grep -w  "inet" | awk '{print $2}' | cut -d/ -f2`
hosts=$(((2**(32-$mask))-2))
wbsrvport=`sudo netstat -4tupan | grep "nginx: master"`



echo \<html\> > /home/ec2-user/websrv/index.html
echo \<body\> >> /home/ec2-user/websrv/index.html

echo "$macip<br>" >> /home/ec2-user/websrv/index.html
echo "default gateway: $gtway<br>" >> /home/ec2-user/websrv/index.html
echo "Hosts: $hosts<br>" >> /home/ec2-user/websrv/index.html
echo "Webserver ipv4 port: $wbsrvport<br>" >> /home/ec2-user/websrv/index.html

echo \<\/body\> >> /home/ec2-user/websrv/index.html
echo \<\/html\> >> /home/ec2-user/websrv/index.html
