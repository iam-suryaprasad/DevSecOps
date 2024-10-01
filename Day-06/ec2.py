import boto3
from datetime import datetime, timedelta

# Constants
REGION = 'us-east-1'  # AWS region
AGE_MINUTES = 5       # Number of minutes to check for unused instances

# Function to calculate the cutoff datetime for instance age
def calculate_cutoff_datetime():
    return datetime.utcnow() - timedelta(minutes=AGE_MINUTES)

# Function to fetch unused (stopped) instances
def fetch_unused_instances(ec2_client, cutoff_datetime):
    print(f"Fetching instances stopped for more than {AGE_MINUTES} minutes in the {REGION} region...")
    instances_to_terminate = []

    # Describe instances
    response = ec2_client.describe_instances()
    
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            # Check if the instance is stopped and older than the cutoff datetime
            if instance['State']['Name'] == 'stopped':
                launch_time = instance['LaunchTime'].replace(tzinfo=None)
                if launch_time <= cutoff_datetime:
                    instances_to_terminate.append(instance['InstanceId'])
    
    return instances_to_terminate

# Function to get manager approval for deletion
def get_manager_approval():
    approval = input("Do you have manager approval to delete these instances? (yes/no): ")
    return approval.lower() == 'yes'

# Function to delete unused instances
def delete_unused_instances(ec2_client, instances):
    if not instances:
        print("No unused instances found.")
        return

    print("Proceeding with instance deletion...")
    for instance_id in instances:
        ec2_client.terminate_instances(InstanceIds=[instance_id])
        print(f"Instance {instance_id} has been terminated.")

# Main execution
if __name__ == "__main__":
    # Initialize the EC2 client
    ec2_client = boto3.client('ec2', region_name=REGION)
    
    cutoff_datetime = calculate_cutoff_datetime()  # Calculate cutoff datetime
    unused_instances = fetch_unused_instances(ec2_client, cutoff_datetime)  # Fetch unused instances

    if unused_instances:
        print("The following unused instances have been found:")
        print("\n".join(unused_instances))

        if get_manager_approval():  # Get manager approval for deletion
            delete_unused_instances(ec2_client, unused_instances)  # Delete the instances if approved
        else:
            print("Deletion cancelled. Please obtain manager approval before proceeding.")
    else:
        print("No unused instances found older than {} minutes.".format(AGE_MINUTES))
