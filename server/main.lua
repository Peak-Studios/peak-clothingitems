-- ============================================================
-- SERVER MAIN
-- Net event handlers, callbacks, and admin commands.
-- ============================================================

-- ============================================================
-- CALLBACKS
-- ============================================================

CreateThread(function()
    while not Peak.Server.Ready do Wait(100) end

    -- Callback: Remove single clothing piece
    Peak.Server.RegisterCallback('removeClothing', function(source, data)
        return Peak.Server.ProcessClothingRemoval(source, data)
    end)

    -- Callback: Remove all clothing pieces
    Peak.Server.RegisterCallback('removeAllClothing', function(source, items)
        return Peak.Server.ProcessBulkClothingRemoval(source, items)
    end)

    Peak.Utils.Debug('Server callbacks registered')
end)

-- ============================================================
-- WEAR CONFIRMATION
-- ============================================================

RegisterNetEvent('peak-clothingitems:server:confirmWear', function(success, metadata)
    local src = source
    local resolved = Peak.Server.ResolvePendingWear(src, success == true)

    if not resolved then
        Peak.Utils.Warn(string.format('Ignoring unmatched wear confirmation from player %d', src))
        return
    end

    if success then
        Peak.Utils.Debug(string.format('Player %d wore %s successfully', src, resolved.itemName))
    end
end)

-- ============================================================
-- ADMIN COMMAND
-- ============================================================

CreateThread(function()
    while not Peak.Server.Ready do Wait(100) end

    RegisterCommand('clothingadmin', function(source, args)
        -- Server console always has access
        if source > 0 and not Peak.Server.IsAdmin(source) then
            TriggerClientEvent('peak-clothingitems:client:adminNotify', source,
                'You do not have permission to use this command.', 'error')
            return
        end

        if not args[1] then
            local msg = 'Usage: /clothingadmin give <player_id> <slot_alias> <drawable> <texture>'
            if source == 0 then print(msg) else
                TriggerClientEvent('peak-clothingitems:client:adminNotify', source, msg, 'info')
            end
            return
        end

        local action = string.lower(args[1])

        if action == 'give' then
            local targetId = tonumber(args[2])
            local slotAlias = args[3] and string.lower(args[3])
            local drawable = tonumber(args[4])
            local texture = tonumber(args[5]) or 0

            if not targetId or not slotAlias or not drawable then
                local msg = 'Usage: /clothingadmin give <player_id> <slot_alias> <drawable> <texture>'
                if source == 0 then print(msg) else
                    TriggerClientEvent('peak-clothingitems:client:adminNotify', source, msg, 'info')
                end
                return
            end

            -- Find slot by alias
            local entry = ClothingItems._byAlias[slotAlias]
            if not entry then
                local msg = 'Unknown slot: ' .. slotAlias
                if source == 0 then print(msg) else
                    TriggerClientEvent('peak-clothingitems:client:adminNotify', source, msg, 'error')
                end
                return
            end

            -- Build metadata (use mp_m_freemode_01 as default model)
            local metadata = {
                description = string.format('%s (admin-given, drawable:%d, texture:%d)',
                    entry.slot.label, drawable, texture),
                type = entry.type,
                componentId = entry.slot.id,
                drawableId = drawable,
                textureId = texture,
                model = 'mp_m_freemode_01', -- Admin items default to male, player can try
                sex = 'male',
                label = entry.slot.label,
            }

            local added = Peak.Server.AddItem(targetId, entry.slot.name, 1, metadata)
            if added then
                local msg = string.format('Gave %s (drawable:%d, texture:%d) to player %d',
                    entry.slot.label, drawable, texture, targetId)
                if source == 0 then print(msg) else
                    TriggerClientEvent('peak-clothingitems:client:adminNotify', source, msg, 'success')
                end
            else
                local msg = 'Failed to give item. Player inventory might be full.'
                if source == 0 then print(msg) else
                    TriggerClientEvent('peak-clothingitems:client:adminNotify', source, msg, 'error')
                end
            end
        end
    end, true) -- ACE restricted

    Peak.Utils.Debug('Admin command registered: /clothingadmin')
end)
