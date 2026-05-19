-- ============================================================
-- SERVER CLOTHING LOGIC
-- Validation, anti-dupe, and clothing processing.
-- ============================================================

local pendingActions = {} -- Anti-dupe: tracks in-flight removal actions per player
local pendingWears = {} -- Tracks inventory items removed while waiting for client wear confirmation
local lastRemovalAt = {}

local WEAR_CONFIRM_TIMEOUT = 15000

local function clearRemovalLock(source)
    pendingActions[source] = nil
end

local function isInteger(value)
    return type(value) == 'number' and value % 1 == 0
end

local function validateRemovalPayload(data)
    if type(data) ~= 'table' then
        return nil, 'action_failed'
    end

    if data.slotType ~= 'component' and data.slotType ~= 'prop' then
        return nil, 'invalid_slot'
    end

    if type(data.itemName) ~= 'string' or type(data.label) ~= 'string' then
        return nil, 'action_failed'
    end

    local slotId = tonumber(data.slotId)
    local drawableId = tonumber(data.drawableId)
    local textureId = tonumber(data.textureId) or 0

    if not isInteger(slotId) or not isInteger(drawableId) or not isInteger(textureId) then
        return nil, 'action_failed'
    end

    local entry = ClothingItems._byName[data.itemName]
    if not entry or entry.type ~= data.slotType or entry.slot.id ~= slotId then
        return nil, 'invalid_slot'
    end

    if data.slotType == 'component' then
        if slotId < 0 or slotId > 11 or drawableId < 0 or textureId < 0 then
            return nil, 'action_failed'
        end
    elseif slotId < 0 or slotId > 12 or drawableId < 0 or textureId < 0 then
        return nil, 'action_failed'
    end

    return {
        slotType = data.slotType,
        slotId = slotId,
        itemName = entry.slot.name,
        label = entry.slot.label,
        drawableId = drawableId,
        textureId = textureId,
        model = type(data.model) == 'string' and data.model or 'unknown',
        sex = type(data.sex) == 'string' and data.sex or 'unknown',
    }
end

--- Builds the metadata table for a clothing item.
--- @param data table Client-sent data
--- @return table metadata
function Peak.Server.BuildClothingMetadata(data)
    -- Build a human-readable description
    local desc = string.format('%s (%s^%s_%d_%d)',
        data.label or 'Clothing',
        data.model or 'unknown',
        data.slotType == 'component' and 'comp' or 'prop',
        data.slotId or 0,
        data.drawableId or 0
    )

    return {
        description = desc,
        type = data.slotType,
        componentId = data.slotId,
        drawableId = data.drawableId,
        textureId = data.textureId,
        model = data.model,
        sex = data.sex,
        label = data.label,
    }
end

--- Processes a single clothing removal request.
--- @param source number
--- @param data table
--- @return table {success, reason}
function Peak.Server.ProcessClothingRemoval(source, data)
    -- Anti-dupe and rate-limit checks
    if pendingActions[source] then
        return { success = false, reason = 'cooldown' }
    end

    local now = GetGameTimer()
    if lastRemovalAt[source] and (now - lastRemovalAt[source]) < Config.Cooldown then
        return { success = false, reason = 'cooldown' }
    end

    pendingActions[source] = true

    local validData, reason = validateRemovalPayload(data)
    if not validData then
        clearRemovalLock(source)
        return { success = false, reason = reason }
    end

    -- Build metadata
    local metadata = Peak.Server.BuildClothingMetadata(validData)

    -- Add item to inventory
    local added = Peak.Server.AddItem(source, validData.itemName, 1, metadata)
    clearRemovalLock(source)

    if not added then
        return { success = false, reason = 'inventory_full' }
    end

    lastRemovalAt[source] = now

    Peak.Utils.Debug(string.format('Player %d removed %s (drawable:%d, texture:%d)',
        source, validData.itemName, validData.drawableId, validData.textureId))

    return { success = true }
end

