## step: We can check the valid parameters are passed or not by using the below script 

#!/bin/bash
if [ $# -gt 0 ]; then
    USER=$1  # No spaces around the "="
    echo $USER
else
    echo "Please enter a valid parameter"
fi


## We need to find the how many user are there in VM by using the below script 

## There is a particular path to find the user already there or not in machine.
cat /etc/passwd 
## Now i need to find the user is there or not with user name with the help of below grep command 
cat /etc/passwd | grep -i -w Ubuntu1
##Now i want take the 1st part of the output to display the user name in output by using the below command 
cut -d ":" -f1
cat /etc/passwd | grep -i -w Ubuntu1 | cut -d ":" -f1

## Adding - User ##
#!/bin/bash
if [ $# -gt 0 ]; then
    USER=$1
    echo $USER
    EXISTING_USER=$(cat /etc/passwd | grep -i -w $USER | cut -d ":" -f1)
    if [ "$USER" = "$EXISTING_USER" ]; then
        echo "The user $USER is already present on the machine. Please enter another username."
    else
        echo "Let's create a new user."
        sudo useradd -m $USER --shell /bin/bash
    fi
else
    echo "Please enter valid parameters."
fi

##password ##
#Now we need to write a script for generating password

#!/bin/bash
# Check if a username is provided as an argument
if [ $# -gt 0 ]; then
    USER=$1
    echo $USER
       EXISTING_USER=$(cat /etc/passwd | grep -i -w $USER | cut -d ":" -f1)
    # Check if user already exists
      if [ "${USER}" = "${EXISTING_USER}" ]; then
        echo "The $USER you have entered is already present in the machine, Please Enter the Another USername"
    else
        echo "Creating new username: $USER"
        sudo useradd -m $USER --shell /bin/bash

        # Generate a random password with a special character
        SPEC=$(echo '!@#$%^&*()_' | fold -w1 | shuf | head -1)
        PASSWORD="P@ssw0rd${RANDOM}${SPEC}"

        # Set the password for the new user
        echo "$USER:$PASSWORD" | sudo chpasswd
        echo "The temporary password for $USER is: ${PASSWORD}"

        # Expire the password so the user has to change it on first login
        passwd -e $USER
    fi
else
    echo "Please Enter the Valid parameter."
fi

#Now we can use the sed stream editor to modify the sshd_config file, particularly changing the PasswordAuthentication.

sed -i “58 s/.*PasswordAuthentication.*/PasswordAuthentication yes/g” /etc/ssh/sshd_config

##Multi User passing ##
# Now we can passing the multiple user with the help of for loop and generating the random password with the help of special characters

# Check if any username is passed as an argument
if [ $# -gt 0 ]; then
    for USER in "$@"; do
        echo $USER
        EXISTING_USER=$(cat /etc/passwd | grep -i -w $USER | cut -d ":" -f1)
        # Check if the user already exists
        if [ "${USER}" = "${EXISTING_USER}" ]; then
            echo "The $USER you have entered is already present in the machine, Please Enter the Another USername"
        else
            echo "Lets Create a new Username"
            sudo useradd -m "$USER" --shell /bin/bash

            # Generate a random password with a special character
            SPEC=$(echo '!@#$%^&*()_' | fold -w1 | shuf | head -1)
            PASSWORD="P@ssw0rd${RANDOM}${SPEC}"

            # Set the password for the new user
            echo "$USER:$PASSWORD" | sudo chpasswd

            # Check if the password was set successfully
            if [ $? -eq 0 ]; then
                echo "The temporary password for $USER is: $PASSWORD"
                # Expire the password to force change at first login
                passwd -e "$USER"
            else
                echo "Failed to set password for $USER."
            fi
        fi
    done
else
    echo "Please Enter the Valid parameter."
fi
