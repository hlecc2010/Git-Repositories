﻿#Requires -Version 5.0

<#
    .SYNOPSIS
        Connect to Exchange Online and adds members to the Universal distribution groups
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT       

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/ExchangeOnline/DistributionGroups

    .Parameter GroupObjectIds
        [sr-en] Alias, Display name, Distinguished name, Guid or Mail address of the Universal distribution groups to which to add members

    .Parameter GroupIds
        [sr-en] Alias, Display name, Distinguished name, Guid or Mail address of the Universal distribution groups to add to the Universal distribution groups

    .Parameter UserIds
        [sr-en] Alias, Display name, Distinguished name, Guid or Mail address of the mailboxes to add to the groups
#>

param(
    [Parameter(Mandatory = $true)]
    [string[]]$GroupObjectIds,
    [string[]]$GroupIds,
    [string[]]$UserIds
)

try{
    $Script:result = @()
    $Script:err = $false
    $Script:addGrp
    $Script:usr
    forEach($gid in $GroupObjectIds){
        try{
            $grp = Get-DistributionGroup -Identity $gid 
        }
        catch{
            $Script:result += "Error: GroupObjectID $($gid) $($_.Exception.Message)"
            $Script:err =$true
            continue
        }
        if($null -ne $grp){
            if($null -ne $GroupIds){
                forEach($itm in $GroupIds){
                    try{
                        $addGrp = Get-DistributionGroup -Identity $itm
                    }
                    catch{
                        $Script:result += "Error: GroupID $($itm) $($_.Exception.Message)"
                        $Script:err = $true
                        continue
                    }
                    if($null -ne $Script:addGrp){
                        try{
                            $null = Add-DistributionGroupMember -Identity $gid -Member $itm -BypassSecurityGroupManagerCheck -Confirm:$false
                            $Script:result += "Group $($Script:addGrp.DisplayName) added to Distribution group $($grp.DisplayName)"
                        }
                        catch{
                            $Script:result += "Error: GroupID $($itm) $($_.Exception.Message)"
                            $Script:err =$true
                            continue
                        }
                    }                
                }
            }
            if($null -ne $UserIds){
                forEach($itm in $UserIds){
                    try{
                        $Script:usr = Get-MailUser -Identity $itm
                    }
                    catch{
                        $Script:result += "Error: UserID $($itm) $($_.Exception.Message)"
                        $Script:err =$true
                        continue
                    }
                    if($null -ne $Script:usr){
                        try{
                            $null = Add-DistributionGroupMember -Identity $gid -Member $itm -BypassSecurityGroupManagerCheck -Confirm:$false
                            $Script:result += "User $($Script:usr.DisplayName) added to Distribution group $($grp.DisplayName)"
                        }
                        catch{
                            $Script:result += "Error: UserID $($itm) $($_.Exception.Message)"
                            $Script:err =$true
                            continue
                        }
                    }
                }
            }
        }
        else {
            $Script:result += "Universal distribution group $($gid) not found"
            $Script:err =$true
        }
    }
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $Script:result
        if($Script:err -eq $true){
           Throw $($Script:result -join ' ')
        }
    } 
    else{    
        Write-Output $Script:result 
    }
}
catch{
    throw
}
finally{
}