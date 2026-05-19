Peak = Peak or {}
Peak.Server = Peak.Server or {}
Peak.Server.FrameworkName = nil
Peak.Server.FrameworkObject = nil
Peak.Server.FrameworkShared = nil
Peak.Server.Callbacks = {}
Peak.Server.Ready = false
Peak.Server.UsableItems = {}

local inventorySystem = nil

-- ============================================================
-- FRAMEWORK DETECTION
-- ============================================================

local function GetFrameworkName()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if GetResourceState('qbx_core') == 'started' then return 'qbox'
    elseif GetResourceState('qb-core') == 'started' then return 'qbcore'
    elseif GetResourceState('es_extended') == 'started' then return 'esx'
    end
    return 'standalone'
end

local function InitializeFramework()
    Peak.Server.FrameworkName = GetFrameworkName()
    local framework = Peak.Server.FrameworkName

    if framework == 'qbcore' then
        Peak.Server.FrameworkObject = exports['qb-core']:GetCoreObject()
        Peak.Server.FrameworkShared = Peak.Server.FrameworkObject.Shared
        Peak.Utils.print('Framework detected: ^5QBCore^0')
    elseif framework == 'qbox' then
        local ok, obj = pcall(function() return exports.qbx_core:GetCoreObject() end)
        if ok and obj then
            Peak.Server.FrameworkObject = obj
            Peak.Server.FrameworkShared = obj.Shared
            Peak.Utils.print('Framework detected: ^5QBox (Legacy)^0')
        else
            local qbx = exports.qbx_core
            Peak.Server.FrameworkObject = {
                Functions = setmetatable({}, {
                    __index = function(_, key)
                        return function(...) return qbx[key](qbx, ...) end
                    end
                })
            }
            Peak.Server.FrameworkShared = setmetatable({}, {
                __index = function(_, key)
                    local map = { Jobs = 'GetJobs', Gangs = 'GetGangs' }
                    if map[key] then
                        local ok2, data = pcall(qbx[map[key]], qbx)
                        if ok2 then return data end
                    end
                    return nil
                end
            })
            Peak.Utils.print('Framework detected: ^5QBox^0')
        end
    elseif framework == 'esx' then
        Peak.Server.FrameworkObject = exports.es_extended:getSharedObject()
        Peak.Utils.print('Framework detected: ^5ESX^0')
    else
        Peak.Utils.Warn('No framework detected. Running in standalone mode.')
    end

    Peak.Server.Ready = true
end

-- ============================================================
-- INVENTORY DETECTION
-- ============================================================

local function InitializeInventory()
    if Config.Inventory ~= 'auto' then
        inventorySystem = Config.Inventory
        Peak.Utils.Debug('Inventory set to:', inventorySystem)
        return
    end
    local systems = {'ox_inventory', 'qb-inventory', 'qs-inventory', 'ps-inventory', 'codem-inventory'}
    for _, s in ipairs(systems) do
        if GetResourceState(s) == 'started' then
            inventorySystem = s
            Peak.Utils.Debug('Inventory detected:', s)
            return
        end
    end
    Peak.Utils.Warn('No supported inventory system detected.')
end

function Peak.Server.GetInventorySystem() return inventorySystem end

-- ============================================================
-- CALLBACK HANDLING
-- ============================================================

function Peak.Server.RegisterCallback(name, cb)
    Peak.Server.Callbacks[name] = cb
end

RegisterNetEvent('peak-clothingitems:server:triggerCallback', function(id, name, ...)
    local src = source
    local cb = Peak.Server.Callbacks[name]
    if not cb then
        Peak.Utils.Warn('Callback not found:', name)
        TriggerClientEvent('peak-clothingitems:client:callbackResponse', src, id, nil)
        return
    end
    local ok, res = pcall(cb, src, ...)
    if ok then
        TriggerClientEvent('peak-clothingitems:client:callbackResponse', src, id, res)
    else
        Peak.Utils.Warn('Callback error [' .. name .. ']:', res)
        TriggerClientEvent('peak-clothingitems:client:callbackResponse', src, id, nil)
    end
end)

-- ============================================================
-- STARTUP
-- ============================================================

CreateThread(function()
    Wait(100)
    InitializeFramework()
    InitializeInventory()
    Peak.Utils.print('Server initialized. Framework: ^5' .. Peak.Server.FrameworkName .. '^0 | Inventory: ^5' .. (inventorySystem or 'none') .. '^0')
end)
