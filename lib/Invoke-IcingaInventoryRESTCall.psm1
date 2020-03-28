function Invoke-IcingaInventoryRESTCall()
{
    param (
        [Hashtable]$Request    = @{},
        [Hashtable]$Connection = @{},
        $IcingaGlobals
    );

    [Hashtable]$ContentResponse = @{};
    
    # Short our call
    $InventoryAliases = $IcingaGlobals.BackgroundDaemon.IcingaPowerShellRestApi.CommandAliases.inventory;

    # Check if there are an inventory aliases configured
    # This should be maintained by the developer and not occur
    # anyway
    if ($null -eq $InventoryAliases) {
        Send-IcingaTCPClientMessage -Message (
            New-IcingaTCPClientRESTMessage `
                -HTTPResponse ($IcingaHTTPEnums.HTTPResponseType.'Internal Server Error') `
                -ContentBody 'Internal Server Error. For this API endpoint no configured command aliases were found.'
        ) -Stream $Connection.Stream;

        return;
    }

    # If we use the list argument, return a list of all available inventory commands
    if ($Request.RequestArguments.ContainsKey('list')) {
        Send-IcingaTCPClientMessage -Message (
            New-IcingaTCPClientRESTMessage `
                -HTTPResponse ($IcingaHTTPEnums.HTTPResponseType.Ok) `
                -ContentBody @{
                    'Inventory' = @(
                        $InventoryAliases.Keys
                    )
                }
        ) -Stream $Connection.Stream;

        return;
    }

    # Our namespace to include inventory packages is 'include' over the api
    # Everything else will be dropped for the moment
    if ($Request.RequestArguments.ContainsKey('include')) {
        [bool]$LoadAll = $FALSE;
        if ($Request.RequestArguments.include -Contains '*') {
            $LoadAll = $TRUE;
        }
        foreach ($element in $InventoryAliases.Keys) {
            if ($Request.RequestArguments.include -Contains '*' -Or $Request.RequestArguments.include -Contains $element) {
                if ($InventoryAliases[$element].GetType().BaseType -eq [array]) {
                    [array]$ArrayContent = @();

                    foreach ($command in $InventoryAliases[$element]) {
                        Write-IcingaDebugMessage -Message ('Executing array inventory command ' + $command);
                        $ArrayContent += & $command;
                    }

                    Add-IcingaHashtableItem `
                        -Hashtable $ContentResponse `
                        -Key $element `
                        -Value $ArrayContent | Out-Null;
                    
                } else {
                    $command = $InventoryAliases[$element];

                    Write-IcingaDebugMessage -Message ('Executing inventory command ' + $command);

                    Add-IcingaHashtableItem `
                        -Hashtable $ContentResponse `
                        -Key $element `
                        -Value (& $command) | Out-Null;
                }
            }
        }
    }

    if ($Request.RequestArguments.ContainsKey('exclude')) {
        foreach ($exclude in $Request.RequestArguments.exclude) {
            Remove-IcingaHashtableItem `
                -Hashtable $ContentResponse `
                -Key $exclude | Out-Null;
        }
    }

    if ($ContentResponse.Count -eq 0) {
        $ContentResponse.Add(
            'message',
            'Welcome to the Icinga for Windows inventory API. To fetch information, please use the include argument. A full list will be returned with /v1/inventory?list. You can also exclude content. Example: /v1/inventory?include=cpu, /v1/inventory?include=*&exclude=users&exclude=services'
        );
    }

    # Send the response to the client
    Send-IcingaTCPClientMessage -Message (
        New-IcingaTCPClientRESTMessage `
            -HTTPResponse ($IcingaHTTPEnums.HTTPResponseType.Ok) `
            -ContentBody $ContentResponse
    ) -Stream $Connection.Stream;
}
