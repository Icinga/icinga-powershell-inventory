<#
.SYNOPSIS
   Registers an endpoint called 'inventory' in our REST-Api
.DESCRIPTION
   This module will provide an endpoint for the Icinga for Windows REST-Api
   https://github.com/Icinga/icinga-powershell-restapi

   The endpoint itself is called 'inventory' and will map available Cmdlets for
   data providers
.FUNCTIONALITY
   This module will depend on the Icinga Plugins as well as the Framework and
   the REST-Api. It will provide general wrappers to securely fetch the
   intended Windows data
.OUTPUTS
   $NULL
.LINK
   https://github.com/Icinga/icinga-powershell-inventory
.NOTES
#>
function Register-IcingaRESTAPIEndpointInventory()
{
    return @{
        'Alias'   = 'inventory';
        'Command' = 'Invoke-IcingaInventoryRESTCall';
    };
}

<#
.SYNOPSIS
   Registers our command aliases for mapping the 'include'/'exclude' arguments
   from our REST-Call securely to our PowerShell Cmdlets
.DESCRIPTION
   This module will provide an endpoint for the Icinga for Windows REST-Api
   https://github.com/Icinga/icinga-powershell-restapi

   By using the references, we can register endpoints and alises to fetch
   informations
.EXAMPLE
   https://example.com/v1/inventory?include=disks&include=cpu
.FUNCTIONALITY
   This module will depend on the Icinga Plugins as well as the Framework and
   the REST-Api. It will provide general wrappers to securely fetch the
   intended Windows data
.OUTPUTS
   $NULL
.LINK
   https://github.com/Icinga/icinga-powershell-inventory
.NOTES
#>
function Register-IcingaRESTApiCommandAliasesInventory()
{
    return @{
        'inventory' = @{
            'bios'       = 'Get-IcingaBios';
            'cpu'        = 'Get-IcingaCPUs';
            'disks'      = @(
                'Get-IcingaDiskInformation',
                'Get-IcingaDiskPartitions'
            );
            'memory'     = 'Get-IcingaMemory';
            'process'    = 'Get-IcingaProcessData';
            'services'   = 'Get-IcingaServices';
            'users'      = 'Get-IcingaUsers';
            'windows'    = 'Get-IcingaWindows';
            'updates'    = @(
                'Get-IcingaWindowsUpdatesPending',
                'Get-IcingaUpdatesHotfix',
                'Get-IcingaUpdatesInstalled'
            );
        }
    }
}

function Import-IcingaPowerShellComponentInventory()
{
    # Allows other components to load this component
}
