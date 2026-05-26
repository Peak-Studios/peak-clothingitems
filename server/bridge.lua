-- ============================================================
-- SERVER BRIDGE
-- Framework, Inventory, and Admin bridges.
-- ============================================================

-- ============================================================
-- PLAYER INFO
-- ============================================================

function Peak.Server.GetIdentifier(src)
    local fw = Peak.Server.FrameworkName
    local obj = Peak.Server.FrameworkObject
    if fw == 'qbcore' or fw == 'qbox' then
        local player = obj.Functions.GetPlayer(src)
        return player and player.PlayerData.citizenid
    elseif fw == 'esx' then
        local player = obj.GetPlayerFromId(src)
        return player and player.identifier
    end
    return GetPlayerIdentifier(src, 0)
end

function Peak.Server.GetPlayerName(src)
    local fw = Peak.Server.FrameworkName
    local obj = Peak.Server.FrameworkObject
    if fw == 'qbcore' or fw == 'qbox' then
        local player = obj.Functions.GetPlayer(src)
        if player then return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname end
    elseif fw == 'esx' then
        local player = obj.GetPlayerFromId(src)
        if player then return player.getName() end
    end
    return GetPlayerName(src)
end

-- ============================================================
-- INVENTORY BRIDGE
-- ============================================================

--- Adds an item with metadata to a player's inventory.
--- @param source number
--- @param item string
--- @param count number
--- @param metadata table
--- @return boolean
function Peak.Server.AddItem(source, item, count, metadata)
    local inv = Peak.Server.GetInventorySystem()
    count = count or 1

    if inv == 'ox_inventory' then
        local ok, result = pcall(function()
            return exports.ox_inventory:AddItem(source, item, count, metadata)
        end)
        return ok and result

    elseif inv == 'qb-inventory' or inv == 'ps-inventory' then
        local fw = Peak.Server.FrameworkName
        local obj = Peak.Server.FrameworkObject
        if fw == 'qbcore' or fw == 'qbox' then
            local player = obj.Functions.GetPlayer(source)
            if player then
                return player.Functions.AddItem(item, count, nil, metadata)
            end
        end
        -- Fallback to export
        local ok, result = pcall(function()
            return exports[inv]:AddItem(source, item, count, nil, metadata)
        end)
        return ok and result

    elseif inv == 'qs-inventory' then
        local ok, result = pcall(function()
            return exports['qs-inventory']:AddItem(source, item, count, nil, metadata)
        end)
        return ok and result

    elseif inv == 'codem-inventory' then
        local ok, result = pcall(function()
            return exports['codem-inventory']:AddItem(source, item, count, nil, metadata)
        end)
        return ok and result

    else
        -- Framework fallback
        local fw = Peak.Server.FrameworkName
        local obj = Peak.Server.FrameworkObject
        if fw == 'qbcore' or fw == 'qbox' then
            local player = obj.Functions.GetPlayer(source)
            if player then return player.Functions.AddItem(item, count, nil, metadata) end
        elseif fw == 'esx' then
            local player = obj.GetPlayerFromId(source)
            if player then player.addInventoryItem(item, count) return true end
        end
    end

    return false
end

--- Removes an item from a player's inventory.
--- @param source number
--- @param item string
--- @param count number
--- @param slot number|nil
--- @return boolean
function Peak.Server.RemoveItem(source, item, count, slot)
    local inv = Peak.Server.GetInventorySystem()
    count = count or 1

    if inv == 'ox_inventory' then
        local ok, result = pcall(function()
            return exports.ox_inventory:RemoveItem(source, item, count, nil, slot)
        end)
        return ok and result

    elseif inv == 'qb-inventory' or inv == 'ps-inventory' then
        local fw = Peak.Server.FrameworkName
        local obj = Peak.Server.FrameworkObject
        if fw == 'qbcore' or fw == 'qbox' then
            local player = obj.Functions.GetPlayer(source)
            if player then return player.Functions.RemoveItem(item, count, slot) end
        end
        local ok, result = pcall(function()
            return exports[inv]:RemoveItem(source, item, count, slot)
        end)
        return ok and result

    elseif inv == 'qs-inventory' then
        local ok, result = pcall(function()
            return exports['qs-inventory']:RemoveItem(source, item, count, slot)
        end)
        return ok and result

    elseif inv == 'codem-inventory' then
        local ok, result = pcall(function()
            return exports['codem-inventory']:RemoveItem(source, item, count, slot)
        end)
        return ok and result

    else
        local fw = Peak.Server.FrameworkName
        local obj = Peak.Server.FrameworkObject
        if fw == 'qbcore' or fw == 'qbox' then
            local player = obj.Functions.GetPlayer(source)
            if player then return player.Functions.RemoveItem(item, count, slot) end
        elseif fw == 'esx' then
            local player = obj.GetPlayerFromId(source)
            if player then player.removeInventoryItem(item, count) return true end
        end
    end

    return false
