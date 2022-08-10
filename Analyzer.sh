#!/bin/bash
#Made by Yuval Ben Shimon

#Greatings the UserName by time
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

#Analayze the memory file
function MEM()
	{
		foremost $file -o $HOME/Desktop/memoryFile/foremost
		binwalk $file > $HOME/Desktop/memoryFile/binwalk
		strings $file > $HOME/Desktop/memoryFile/strings
		sleep 1
		echo "Your resoults have been saved on your Desktop ('memoryFile' Directory)"
	}



function VOL()
	{
		echo "Do you have Volatility installed?"
		echo "(y/n)"
		read VolAns
		if [[ $VolAns == "y" ]]
			then  echo "Enter your Vollatility path"
			read volPath
			mkdir $HOME/Desktop/memoryFile/Volatility
			$volPath -f $file sockets > $HOME/Desktop/memoryFile/Volatility/sockets
			$volPath -f $file pslist > $HOME/Desktop/memoryFile/Volatility/pslist
			$volPath -f $file pstree > $HOME/Desktop/memoryFile/Volatility/pstree
			MEM
		elif [[ $VolAns == "n" ]]
			then MEM
		fi
	}



#Analayze the HDD file
function HDD()
	{
		foremost $file -o $HOME/Desktop/HDDfile/foremost
		binwalk $file > $HOME/Desktop/HDDfile/binwalk
		strings $file > $HOME/Desktop/HDDfile/strings
		echo "Your resoults have been saved on your Desktop ('HDDfile' Directory)"
	}



#ask for a file, check the file's type and create a directory base on the type
function  GET()
	{
	echo Enter your HDD or Memory file
	read file
	filetype=$(file -b $file)
	if [[ $filetype == "data" ]]
		then mkdir $HOME/Desktop/memoryFile
		VOL
	elif [[ $filetype == "EWF/Expert Witness/EnCase image file format" ]]
		then mkdir $HOME/Desktop/HDDfile
		HDD
	else echo Unsaported file Type
	fi
	}
GR
GET