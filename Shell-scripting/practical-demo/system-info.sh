#!/bin/bash 

echo "========================================"
echo "       LINUX SERVER INFORMATION"
echo "========================================" 

echo ""
echo "[ SYSTEM INFORMATION ]"
echo ""
echo "Hostname       : $(hostname)"
echo "Operating OS   : $(grep 'PRETTY_NAME' /etc/os-release | cut -d'"' -f2)"
echo "Kernel Version : $(uname -r)"
echo "Current User   : $(whoami)"
echo "Date & Time    : $(date '+%a %b %d %Y')" 

echo ""
echo "[ SERVER STATUS ]"
echo ""
echo "Uptime:"
uptime -p | sed 's/up //' 

echo ""
echo "[ CPU INFORMATION ]"
echo ""
echo "CPU Architecture: $(uname -m)"
echo "CPU Cores       : $(nproc)" 

echo ""
echo "[ MEMORY INFORMATION ]"
echo ""
echo "               total   used   free"
echo "Memory         $(free -h | awk '/^Mem:/ {print $2"    "$3"    "$4}')" 

echo ""
echo "[ DISK INFORMATION ]"
echo ""
df -h / | awk 'NR==1 {printf "%-15s %-5s %-5s %-6s %-4s\n", $1, $2, $3, $4, $5} NR==2 {printf "%-15s %-5s %-5s %-6s %-4s\n", $1, $2, $3, $4, $5}' 

echo ""
echo "[ LOGGED-IN USERS ]"
echo ""
who | awk '{print $1}' | sort -u 

echo ""
echo "========================================"
echo "         REPORT COMPLETED"
echo "========================================"