# API Reference

## Server Exports

```lua
exports['peak-clothingitems']:GetFrameworkName()
exports['peak-clothingitems']:IsReady()
exports['peak-clothingitems']:AddItem(source, itemName, count, metadata)
exports['peak-clothingitems']:RemoveItem(source, itemName, count, slot)
exports['peak-clothingitems']:HasItem(source, itemName, count)
```

These exports are thin wrappers around the active framework and inventory bridge.

## Client Functions

The resource exposes functions on the shared `Peak.Client` table for internal integrations:

```lua
Peak.Client.RemoveClothingPiece('prop', 0)
Peak.Client.RemoveAllClothing()
Peak.Client.WearClothingPiece(metadata)
Peak.Client.GetWornClothing()
```

Prefer commands or inventory item usage for normal gameplay. Direct calls should only be used by trusted client-side integrations in your own resources.

## Events

### Client Events

```lua
TriggerClientEvent('peak-clothingitems:client:wearItem', source, metadata)
TriggerClientEvent('peak-clothingitems:client:adminNotify', source, message, type)
```

`wearItem` is intended for this resource's server flow after the inventory item has been removed.

### Server Events

```lua
TriggerServerEvent('peak-clothingitems:server:confirmWear', success, metadata)
```

The server only honors this event when the player has a matching pending wear action that was created by item use. Forged confirmations are ignored and logged.

## Metadata Shape

Inventory items use this metadata:

```lua
{
    description = 'Hat (mp_m_freemode_01^prop_0_12)',
    type = 'prop', -- 'component' or 'prop'
    componentId = 0,
    drawableId = 12,
    textureId = 0,
    model = 'mp_m_freemode_01',
    sex = 'male',
    label = 'Hat'
}
```

`componentId` is used for both GTA component IDs and prop IDs. The `type` field determines which native is used.
