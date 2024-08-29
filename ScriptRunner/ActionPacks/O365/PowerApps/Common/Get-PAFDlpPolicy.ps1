#Requires -Version 5.0
#Requires -Modules Microsoft.PowerApps.Administration.PowerShell

<#
.SYNOPSIS
    Retrieves api policy objects and provides the option to print out the connectors in each data group

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
    https://github.com/scriptrunner/ActionPacks/tree/master/O365/PowerApps/Common
 
.Parameter PACredential
    Provides the user ID and password for PowerApps credentials

.Parameter PolicyName
    Retrieves the policy with the input name (identifier)

.Parameter CreatedBy
    Created by the specified user

.Parameter Filter
    Specifies the filter

.Parameter ApiVersion
    The api version to call with
    
.Parameter Properties
    List of properties to expand. Use * for all properties
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]   
    [pscredential]$PACredential,
    [string]$PolicyName,
    [string]$CreatedBy,
    [string]$Filter,
    [string]$ApiVersion,
    [ValidateSet('*','DisplayName','PolicyName','CreatedTime','CreatedBy','LastModifiedTime','LastModifiedBy','Constraints','BusinessDataGroup','NonBusinessDataGroup','Type','Environments')]
    [string[]]$Properties = @('DisplayName','PolicyName','LastModifiedTime','LastModifiedBy')
)

Import-Module Microsoft.PowerApps.Administration.PowerShell

try{
    if($Properties -contains '*'){
        $Properties = @('*')
    }
    ConnectPowerApps -PAFCredential $PACredential
    
    [hashtable]$getArgs = @{'ErrorAction' = 'Stop'}  
                            
    if($PSBoundParameters.ContainsKey('PolicyName')){
        $getArgs.Add('PolicyName',$PolicyName)
    }
    if($PSBoundParameters.ContainsKey('CreatedBy')){
        $getArgs.Add('CreatedBy',$CreatedBy)
    }
    if($PSBoundParameters.ContainsKey('Filter')){
        $getArgs.Add('Filter',$Filter)
    }
    if($PSBoundParameters.ContainsKey('ApiVersion')){
        $getArgs.Add('ApiVersion',$ApiVersion)
    }

    $result = Get-AdminDlpPolicy @getArgs | Select-Object $Properties
    
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