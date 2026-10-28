#!/bin/bash

if [ "$#" -ne 3 ]; then 
	echo "Usage: ./deploy.sh <environment> <application-name> <version>"
	exit 1
fi

ENVIRONMENT=$1
APP_NAME=$2
VERSION=$3

if [ "$ENVIRONMENT" = "qa" ] || [ "$ENVIRONMENT" = "dev" ] || [ "$ENVIRONMENT" = "production" ]; then

	echo "Deployment Started"
	echo Environment: "$ENVIRONMENT"
	echo Application: "$APP_NAME"
	echo Version: "$VERSION"
else
	echo "ERROR: Invalid Environmnet" && echo "Allowed environment: dev, qa, production"
	exit 1
fi

echo Deployment successful
exit 0


