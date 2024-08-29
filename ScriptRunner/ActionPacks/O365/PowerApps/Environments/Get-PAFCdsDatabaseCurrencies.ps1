#Requires -Version 5.0
#Requires -Modules Microsoft.PowerApps.Administration.PowerShell

<#
.SYNOPSIS
    Returns all currencies

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
    © ScriptRunner Software GmbH

.COMPONENT
    Requires Module Microsoft.PowerApps.Administration.PowerShell
    Requires Library script PAFLibrary.ps1

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/O365/PowerApps/Environments
 
.Parameter PACredential
    Provides the user ID and password for PowerApps credentials

.Parameter LocationName
    The location of the current environment

.Parameter Filter
    Finds currencies matching the specified filter (wildcards supported)

.Parameter ApiVersion
    The api version to call with
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]   
    [pscredential]$PACredential,
    [Parameter(Mandatory = $true)]   
    [string]$LocationName,
    [string]$Filter,
    [string]$ApiVersion
)

Import-Module Microsoft.PowerApps.Administration.PowerShell

try{
    ConnectPowerApps -PAFCredential $PACredential    

    [hashtable]$getArgs = @{'ErrorAction' = 'Stop'
                            'LocationName' = $LocationName
                            }  
                            
    if([System.String]::IsNullOrWhiteSpace($Filter) -eq $false){
        $getArgs.Add('Filter',$Filter)
    }
    if([System.String]::IsNullOrWhiteSpace($ApiVersion) -eq $false){
        $getArgs.Add('ApiVersion',$ApiVersion)
    }

    $result = Get-AdminPowerAppCdsDatabaseCurrencies @getArgs | Select-Object *
    
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $result
    }
    else{
        Write-Output $result
    }
}
catch{
    throw
}
finally{
    DisconnectPowerApps
}