-- ============================================================
-- CLIENT CLOTHING LOGIC
-- Core functions for removing and wearing clothing pieces.
-- ============================================================

local lastActionTime = 0

--- Checks if the cooldown period has elapsed.
--- @return boolean
local function CheckCooldown()
    local now = GetGameTimer()
    if (now - lastActionTime) < Config.Cooldown then
        return false
    end
    lastActionTime = now
    return true
end

-- ============================================================
-- REMOVE CLOTHING
-- ============================================================

--- Removes a single clothing piece from the player ped and requests server to add the item.
--- @param slotType string "component" or "prop"
--- @param slotId number The GTA component/prop ID
--- @return boolean success
function Peak.Client.RemoveClothingPiece(slotType, slotId)
    if not CheckCooldown() then
        Peak.Client.Notify(Peak.Utils.Locale('cooldown'), 'error')
        return false
    end

    -- Get the slot definition
    local slot = Peak.Utils.GetSlotById(slotType, slotId)
    if not slot then
        Peak.Client.Notify(Peak.Utils.Locale('invalid_slot', tostring(slotId)), 'error')
        return false
    end

    -- Get model info
    local model = Peak.Utils.GetPedModelName()
    local sex = Peak.Utils.GetPedSex()

    -- Read current values
    local drawable, texture
    if slotType == 'component' then
        drawable, texture = Peak.Client.GetComponentValue(slotId)
    else
        drawable, texture = Peak.Client.GetPropValue(slotId)
    end

    -- Check if already at default (nothing to remove)
    local defDrawable, defTexture = ClothingItems.GetDefaultValues(model, slotType, slotId)
    if slotType == 'component' then
        if drawable == defDrawable and texture == defTexture then
            Peak.Client.Notify(Peak.Utils.Locale('already_default'), 'error')
            return false
        end
    else
        if drawable == defDrawable then
            Peak.Client.Notify(Peak.Utils.Locale('already_default'), 'error')
            return false
        end
    end

    -- Request server to add the item
    local result = Peak.Client.TriggerCallback('removeClothing', {
        slotType = slotType,
        slotId = slotId,
        itemName = slot.name,
        label = slot.label,
        drawableId = drawable,
        textureId = texture,
        model = model,
        sex = sex,
    })

    if result and result.success then
        -- Reset the slot on the ped
        if slotType == 'component' then
            Peak.Client.ResetComponent(slotId, slot)
        else
            Peak.Client.ResetProp(slotId)
        end

        -- Persist changes through appearance system
        Peak.Client.SaveAppearance()
        Peak.Client.Notify(Peak.Utils.Locale('removed_clothing', slot.label), 'success')
        return true
    else
        local reason = result and result.reason or 'action_failed'
        Peak.Client.Notify(Peak.Utils.Locale(reason), 'error')
        return false
    end
end

--- Removes all non-default clothing pieces from the player ped.
--- @return number removedCount
function Peak.Client.RemoveAllClothing()
    if not CheckCooldown() then
        Peak.Client.Notify(Peak.Utils.Locale('cooldown'), 'error')
        return 0
    end

    local worn = Peak.Client.GetWornClothing()
    if #worn == 0 then
        Peak.Client.Notify(Peak.Utils.Locale('nothing_to_remove'), 'error')
        return 0
    end

    local model = Peak.Utils.GetPedModelName()
    local sex = Peak.Utils.GetPedSex()

    -- Build payload for all worn items
    local items = {}
    for _, w in ipairs(worn) do
        items[#items + 1] = {
            slotType = w.type,
            slotId = w.slotId,
            itemName = w.slot.name,
            label = w.slot.label,
            drawableId = w.drawableId,
            textureId = w.textureId,
            model = model,
            sex = sex,
        }
    end

    -- Request server to add all items
    local result = Peak.Client.TriggerCallback('removeAllClothing', items)

    if result and result.success then
        local removedCount = result.count or 0
        local serverAccepted = {}

        if result.removedItems then
            for _, item in ipairs(result.removedItems) do
                serverAccepted[item.type .. ':' .. tostring(item.slotId)] = true
            end
        end

        -- Reset only the slots that the server successfully converted into items.
        for _, w in ipairs(worn) do
            local key = w.type .. ':' .. tostring(w.slotId)
            if not result.removedItems or serverAccepted[key] then
                if w.type == 'component' then
                    Peak.Client.ResetComponent(w.slotId, w.slot)
                else
                    Peak.Client.ResetProp(w.slotId)
                end
            end
        end

        Peak.Client.SaveAppearance()

        if result.partial then
            Peak.Client.Notify(Peak.Utils.Locale('partial_remove', removedCount), 'error')
        else
            Peak.Client.Notify(Peak.Utils.Locale('removed_all_clothing'), 'success')
        end

        return removedCount
    else
        local reason = result and result.reason or 'action_failed'
        Peak.Client.Notify(Peak.Utils.Locale(reason), 'error')
        return 0
    end
end

-- ============================================================
-- WEAR CLOTHING
-- ============================================================

--- Wears a clothing piece from inventory (called when item is used).
--- @param metadata table Item metadata containing clothing data
--- @return boolean success
function Peak.Client.WearClothingPiece(metadata)
    if not metadata or not metadata.type or not metadata.componentId then
        Peak.Client.Notify(Peak.Utils.Locale('invalid_metadata'), 'error')
        return false
    end

    -- Validate model compatibility
    local currentModel = Peak.Utils.GetPedModelName()
    if metadata.model and metadata.model ~= currentModel then
        Peak.Client.Notify(Peak.Utils.Locale('wrong_model'), 'error')
        return false
    end

    local slotType = metadata.type
    local slotId = metadata.componentId

    -- Check if slot is occupied (player wearing something non-default)
    local slot = Peak.Utils.GetSlotById(slotType, slotId)
    if slot then
        local defDrawable, defTexture = ClothingItems.GetDefaultValues(currentModel, slotType, slotId)
        if slotType == 'component' then
            local currentDrawable, currentTexture = Peak.Client.GetComponentValue(slotId)
            if currentDrawable ~= defDrawable or currentTexture ~= defTexture then
                Peak.Client.Notify(Peak.Utils.Locale('slot_occupied'), 'error')
                return false
            end
        else
            local currentDrawable = Peak.Client.GetPropValue(slotId)
            if currentDrawable ~= defDrawable then
                Peak.Client.Notify(Peak.Utils.Locale('slot_occupied'), 'error')
                return false
            end
        end
    end

    -- Apply the clothing
    if slotType == 'component' then
        Peak.Client.SetComponentValue(slotId, metadata.drawableId, metadata.textureId)
    else
        Peak.Client.SetPropValue(slotId, metadata.drawableId, metadata.textureId)
    end

    -- Persist through appearance system
    Peak.Client.SaveAppearance()
    Peak.Client.Notify(Peak.Utils.Locale('wearing_clothing', slot and slot.label or 'Clothing'), 'success')
    return true
end
