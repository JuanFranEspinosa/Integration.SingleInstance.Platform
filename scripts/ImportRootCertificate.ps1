Param(
  [string]$CA_Arn
)
write-host "arn = " $CA_Arn
$RootCAFile = "$env:TEMP\RootCA.pem"
aws acm-pca get-certificate-authority-certificate --certificate-authority-arn $CA_Arn --region eu-west-1 | jq -r .Certificate | Out-File -Encoding utf8 $RootCAFile
Import-Certificate -FilePath $RootCAFile -CertStoreLocation Cert:`\LocalMachine`\Root