end

--- Checks if a player has a certain amount of an item.
--- @param source number
--- @param item string
--- @param count number
--- @return boolean
function Peak.Server.HasItem(source, item, count)
    count = count or 1
    local inv = Peak.Server.GetInventorySystem()

    if inv == 'ox_inventory' then
        local c = exports.ox_inventory:GetItemCount(source, item) or 0
        return c >= count
    end

    local fw = Peak.Server.FrameworkName
    local obj = Peak.Server.FrameworkObject
    if fw == 'qbcore' or fw == 'qbox' then
        local player = obj.Functions.GetPlayer(source)
        if player then
            local itemData = player.Functions.GetItemByName(item)
            return itemData and (itemData.amount or 0) >= count
        end
    elseif fw == 'esx' then
        local player = obj.GetPlayerFromId(source)
        if player then
            local itemData = player.getInventoryItem(item)
            return itemData and (itemData.count or 0) >= count
        end
    end
    return false
end

-- ============================================================
-- USABLE ITEM REGISTRATION
-- ============================================================

function Peak.Server.RegisterUsableItem(item, cb)
    Peak.Server.UsableItems[item] = cb
    local fw = Peak.Server.FrameworkName
    local obj = Peak.Server.FrameworkObject
    local inv = Peak.Server.GetInventorySystem()

    local onUse = function(source, itemData)
        local callback = Peak.Server.UsableItems[item]
        if callback then callback(source, item, itemData) end
    end

    if inv == 'ox_inventory' then
        -- ox_inventory uses item definition exports instead of runtime usable registration.
        -- See install/ox_inventory_items.lua for the required server.export entry.
        return
    elseif fw == 'qbox' then
        pcall(function() exports.qbx_core:CreateUseableItem(item, function(src, itm) onUse(src, itm) end) end)
        return
    elseif fw == 'qbcore' then
        obj.Functions.CreateUseableItem(item, function(src, itm) onUse(src, itm) end)
        return
    elseif fw == 'esx' then
        obj.RegisterUsableItem(item, function(src) onUse(src) end)
        return
    end

    Peak.Utils.Warn('No usable item registration available for item:', item)
end

-- ============================================================
-- ADMIN CHECK
-- ============================================================

function Peak.Server.IsAdmin(src)
    if IsPlayerAceAllowed(src, 'command.clothingadmin') then return true end
    local fw = Peak.Server.FrameworkName
    if fw == 'qbcore' or fw == 'qbox' then
        return Peak.Server.FrameworkObject.Functions.HasPermission(src, 'admin')
            or Peak.Server.FrameworkObject.Functions.HasPermission(src, 'god')
    elseif fw == 'esx' then
        local player = Peak.Server.FrameworkObject.GetPlayerFromId(src)
        if player then
            local group = player.getGroup()
            return group == 'admin' or group == 'superadmin' or group == 'god'
        end
    end
    return false
end

-- ============================================================
-- EXPORTS
-- ============================================================

exports('GetFrameworkName', function() return Peak.Server.FrameworkName end)
exports('IsReady', function() return Peak.Server.Ready end)
exports('AddItem', function(...) return Peak.Server.AddItem(...) end)
exports('RemoveItem', function(...) return Peak.Server.RemoveItem(...) end)
exports('HasItem', function(...) return Peak.Server.HasItem(...) end)
exports('useClothingItem', function(event, item, inventory, slot)
    if event ~= 'usingItem' then return end
    if type(inventory) ~= 'table' or not inventory.id then return false end

    local itemData = nil
    if Peak.Server.GetInventorySystem() == 'ox_inventory' then
        local ok, slotData = pcall(function()
            return exports.ox_inventory:GetSlot(inventory.id, slot)
        end)
        if ok then itemData = slotData end
    end

    local itemName = type(item) == 'table' and item.name or item
    if type(itemName) ~= 'string' and itemData then
        itemName = itemData.name
    end
    if type(itemName) ~= 'string' then return false end

    if not itemData then
        itemData = { name = itemName, slot = slot }
    end

    if not Peak.Server.HandleClothingItemUse then return false end
    local handled = Peak.Server.HandleClothingItemUse(inventory.id, itemName, itemData, true)
    if not handled then return false end
end)
