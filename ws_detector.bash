#!/bin/bash

# Prompt the user to enter the directory path to scan
echo "Enter the path of the website directory you want to scan (press Enter to use the default: /var/www/html):"
read -r USER_DIR

# Path to the Web directory to scan
WEB_DIR="${USER_DIR:-/var/www/html}"

# Keywords commonly found in Web Shell scripts
KEYWORDS=(
  "eval(" "base64_decode(" "shell_exec(" "exec(" "system(" "passthru(" "decrypt(" "hardLogin(" "setcookie(" "md5("
)

# Tools for additional scanning
CLAMSCAN="clamscan -r --detect-pua=yes"
LOG_FILE="/var/log/webshell_scan.log"

# Check if ClamAV is installed and install it if necessary
if ! command -v clamscan &> /dev/null; then
    echo "ClamAV (clamscan) not found. Installing..."
    sudo apt install clamav -y
fi

# Function to check files for suspicious content
check_file_content() {
  local file=$1
  for keyword in "${KEYWORDS[@]}"; do
    if grep -q "$keyword" "$file"; then
      echo "[!] Suspicious Web Shell pattern detected in: $file (keyword: $keyword)" | tee -a "$LOG_FILE"
    fi
  done
}

# Scan directory using find and grep for suspicious content
find "$WEB_DIR" -type f -name "*.php" | while read -r file; do
  check_file_content "$file"
done

# Run additional scans with ClamAV
echo "Running ClamAV scan..." | tee -a "$LOG_FILE"
$CLAMSCAN "$WEB_DIR" | tee -a "$LOG_FILE"

echo "Scan completed. Results saved to $LOG_FILE."
