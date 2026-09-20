echo "=================================="
echo "       PROCESS MONITOR"
echo "=================================="

echo
echo "TOP 10 PROCESSES BY CPU USAGE:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 11

echo
echo "TOP 10 PROCESSES BY MEMORY USAGE:"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 11

echo
echo "TOTAL RUNNING PROCESSES:"
ps -e --no-headers | wc -l

echo
echo "CURRENT LOAD:"
uptime

echo
echo "=================================="
echo "       CHECK COMPLETED"
echo "=================================="
