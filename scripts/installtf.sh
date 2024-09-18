#!/bin/bash

if command -v terraform &> /dev/null
then
    echo "Terraform is already installed"
else
    echo "Terraform is not installed. Installing Terraform..."
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common || { echo "Failed to install prerequisites"; exit 1; }
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg || { echo "Failed to add HashiCorp GPG key"; exit 1; }
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list || { echo "Failed to add HashiCorp repository"; exit 1; }
    sudo apt-get update && sudo apt-get install -y terraform 
    if command -v terraform &> /dev/null
    then
        echo "Terraform has been installed"
    else
        echo "Failed to install Terraform"
        exit 1
    fi
fi