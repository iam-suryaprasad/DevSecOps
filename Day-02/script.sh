#!bin/bash
if [ $# -gt 0 ]
then 
aws --version
if [ $? -eq 0]; then
REGIONS = $@
for REGION in ${REGIONS}; do
    aws ec2 describe-vpcs --region us-east-1 | jq ".Vpcs[].VpcId" -r
    echo '________________________'
  done
else
     echo " incorrect command "
fi
else
echo " please enter the arguments "
fi
