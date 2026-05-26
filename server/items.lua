-- ============================================================
-- SERVER ITEMS
-- Registers all clothing items as usable.
-- ============================================================

function Peak.Server.HandleClothingItemUse(source, itemName, itemData, skipRemove)
    Peak.Utils.Debug(string.format('Player %d used item: %s', source, itemName))

    if Peak.Server.HasPendingWear(source) then
        TriggerClientEvent('peak-clothingitems:client:adminNotify', source,
            'Please wait for your current clothing action to finish.', 'error')
        return false
    end

    -- Get metadata from the item
    local metadata, slot = Peak.Server.GetItemMetadata(source, itemName, itemData)

    if not metadata or not metadata.type or not metadata.componentId then
        Peak.Utils.Warn(string.format('Player %d used %s but metadata is invalid', source, itemName))
        TriggerClientEvent('peak-clothingitems:client:adminNotify', source,
            'This clothing item has no valid data.', 'error')
        return false
    end

    if not skipRemove then
        -- Remove the item from inventory FIRST (server-authoritative)
        local removed = Peak.Server.RemoveItem(source, itemName, 1, slot)
        if not removed then
            Peak.Utils.Warn(string.format('Failed to remove %s from player %d', itemName, source))
            return false
        end
    end

    Peak.Server.StartPendingWear(source, itemName, metadata)

    -- Trigger client to wear the item
    TriggerClientEvent('peak-clothingitems:client:wearItem', source, metadata)
    return true
end

CreateThread(function()
    -- Wait for framework and inventory to initialize
    while not Peak.Server.Ready do Wait(100) end
    Wait(500) -- Extra buffer for inventory system

    local registered = 0

    -- Register all component items
    for _, slotDef in ipairs(ClothingItems.Components) do
        Peak.Server.RegisterUsableItem(slotDef.name, Peak.Server.HandleClothingItemUse)
        registered = registered + 1
    end

    -- Register all prop items
    for _, slotDef in ipairs(ClothingItems.Props) do
        Peak.Server.RegisterUsableItem(slotDef.name, Peak.Server.HandleClothingItemUse)
        registered = registered + 1
    end

    Peak.Utils.print(string.format('Registered ^5%d^0 usable clothing items', registered))
end)
