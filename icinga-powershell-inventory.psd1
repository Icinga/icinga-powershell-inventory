@{
    ModuleVersion     = '1.2.0'
    GUID              = 'b4aec037-4361-415e-8921-94ff0f664e0b'
    ModuleToProcess   = 'icinga-powershell-inventory.psm1'
    Author            = 'Lord Hepipud, Crited'
    CompanyName       = 'Icinga GmbH'
    Copyright         = '(c) 2020 Icinga GmbH | GPLv2'
    Description       = 'A module to extend the REST-Api of the Icinga PowerShell Framework to provide inventory data'
    PowerShellVersion = '4.0'
    RequiredModules   = @( @{ModuleName = 'icinga-powershell-framework'; ModuleVersion = '1.9.0' }, 'icinga-powershell-plugins' )
    NestedModules     = @(
        '.\compiled\icinga-powershell-inventory.ifw_compilation.psm1'
    )
    FunctionsToExport     = @(
        'Register-IcingaRESTAPIEndpointInventory',
        'Register-IcingaRESTApiCommandAliasesInventory',
        'Import-IcingaPowerShellComponentInventory',
        'Invoke-IcingaInventoryRESTCall'
    )
    CmdletsToExport     = @(
    )
    VariablesToExport     = @(
    )
    PrivateData       = @{
        PSData = @{
            Tags = @( 'icinga','icinga2','inventory','icingainventory','windowsrest','icingawindows')
            LicenseUri = 'https://github.com/Icinga/icinga-powershell-inventory/blob/master/LICENSE'
            ProjectUri = 'https://github.com/Icinga/icinga-powershell-inventory'
            ReleaseNotes = 'https://github.com/Icinga/icinga-powershell-inventory/releases'
        };
        Version = 'v1.2.0';
        Name    = 'Inventory';
        Type    = 'apiendpoint';
    }
    HelpInfoURI       = 'https://github.com/Icinga/icinga-powershell-inventory'
}

