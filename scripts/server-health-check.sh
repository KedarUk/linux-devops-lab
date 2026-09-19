#!/bin/bash

echo "=================================="
echo "       SERVER HEALTH CHECK"
echo "=================================="

echo
echo "HOSTNAME:"
hostname

echo
echo "UPTIME:"
uptime

echo
echo "MEMORY USAGE:"
free -h

echo
echo "DISK USAGE:"
df -h /

echo
echo "CPU INFORMATION:"
lscpu | grep "Model name"

echo
echo "=================================="
echo "           HEALTH CHECK"
echo "=================================="

# -----------------------------
# Disk Usage Check
# -----------------------------

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo
echo "Root Disk Usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -ge 90 ]; then
    echo "STATUS: CRITICAL - Disk usage is above 90%"
elif [ "$DISK_USAGE" -ge 80 ]; then
    echo "STATUS: WARNING - Disk usage is above 80%"
else
    echo "STATUS: OK - Disk usage is below 80%"
fi

# -----------------------------
# Memory Usage Check
# -----------------------------

MEMORY_USAGE=$(free | awk '/^Mem:/ {printf "%.0f", ($3/$2)*100}')

echo
echo "Memory Usage: ${MEMORY_USAGE}%"

if [ "$MEMORY_USAGE" -ge 90 ]; then
    echo "STATUS: CRITICAL - Memory usage is above 90%"
elif [ "$MEMORY_USAGE" -ge 80 ]; then
    echo "STATUS: WARNING - Memory usage is above 80%"
else
    echo "STATUS: OK - Memory usage is below 80%"
fi

echo
echo "=================================="
echo "       CHECK COMPLETED"
echo "=================================="