--- Processes a bulk clothing removal (remove all).
--- @param source number
--- @param items table[]
--- @return table {success, count, reason}
function Peak.Server.ProcessBulkClothingRemoval(source, items)
    if pendingActions[source] then
        return { success = false, reason = 'cooldown', count = 0 }
    end

    local now = GetGameTimer()
    if lastRemovalAt[source] and (now - lastRemovalAt[source]) < Config.Cooldown then
        return { success = false, reason = 'cooldown', count = 0 }
    end

    pendingActions[source] = true

    if not items or #items == 0 then
        clearRemovalLock(source)
        return { success = false, reason = 'nothing_to_remove', count = 0 }
    end

    if #items > (#ClothingItems.Components + #ClothingItems.Props) then
        clearRemovalLock(source)
        return { success = false, reason = 'action_failed', count = 0 }
    end

    local validItems = {}
    local seenSlots = {}
    for _, data in ipairs(items) do
        local validData, reason = validateRemovalPayload(data)
        if not validData then
            clearRemovalLock(source)
            return { success = false, reason = reason, count = 0 }
        end
        local key = validData.slotType .. ':' .. tostring(validData.slotId)
        if seenSlots[key] then
            clearRemovalLock(source)
            return { success = false, reason = 'action_failed', count = 0 }
        end
        seenSlots[key] = true
        validItems[#validItems + 1] = validData
    end

    local addedCount = 0
    local removedItems = {}

    for _, data in ipairs(validItems) do
        local metadata = Peak.Server.BuildClothingMetadata(data)
        local added = Peak.Server.AddItem(source, data.itemName, 1, metadata)
        if added then
            addedCount = addedCount + 1
            removedItems[#removedItems + 1] = { type = data.slotType, slotId = data.slotId }
        else
            Peak.Utils.Warn(string.format('Failed to add %s to player %d inventory (full?)', data.itemName, source))
            break -- Stop if inventory is full
        end
    end

    clearRemovalLock(source)

    if addedCount == 0 then
        return { success = false, reason = 'inventory_full', count = 0 }
    end

    lastRemovalAt[source] = now

    Peak.Utils.Debug(string.format('Player %d removed %d clothing pieces', source, addedCount))
    return {
        success = true,
        partial = addedCount < #validItems,
        count = addedCount,
        removedItems = removedItems,
    }
end

--- Gets the metadata from an item in a player's inventory (for item-use).
--- Inventory-specific metadata extraction.
--- @param source number
--- @param item string
--- @param itemData table|nil Raw item data from framework
--- @return table|nil metadata
function Peak.Server.GetItemMetadata(source, item, itemData)
    local inv = Peak.Server.GetInventorySystem()

    -- ox_inventory passes itemData with metadata directly
    if inv == 'ox_inventory' then
        if itemData and itemData.metadata then
            return itemData.metadata, itemData.slot
        end
        -- Fallback: search inventory
        local items = exports.ox_inventory:Search(source, 'slots', item)
        if items and #items > 0 then
            return items[1].metadata, items[1].slot
        end

    elseif inv == 'qb-inventory' or inv == 'ps-inventory' then
        -- QBCore item data has .info for metadata
        if itemData and itemData.info then
            return itemData.info, itemData.slot
        end
        -- Fallback: get from player
        local fw = Peak.Server.FrameworkName
        local obj = Peak.Server.FrameworkObject
        if fw == 'qbcore' or fw == 'qbox' then
            local player = obj.Functions.GetPlayer(source)
            if player then
                local itm = player.Functions.GetItemByName(item)
                if itm then return itm.info, itm.slot end
            end
        end

    elseif inv == 'qs-inventory' or inv == 'codem-inventory' then
        if itemData and itemData.info then
            return itemData.info, itemData.slot
        end
        if itemData and itemData.metadata then
            return itemData.metadata, itemData.slot
        end
    end

    return nil, nil
end

--- Records an item that has been removed from inventory while the client applies it.
--- The matching confirmWear event is the only event allowed to refund it on failure.
--- @param source number
--- @param itemName string
--- @param metadata table
function Peak.Server.StartPendingWear(source, itemName, metadata)
    pendingWears[source] = {
        itemName = itemName,
        metadata = metadata,
        expiresAt = GetGameTimer() + WEAR_CONFIRM_TIMEOUT,
    }

    SetTimeout(WEAR_CONFIRM_TIMEOUT, function()
        local pending = pendingWears[source]
        if pending and pending.expiresAt <= GetGameTimer() then
            pendingWears[source] = nil
            Peak.Utils.Warn(string.format('Wear confirmation timed out for player %d and item %s', source, pending.itemName))
        end
    end)
end

--- Returns whether the player already has a clothing item awaiting wear confirmation.
--- @param source number
--- @return boolean
function Peak.Server.HasPendingWear(source)
    return pendingWears[source] ~= nil
end

--- Resolves a pending wear confirmation.
--- @param source number
--- @param success boolean
--- @return table|nil pendingWear
function Peak.Server.ResolvePendingWear(source, success)
    local pending = pendingWears[source]
    pendingWears[source] = nil

    if not pending then
        return nil
    end

    if pending.expiresAt < GetGameTimer() then
        return nil
    end

    if success then
        return pending
    end

    local returned = Peak.Server.AddItem(source, pending.itemName, 1, pending.metadata)
    if returned then
        Peak.Utils.Debug(string.format('Wear failed for player %d, returned %s', source, pending.itemName))
    else
        Peak.Utils.Warn(string.format('Wear failed for player %d, but %s could not be returned', source, pending.itemName))
    end

    return pending
end

-- Clean up pending actions on player disconnect
AddEventHandler('playerDropped', function()
    pendingActions[source] = nil
    pendingWears[source] = nil
    lastRemovalAt[source] = nil
end)
