#!/bin/bash

if [ $# -gt 0 ]; then
    aws --version
    if [ $? -eq 0 ]; then
        REGIONS="$@"
        for REGION in ${REGIONS}; do
            echo "VPCs in region: $REGION"
            aws ec2 describe-vpcs --region "$REGION" | jq ".Vpcs[].VpcId" -r
            echo '________________________'
        done
    else
        echo "Incorrect command."
    fi
else
    echo "Please enter the arguments."
fi




#!/bin/bash
echo "Welcome DevSecOps day-02"
for arg in "$*"; do
    echo "$arg"
done



