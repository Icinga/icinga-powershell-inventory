# API Documentation

This module is providing a REST endpoint for the [Icinga PowerShell REST-Api](https://icinga.com/docs/windows/latest/restapi).

Once the module is [installed](02-Installation.md) you can access it over the API under its namespace

```url
/v1/inventory
```

The module will only support to query one check command per connection.

## Fetch inventory list

To receive a list of all available inventory objects you can simply use

```url
/v1/inventory?list
```

```json
{
    "Inventory": [
        "bios",
        "cpu",
        "disks",
        "memory",
        "process",
        "services",
        "users",
        "windows",
        "updates"
    ]
}
```

For fetching inventory information you will have to provide the alias inside the url

## Fetching Single Entry

You can simply query data for one alias as follows

### Browser (Single Entry)

```url
/v1/inventory?include=cpu
```

### GET with curl (Single Entry)

```bash
curl -X GET "/v1/inventory?include=cpu"
```

### GET with PowerShell (Single Entry)

```powershell
Invoke-WebRequest -Method GET -UseBasicParsing -Uri '/v1/inventory?include=cpu';
```

## Fetching Multiple Entries

You can repeat the include argument for fetch multiple entries at once

### Browser (Multi Entries)

```url
/v1/inventory?include=cpu&include=bios
```

### GET with curl (Multi Entries)

```bash
curl -X GET "/v1/inventory?include=cpu&include=bios"
```

### GET with PowerShell (Multi Entries)

```powershell
Invoke-WebRequest -Method GET -UseBasicParsing -Uri '/v1/inventory?include=cpu&include=bios';
```

## Wildcard Include with Exclude

You can also use `*` as wildcard for includes and exclude unwanted entries

### Browser (Exclude)

```url
/v1/inventory?include=*&exclude=bios&exclude=updates
```

### GET with curl (Exclude)

```bash
curl -X GET "/v1/inventory?include=*&exclude=bios&exclude=updates"
```

### GET with PowerShell (Exclude)

```powershell
Invoke-WebRequest -Method GET -UseBasicParsing -Uri '/v1/inventory?include=*&exclude=bios&exclude=updates';
```
