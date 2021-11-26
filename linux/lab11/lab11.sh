#!/usr/bin/env bash

#Install net-tools package
dnf install -y net-tools

#Takes first installed binary from the package using inode number
binary=$(rpm -ql net-tools | grep bin | xargs ls -i | sort -g | head -1 | awk '{print $2}')

#First binary is netstat, using it discovers all IP packets sent from the kernel
ipout=$($binary --statistics --raw | grep "requests sent out" | awk '{print $1}')

echo $binary
echo $ipout

echo $ipout | tr "[1,3,5,7,9]" "o" | tr "[0,2,4,6,8]" "e"
