#!/bin/ksh
clear
printf "\nThis script must be run with elevated privileges. It will fail otherwise!"
printf "\n\nTo shred an attached hard drive, enter full /dev path."
printf "\n\nThe openssl and pv packages must be installed to use this script"
printf "\n\nWhich device would you like to shred?: "

read devPath

while [[ ! "$passes" = +([0-9]) ]]; do
	printf "\nHow man passes would you like to do?: "
	read passes
done

printf "\nWhat blocksize would you like to use? (#K|M|G|T): "
read bs

i=1
while [[ $i -le $passes ]]; do
	key=$(head -n 2048 /dev/urandom | base64 | tail | tr '\r\n' '\0')
	printf "\n\nPass $i of $passes \n\n"
	openssl enc -aes128 -k "$key" < /dev/zero | pv > $devPath -B $bs
	let i=i+1
done
