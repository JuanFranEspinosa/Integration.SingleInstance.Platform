#!/bin/bash

CA_Arn=$1
echo "arn = $CA_Arn"
RootCAFile="/tmp/RootCA.pem"

aws acm-pca get-certificate-authority-certificate --certificate-authority-arn $CA_Arn --region eu-west-1 | jq -r .Certificate > $RootCAFile

sudo cp $RootCAFile /usr/local/share/ca-certificates/
sudo update-ca-certificates
