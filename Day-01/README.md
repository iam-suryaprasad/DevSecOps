#  shell scripting

. First, we need to install net-tools to use `ifconfig` and `nslookup`.

sudo apt install net-tools -y && sudo apt install unzip -y && sudo apt install jq -y

##### Explanation:

. sudo apt install net-tools -y: Installs net-tools (for ifconfig).
. sudo apt install unzip -y: Installs unzip (for extracting ZIP files).
. sudo apt install jq -y: Installs jq (a tool for processing JSON).

### for loop

#!/bin/bash

for i in {1..10}; do
    echo $(date)
done

##### Explanation:
. for i in {1..10}; do: This initializes a loop that will run 10 times.
. echo $(date): This prints the current date and time for each iteration.
. done: This marks the end of the loop.

#!/bin/bash

for i in {1..10}; do
    echo $(date) | awk '{print $1}'
    sleep 1
done

##### Explanation:
. for i in {1..10}; do: This loop will iterate 10 times.
. echo $(date) | awk '{print $1}': This command prints the first field (the day of the week) from the date output.
. sleep 1: This pauses the loop for 1 second after each iteration.
. done: This marks the end of the loop.



#!/bin/bash

for i in {1..10}; do
    echo $(date) | awk '{print $1, $2, $3, $4}'
    sleep 1
done

##### Explanation:
. for i in {1..10}; do: This starts a loop that will run 10 times.
. echo $(date) | awk '{print $1, $2, $3, $4}': This prints the first four fields of the date output:
. $1: Day of the week
. $2: Month
. $3: Day of the month
. $4: Time
. sleep 1: This pauses the loop for 1 second after each iteration.
. done: This indicates the end of the loop.

### Variables

##### Example: Simple Variable
#!/bin/bash
###### Define a variable
name="Surya Prasad"
###### Access and print the variable
echo $name

### diff b/w Single Quotes and Double Quotes 

. Single Quotes ('): Treat everything as a literal string.
. Double Quotes ("): Allow variable expansion and interpret special characters.

##### Example: Single Quotes

#!/bin/bash

name="Surya Prasad"
fullname='Mokadi - $name'  
echo "$fullname"

##### Explanation:
.Variable Assignment:
  . name="Surya Prasad": Assigns the value Surya Prasad to name.
  . fullname='Mokadi - $name': The $name is treated literally as the string $name, not its value.
. Printing the Value:
  . echo "$fullname": This will print Mokadi - $name.

##### Example: Double Quotes

#!/bin/bash

name="Surya Prasad"
fullname="Mokadi - $name"
echo "$fullname"

##### Explanation:

.Variable Assignment:
  . name="Surya Prasad": Assigns the value Surya Prasad to the variable name.
  . fullname="Mokadi - $name": Uses double quotes to allow variable expansion, resulting in fullname being Mokadi - Surya Prasad.
. Printing the Value:
  . echo "$fullname": This will print Mokadi - Surya Prasad.

### cut command

aws s3 ls | cut -d " " -f1
aws s3 ls | cut -d " " -f1 > text.logs

##### Explanation:
.aws s3 ls:
  . This command lists the contents of an S3 bucket, showing details such as the last modified date, size, and file names.
. | (Pipe):
  . This operator takes the output of the command on the left (aws s3 ls) and sends it as input to the command on the right (cut).
. cut -d " " -f2:
  . cut: A command used to extract sections from each line of input.
  . -d " ": Specifies that a space is the delimiter for separating fields.
  . -f2: Indicates that you want to extract the second field from each line of the output.
  . > text.logs: will store all the extracted timestamps from the S3 listing into the file.
  . >> text.logs: If the file already exists, the new timestamps will be added to the end of the file without overwriting the existing content.

### Note
. The command aws s3 ls | cut -d " " -f1,f2,f3, cut does not support reversing fields directly. Instead, you can use awk, which allows you to control the output order more flexibly.

### awk command

. Here’s how to use awk to reverse the fields:
aws s3 ls | awk '{print $3, $2, $1}'
##### Explanation:
. awk '{print $3, $2, $1}': Prints the fields in reverse order:
 . $3: File size
 . $2: Last modified time
 . $1: Last modified date

### grep command

aws s3 ls | cut -d " " -f3 | grep -i www.
##### Explanation:
. | grep -i www.:
 . grep: This command searches for patterns in text.
 . -i: Makes the search case-insensitive, meaning it will match "www", "Www", "WWW", etc.
 . www.: The pattern to search for in the filenames. It will match any filenames containing "www".

. If wanted see only the particular entries with "www.logs,"

##### Explanation:
. | grep -E www[.]:
 . grep: Searches for lines that match a specified pattern.
 . -E: Enables extended regular expressions, allowing for more complex patterns. However, in this case, just using www. is sufficient.
 .www[.]: Matches any filenames containing "www." The brackets around the dot (.) indicate that the dot is treated as a literal character rather than a special regex character.
 ."www[-]": Matches any lines containing "www-" (the - is treated as a literal character).

### Three text editors
. Vi, Vim, and Nano

##### Create a new script file 
nano myscript.sh
#!/bin/bash
echo "Hello, World!"

. you need to give the permissions to the above file
chmod +x myscript.sh
###### Run your script
./myscript.sh

### set -x command

set -x command mainly using to check the debugging purposes.

##### Enable Debugging:
#!/bin/bash
set -x  # Enable debugging

##### Disable Debugging:
set +x  # Disable debugging

##### Output
bash script.sh
+ grep -E 'www[.]'
+ cut -d '' -f3
+ aws s3 ls 


















