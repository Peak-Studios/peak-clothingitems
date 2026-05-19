-- ============================================================
-- CLIENT RADIAL MENU
-- Optional integration with ox_lib and qb-radialmenu.
-- ============================================================

CreateThread(function()
    while not Peak.Client.Ready do Wait(100) end
    if not Config.EnableRadialMenu then return end

    local system = Peak.Client.GetRadialSystem()
    if system == 'none' then return end

    if system == 'ox_lib' then
        Peak.Client.SetupOxRadial()
    elseif system == 'qb-radialmenu' then
        Peak.Client.SetupQBRadial()
    end

    Peak.Utils.Debug('Radial menu registered:', system)
end)

-- ============================================================
-- OX_LIB RADIAL
-- ============================================================

function Peak.Client.SetupOxRadial()
    -- Build remove submenu items for each slot
    local removeItems = {}

    for _, slot in ipairs(ClothingItems.Components) do
        removeItems[#removeItems + 1] = {
            label = slot.label,
            icon = slot.icon,
            onSelect = function()
                Peak.Client.RemoveClothingPiece('component', slot.id)
            end
        }
    end

    for _, slot in ipairs(ClothingItems.Props) do
        removeItems[#removeItems + 1] = {
            label = slot.label,
            icon = slot.icon,
            onSelect = function()
                Peak.Client.RemoveClothingPiece('prop', slot.id)
            end
        }
    end

    -- Add "Remove All" option
    if Config.AllowRemoveAll then
        removeItems[#removeItems + 1] = {
            label = Peak.Utils.Locale('radial_remove_all'),
            icon = 'xmark',
            onSelect = function()
                Peak.Client.RemoveAllClothing()
            end
        }
    end

    lib.registerRadial({
        id = 'peak_clothing_remove',
        items = removeItems
    })

    lib.registerRadial({
        id = 'peak_clothing',
        items = {
            {
                label = Peak.Utils.Locale('radial_remove'),
                icon = 'shirt',
                menu = 'peak_clothing_remove'
            }
        }
    })

    -- Add to the default radial menu
    lib.addRadialItem({
        id = 'peak_clothing_main',
        label = Peak.Utils.Locale('radial_clothing'),
        icon = 'shirt',
        menu = 'peak_clothing'
    })
end

-- ============================================================
-- QB-RADIALMENU
-- ============================================================

function Peak.Client.SetupQBRadial()
    local subItems = {}

    for _, slot in ipairs(ClothingItems.Components) do
        subItems[#subItems + 1] = {
            id = 'peak_remove_' .. slot.alias,
            title = slot.label,
            icon = slot.icon,
            type = 'client',
            event = 'peak-clothingitems:client:radialRemove',
            shouldClose = true,
            params = { type = 'component', id = slot.id }
        }
    end

    for _, slot in ipairs(ClothingItems.Props) do
        subItems[#subItems + 1] = {
            id = 'peak_remove_' .. slot.alias,
            title = slot.label,
            icon = slot.icon,
            type = 'client',
            event = 'peak-clothingitems:client:radialRemove',
            shouldClose = true,
            params = { type = 'prop', id = slot.id }
        }
    end

    if Config.AllowRemoveAll then
        subItems[#subItems + 1] = {
            id = 'peak_remove_all',
            title = Peak.Utils.Locale('radial_remove_all'),
            icon = 'xmark',
            type = 'client',
            event = 'peak-clothingitems:client:radialRemoveAll',
            shouldClose = true,
        }
    end

    local ok = pcall(function()
        exports['qb-radialmenu']:AddOption({
            id = 'peak_clothing',
            title = Peak.Utils.Locale('radial_clothing'),
            icon = 'shirt',
            items = subItems,
        }, 'peak_clothing')
    end)

    if not ok then
        Peak.Utils.Warn('Failed to register qb-radialmenu options. Ensure qb-radialmenu is running.')
    end
end

-- ============================================================
-- RADIAL EVENT HANDLERS
-- ============================================================

RegisterNetEvent('peak-clothingitems:client:radialRemove', function(data)
    if data and data.type and data.id then
        Peak.Client.RemoveClothingPiece(data.type, data.id)
    end
end)

RegisterNetEvent('peak-clothingitems:client:radialRemoveAll', function()
    Peak.Client.RemoveAllClothing()
end)
