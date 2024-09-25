#Day-02 shell scripting

##1. Passing Parameters
##2. Understanding special Variables: $?, $@, $*, $#

###### Below AWS CLI command for describing a VPC in a specific region

command: aws ec2 describe-vpcs --region us-east-1

command : aws ec2 describe-vpcs --region us-east-1 | jq ".Vpcs[].VpcId" -r

1. aws ec2 describe-vpcs --region us-east-1:
  ->This section calls the AWS CLI to describe all VPCs in the specified zone (us-east-1), returning JSON output with details about the VPCs.
2. | jq ".Vpcs[].VpcId" -r:
  -> pipe (|) takes the output from the previous command and sends it to jq
     jq processes JSON data:
  -> Vpcs[] accesses the array of VPCs in the response.
  -> VpcId Retrieves the VPC ID for each VPC.
    The -r flag outputs a raw string. This means that the VPC ID is typed without quotes.

###### We need to remove the double quotes from the output by using this command | tr -d '"'.

command : aws ec2 describe-vpcs --region us-east-1 | jq ".Vpcs[].VpcId" | tr -d '"'

###### We can Converts any lowercase letters in the output to uppercase by using this command  | tr '[:lower:]' '[:upper:]'

command : aws ec2 describe-vpcs --region us-east-1 | jq ".Vpcs[].VpcId" | tr -d '"' | tr '[:lower:]' '[:upper:]'

Every time we enter this command, it takes a very long time. Therefore, we had to write shell scripts to efficiently extract VPC details.

nano script.sh

#!/bin/bash
REGUION=$1
aws ec2 describe-vpcs --region us-east-1 | jq ".Vpcs[].VpcId" -r

This is not a recommended way to get the job done. Now we need to follow the steps below to write a shell script to efficiently retrieve VPC details.

#!/bin/bash
REGION="$1,$2,$3"
aws ec2 describe-vpcs --region us-east-1 | jq ".Vpcs[].VpcId" -r
Now we need to execute the shell script by passing three parameters
bash script.sh us-east-1 us-east-2 us-west-2 

We do not pass the $0 parameter because it represents the name of the script.
script.sh - $0
us-east-1 - $1
us-east-2 - $2
us-west-2 - $3

Every time we have to refer to REGION as "$1,$2,$3" it is an inconvenience. Now we need to solve this problem using $@ to better handle all the supplied arguments.

Before moving on to $@, it's important to understand error codes and exit codes. Because it plays an important role in determining the success or failure of commands executed within a script.

-> echo $? => 127
-> ls
-> echo $? => 0

When executing echo $?, an output of 127 indicates that the last command failed because it was not found, while an output of 0 signifies that the last command was executed successfully without any errors.

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

# Explanation 

1. Argument Check
if [ $# -gt 0 ]; then
"$#" specifies the number of arguments sent to the script. This condition checks if at least one argument is provided
2. Check AWS CLI Version
aws --version
if [ $? -eq 0 ]; then
This command checks if the AWS CLI is installed by executing aws --version. The exit status ($?) is checked to see if the command succeeded (0 indicates success).
If the AWS CLI is not found, it will fall into the else block.
3. Store Regions
REGIONS="$@"
"$@" is a special variable that represents all arguments passed to the script. The script stores these arguments in the REGIONS variable.
4. for REGION in ${REGIONS}; do
This line starts a loop that iterates over each region passed as an argument.
5. Display VPCs in Each Region
echo "VPCs in region: $REGION"
aws ec2 describe-vpcs --region "$REGION" | jq ".Vpcs[].VpcId" -r
The script prints which region's VPC is currently processing.
Run the AWS CLI command aws ec2 description-vpcs --region "$REGION" to list all VPCs in the specified region.
The output is sent to jq, which extracts and prints the VPC ID in a readable format (the -r flag outputs the raw string).
6. echo '________________________'
This line prints an underscore line for better readability of output from different regions.
7. else
    echo "Incorrect command."
If an AWS CLI command fails (for example, if it is not installed or there is another issue), this message will appear.
8. No Arguments Provided
else
    echo "Please enter the arguments."
fi
If no arguments are specified for the script This message prompts the user to enter those arguments.

## $*

#!/bin/bash
#!/bin/bash
echo "Welcome DevSecOps day-02"
for arg in "$*"; do
    echo "$arg"
done

bash script.sh Special "Thanks to" saikiran pinapathruni
Output be like:
Welcome DevSecOps day-02
Special Thanks to saikiran pinapathruni
