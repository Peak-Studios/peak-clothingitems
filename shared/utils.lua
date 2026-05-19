Peak = Peak or {}
Peak.Utils = Peak.Utils or {}

local RESOURCE_NAME = GetCurrentResourceName()
local PREFIX = '^5[' .. RESOURCE_NAME .. ']^0 '

--- Prints an info message to the console.
--- @param ... any
function Peak.Utils.print(...)
    local parts = {}
    for i = 1, select('#', ...) do
        parts[#parts + 1] = tostring(select(i, ...))
    end
    print(PREFIX .. table.concat(parts, ' '))
end

--- Prints a debug message (only when Config.Debug is true).
--- @param ... any
function Peak.Utils.Debug(...)
    if not Config or not Config.Debug then return end
    local parts = {}
    for i = 1, select('#', ...) do
        parts[#parts + 1] = tostring(select(i, ...))
    end
    print(PREFIX .. '^3[DEBUG]^0 ' .. table.concat(parts, ' '))
end

--- Prints a warning message.
--- @param ... any
function Peak.Utils.Warn(...)
    local parts = {}
    for i = 1, select('#', ...) do
        parts[#parts + 1] = tostring(select(i, ...))
    end
    print(PREFIX .. '^1[WARN]^0 ' .. table.concat(parts, ' '))
end

--- Returns the locale string for a given key, with optional format args.
--- @param key string
--- @param ... any
--- @return string
function Peak.Utils.Locale(key, ...)
    local str = Locales and Locales[key]
    if not str then return key end
    if select('#', ...) > 0 then
        return string.format(str, ...)
    end
    return str
end

--- Returns a clothing slot definition by item name.
--- @param itemName string
--- @return table|nil
function Peak.Utils.GetSlotByItemName(itemName)
    if not ClothingItems then return nil end
    for _, slot in ipairs(ClothingItems.Components) do
        if slot.name == itemName then return slot end
    end
    for _, slot in ipairs(ClothingItems.Props) do
        if slot.name == itemName then return slot end
    end
    return nil
end

--- Returns a clothing slot definition by component/prop ID and type.
--- @param slotType string "component" or "prop"
--- @param slotId number
--- @return table|nil
function Peak.Utils.GetSlotById(slotType, slotId)
    if not ClothingItems then return nil end
    local list = (slotType == 'component') and ClothingItems.Components or ClothingItems.Props
    for _, slot in ipairs(list) do
        if slot.id == slotId then return slot end
    end
    return nil
end

--- Returns a clothing slot definition by its human-readable alias.
--- @param alias string e.g. "hat", "pants", "top"
--- @return table|nil slotDef, string|nil slotType
function Peak.Utils.GetSlotByAlias(alias)
    if not ClothingItems then return nil end
    alias = string.lower(alias)
    for _, slot in ipairs(ClothingItems.Components) do
        if slot.alias == alias then return slot, 'component' end
    end
    for _, slot in ipairs(ClothingItems.Props) do
        if slot.alias == alias then return slot, 'prop' end
    end
    return nil, nil
end

--- Returns all slot definitions as a flat list with type annotations.
--- @return table[]
function Peak.Utils.GetAllSlots()
    local result = {}
    for _, slot in ipairs(ClothingItems.Components) do
        result[#result + 1] = { slot = slot, type = 'component' }
    end
    for _, slot in ipairs(ClothingItems.Props) do
        result[#result + 1] = { slot = slot, type = 'prop' }
    end
    return result
end

--- Returns the ped model name for the current player (client only).
--- @return string
function Peak.Utils.GetPedModelName()
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)
    if model == GetHashKey('mp_m_freemode_01') then
        return 'mp_m_freemode_01'
    elseif model == GetHashKey('mp_f_freemode_01') then
        return 'mp_f_freemode_01'
    end
    return tostring(model)
end

--- Returns the sex string for the current ped model.
--- @return string "male" | "female" | "unknown"
function Peak.Utils.GetPedSex()
    local model = Peak.Utils.GetPedModelName()
    if model == 'mp_m_freemode_01' then return 'male'
    elseif model == 'mp_f_freemode_01' then return 'female'
    else return 'unknown' end
end
