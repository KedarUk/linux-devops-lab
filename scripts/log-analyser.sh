#!/bin/bash

LOG_FILE="${1:-examples/sample.log}"

echo "=================================="
echo "          LOG ANALYZER"
echo "=================================="

if [ ! -f "$LOG_FILE" ]; then
    echo "ERROR: Log file not found: $LOG_FILE"
    exit 1
fi

TOTAL_LINES=$(wc -l < "$LOG_FILE")
ERROR_COUNT=$(grep -ci "ERROR" "$LOG_FILE")
WARN_COUNT=$(grep -ciE "WARN|WARNING" "$LOG_FILE")
HTTP_5XX_COUNT=$(grep -cE '\b5[0-9]{2}\b' "$LOG_FILE")
EXCEPTION_COUNT=$(grep -ci "exception" "$LOG_FILE")

echo
echo "Log File: $LOG_FILE"
echo "Total Log Lines: $TOTAL_LINES"
echo "ERROR Entries: $ERROR_COUNT"
echo "WARNING Entries: $WARN_COUNT"
echo "HTTP 5xx Entries: $HTTP_5XX_COUNT"
echo "Exception Entries: $EXCEPTION_COUNT"

echo
echo "LATEST ERROR ENTRIES:"
grep -i "ERROR" "$LOG_FILE" | tail -n 5

echo
echo "=================================="
echo "         ANALYSIS COMPLETED"
echo "=================================="
