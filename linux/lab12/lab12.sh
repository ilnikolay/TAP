#!/usr/bin/env bash
#set -x

function numports(){
    ports=$(grep "/$1" /etc/services | awk '{print $2}' | cut -d/ -f1)

    port1=0
    port2=0
    port3=0
    port4=0
    port5=0
    port6=0
    port7=0
    port8=0

    for port in $ports; do
        case $port in
            [0-9]|[1-9][0-9]|[1-9][0-9][0-9]|10[0-2][0-4])
                port1=$(($port1+1)) ;;
            [1-9][0-9][0-9][0-9])
                port2=$(($port2+1)) ;;
            1[0-9][0-9][0-9][0-9])
                port3=$(($port3+1)) ;;
            2[0-9][0-9][0-9][0-9])
                port4=$(($port4+1)) ;;
            3[0-9][0-9][0-9][0-9])
                port5=$(($port5+1)) ;;
            4[0-9][0-9][0-9][0-9])
                port6=$(($port6+1)) ;;
            5[0-9][0-9][0-9][0-9])
                port7=$(($port7+1)) ;;
            *)
                port8=$(($port8+1)) ;;
        esac
    done

    echo "$1-based ports 1-1024: $port1"
    echo "$1-based ports 1025-9999: $port2"
    echo "$1-based ports 10000-19999: $port3"
    echo "$1-based ports 20000-29999: $port4"
    echo "$1-based ports 30000-39999: $port5"
    echo "$1-based ports 40000-49999: $port6"
    echo "$1-based ports 50000-59999: $port7"
    echo "$1-based ports 60000-65535: $port8"
}

numports tcp
numports udp
