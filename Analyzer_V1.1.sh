#!/bin/bash
# Made by Yuval Ben Shimon

# Greetings the UserName by time
function GR() {
    clear
    hour=$(date +%H)
    if ((hour >= 5 && hour < 12)); then
        echo "//Good morning $USER\\\\"
    elif ((hour >= 12 && hour < 18)); then
        echo "//Good afternoon $USER\\\\"
    else
        echo "//Good evening $USER\\\\"
    fi
    echo "___________________________________"
    echo
    sleep 0.5
}

# Analyze the memory file
function MEM() {
    mkdir -p $HOME/Desktop/memoryFile
    foremost $file -o $HOME/Desktop/memoryFile/foremost
    binwalk $file > $HOME/Desktop/memoryFile/binwalk
    strings $file > $HOME/Desktop/memoryFile/strings
    sleep 1
    echo "Your results have been saved on your Desktop ('memoryFile' Directory)"
}

# Analyze the memory file using Volatility
function VOL() {
    if command -v volatility &> /dev/null; then
        volPath=$(command -v volatility)
    else
        echo "Volatility is not installed or not in your PATH."
        read -p "Please enter the path to Volatility: " volPath
    fi

    mkdir -p $HOME/Desktop/memoryFile/Volatility
    $volPath -f $file sockets > $HOME/Desktop/memoryFile/Volatility/sockets
    $volPath -f $file pslist > $HOME/Desktop/memoryFile/Volatility/pslist
    $volPath -f $file pstree > $HOME/Desktop/memoryFile/Volatility/pstree
    MEM
}

# Analyze the HDD file
function HDD() {
    mkdir -p $HOME/Desktop/HDDfile
    foremost $file -o $HOME/Desktop/HDDfile/foremost
    binwalk $file > $HOME/Desktop/HDDfile/binwalk
    strings $file > $HOME/Desktop/HDDfile/strings
    echo "Your results have been saved on your Desktop ('HDDfile' Directory)"
}

# Ask for a file, check the file's type and create a directory based on the type
function GET() {
    echo "Enter your HDD or Memory file:"
    read file

    if [[ ! -f $file ]]; then
        echo "File does not exist. Please provide a valid file."
        exit 1
    fi

    filetype=$(file -b $file)
    if [[ $filetype == "data" ]]; then
        VOL
    elif [[ $filetype == "EWF/Expert Witness/EnCase image file format" ]]; then
        HDD
    else
        echo "Unsupported file type: $filetype"
        echo "Please provide a valid memory or HDD file."
        exit 1
    fi
}

GR
GET
