#!/usr/bin/env bash
#set -x

function randint(){
        rndin=0
        while [ $rndin -eq 0 ]; do
                rndin=$(($RANDOM%10+1))
        echo $rndin
        done
}

function createfile(){
        local psid=`ps aux | grep -w 'ps aux$' | awk '{print $2}'`
        local numfiles=`echo $psid/100+1 | bc`
        local inputdir="$1"
        for f in `seq 1 $numfiles`; do
                touch "$inputdir"/filename."$f"
        done
}

randresult1=$(randint)
randresult2=$(randint)
randresult3=$(randint)

for i in `seq 1 $randresult1`; do
        mkdir dir$i
        for j in `seq 1 $randresult2`; do
                mkdir dir$i/fold$j
                for p in `seq 1 $randresult3`; do
                        mkdir dir$i/fold$j/dir$p
                        createfile dir$i/fold$j/dir$p
                done
        done
done
