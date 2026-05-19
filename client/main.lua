-- ============================================================
-- CLIENT MAIN
-- Net event handlers for server→client communication.
-- ============================================================

-- ============================================================
-- ITEM USE HANDLER (triggered by server when player uses a clothing item)
-- ============================================================

RegisterNetEvent('peak-clothingitems:client:wearItem', function(metadata)
    if not metadata then return end

    Peak.Utils.Debug('Wear item triggered:', json.encode(metadata))

    local success = Peak.Client.WearClothingPiece(metadata)

    -- Confirm to server whether the wear was successful
    TriggerServerEvent('peak-clothingitems:server:confirmWear', success, metadata)
end)

-- ============================================================
-- ADMIN GIVE FEEDBACK
-- ============================================================

RegisterNetEvent('peak-clothingitems:client:adminNotify', function(msg, nType)
    Peak.Client.Notify(msg, nType or 'info')
end)
