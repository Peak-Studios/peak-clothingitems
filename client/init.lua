Peak = Peak or {}
Peak.Client = Peak.Client or {}
Peak.Client.Framework = nil
Peak.Client.FrameworkName = nil
Peak.Client.FrameworkObject = nil
Peak.Client.Ready = false
Peak.Client.PendingCallbacks = {}
Peak.Client.CallbackId = 0

local notifySystem = nil
local radialSystem = nil
local appearanceSystem = nil

-- ============================================================
-- FRAMEWORK DETECTION
-- ============================================================

--- Detects the currently running framework.
--- @return string frameworkName
local function GetFrameworkName()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end

    if GetResourceState('qbx_core') == 'started' then
        return 'qbox'
    elseif GetResourceState('qb-core') == 'started' then
        return 'qbcore'
    elseif GetResourceState('es_extended') == 'started' then
        return 'esx'
    end

    return 'standalone'
end

--- Initializes the framework object.
local function InitializeFramework()
    Peak.Client.FrameworkName = GetFrameworkName()
    local framework = Peak.Client.FrameworkName

    if framework == 'qbcore' then
        Peak.Client.FrameworkObject = exports['qb-core']:GetCoreObject()
    elseif framework == 'qbox' then
        local ok, obj = pcall(function() return exports.qbx_core:GetCoreObject() end)
        if ok and obj then
            Peak.Client.FrameworkObject = obj
        else
            local qbx = exports.qbx_core
            Peak.Client.FrameworkObject = {
                Functions = setmetatable({}, {
                    __index = function(_, key)
                        if key == 'GetPlayerData' then
                            return function()
                                if rawget(_G, 'QBX') and QBX.PlayerData then
                                    return QBX.PlayerData
                                end
                                local ok2, data = pcall(qbx.GetPlayerData, qbx)
                                return (ok2 and data) or {}
                            end
                        end
                        return function(...)
                            return qbx[key](qbx, ...)
                        end
                    end
                })
            }
        end
    elseif framework == 'esx' then
        Peak.Client.FrameworkObject = exports.es_extended:getSharedObject()
    end

    Peak.Utils.Debug('Client framework initialized:', framework)
end

-- ============================================================
-- SUBSYSTEM DETECTION
-- ============================================================

local function InitializeSubsystems()
    -- Notification System
    if Config.Notify == 'auto' then
        if GetResourceState('ox_lib') == 'started' then
            notifySystem = 'ox_lib'
        elseif GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started' then
            notifySystem = 'qb-core'
        elseif GetResourceState('es_extended') == 'started' then
            notifySystem = 'esx'
        else
            notifySystem = 'native'
        end
    else
        notifySystem = Config.Notify
    end

    -- Radial Menu System
    if Config.RadialMenu == 'auto' then
        if GetResourceState('ox_lib') == 'started' then
            radialSystem = 'ox_lib'
        elseif GetResourceState('qb-radialmenu') == 'started' then
            radialSystem = 'qb-radialmenu'
        else
            radialSystem = 'none'
        end
    else
        radialSystem = Config.RadialMenu
    end

    -- Appearance System
    if Config.Appearance == 'auto' then
        local systems = { 'illenium-appearance', 'rcore_clothing', 'fivem-appearance', 'skinchanger' }
        for _, s in ipairs(systems) do
            if GetResourceState(s) == 'started' then
                appearanceSystem = s
                break
            end
        end
        appearanceSystem = appearanceSystem or 'native'
    else
        appearanceSystem = Config.Appearance
    end

    Peak.Utils.Debug('Subsystems — Notify:', notifySystem, '| Radial:', radialSystem, '| Appearance:', appearanceSystem)
end

-- ============================================================
-- CALLBACK HANDLING
-- ============================================================

--- Triggers a server-side callback and awaits the response.
--- @param name string Callback name
--- @param ... any Arguments to pass
--- @return any Response data
function Peak.Client.TriggerCallback(name, ...)
    local p = promise.new()
    Peak.Client.CallbackId = Peak.Client.CallbackId + 1
    local id = Peak.Client.CallbackId

    Peak.Client.PendingCallbacks[id] = p
    TriggerServerEvent('peak-clothingitems:server:triggerCallback', id, name, ...)

    SetTimeout(15000, function()
        if Peak.Client.PendingCallbacks[id] then
            Peak.Client.PendingCallbacks[id]:reject('Callback timeout: ' .. name)
            Peak.Client.PendingCallbacks[id] = nil
        end
    end)

    return Citizen.Await(p)
end

RegisterNetEvent('peak-clothingitems:client:callbackResponse', function(id, data)
    if Peak.Client.PendingCallbacks[id] then
        Peak.Client.PendingCallbacks[id]:resolve(data)
        Peak.Client.PendingCallbacks[id] = nil
    end
end)

-- ============================================================
-- GETTERS
-- ============================================================

function Peak.Client.GetNotifySystem() return notifySystem end
function Peak.Client.GetRadialSystem() return radialSystem end
function Peak.Client.GetAppearanceSystem() return appearanceSystem end

-- ============================================================
-- STARTUP
-- ============================================================

CreateThread(function()
    Wait(500)
    InitializeFramework()
    InitializeSubsystems()
    Peak.Client.Ready = true
    Peak.Utils.print('Client initialized. Framework: ^5' .. Peak.Client.FrameworkName .. '^0 | Appearance: ^5' .. (appearanceSystem or 'native') .. '^0')
end)
