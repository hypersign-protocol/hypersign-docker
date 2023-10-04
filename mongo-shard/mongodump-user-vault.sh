#!/bin/bash
set -e

USER_NAME=admin
PASSWORD="" #enter your password
HOST=cluster0.jg0ef.mongodb.net

GREEN="\033[32m"
NORMAL="\033[0;39m"
RED="\033[31m"

echo  -e $GREEN "========================== $NORMAL"
echo  -e $GREEN "Exporting from DB...$NORMAL"
echo  -e $GREEN "USER_NAME : $RED $USER_NAME $NORMAL" 
echo  -e $GREEN "PASSWORD  : $RED $PASSWORD $NORMAL" 
echo  -e $GREEN "HOST      : $RED $HOST $NORMAL" 
echo  -e $GREEN "==========================$NORMAL"

proddatabases=(hs:vault:3utmmvHNjTHfBi-KOUzuSwNXzi0 hs:vault:54RjQ0wl9SWPHRQFvsWOa6B4VJg hs:vault:6AztkaFT4W-iegNvcN3M7qrmL8s hs:vault:6IVsc-qm3RdZ-puqFWZ6WnILR5A hs:vault:8iqi3rby0K-Sn3o4sNFae3ayNbc hs:vault:9tbQQjZeicZvnKd_gk2SwP6f03M hs:vault:AcoTNUM3Oqn981cWj9RuTLBHcxE hs:vault:B7zbOwN3rH1F-Jf5_7Sy5fvvyYw hs:vault:DZapkY3bnrZ3vj7kBAooVI6Sio4 hs:vault:DikIjWimel_M6HYc8qsz3q8WrJw hs:vault:ES1hZPd3VQuOBVaEw8-OjGmexAo hs:vault:I-v0lfWkWICwtUCSzoxv_urVpT8 hs:vault:JJhK60QGu_JK7I1JiD6M8j1ZH-s hs:vault:L46_T6yaqjzEbOeUT4prGni9sHs hs:vault:NZRnnQr_e5yFnpUoKQtyp9hkmZo hs:vault:NczGN02Uln_xjVybUqVYjfI51jY hs:vault:P-sQE_qb3LPMg1-JfISjCaWKPX8 hs:vault:QPtzHFBEvDOQAzvwmc7MAe6I31w hs:vault:QTx3MGxEyDuoxmhGaYqX7AfXqMs hs:vault:QhoAGmrPx06wzBeUpFXV5a9t1tA hs:vault:SeeQ-O8CT-JThxUuSzrg6oyGFEQ hs:vault:TYj8SbKIfCS9c--IUAR9TAdxncI hs:vault:VNmF8XdARqoR0blQCLk4Dhc-I7g hs:vault:VyeBXKrBoWuCrs19cbF46oQzzeI hs:vault:dpP3Vwnu23N0ffQoHeGjXeCf5mg hs:vault:f_9aWaEUYdUPohqsL36Fdi7PLYk hs:vault:gIaDPJ1qRCs06PDAYGbTo5olTGU hs:vault:ggKpXKowPirWL8oJsE2ux3GA85Q hs:vault:gmyltDM9Vh7tCtIArgcMtjtKVbE hs:vault:hXMM5Yx9r6S6ScQJxc6WKXwJ49I hs:vault:j5S1O6EbI_AsOyu096pBR_RAeJg hs:vault:nZRJ5I9piHUIuBRXa8l7pR5AfMU hs:vault:rAe84A62AarwvACbatwhl00ryC8 hs:vault:rkBsPbuypvm-tt7RT-T1C6p08-c hs:vault:rzbiqi4PrO4Ll62HingRhDZ6JDQ hs:vault:vP8W_GxhbRxAzPdh--k1FmUMwsk hs:vault:wGAjOxD_P-EvEVE0sx-yWKnbVmo hs:vault:wkUmmvDvFxUIxOTAThVycTftXu0)
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
