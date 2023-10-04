#!/bin/bash
set -e

USER_NAME=
PASSWORD=
HOST=localhost:2717


GREEN="\033[32m"
NORMAL="\033[0;39m"
RED="\033[31m"

echo  -e $GREEN "========================== $NORMAL"
echo  -e $GREEN "Import into DB...$NORMAL"
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
        echo -e $GREEN "[$index] Start Importing $u database ================ $NORMAL"
        mongorestore --uri="mongodb://$HOST/" -d $u ./$u
        successCount=$(( $successCount + 1 ))
        echo -e $GREEN "End Importing ================$NORMAL"
        #save your output

    } || { 
        # catch
        # save log for exception 
        failureCount=$(( $failureCount + 1 ))
        echo "Failed Importing; Database = ${u}"
    }
    index=$(( $index + 1 ))
done

echo -e $GREEN "Finished all imports$NORMAL"
echo -e $GREEN "Summary =====================================$NORMAL"
echo -e $GREEN "Total databases to import      : $RED $totalCount $NORMAL"
echo -e $GREEN "Successfully Importing database: $RED $totalCount $NORMAL"
echo -e $GREEN "Failed Importing database      : $RED $failureCount $NORMAL"
echo -e $GREEN "=============================================$NORMAL"

exit