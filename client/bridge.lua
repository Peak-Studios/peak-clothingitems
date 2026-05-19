-- ============================================================
-- CLIENT BRIDGE
-- Notification and Appearance persistence bridges.
-- ============================================================

-- ============================================================
-- NOTIFICATION BRIDGE
-- ============================================================

--- Sends a notification to the player.
--- @param msg string
--- @param nType string 'success' | 'error' | 'info'
function Peak.Client.Notify(msg, nType)
    nType = nType or 'info'
    local system = Peak.Client.GetNotifySystem()

    if system == 'ox_lib' then
        local oxType = nType
        if nType == 'info' then oxType = 'inform' end
        lib.notify({ title = 'Clothing', description = msg, type = oxType })
    elseif system == 'qb-core' then
        local qbType = nType
        if nType == 'info' then qbType = 'primary' end
        if Peak.Client.FrameworkObject and Peak.Client.FrameworkObject.Functions then
            Peak.Client.FrameworkObject.Functions.Notify(msg, qbType, 5000)
        else
            -- Fallback for QBox without legacy core object
            TriggerEvent('QBCore:Notify', msg, qbType, 5000)
        end
    elseif system == 'esx' then
        if Peak.Client.FrameworkObject then
            Peak.Client.FrameworkObject.ShowNotification(msg)
        end
    else
        -- Native notification
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(false, false)
    end
end

-- ============================================================
-- APPEARANCE PERSISTENCE BRIDGE
-- ============================================================

--- Saves the current appearance through the active appearance system.
--- This ensures clothing changes persist across sessions.
function Peak.Client.SaveAppearance()
    local system = Peak.Client.GetAppearanceSystem()
    local ped = PlayerPedId()

    if system == 'illenium-appearance' then
        local ok, data = pcall(function()
            return exports['illenium-appearance']:getPedAppearance(ped)
        end)
        if ok and data then
            TriggerServerEvent('illenium-appearance:server:saveAppearance', data)
            Peak.Utils.Debug('Appearance saved via illenium-appearance')
        end

    elseif system == 'rcore_clothing' then
        local ok, skin = pcall(function()
            return exports['rcore_clothing']:getPlayerSkin(false)
        end)
        if ok and skin then
            pcall(function()
                exports['rcore_clothing']:setPlayerSkin(skin, false)
            end)
            Peak.Utils.Debug('Appearance saved via rcore_clothing')
        end

    elseif system == 'fivem-appearance' then
        local ok, data = pcall(function()
            return exports['fivem-appearance']:getPedAppearance(ped)
        end)
        if ok and data then
            TriggerServerEvent('fivem-appearance:save', data)
            Peak.Utils.Debug('Appearance saved via fivem-appearance')
        end

    elseif system == 'skinchanger' then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin then
                TriggerServerEvent('skinchanger:save', skin)
                Peak.Utils.Debug('Appearance saved via skinchanger')
            end
        end)

    else
        -- Native fallback — no persistence system detected.
        -- Changes will only last until the player reconnects.
        Peak.Utils.Debug('No appearance system detected. Changes are session-only.')
    end
end

-- ============================================================
-- PED CLOTHING READ/WRITE BRIDGE
-- ============================================================

--- Gets the current drawable and texture for a component slot.
--- @param componentId number
--- @return number drawableId, number textureId
function Peak.Client.GetComponentValue(componentId)
    local ped = PlayerPedId()
    return GetPedDrawableVariation(ped, componentId), GetPedTextureVariation(ped, componentId)
end

--- Gets the current drawable and texture for a prop slot.
--- @param propId number
--- @return number drawableId, number textureId
function Peak.Client.GetPropValue(propId)
    local ped = PlayerPedId()
    return GetPedPropIndex(ped, propId), GetPedPropTextureIndex(ped, propId)
end

--- Sets a component variation on the player ped.
--- @param componentId number
--- @param drawableId number
--- @param textureId number
function Peak.Client.SetComponentValue(componentId, drawableId, textureId)
    local ped = PlayerPedId()
    SetPedComponentVariation(ped, componentId, drawableId, textureId, 0)
end

--- Sets a prop on the player ped.
--- @param propId number
--- @param drawableId number
--- @param textureId number
function Peak.Client.SetPropValue(propId, drawableId, textureId)
    local ped = PlayerPedId()
    if drawableId == -1 then
        ClearPedProp(ped, propId)
    else
        SetPedPropIndex(ped, propId, drawableId, textureId, true)
    end
end

--- Resets a component slot to its default value.
--- @param componentId number
--- @param slot table The slot definition from ClothingItems
function Peak.Client.ResetComponent(componentId, slot)
    local model = Peak.Utils.GetPedModelName()
    local drawable, texture = ClothingItems.GetDefaultValues(model, 'component', componentId)
    Peak.Client.SetComponentValue(componentId, drawable, texture)
end

--- Resets a prop slot (removes the prop).
--- @param propId number
function Peak.Client.ResetProp(propId)
    ClearPedProp(PlayerPedId(), propId)
end

--- Returns a full table of currently worn non-default clothing.
--- @return table[] List of {type, slotId, slot, drawableId, textureId}
function Peak.Client.GetWornClothing()
    local worn = {}
    local model = Peak.Utils.GetPedModelName()
    Peak.Utils.Debug("GetWornClothing called for model: " .. tostring(model))

    for _, slot in ipairs(ClothingItems.Components) do
        local drawable, texture = Peak.Client.GetComponentValue(slot.id)
        local defDrawable, defTexture = ClothingItems.GetDefaultValues(model, 'component', slot.id)
        Peak.Utils.Debug(string.format("Component %d (%s): drawable=%d, texture=%d | default: drawable=%d, texture=%d", 
            slot.id, slot.alias, drawable, texture, defDrawable, defTexture))
        if drawable ~= defDrawable or texture ~= defTexture then
            worn[#worn + 1] = {
                type = 'component',
                slotId = slot.id,
                slot = slot,
                drawableId = drawable,
                textureId = texture,
            }
        end
    end

    for _, slot in ipairs(ClothingItems.Props) do
        local drawable, texture = Peak.Client.GetPropValue(slot.id)
        local defDrawable, defTexture = ClothingItems.GetDefaultValues(model, 'prop', slot.id)
        Peak.Utils.Debug(string.format("Prop %d (%s): drawable=%d, texture=%d | default: drawable=%d, texture=%d", 
            slot.id, slot.alias, drawable, texture, defDrawable, defTexture))
        if drawable ~= defDrawable then
            worn[#worn + 1] = {
                type = 'prop',
                slotId = slot.id,
                slot = slot,
                drawableId = drawable,
                textureId = texture,
            }
        end
    end

    Peak.Utils.Debug("Worn count found: " .. #worn)
    return worn
end
