#Requires -Version 5.0
#Requires -Modules Microsoft.PowerApps.Administration.PowerShell

<#
.SYNOPSIS
    Deletes the connection

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
    https://github.com/scriptrunner/ActionPacks/tree/master/O365/PowerApps/Connections
 
.Parameter PACredential
    Provides the user ID and password for PowerApps credentials

.Parameter ConnectionName
    The connection identifier

.Parameter EnvironmentName
    The connection's environment

.Parameter ConnectorName 
    The connection's connector name

.Parameter ApiVersion
    The api version to call with
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]   
    [pscredential]$PACredential,
    [Parameter(Mandatory = $true)]
    [string]$ConnectionName,
    [Parameter(Mandatory = $true)]
    [string]$ConnectorName,
    [Parameter(Mandatory = $true)]
    [string]$EnvironmentName,
    [string]$ApiVersion
)

Import-Module Microsoft.PowerApps.Administration.PowerShell

try{
    ConnectPowerApps -PAFCredential $PACredential

    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'ConnectorName' = $ConnectorName
                            'ConnectionName' = $ConnectionName
                            'EnvironmentName' = $EnvironmentName
                            }                              
     
    if($PSBoundParameters.ContainsKey('ApiVersion')){
        $getArgs.Add('ApiVersion',$ApiVersion)
    }

    $result = Remove-AdminPowerAppConnection @cmdArgs | Select-Object *
    
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