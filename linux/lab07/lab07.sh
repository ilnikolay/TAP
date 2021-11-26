#!/usr/bin/env bash
#set -x

if [ $# -eq 0 ] || [ $1 = "--help" ]; then
	echo -e "For help use $0 --help\n"
	echo -e "Delete all files with size 0B in the folder name passed as argument."
	echo -e "\texample: $0 /home/$USER"
	echo -e "Create folder equal to the first argument in which of files equal to the second argument will be create."
	echo -e "\t$0 dirname 5"

	elif [ -n "$1" ] && [ "$#" -eq "1" ]; then
		if [ -d $1 ]; then
			echo "Deleting 0B files in $1"
			find $1 -type f -size 0b -delete
			else
				echo "There is no such directory" 
		fi
	elif [ "$#" -eq "2" ] && [ -n $1 ] && [ ! -d $1 ]; then
		echo "$2" | grep -q "^[0-9]*$"
		exitcode="$?"
		if [ $exitcode -eq 0 ] && [ $2 -gt 0 ]; then
			mkdir $1
			count=0
			cd $1
			while [ $count -lt $2 ]
			do
			touch filename.$count
			((count++)) 
			done
		else
			echo "Please enter integer as second argument."
		fi
	elif [ "$#" -eq "2" ] && [ -d $1 ]; then
		echo "You are trying to create directory that already exist."
	else
		echo "Please use --help argument. And start again."
fi
