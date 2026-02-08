--[[
    ██╗     ██╗  ██╗██████╗       ██╗      ██████╗ ██╗    ██╗██████╗ ██╗      ██████╗ ██╗    ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗██║    ██║██╔══██╗██║     ██╔═══██╗██║    ██║
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██║ █╗ ██║██████╔╝██║     ██║   ██║██║ █╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██║███╗██║██╔══██╗██║     ██║   ██║██║███╗██║
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝╚███╔███╔╝██████╔╝███████╗╚██████╔╝╚███╔███╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝ ╚═════╝  ╚══╝╚══╝ 
                                                                                                   
    🐺 LXR LowBlow - Framework Bridge / Adapter
    
    This shared script provides a unified interface for multi-framework support.
    It handles framework detection and provides a consistent API regardless of
    which framework is running on the server.
    
    ═══════════════════════════════════════════════════════════════════════════════
    ADAPTER FUNCTIONS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Unified API provided by this bridge:
    - Framework.Notify(source, type, message) - Send notification to player
    - Framework.GetPlayerHealth(source) - Get player current health
    - Framework.GetPlayerMaxHealth(source) - Get player max health
    - Framework.SetPlayerHealth(source, amount) - Set player health
    - Framework.ApplyDamage(source, amount) - Apply damage to player
    - Framework.IsPlayerLoaded(source) - Check if player data is loaded
    - Framework.GetPlayerIdentifier(source) - Get unique player identifier
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

Framework = {}
Framework.Name = 'unknown'
Framework.Object = nil

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK AUTO-DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        -- Manual framework selection
        Framework.Name = Config.Framework
        if Config.Debug then
            print('^3[LXR-LowBlow]^7 Framework manually set to: ^2' .. Framework.Name .. '^7')
        end
        return Framework.Name
    end
    
    -- Auto-detection logic (priority order)
    local detectionOrder = {
        {name = 'lxr-core', resource = 'lxr-core'},
        {name = 'rsg-core', resource = 'rsg-core'},
        {name = 'vorp_core', resource = 'vorp_core'},
        {name = 'redem_roleplay', resource = 'redem_roleplay'},
        {name = 'qbr-core', resource = 'qbr-core'},
        {name = 'qr-core', resource = 'qr-core'}
    }
    
    for _, fw in ipairs(detectionOrder) do
        local state = GetResourceState(fw.resource)
        if state == 'started' or state == 'starting' then
            Framework.Name = fw.name
            if Config.Debug then
                print('^3[LXR-LowBlow]^7 Framework detected: ^2' .. Framework.Name .. '^7')
            end
            return Framework.Name
        end
    end
    
    -- Fallback to standalone
    Framework.Name = 'standalone'
    if Config.Debug then
        print('^3[LXR-LowBlow]^7 No framework detected, using: ^2standalone^7')
    end
    return Framework.Name
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    DetectFramework()
    
    -- Initialize framework object if needed
    if Framework.Name == 'lxr-core' then
        -- LXR-Core initialization
        while Framework.Object == nil do
            TriggerEvent('lxr-core:getSharedObject', function(obj) Framework.Object = obj end)
            if Framework.Object == nil then
                exports['lxr-core']:GetCoreObject(function(obj) Framework.Object = obj end)
            end
            Wait(100)
        end
    elseif Framework.Name == 'rsg-core' then
        -- RSG-Core initialization
        while Framework.Object == nil do
            Framework.Object = exports['rsg-core']:GetCoreObject()
            Wait(100)
        end
    elseif Framework.Name == 'vorp_core' then
        -- VORP initialization
        while Framework.Object == nil do
            Framework.Object = exports.vorp_core:GetCore()
            Wait(100)
        end
    elseif Framework.Name == 'redem_roleplay' then
        -- RedEM:RP initialization
        while Framework.Object == nil do
            TriggerEvent('redemrp:getSharedObject', function(obj) Framework.Object = obj end)
            Wait(100)
        end
    elseif Framework.Name == 'qbr-core' then
        -- QBR-Core initialization
        while Framework.Object == nil do
            Framework.Object = exports['qbr-core']:GetCoreObject()
            Wait(100)
        end
    elseif Framework.Name == 'qr-core' then
        -- QR-Core initialization
        while Framework.Object == nil do
            Framework.Object = exports['qr-core']:GetCoreObject()
            Wait(100)
        end
    end
    
    if Config.Debug then
        print('^3[LXR-LowBlow]^7 Framework initialized: ^2' .. Framework.Name .. '^7')
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UNIFIED NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

function Framework.Notify(source, notifType, message)
    if not Config.Notifications.enabled then return end
    
    local settings = Config.FrameworkSettings[Framework.Name]
    if not settings then return end
    
    if IsDuplicityVersion() then
        -- Server-side notification
        if settings.notifications == 'ox_lib' then
            TriggerClientEvent('ox_lib:notify', source, {
                type = notifType,
                description = message,
                duration = 3000
            })
        elseif settings.notifications == 'vorp' then
            TriggerClientEvent('vorp:NotifyLeft', source, 'LowBlow', message, 'generic_textures', 'tick', 3000)
        elseif settings.notifications == 'redem' then
            TriggerClientEvent('redem_roleplay:NotifyLeft', source, 'LowBlow', message, 'generic_textures', 'tick', 3000)
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = {'LowBlow', message}
            })
        end
    else
        -- Client-side notification
        if settings.notifications == 'ox_lib' then
            exports.ox_lib:notify({
                type = notifType,
                description = message,
                duration = 3000
            })
        elseif settings.notifications == 'vorp' then
            TriggerEvent('vorp:NotifyLeft', 'LowBlow', message, 'generic_textures', 'tick', 3000)
        elseif settings.notifications == 'redem' then
            TriggerEvent('redem_roleplay:NotifyLeft', 'LowBlow', message, 'generic_textures', 'tick', 3000)
        else
            print('^3[LowBlow]^7 ' .. message)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UNIFIED HEALTH SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() then
    -- Server-side health functions
    
    function Framework.GetPlayerHealth(source)
        local ped = GetPlayerPed(source)
        return GetEntityHealth(ped)
    end
    
    function Framework.GetPlayerMaxHealth(source)
        local ped = GetPlayerPed(source)
        return GetEntityMaxHealth(ped)
    end
    
    function Framework.SetPlayerHealth(source, amount)
        local ped = GetPlayerPed(source)
        SetEntityHealth(ped, amount)
    end
    
    function Framework.ApplyDamage(source, damageAmount)
        local currentHealth = Framework.GetPlayerHealth(source)
        local newHealth = currentHealth - damageAmount
        
        if not Config.Damage.canKill and newHealth < 1 then
            newHealth = 1
        end
        
        Framework.SetPlayerHealth(source, math.max(0, newHealth))
        
        if Config.Debug then
            print(string.format('^3[LXR-LowBlow]^7 Applied ^1%d^7 damage to player ^2%s^7. Health: ^2%d^7 -> ^1%d^7', 
                damageAmount, GetPlayerName(source), currentHealth, newHealth))
        end
    end
    
    function Framework.IsPlayerLoaded(source)
        -- Check if player exists and has a valid ped
        if not source or source <= 0 then return false end
        local ped = GetPlayerPed(source)
        return ped and ped > 0
    end
    
    function Framework.GetPlayerIdentifier(source)
        local identifiers = GetPlayerIdentifiers(source)
        for _, id in pairs(identifiers) do
            if string.match(id, 'license:') then
                return id
            end
        end
        return nil
    end
    
else
    -- Client-side health functions
    
    function Framework.GetPlayerHealth()
        return GetEntityHealth(PlayerPedId())
    end
    
    function Framework.GetPlayerMaxHealth()
        return GetEntityMaxHealth(PlayerPedId())
    end
    
    function Framework.SetPlayerHealth(amount)
        SetEntityHealth(PlayerPedId(), amount)
    end
    
    function Framework.IsPlayerLoaded()
        local ped = PlayerPedId()
        return ped and ped > 0 and NetworkIsPlayerActive(PlayerId())
    end
    
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function Framework.GetLocale(key)
    local locale = Config.Locale[Config.Lang]
    if locale and locale[key] then
        return locale[key]
    end
    -- Fallback to English
    if Config.Locale.en and Config.Locale.en[key] then
        return Config.Locale.en[key]
    end
    return key
end

-- Export framework for external use
exports('GetFramework', function()
    return Framework
end)

if Config.Debug then
    print('^3[LXR-LowBlow]^7 Framework bridge loaded successfully')
end
