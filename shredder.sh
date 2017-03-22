#!/bin/bash
clear
printf "\nThis script must be run with elevated privileges. It will fail otherwise!"
printf "\n\nTo shred an attached hard drive, enter full /dev path."
printf "\n\nThe openssl and pv packages must be installed to use this script"
printf "\n\nWhich device would you like to shred?: "

read devPath

passes=""
while [[ ! $passes =~ ^[0-9]+$ ]]; do
	printf "\nHow man passes would you like to do?: "
	read passes
done

printf "\nWhat blocksize would you like to use?: "
read bs

for I in `seq 1 $passes`; do
	key=`head -c 2048 /dev/urandom | base64 --wrap=0`
	printf "\n\nPass $I of $passes \n\n"
	openssl enc -aes128 -k "$key" < /dev/zero | pv > $devPath -B $bs
	#openssl enc -aes128 -k "$key" < /dev/zero | pv | dd of=$devPath bs=$bs
done
