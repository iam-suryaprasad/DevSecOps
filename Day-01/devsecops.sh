#!/bin/bash

# Update package list and upgrade packages
echo "Updating package list..."
sudo apt update && sudo apt upgrade -y

# Install Python and pip
echo "Installing Python 3 and pip..."
sudo apt install python3 python3-pip python3-venv docker.io -y

# Install common DevSecOps Python packages
echo "Installing DevSecOps Python packages..."
pip3 install bandit pycryptodome boto3 python-terraform requests \
    python-nmap mypy yara-python jwt selenium pytest pylint \
    c7n pre-commit guardrails python-owasp-zap-v2.4 gitpython \
    prometheus_client elasticsearch fluent-logger

# Install Ansible
echo "Installing Ansible..."
sudo apt install ansible -y

# Install sqlmap for SQL injection testing
echo "Installing sqlmap..."
sudo apt install sqlmap -y

# Install Pipenv for dependency management
echo "Installing Pipenv..."
pip3 install pipenv

# Clean up
echo "Cleaning up..."
sudo apt autoremove -y

# Completion message
echo "DevSecOps environment setup complete!"
