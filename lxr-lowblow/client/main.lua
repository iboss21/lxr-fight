--[[
    ██╗     ██╗  ██╗██████╗       ██╗      ██████╗ ██╗    ██╗██████╗ ██╗      ██████╗ ██╗    ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗██║    ██║██╔══██╗██║     ██╔═══██╗██║    ██║
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██║ █╗ ██║██████╔╝██║     ██║   ██║██║ █╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██║███╗██║██╔══██╗██║     ██║   ██║██║███╗██║
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝╚███╔███╔╝██████╔╝███████╗╚██████╔╝╚███╔███╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝ ╚═════╝  ╚══╝╚══╝ 
                                                                                                   
    🐺 LXR LowBlow - Client Script
    
    Client-side logic for the low blow melee combat system.
    Handles key detection, face-to-face validation, animations, camera shake,
    and victim ragdoll effects.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT STATE
-- ═══════════════════════════════════════════════════════════════════════════════

local onCooldown = false
local lastActionTime = 0

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Get the closest player within range
local function GetClosestPlayer(maxDistance)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer = -1
    local closestDistance = maxDistance or Config.General.maxDistance
    
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            if targetPed ~= playerPed then
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(playerCoords - targetCoords)
                
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer, closestDistance
end

-- Check if player is facing target
local function IsFacingTarget(playerPed, targetPed)
    if not Config.General.requireFacing then
        return true
    end
    
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    local playerHeading = GetEntityHeading(playerPed)
    
    -- Calculate angle between player forward vector and vector to target
    local dx = targetCoords.x - playerCoords.x
    local dy = targetCoords.y - playerCoords.y
    local targetAngle = math.deg(math.atan2(dy, dx))
    
    -- Normalize angles
    local angleDiff = math.abs(playerHeading - targetAngle)
    if angleDiff > 180 then
        angleDiff = 360 - angleDiff
    end
    
    return angleDiff <= Config.General.facingAngle
end

-- Check if target is facing player (for face-to-face requirement)
local function AreFacingEachOther(playerPed, targetPed)
    return IsFacingTarget(playerPed, targetPed) and IsFacingTarget(targetPed, playerPed)
end

-- Check if player has line of sight to target
local function HasLineOfSight(playerPed, targetPed)
    if not Config.General.requireLineOfSight then
        return true
    end
    
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    
    local rayHandle = StartShapeTestRay(
        playerCoords.x, playerCoords.y, playerCoords.z,
        targetCoords.x, targetCoords.y, targetCoords.z,
        -1, playerPed, 0
    )
    
    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
    
    return not hit or entityHit == targetPed
end

-- Validate target player state
local function IsValidTarget(targetPed)
    if not targetPed or not DoesEntityExist(targetPed) then
        return false
    end
    
    if not Config.General.checkVictimState then
        return true
    end
    
    -- Check if target is alive
    if IsEntityDead(targetPed) then
        return false
    end
    
    -- Check if target is in a vehicle
    if IsPedInAnyVehicle(targetPed, false) then
        return false
    end
    
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 ANIMATION FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Load animation dictionary
local function LoadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 5000 do
        Wait(10)
        timeout = timeout + 10
    end
    
    return HasAnimDictLoaded(dict)
end

-- Play attacker kick animation
local function PlayAttackerAnimation()
    local playerPed = PlayerPedId()
    local animConfig = Config.Animation.attacker
    
    if not LoadAnimDict(animConfig.dict) then
        if Config.Debug then
            print('^1[LXR-LowBlow]^7 Failed to load animation dictionary: ' .. animConfig.dict)
        end
        return
    end
    
    TaskPlayAnim(
        playerPed,
        animConfig.dict,
        animConfig.anim,
        animConfig.blendIn,
        animConfig.blendOut,
        animConfig.duration,
        animConfig.flag,
        0,
        false, false, false
    )
    
    -- Apply forward lunge if enabled
    if animConfig.enableLunge then
        local heading = GetEntityHeading(playerPed)
        local forwardX = math.sin(math.rad(heading)) * animConfig.lungeForce
        local forwardY = math.cos(math.rad(heading)) * animConfig.lungeForce
        
        ApplyForceToEntity(
            playerPed,
            1, -- Force type
            forwardX, forwardY, 0.0,
            0.0, 0.0, 0.0,
            0, false, true, true, false, true
        )
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CAMERA SHAKE FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function ApplyCameraShake(shakeConfig)
    if not shakeConfig.enabled then return end
    
    ShakeGameplayCam(shakeConfig.shakeName, shakeConfig.intensity)
    
    CreateThread(function()
        Wait(shakeConfig.duration)
        StopGameplayCamShaking(true)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LOW BLOW EXECUTION
-- ═══════════════════════════════════════════════════════════════════════════════

local function ExecuteLowBlow(targetPlayer)
    if onCooldown then
        if Config.Cooldowns.notifyOnCooldown then
            Framework.Notify(nil, 'error', Framework.GetLocale('cooldown_active'))
        end
        return
    end
    
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(targetPlayer)
    local targetServerId = GetPlayerServerId(targetPlayer)
    
    -- Validation checks
    if not IsValidTarget(targetPed) then
        Framework.Notify(nil, 'error', Framework.GetLocale('invalid_target'))
        return
    end
    
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    local distance = #(playerCoords - targetCoords)
    
    if distance > Config.General.maxDistance then
        Framework.Notify(nil, 'error', Framework.GetLocale('too_far'))
        return
    end
    
    if not IsFacingTarget(playerPed, targetPed) then
        Framework.Notify(nil, 'error', Framework.GetLocale('not_facing'))
        return
    end
    
    if not HasLineOfSight(playerPed, targetPed) then
        Framework.Notify(nil, 'error', Framework.GetLocale('not_facing'))
        return
    end
    
    -- All checks passed - execute low blow
    if Config.Debug then
        print('^3[LXR-LowBlow]^7 Executing low blow on player: ^2' .. targetServerId .. '^7')
    end
    
    -- Play attacker animation
    PlayAttackerAnimation()
    
    -- Apply camera shake to attacker (if enabled)
    if Config.CameraShake.attacker.enabled then
        ApplyCameraShake(Config.CameraShake.attacker)
    end
    
    -- Notify attacker
    if Config.Notifications.notifyAttacker then
        Framework.Notify(nil, 'success', Framework.GetLocale('lowblow_executed'))
    end
    
    -- Send to server for validation and damage application
    TriggerServerEvent('lxr-lowblow:server:executeLowBlow', targetServerId, distance)
    
    -- Set cooldown
    if Config.Cooldowns.enabled then
        onCooldown = true
        lastActionTime = GetGameTimer()
        
        CreateThread(function()
            Wait(Config.Cooldowns.duration)
            onCooldown = false
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 KEY DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    while true do
        Wait(Config.Performance.keyCheckInterval)
        
        if Config.General.enabled and Framework.IsPlayerLoaded() then
            local playerPed = PlayerPedId()
            
            -- Check for key press
            if IsControlJustPressed(0, Config.Keys.lowblow) then
                if Config.Debug and Config.DebugOptions.printKeyPress then
                    print('^3[LXR-LowBlow]^7 Low blow key pressed')
                end
                
                -- Check for modifier key if configured
                if Config.Keys.modifier then
                    if not IsControlPressed(0, Config.Keys.modifier) then
                        goto continue
                    end
                end
                
                -- Check if player has weapon drawn (if required)
                if Config.General.requireEmptyHands then
                    local currentWeapon = GetCurrentPedWeapon(playerPed, true)
                    if currentWeapon ~= GetHashKey('WEAPON_UNARMED') then
                        goto continue
                    end
                end
                
                -- Find closest player
                local closestPlayer, distance = GetClosestPlayer()
                
                if closestPlayer ~= -1 then
                    ExecuteLowBlow(closestPlayer)
                else
                    Framework.Notify(nil, 'error', Framework.GetLocale('too_far'))
                end
            end
        end
        
        ::continue::
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 VICTIM EFFECTS (Received from server)
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-lowblow:client:receiveHit', function()
    local playerPed = PlayerPedId()
    
    if Config.Debug then
        print('^3[LXR-LowBlow]^7 Received low blow hit')
    end
    
    -- Apply camera shake
    if Config.CameraShake.victim.enabled then
        ApplyCameraShake(Config.CameraShake.victim)
    end
    
    -- Apply ragdoll
    if Config.Animation.victim.enableRagdoll then
        SetPedToRagdoll(
            playerPed,
            Config.Animation.victim.ragdollDuration,
            Config.Animation.victim.ragdollDuration,
            Config.Animation.victim.ragdollType,
            false, false, false
        )
    end
    
    -- Notify victim
    if Config.Notifications.notifyVictim then
        Framework.Notify(nil, 'error', Framework.GetLocale('lowblow_received'))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DEBUG VISUALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.Debug and Config.DebugOptions.drawDebugLines then
    CreateThread(function()
        while true do
            Wait(0)
            
            local playerPed = PlayerPedId()
            local closestPlayer, distance = GetClosestPlayer(10.0)
            
            if closestPlayer ~= -1 then
                local playerCoords = GetEntityCoords(playerPed)
                local targetPed = GetPlayerPed(closestPlayer)
                local targetCoords = GetEntityCoords(targetPed)
                
                -- Draw line to target
                local color = distance <= Config.General.maxDistance and {0, 255, 0} or {255, 0, 0}
                DrawLine(
                    playerCoords.x, playerCoords.y, playerCoords.z,
                    targetCoords.x, targetCoords.y, targetCoords.z,
                    color[1], color[2], color[3], 255
                )
                
                -- Draw distance text
                if Config.DebugOptions.showTargetInfo then
                    local screenX, screenY = GetScreenCoordFromWorldCoord(targetCoords.x, targetCoords.y, targetCoords.z)
                    SetTextScale(0.35, 0.35)
                    SetTextFont(4)
                    SetTextProportional(true)
                    SetTextColour(255, 255, 255, 215)
                    SetTextEntry("STRING")
                    SetTextCentre(true)
                    AddTextComponentString(string.format("Distance: %.2fm", distance))
                    DrawText(screenX, screenY)
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    if Config.Debug then
        print('^3[LXR-LowBlow]^7 Client initialized successfully')
    end
end)
