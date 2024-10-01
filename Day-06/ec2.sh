#!/bin/bash

# Variables
REGION="us-east-1"                 # AWS region (e.g., us-east-1)
AGE_MINUTES=5                      # Number of minutes to check for unused instances
TMP_FILE="/tmp/unused_instances.txt"

# Function to calculate the cutoff date for instance age
calculate_cutoff_date() {
    echo $(date -d "$AGE_MINUTES minutes ago" --utc +%Y-%m-%dT%H:%M:%S.000Z)
}

# Function to fetch unused (stopped) instances
fetch_unused_instances() {
    local cutoff_date=$1
    echo "Fetching instances stopped for more than $AGE_MINUTES minutes in the $REGION region..."
    
    # Fetching instances and ensuring output is correctly formatted
    aws ec2 describe-instances \
        --region "$REGION" \
        --query 'Reservations[*].Instances[?State.Name==`stopped` && LaunchTime<=`'"$cutoff_date"'`].InstanceId' \
        --output text | tr '\t' '\n' > "$TMP_FILE"  # Convert tabs to newlines
}

# Function to check if any unused instances were found
check_unused_instances() {
    if [[ ! -s $TMP_FILE ]]; then
        echo "No unused instances found older than $AGE_MINUTES minutes."
        exit 0
    fi
    
    echo "The following unused instances have been found:"
    cat "$TMP_FILE"
}

# Function to get manager approval for deletion
get_manager_approval() {
    read -p "Do you have manager approval to delete these instances? (yes/no): " APPROVAL
    if [[ "$APPROVAL" != "yes" ]]; then
        echo "Deletion cancelled. Please obtain manager approval before proceeding."
        exit 1
    fi
}

# Function to delete unused instances
delete_unused_instances() {
    echo "Proceeding with instance deletion..."
    
    while IFS= read -r instance_id; do
        # Trim whitespace from the instance ID
        instance_id=$(echo "$instance_id" | xargs)
        
        if [[ ! -z "$instance_id" ]]; then  # Check if the instance ID is not empty
            # Debugging output
            echo "Attempting to terminate instance: $instance_id"
            aws ec2 terminate-instances --instance-ids "$instance_id" --region "$REGION"
            echo "Instance $instance_id has been terminated."
        else
            echo "Warning: Encountered an empty instance ID, skipping..."
        fi
    done < "$TMP_FILE"
    
    echo "All unused instances have been successfully terminated."
}

# Main script execution
cutoff_date=$(calculate_cutoff_date)      # Calculate cutoff date
fetch_unused_instances "$cutoff_date"     # Fetch unused instances
check_unused_instances                     # Check if any unused instances were found
get_manager_approval                       # Get manager approval for deletion
delete_unused_instances                    # Delete the instances if approved
