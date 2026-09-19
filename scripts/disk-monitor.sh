#!/bin/bash

echo "================================"
echo "       DISK USAGE MONITOR"
echo "================================"

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo
echo "Root Disk Usage : ${DISK_USAGE}%"

if [ "$DISK_USAGE" -ge 90 ]; then
        echo "STATUS: CRITICAL - Disk usage is above 90%"
elif "$DISK_USAGE" -ge 80 ]; then
        echo "STATUS : WARNING - Disk usage is above 80%"
else
        echo "STATUS: OK - Disk usage is below 80%"
fi

echo
echo "Disk Details"
df -h


echo
echo "=================================="
echo "         CHECK COMPLETED"
echo "=================================="
