#!bin/bash
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



#connect to an SSH given by the user
function SSH()
{
    echo "What is the IP you want to connect to?"
    read IP
    echo "What is the Username?"
    read Username
    ssh "$Username@$IP" &
    TASK
    sleep 6
    whois $IP |more
    wait
    sudo nmap -sS -D 10.7.1.80 $IP
    sudo perl nipe.pl stop
}


#check if you browse anonimusly
function ANON()
{
cd Nipe
sudo perl nipe.pl start
location=$(curl -s https://json.geoiplookup.io/|grep country_code|cut -d":" -f2|cut -d"," -f1|cut -d"\"" -f2)
if (( $location == IL ))
then 
    echo U R Not Anonimus
else 
    clear
    echo Good, your identity is safe now!
    sleep 1
    SSH
fi
}


#Install all tools needed
function INST()
{
echo "Do you want to install all tools neaded?"
echo "1/0"
read ANS1
if (($ANS1==1))
then
        git clone https://github.com/Gouveaheitor/Nipe
        sudo cpan install Try::Tiny Config::Simple JSON
        sudo perl nipe.pl install
        sudo apt-get install sshpass
        service ssh start
        ANON
    else
    ANON
fi
}


GR
INST
