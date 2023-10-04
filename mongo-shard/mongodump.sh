#!/bin/bash
set -e

USER_NAME=admin
PASSWORD="" #enter your password
HOST="" # enter hostname of cluster

GREEN="\033[32m"
NORMAL="\033[0;39m"
RED="\033[31m"

echo  -e $GREEN "========================== $NORMAL"
echo  -e $GREEN "Exporting from DB...$NORMAL"
echo  -e $GREEN "USER_NAME : $RED $USER_NAME $NORMAL" 
echo  -e $GREEN "PASSWORD  : $RED $PASSWORD $NORMAL" 
echo  -e $GREEN "HOST      : $RED $HOST $NORMAL" 
echo  -e $GREEN "==========================$NORMAL"

proddatabases=(admin cavach-prod config developer-dashboard-stage hs-auth-server hs-auth-server-stage hyperfyre-prod myFirstDatabase ssi-stage studio-api studio-server vault whitelist-prod whitelist-stage)
successCount=0
failureCount=0
totalCount=${#proddatabases[@]}
index=1
for u in "${proddatabases[@]}"
do
    { 
        # try
        echo "[$index] Start Exporting $u database ================ "
		mongodump --uri="mongodb+srv://$USER_NAME:$PASSWORD@$HOST/$u?retryWrites=true&w=majority" --out='.' &
        successCount=$(( $successCount + 1 ))
        echo "End Exporting $u database  ================ "
        #save your output

    } || { 
        # catch
        # save log for exception 
        failureCount=$(( $failureCount + 1 ))
        echo "Failed Exporting; Database = ${u}"
    }
    index=$(( $index + 1 ))
done

echo "Finished all imports"
echo "Summary ====================================="
echo "Total databases to import      : $totalCount"
echo "Successfully Importing database: $totalCount"
echo "Failed Importing database      : $failureCount"
echo "============================================="

exit
