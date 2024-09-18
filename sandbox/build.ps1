Param(
  [string]$Environment = "sandbox",
  [string]$Action = "init",
  [array[]]$Packages
)
$randomNumber = Get-Random -Minimum 1000 -Maximum 10000
write-host "randomNumber = $randomNumber"

Write-Host "environment = $Environment"
Write-Host "Action = $Action"
Write-Host "Packages = $Packages"
$CAArn = "arn:aws:acm-pca:eu-west-1:052856013734:certificate-authority/5cdc57c4-0a85-4c85-917a-5d7e47e73a60"
Write-Host "CA Arn=$CAArn"
$env:TF_VAR_artifactory_access_token = $env:ARTIFACTORY_ACCESS_TOKEN
Write-Host "artifactory_access_token=$env:TF_VAR_artifactory_access_token"
$env:TF_VAR_artifactory_username = $env:ARTIFACTORY_USERNAME
Write-Host "artifactory_username=$env:TF_VAR_artifactory_username"
$env:TF_VAR_arcgis_login_secret = $env:ArcgisLoginSecret
Write-Host "arcgis_login_secret=$env:TF_VAR_arcgis_login_secret"
$env:TFPath = "./terraform"
write-host "TFPath=$env:TFPath"
$env:TF_VAR_domain_name = "$Environment.enablon.io"
$env:TF_VAR_instance_name = "intteam-localrun-$randomNumber"
Write-Host "instance_name=$env:TF_VAR_instance_name"

function Test-SemVer {
  param (
      [string]$version
  )

  $semverPattern = '^\d+\.\d+\.\d+(-\S+)?$'
  if ($version -match $semverPattern) {
      $TypeOfPackage = "ShowCase"
  } else {
      $TypeOfPackage = "Ondemand"
  }
  return $TypeOfPackage
}

$TypeOfPackage = Test-SemVer $Packages[1]

write-host "switch is $TypeOfPackage"

if ($TypeOfPackage -eq "Ondemand") {
  $PackageDictionary = @{}

  foreach ($tuple in $Packages) {
    $product = $tuple[0]
    $version = $tuple[1]
    if ($PackageDictionary.ContainsKey($product)) {
        $PackageDictionary[$product] += , $version
    } else {
        $PackageDictionary[$product] = @($version)
    }
  }
  $env:TF_VAR_packages = "["

  foreach ($product in $PackageDictionary.Keys) {
    foreach ($version in $PackageDictionary[$product]) {
        $env:TF_VAR_packages += @"
{
product = "$product"
version = "$version"
},
"@
        if (-not ($product -eq $PackageDictionary.Keys[-1] -and $version -eq $PackageDictionary[$product][-1])) {
            $env:TF_VAR_packages += "`n"
        }
    }
  }

  $env:TF_VAR_packages = $env:TF_VAR_packages.TrimEnd(",")  # Supprime la virgule en trop à la fin
  $env:TF_VAR_packages += "]"
}
elseif ($TypeOfPackage -eq "ShowCase") {
  $env:TF_VAR_packages = @"
  [{
    product = "$($Packages[0][0])"
    version = "$($Packages[1][0])"
  }]
"@
}
Write-Host "newPackagesString = $env:TF_VAR_packages"

Function SetBackend {
  $backendfile = "backend-config.tf"
  $BackendPath = "$env:TFPath/$backendfile"
  $BackendPathContent = Get-Content -Path $BackendPath
  $BackendPathModified = $BackendPathContent -replace "ToBeChanged", "integration-$randomNumber/tfstate-$env:TF_VAR_instance_name"
  Set-Content -Path $BackendPath -Value $BackendPathModified
}

function InitVM {
  Push-Location -Path $env:TFPath
  & terraform init -reconfigure
  Pop-Location 
}

function ApplyVM {
  Push-Location -Path $env:TFPath
  & terraform apply -auto-approve
  Pop-Location
}

function PlanVM {
  Push-Location -Path $env:TFPath
  & terraform plan
  Pop-Location
}

function DestroyVM {
  Push-Location -Path $env:TFPath
  & terraform destroy -auto-approve
  Pop-Location
}

if ($Action -eq "init") {
  SetBackend
  InitVM
}
elseif ($Action -eq "plan") {
  SetBackend
  InitVM
  PlanVM
}
elseif ($Action -eq "apply") {
  SetBackend
  ../scripts/ImportRootCertificate.ps1 -CA_Arn $CAArn
  InitVM
  ApplyVM
}
elseif ($Action -eq "destroy") {
  SetBackend
  DestroyVM
}
else {
  Write-Host "Invalid action"
  exit 1
}
