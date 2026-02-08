--[[
    ██╗     ██╗  ██╗██████╗       ██╗      ██████╗ ██╗    ██╗██████╗ ██╗      ██████╗ ██╗    ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗██║    ██║██╔══██╗██║     ██╔═══██╗██║    ██║
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██║ █╗ ██║██████╔╝██║     ██║   ██║██║ █╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██║███╗██║██╔══██╗██║     ██║   ██║██║███╗██║
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝╚███╔███╔╝██████╔╝███████╗╚██████╔╝╚███╔███╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝ ╚═════╝  ╚══╝╚══╝ 
                                                                                                   
    🐺 LXR LowBlow - Server Script
    
    Server-side authority for the low blow melee combat system.
    Handles validation, damage application, cooldown tracking, and anti-abuse measures.
    All critical logic runs server-side to prevent exploits.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER STATE
-- ═══════════════════════════════════════════════════════════════════════════════

local playerCooldowns = {}      -- Track cooldowns per player
local playerActionCounts = {}   -- Track actions per minute for anti-spam

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Check if player is on cooldown
local function IsOnCooldown(source)
    if not Config.Cooldowns.enabled then
        return false
    end
    
    local identifier = Framework.GetPlayerIdentifier(source)
    if not identifier then return false end
    
    if playerCooldowns[identifier] then
        local timeLeft = playerCooldowns[identifier] - os.time()
        if timeLeft > 0 then
            return true, timeLeft
        else
            playerCooldowns[identifier] = nil
        end
    end
    
    return false
end

-- Set cooldown for player
local function SetCooldown(source)
    if not Config.Cooldowns.enabled then return end
    
    local identifier = Framework.GetPlayerIdentifier(source)
    if not identifier then return end
    
    local cooldownEnd = os.time() + (Config.Cooldowns.duration / 1000)
    playerCooldowns[identifier] = cooldownEnd
    
    if Config.Debug and Config.DebugOptions.printCooldowns then
        print(string.format('^3[LXR-LowBlow]^7 Cooldown set for player ^2%s^7 until: ^2%s^7', 
            GetPlayerName(source), os.date('%H:%M:%S', cooldownEnd)))
    end
end

-- Track action for anti-spam
local function TrackAction(source)
    if not Config.Security.enabled then return true end
    
    local identifier = Framework.GetPlayerIdentifier(source)
    if not identifier then return false end
    
    local currentTime = os.time()
    
    if not playerActionCounts[identifier] then
        playerActionCounts[identifier] = {
            count = 1,
            resetTime = currentTime + 60
        }
        return true
    end
    
    local actionData = playerActionCounts[identifier]
    
    -- Reset if minute has passed
    if currentTime >= actionData.resetTime then
        actionData.count = 1
        actionData.resetTime = currentTime + 60
        return true
    end
    
    -- Check if over limit
    if actionData.count >= Config.Security.maxActionsPerMinute then
        LogSuspiciousActivity(source, 'Too many low blow attempts', actionData.count)
        return false
    end
    
    actionData.count = actionData.count + 1
    return true
end

-- Log suspicious activity
function LogSuspiciousActivity(source, reason, extraData)
    if not Config.Security.logSuspiciousActivity then return end
    
    local playerName = GetPlayerName(source)
    local identifier = Framework.GetPlayerIdentifier(source)
    
    print(string.format('^1[LXR-LowBlow SECURITY]^7 Player: ^2%s^7 (%s) - Reason: ^1%s^7 - Data: ^3%s^7', 
        playerName, identifier or 'unknown', reason, tostring(extraData)))
    
    -- Discord webhook logging (if enabled)
    if Config.Security.webhookEnabled and Config.Security.webhookUrl ~= '' then
        local embed = {
            {
                ['title'] = '🔒 LowBlow Security Alert',
                ['description'] = string.format('**Player:** %s\n**ID:** %s\n**Reason:** %s\n**Data:** %s', 
                    playerName, source, reason, tostring(extraData)),
                ['color'] = 15158332, -- Red color
                ['footer'] = {
                    ['text'] = 'LXR LowBlow Security System | wolves.land'
                },
                ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%S')
            }
        }
        
        PerformHttpRequest(Config.Security.webhookUrl, function(err, text, headers) end, 'POST', 
            json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
    end
    
    -- Handle exploit detection
    if Config.Security.kickOnExploit then
        DropPlayer(source, 'LowBlow exploit detected. Contact server administration.')
    end
end

-- Validate distance between players
local function ValidateDistance(source, target, reportedDistance)
    if not Config.Security.serverSideValidation then
        return true
    end
    
    local sourcePed = GetPlayerPed(source)
    local targetPed = GetPlayerPed(target)
    
    if not sourcePed or not targetPed then
        return false
    end
    
    local sourceCoords = GetEntityCoords(sourcePed)
    local targetCoords = GetEntityCoords(targetPed)
    local actualDistance = #(sourceCoords - targetCoords)
    
    if actualDistance > Config.Security.maxDistanceCheck then
        LogSuspiciousActivity(source, 'Distance validation failed', 
            string.format('Actual: %.2f, Reported: %.2f', actualDistance, reportedDistance))
        return false
    end
    
    return true
end

-- Calculate damage amount
local function CalculateDamage(target)
    local damageAmount = 0
    
    if Config.Damage.type == 'percentage' then
        local maxHealth = Framework.GetPlayerMaxHealth(target)
        damageAmount = math.floor(maxHealth * (Config.Damage.amount / 100))
    else
        damageAmount = Config.Damage.amount
    end
    
    return damageAmount
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 MAIN LOW BLOW EVENT HANDLER
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-lowblow:server:executeLowBlow', function(targetId, distance)
    local source = source
    
    if not Config.General.enabled then return end
    
    -- Validate source and target
    if not source or source <= 0 then return end
    if not targetId or targetId <= 0 then return end
    if source == targetId then return end
    
    -- Check if players exist
    if not Framework.IsPlayerLoaded(source) or not Framework.IsPlayerLoaded(targetId) then
        return
    end
    
    -- Check cooldown
    local onCooldown, timeLeft = IsOnCooldown(source)
    if onCooldown then
        if Config.Cooldowns.notifyOnCooldown then
            Framework.Notify(source, 'error', Framework.GetLocale('cooldown_active'))
        end
        return
    end
    
    -- Check action spam
    if not TrackAction(source) then
        Framework.Notify(source, 'error', 'Too many attempts. Please slow down.')
        return
    end
    
    -- Validate distance
    if not ValidateDistance(source, targetId, distance) then
        Framework.Notify(source, 'error', Framework.GetLocale('too_far'))
        return
    end
    
    -- Validate target is alive
    local targetPed = GetPlayerPed(targetId)
    if IsEntityDead(targetPed) then
        Framework.Notify(source, 'error', Framework.GetLocale('must_be_alive'))
        return
    end
    
    -- All validation passed - apply damage
    local damageAmount = CalculateDamage(targetId)
    Framework.ApplyDamage(targetId, damageAmount)
    
    -- Trigger victim effects
    TriggerClientEvent('lxr-lowblow:client:receiveHit', targetId)
    
    -- Set cooldown
    SetCooldown(source)
    
    -- Logging
    if Config.Debug then
        print(string.format('^3[LXR-LowBlow]^7 Player ^2%s^7 executed low blow on ^2%s^7 for ^1%d^7 damage', 
            GetPlayerName(source), GetPlayerName(targetId), damageAmount))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLEANUP & MAINTENANCE
-- ═══════════════════════════════════════════════════════════════════════════════

-- Cleanup old cooldowns and action counts
CreateThread(function()
    while true do
        Wait(Config.Performance.cleanupInterval)
        
        local currentTime = os.time()
        local cleanedCooldowns = 0
        local cleanedActions = 0
        
        -- Clean cooldowns
        for identifier, cooldownEnd in pairs(playerCooldowns) do
            if currentTime >= cooldownEnd then
                playerCooldowns[identifier] = nil
                cleanedCooldowns = cleanedCooldowns + 1
            end
        end
        
        -- Clean action counts
        for identifier, actionData in pairs(playerActionCounts) do
            if currentTime >= actionData.resetTime then
                playerActionCounts[identifier] = nil
                cleanedActions = cleanedActions + 1
            end
        end
        
        if Config.Debug and (cleanedCooldowns > 0 or cleanedActions > 0) then
            print(string.format('^3[LXR-LowBlow]^7 Cleanup: ^2%d^7 cooldowns, ^2%d^7 action trackers', 
                cleanedCooldowns, cleanedActions))
        end
    end
end)

-- Clean player data on disconnect
AddEventHandler('playerDropped', function(reason)
    local source = source
    local identifier = Framework.GetPlayerIdentifier(source)
    
    if identifier then
        playerCooldowns[identifier] = nil
        playerActionCounts[identifier] = nil
        
        if Config.Debug then
            print(string.format('^3[LXR-LowBlow]^7 Cleaned data for disconnected player: ^2%s^7', 
                GetPlayerName(source)))
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 ADMIN COMMANDS (Optional)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Clear cooldown for a player (admin command)
RegisterCommand('lowblow_clearcooldown', function(source, args, rawCommand)
    if source == 0 then
        -- Console command
        if args[1] then
            local targetId = tonumber(args[1])
            if targetId then
                local identifier = Framework.GetPlayerIdentifier(targetId)
                if identifier then
                    playerCooldowns[identifier] = nil
                    print('^2[LXR-LowBlow]^7 Cooldown cleared for player: ' .. GetPlayerName(targetId))
                end
            end
        else
            print('^1[LXR-LowBlow]^7 Usage: lowblow_clearcooldown <player_id>')
        end
    end
end, false)

-- Clear all cooldowns (admin command)
RegisterCommand('lowblow_clearall', function(source, args, rawCommand)
    if source == 0 then
        -- Console command
        playerCooldowns = {}
        playerActionCounts = {}
        print('^2[LXR-LowBlow]^7 All cooldowns and action trackers cleared')
    end
end, false)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    if Config.Debug then
        print('^3[LXR-LowBlow]^7 Server initialized successfully')
        print('^3[LXR-LowBlow]^7 Security: ' .. (Config.Security.enabled and '^2ENABLED^7' or '^1DISABLED^7'))
        print('^3[LXR-LowBlow]^7 Cooldowns: ' .. (Config.Cooldowns.enabled and '^2ENABLED^7' or '^1DISABLED^7'))
    end
end)
