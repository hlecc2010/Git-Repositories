#Requires -Version 5.0
#Requires -Modules Microsoft.PowerApps.PowerShell

<#
.SYNOPSIS
    Sets the current environment for listing powerapps, flows, and other environment resources

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
    © ScriptRunner Software GmbH

.COMPONENT
    Requires Module Microsoft.PowerApps.PowerShell
    Requires Library script PAFLibrary.ps1

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/O365/PowerApps/AppCreators
 
.Parameter PACredential
    Provides the user ID and password for PowerApps credentials

.Parameter EnvironmentName
    Environment identifier (not display name)
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]   
    [pscredential]$PACredential,
    [string]$EnvironmentName
)

Import-Module Microsoft.PowerApps.PowerShell

try{
    ConnectPowerApps4Creators -PAFCredential $PACredential
    
    $Script:result
                            
    if([System.String]::IsNullOrWhiteSpace($EnvironmentName) -eq $true){
        $Script:result = Select-CurrentEnvironment -Default -ErrorAction Stop
    }
    else{
        $Script:result = Select-CurrentEnvironment -EnvironmentName $EnvironmentName -ErrorAction Stop
    }

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
    DisconnectPowerApps4Creators
}