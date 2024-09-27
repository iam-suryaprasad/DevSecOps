#Day-03 shell scripting
##1. Output Redirection-For-While

-> ls -al 
This is standard input.
Then we give ls -al as input and we get the output.

Then I was enter the command Surya Prasad. i get the below output
I can't find the command -> this is a standard error.

Below Shell script that handle standard input and standard error include commands to list files. Check disk space Show memory usage Displays the system hostname. and handle standard errors...

nano script.sh
#!/bin/bash
ls -al
Surya Prasad
df-h
surya
free
suryarao
cat/etc/hostname
surya prasad

bash script.sh 2>/dev/null -> This script gives the standard error (stderr) 
bash script.sh 1>/dev/null -> This script gives the standard output (stdout)

I want to run a script without printing any output to the screen.

The command bash script.sh > /dev/null 2>&1 is used to run a shell script (script.sh) to gives the below output.
>: This operator redirects standard output (stdout).
/dev/null: This is a special file that discards all data written to it. and mute any output. effectively
2>&1: This redirects standard error (stderr), file descriptor 2, to the same destination as standard output (stdout).
bash script.sh >> /tmp/error 2>&1 < /dev/null This command is used to run a shell script (script.sh) to gives the below output.
>> /tmp/error: Appends the standard output (stdout) of the script to the file /tmp/error. 


For, While loops:

##For:
Now we can write a one shell script to Listing S3 Buckets and Their Sizes using for loop

#!/bin/bash

##### List all S3 buckets
buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

##### Iterate through each bucket
for bucket in $buckets
do
    # Get the size of each bucket
    size=$(aws s3 ls s3://$bucket --recursive --human-readable --summarize | grep "Total Size" | awk '{print $3 $4}')

    # Output the bucket name and its size
    echo "Bucket: $bucket, Size: $size"
done

##### Output:
Finally, it prints the bucket name and its size like this .

Bucket: my-first-bucket, Size: 2.3 GB
Bucket: my-second-bucket, Size: 500 MB
Bucket: my-third-bucket, Size: 10.1 GB
Bucket: my-fourth-bucket, Size: 150 KB

## While
Now we can write a one shell script to find the Ip status using While loop

while true; do
    curl -SL https://www.suryaprasad.xyz/ | grep -i 'ip/205.254.169.135'
    sleep 1
done

#while true; do:
This is the beginning of an endless loop. A true condition always evaluates to true. This means that the loop will run indefinitely. Unless you stop it yourself.
#Output:
You will see the status of ip/205.254.169.135