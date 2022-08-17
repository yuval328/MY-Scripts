#!bin/bash
#Greatings UserName by time
function GR()
{
clear
currenttime=$(date +%H:%M)
   if [[ "$currenttime" > "5:01" ]] && [[ "$currenttime" < "11:59" ]]; then
     echo "//Good morning $USER\\\\"
     elif [[ "$currenttime" > "12:00" ]] && [[ "$currenttime" < "17:59" ]]; then
     echo "//Good afternoon $USER\\\\"
     else
     echo "//Good evening $USER\\\\"
   fi
echo ___________________________________
echo
}

#1 New cases
function NC()
{
if (($choice1==1))
then
#space between countries to have it work, 5 countries MAX
echo "Type countrys of choice:"
read country1 country2 country3 country4 country5
for Country in $country1 $country2 $country3 $country4 $country5
do
printf "$Country =" &&curl -s https://www.worldometers.info/coronavirus/ | grep -a2 country/$Country/ | head -n 6 | tail -n 2| head -n 1 |cut -d">" -f2 | cut -d"<" -f1
done
fi
}
#2 Total Cases
function TC()
{
if (($choice1==2))
then
#space between countries to have it work, 5 countries MAX
echo "Type countrys of choice:"
read country1 country2 country3 country4 country5
for Country in $country1 $country2 $country3 $country4 $country5
do
printf "$Country =" &&curl -s https://www.worldometers.info/coronavirus/country/$Country/|grep -a1 maincounter-number |head -n 3 |tail -n 1|cut -d">" -f2|cut -d"<" -f1
done
fi
}

#3 Total Death
function TD()
{
if (($choice1==3))
then
#Spaces between countries to have it work, 5 countries MAX
echo "Type countrys of choice:"
read country1 country2 country3 country4 country5
for Country in $country1 $country2 $country3 $country4 $country5
do
printf "$Country =" &&curl -s https://www.worldometers.info/coronavirus/country/$Country/|grep -a1 maincounter-number|head -n 7|tail -n 1|cut -d">" -f2|cut -d"<" -f1
done
fi
}

#4 Quit
function Q()
{
 if (($choice1==4))
then
clear && exit
fi   
}
#Made by Yuval Ben Shimon
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------


GR
#Main Menue
choice1=1
while [ $choice1 -lt 4 ]
do
echo "Daily new cases - 1"
echo "Total cases - 2"
echo "Total death - 3"
echo "Quit - 4"
echo "______________________"
echo
echo "Type a number of choice:"
read choice1
echo "_______________________"
echo
echo "$choice1 - Selected"
echo
echo
echo

NC
TC
TD
Q
sleep 3
clear
done

