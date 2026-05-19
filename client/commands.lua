-- ============================================================
-- CLIENT COMMANDS
-- Chat command registration for clothing management.
-- ============================================================

local function BuildSlotList()
    local names = {}
    for _, slot in ipairs(ClothingItems.Components) do
        names[#names + 1] = slot.alias
    end
    for _, slot in ipairs(ClothingItems.Props) do
        names[#names + 1] = slot.alias
    end
    return table.concat(names, ', ')
end

local function HandleRemoveCommand(args)
    if not args[2] then
        Peak.Client.Notify(Peak.Utils.Locale('cmd_help', Config.Command, BuildSlotList()), 'info')
        return
    end
    local target = string.lower(args[2])
    if target == 'all' then
        if Config.AllowRemoveAll then
            Peak.Client.RemoveAllClothing()
        end
        return
    end
    local slot, slotType = Peak.Utils.GetSlotByAlias(target)
    if not slot then
        Peak.Client.Notify(Peak.Utils.Locale('invalid_slot', target), 'error')
        return
    end
    Peak.Client.RemoveClothingPiece(slotType, slot.id)
end

local function HandleListCommand()
    local worn = Peak.Client.GetWornClothing()
    if #worn == 0 then
        Peak.Client.Notify(Peak.Utils.Locale('cmd_list_empty'), 'info')
        return
    end
    TriggerEvent('chat:addMessage', { color = {255,165,0}, multiline = true, args = {'Clothing', Peak.Utils.Locale('cmd_list_header')} })
    for _, w in ipairs(worn) do
        TriggerEvent('chat:addMessage', { color = {200,200,200}, args = {'', Peak.Utils.Locale('cmd_list_item', w.slot.label, w.drawableId, w.textureId)} })
    end
end

CreateThread(function()
    while not Peak.Client.Ready do Wait(100) end
    RegisterCommand(Config.Command, function(_, args)
        if not args[1] then
            Peak.Client.Notify(Peak.Utils.Locale('cmd_help', Config.Command, BuildSlotList()), 'info')
            return
        end
        local sub = string.lower(args[1])
        if sub == 'remove' then HandleRemoveCommand(args)
        elseif sub == 'list' then HandleListCommand()
        else Peak.Client.Notify(Peak.Utils.Locale('cmd_help', Config.Command, BuildSlotList()), 'info') end
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. Config.Command, 'Manage clothing items', {
        { name = 'action', help = 'remove | list' },
        { name = 'slot', help = 'hat, mask, top, pants, shoes, glasses, etc. or "all"' },
    })
end)
