Param(
  [string]$Environment = "dev",
  [string]$Action = "init",
  [array[]]$Packages,
  [string]$BuildCounter
)
Write-Host "environment = $Environment"
Write-Host "Action = $Action"
Write-Host "PackageName = $Packages"
write-host "BuildCounter = $BuildCounter"
$CAArn = "arn:aws:acm-pca:eu-west-1:634773506107:certificate-authority/09c978c4-6b47-4ca6-9911-6c4a7af31bea"
Write-Host "CA Arn=$CAArn"
Set-Item -Path Env:/TF_VAR_artifactory_access_token -Value  $env:ARTIFACTORY_ACCESS_TOKEN
Write-Host "ar<# tifactory_access_token=$env:TF_VAR_artifactory_access_token"
Set-Item -Path Env:/TF_VAR_artifactory_username -Value  $env:ARTIFACTORY_USERNAME
Write-Host "artifactory_username=$env:TF_VAR_artifactory_username"
Set-Item -Path Env:/TF_VAR_arcgis_login_secret -Value  $env:ArcgisLoginSecret
Write-Host "arcgis_login_secret=$env:TF_VAR_arcgis_login_secret"
Set-Item -Path Env:/TFPath -Value  "./terraform"
write-host "TFPath=$env:TFPath"
Set-Item -Path Env:/TF_VAR_domain_name -value $Environment".enablon.io"
Set-Item -Path Env:/TF_VAR_instance_name -Value "intteam-$BuildCounter"
Write-Host "instance_name=$env:TF_VAR_instance_name"

# set teamcity env variables
"##teamcity[setParameter name='env.packages' value='$env:TF_VAR_packages']"


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

$TypeOfPackage=Test-SemVer $Packages[1]

write-host "switch is "$TypeOfPackage

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
    $BackendPathModified = $BackendPathContent -replace "ToBeChanged", "integration-$BuildCounter/tfstate-$env:TF_VAR_instance_name"
    Set-Content -Path $BackendPath -Value $BackendPathModified
  }


  function InitVM {
    Push-Location -Path $env:TFPath
    & "$env:ChocolateyInstall/lib/terraform/tools/terraform.exe" init -reconfigure
    Pop-Location 
  }

  function ApplyVM {
    Push-Location -Path $env:TFPath
    & "$env:ChocolateyInstall/lib/terraform/tools/terraform.exe"  apply -auto-approve
    Pop-Location
  }

  function PlanVM {
    Push-Location -Path $env:TFPath
    & "$env:ChocolateyInstall/lib/terraform/tools/terraform.exe"  plan
    Pop-Location
  }

  function DestroyVM {
    Push-Location -Path $TFPath
    & "$env:ChocolateyInstall/lib/terraform/tools/terraform.exe"  destroy -auto-approve
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
    ../scripts/ImportRootCertificate.ps1 $CAArn
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