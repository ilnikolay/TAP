#!/bin/sh
grep -i '.*udp.*#.*debug' /etc/services | cut -d '/' -f 1 | awk '{print $2"\t"$1}' | tee udp.debug | sort -g | tail -n 2 > udp.high
