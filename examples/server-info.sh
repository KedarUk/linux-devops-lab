#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Usage: ./server-info.sh <environment> <server-name>"
       exit 1
fi

Environment=$1
Server_Name=$2

echo "Environment: $Environment"
echo "Server_Name: $Server_Name"
exit 0

