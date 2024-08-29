﻿#Requires -Version 5.0
# Requires -Modules VMware.VimAutomation.Core

<#
    .SYNOPSIS
        Modifies the configuration of the virtual network adapter

    .DESCRIPTION

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module VMware.VimAutomation.Core

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/VMware/Network

    .Parameter VIServer
        [sr-en] IP address or the DNS name of the vSphere server to which you want to connect
        [sr-de] IP Adresse oder DNS des vSphere Servers

    .Parameter VICredential
        [sr-en] PSCredential object that contains credentials for authenticating with the server
        [sr-de] Benutzerkonto für die Ausführung

    .Parameter VMName
        [sr-en] Snapshot from which you want to configure virtual network adapters
        [sr-de] VM der Netzwerk-Adapter

    .Parameter TemplateName
        [sr-en] Template from which you want to configure virtual network adapters
        [sr-de] Vorlage der Netzwerk-Adapter

    .Parameter SnapshotName
        [sr-en] Snapshot from which you want to configure virtual network adapters
        [sr-de] Snapshot des Netzwerk-Adapters

    .Parameter AdapterName
        [sr-en] Name of the virtual network adapter you want to modify
        [sr-de] Name des Netzwerk-Adapters

    .Parameter AdapterType
        [sr-en] Type of the network adapter 
        [sr-de] Typ des Netzwerk-Adapters

    .Parameter Network
        [sr-en] Name of the network to which you want to connect the virtual network adapter   
        [sr-de] Netzwerkname

    .Parameter MacAddress
        [sr-en] Optional MAC address for the virtual network adapter
        [sr-de] Optionale MAC-Adresse der Netzwerk-Adapters

    .Parameter Connected
        [sr-en] If the value is $true, the virtual network adapter is connected after its creation
        [sr-de] Virtuellee Netzwerk-Adapter nach seiner Erstellung verbinden 

    .Parameter StartConnected
        [sr-en] If the value is $true, the virtual network adapter starts connected when its associated virtual machine powers on
        [sr-de] Netzwerk-Adapter verbinden, wenn die zugehörige virtuelle Maschine eingeschaltet wird

    .Parameter WakeOnLan
        [sr-en] Wake-on-LAN is enabled on the virtual network adapter
        [sr-de] Wake-On-Lan aktivieren
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true,ParameterSetName = "VM")]
    [Parameter(Mandatory = $true,ParameterSetName = "Template")]
    [Parameter(Mandatory = $true,ParameterSetName = "Snapshot")]
    [string]$VIServer,
    [Parameter(Mandatory = $true,ParameterSetName = "VM")]
    [Parameter(Mandatory = $true,ParameterSetName = "Template")]
    [Parameter(Mandatory = $true,ParameterSetName = "Snapshot")]
    [pscredential]$VICredential,
    [Parameter(Mandatory = $true,ParameterSetName = "VM")]
    [Parameter(Mandatory = $true,ParameterSetName = "Snapshot")]
    [string]$VMName,
    [Parameter(Mandatory = $true,ParameterSetName = "Template")]    
    [string]$TemplateName,
    [Parameter(Mandatory = $true,ParameterSetName = "Snapshot")]
    [string]$SnapshotName,
    [Parameter(ParameterSetName = "VM")]
    [Parameter(ParameterSetName = "Template")]
    [Parameter(ParameterSetName = "Snapshot")]
    [string]$AdapterName,
    [Parameter(ParameterSetName = "VM")]
    [Parameter(ParameterSetName = "Template")]
    [Parameter(ParameterSetName = "Snapshot")]
    [ValidateSet('e1000', 'Flexible', 'Vmxnet', 'EnhancedVmxnet', 'Vmxnet3', 'Unknown')]
    [string]$AdapterType,
    [Parameter(ParameterSetName = "VM")]
    [Parameter(ParameterSetName = "Template")]
    [Parameter(ParameterSetName = "Snapshot")]
    [string]$Network,
    [Parameter(ParameterSetName = "VM")]
    [Parameter(ParameterSetName = "Template")]
    [Parameter(ParameterSetName = "Snapshot")]
    [string]$MacAddress,
    [Parameter(ParameterSetName = "VM")]
    [Parameter(ParameterSetName = "Template")]
    [Parameter(ParameterSetName = "Snapshot")]
    [bool]$Connected,
    [Parameter(ParameterSetName = "VM")]
    [Parameter(ParameterSetName = "Template")]
    [Parameter(ParameterSetName = "Snapshot")]
    [bool]$StartConnected,    
    [Parameter(ParameterSetName = "VM")]
    [Parameter(ParameterSetName = "Template")]
    [Parameter(ParameterSetName = "Snapshot")]
    [bool]$WakeOnLan
)

Import-Module VMware.VimAutomation.Core

try{
    if([System.String]::IsNullOrWhiteSpace($AdapterName) -eq $true){
        $AdapterName = "*"
    }
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'Server' = $Script:vmServer
                            }                            
    if($PSCmdlet.ParameterSetName  -eq "Snapshot"){
        $vm = Get-VM @cmdArgs -Name $VMName
        $snap = Get-Snapshot @cmdArgs -Name $SnapshotName -VM $vm
        $cmdArgs.Add('Snapshot', $snap)
    }
    elseif($PSCmdlet.ParameterSetName  -eq "Template"){
        $temp = Get-Template @cmdArgs -Name $TemplateName
        $cmdArgs.Add('Template', $temp)
    }
    else {
        $vm = Get-VM @cmdArgs -Name $VMName  
        $cmdArgs.Add('VM', $vm)
    }
    $Script:adapter = Get-NetworkAdapter @cmdArgs -Name $AdapterName

    $cmdArgs = @{'ErrorAction' = 'Stop'
                'Server' = $Script:vmServer
                'NetworkAdapter' = $Script:adapter
                'Confirm' = $false
                }               
    if($PSBoundParameters.ContainsKey('Network') -eq $true){
        $Script:Output = Set-NetworkAdapter @cmdArgs -NetworkName $Network | Select-Object *
    }
    if($PSBoundParameters.ContainsKey('AdapterType') -eq $true){
        $Script:Output = Set-NetworkAdapter @cmdArgs -Type $AdapterType | Select-Object *
    }
    if($PSBoundParameters.ContainsKey('MacAddress') -eq $true){
        $Script:Output = Set-NetworkAdapter @cmdArgs -MacAddress $MacAddress | Select-Object *    
    }
    if($PSBoundParameters.ContainsKey('Connected') -eq $true){
        $Script:Output = Set-NetworkAdapter @cmdArgs -Connected $Connected | Select-Object *
    }
    if($PSBoundParameters.ContainsKey('StartConnected') -eq $true){
        $Script:Output = Set-NetworkAdapter @cmdArgs -StartConnected $StartConnected | Select-Object *
    }
    if($PSBoundParameters.ContainsKey('WakeOnLan') -eq $true){
        $Script:Output = Set-NetworkAdapter @cmdArgs -WakeOnLan $WakeOnLan | Select-Object *
    }

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $Script:Output 
    }
    else{
        Write-Output $Script:Output
    }
}
catch{
    throw
}
finally{    
    if($null -ne $Script:vmServer){
        Disconnect-VIServer -Server $Script:vmServer -Force -Confirm:$false
    }
}