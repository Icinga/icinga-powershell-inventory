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

    # Our namespace to include inventory packages is 'include' over the api
    # Everything else will be dropped for the moment
    if ($Request.RequestArguments.ContainsKey('include')) {
        foreach ($inquiry in $Request.RequestArguments.include) {
            if ($InventoryAliases.ContainsKey($inquiry)) {
                if ($InventoryAliases[$inquiry].GetType().BaseType -eq [array]) {
                    [array]$ArrayContent = @();

                    foreach ($command in $InventoryAliases[$inquiry]) {
                        Write-IcingaDebugMessage -Message ('Executing array inventory command ' + $command);
                        $ArrayContent += & $command;
                    }

                    Add-IcingaHashtableItem `
                        -Hashtable $ContentResponse `
                        -Key $inquiry `
                        -Value $ArrayContent | Out-Null;
                    
                } else {
                    $command = $InventoryAliases[$inquiry];

                    Write-IcingaDebugMessage -Message ('Executing inventory command ' + $command);

                    Add-IcingaHashtableItem `
                        -Hashtable $ContentResponse `
                        -Key $inquiry `
                        -Value (& $command) | Out-Null;
                }
            }
        }
    }

    # Send the response to the client
    Send-IcingaTCPClientMessage -Message (
        New-IcingaTCPClientRESTMessage `
            -HTTPResponse ($IcingaHTTPEnums.HTTPResponseType.Ok) `
            -ContentBody $ContentResponse
    ) -Stream $Connection.Stream;
}
