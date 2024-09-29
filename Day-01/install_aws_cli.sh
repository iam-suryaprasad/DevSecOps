#!/bin/bash

# Step 1: Update the system
echo "Updating system packages..."
sudo apt update -y

# Step 2: Install unzip if it's not installed
echo "Installing unzip..."
sudo apt install unzip -y

# Step 3: Download AWS CLI version 2
echo "Downloading AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Step 4: Unzip the AWS CLI installation package
echo "Unzipping AWS CLI..."
unzip awscliv2.zip

# Step 5: Run the AWS CLI installer
echo "Installing AWS CLI..."
sudo ./aws/install

# Step 6: Verify AWS CLI installation
echo "Verifying AWS CLI installation..."
aws --version

# Step 7: Configure AWS CLI
echo "Configuring AWS CLI..."
aws configure

echo "AWS CLI installation and configuration complete."
