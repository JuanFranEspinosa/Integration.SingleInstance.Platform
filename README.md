# Integration.SingleInstance.platform 
****

To run in sandbox

    Prerequisits
    
        The following softs must be installed

            a- terraform
            b- Saml2Aws
            c- AWS tools

    1- Set your environment with the required variables values

        a- $env:ARTIFACTORY_ACCESS_TOKEN
        b- $env:ArcgisLoginSecret
        c- $env:ARTIFACTORY_USERNAME

    2- run ./Build.ps1 -env [sandbox - dev] -action [init/apply/destroy] -ovpbuild [OneVisionPackage branch]

        a- init: set the environment
            i- need to go to sandbox or dev directory to launch the terraform commands
                Start a VM
                    terraform apply
                Destroy the AWS VM
                    terraform destroy
        b- apply: it builds/rebuilds the AWS IntTeam VM environment
        c- destroy: it destroys the environment

Usefull outputs

    Url = "https://IntTeam-xxxxxxxx.yyyyyyy.si.enablon.io" => OneVisionServer url
    instance_name = "IntTeam-xxxxxxxx.yyyyyyy.si.enablon.io" => AWS DNS Virtual Machine name 
<!-- BEGIN_TF_DOCS -->
