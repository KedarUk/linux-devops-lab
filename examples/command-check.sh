#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./command-check.sh <directory>"
    exit 1
fi

Directory="$1"

[ -d "$Directory" ]
Status=$?

if [ "$Status" -eq 0 ]; then
    echo "Success: Directory exists"
    echo "Directory check passed" && echo "Ready to continue"
else
    echo "Error: Directory does not exist"
    exit 1
fi

exit 0
