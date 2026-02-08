--[[
    ██╗     ██╗  ██╗██████╗       ██╗      ██████╗ ██╗    ██╗██████╗ ██╗      ██████╗ ██╗    ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗██║    ██║██╔══██╗██║     ██╔═══██╗██║    ██║
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██║ █╗ ██║██████╔╝██║     ██║   ██║██║ █╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██║███╗██║██╔══██╗██║     ██║   ██║██║███╗██║
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝╚███╔███╔╝██████╔╝███████╗╚██████╔╝╚███╔███╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝ ╚═════╝  ╚══╝╚══╝ 
                                                                                                   
    🐺 LXR LowBlow - Configuration File
    
    This configuration file controls the close-range melee combat system for RedM.
    Players can execute devastating low blows when face-to-face with another player,
    triggering kick animations, damage, camera shake, and ragdoll reactions.
    All mechanics are fully configurable for your roleplay server needs.
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 1.0.0
    Performance Target: Optimized for minimal overhead and smooth player interactions
    
    Tags: RedM, Georgian, SeriousRP, Whitelist, Melee, Combat, PVP, Immersive
    
    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Primary)
    - VORP Core (Supported)
    - RedEM:RP (Compatible)
    - QBR Core (Compatible)
    - QR Core (Compatible)
    - Standalone (Compatible)
    
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Original Concept: Close-range melee combat for immersive roleplay
    Inspired by: Realistic fight mechanics and player interaction systems
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-lowblow"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════
        
        Expected: %s
        Got: %s
        
        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.
        
        🐺 wolves.land - The Land of Wolves
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    
    -- Contact & Links
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    
    -- Developer Info
    developer = 'iBoss21 / The Lux Empire',
    
    -- Tags
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'Melee', 'Combat', 'PVP', 'Immersive'}
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core (Primary)
    2. RSG-Core (Primary)
    3. VORP Core (Supported)
    4. RedEM:RP (Optional - if detected)
    5. QBR-Core (Optional - if detected)
    6. QR-Core (Optional - if detected)
    7. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' or manual: 'lxr-core', 'rsg-core', 'vorp_core', 'redem_roleplay', 'qbr-core', 'qr-core', 'standalone'

-- Framework-specific settings
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib', -- notification system to use
        health = 'native', -- health system: 'native', 'status', 'needs'
        -- Event naming convention
        events = {
            server = 'lxr-core:server:%s',
            client = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    ['rsg-core'] = {
        resource = 'rsg-core',
        notifications = 'ox_lib',
        health = 'native',
        events = {
            server = 'RSGCore:Server:%s',
            client = 'RSGCore:Client:%s',
            callback = 'RSGCore:Callback:%s'
        }
    },
    ['vorp_core'] = {
        resource = 'vorp_core',
        notifications = 'vorp',
        health = 'native',
        events = {
            server = 'vorp:server:%s',
            client = 'vorp:client:%s'
        }
    },
    ['redem_roleplay'] = {
        resource = 'redem_roleplay',
        notifications = 'redem',
        health = 'native',
        events = {
            server = 'redem:%s:server',
            client = 'redem:%s:client'
        }
    },
    ['qbr-core'] = {
        resource = 'qbr-core',
        notifications = 'ox_lib',
        health = 'native',
        events = {
            server = 'QBR:Server:%s',
            client = 'QBR:Client:%s'
        }
    },
    ['qr-core'] = {
        resource = 'qr-core',
        notifications = 'ox_lib',
        health = 'native',
        events = {
            server = 'QR:Server:%s',
            client = 'QR:Client:%s'
        }
    },
    ['standalone'] = {
        -- Minimal functionality without framework
        notifications = 'print',
        health = 'native'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'en' -- Language for notifications (en, ge, etc.)

Config.Locale = {
    en = {
        lowblow_executed = 'Low blow executed!',
        lowblow_received = 'You received a low blow!',
        cooldown_active = 'You need to wait before doing that again',
        too_far = 'Target is too far away',
        not_facing = 'You must be facing your target',
        invalid_target = 'Invalid target',
        must_be_alive = 'Target must be alive'
    },
    ge = {
        lowblow_executed = 'დარტყმა შესრულდა!',
        lowblow_received = 'მიიღე დარტყმა!',
        cooldown_active = 'უნდა დაელოდო ხელახლა გასაკეთებლად',
        too_far = 'სამიზნე ძალიან შორსაა',
        not_facing = 'უნდა უყურებდე შენს მიზანს',
        invalid_target = 'არასწორი სამიზნე',
        must_be_alive = 'სამიზნე უნდა იყოს ცოცხალი'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SETTINGS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.General = {
    enabled = true,                -- Enable/disable the entire system
    maxDistance = 2.5,             -- Maximum distance to execute low blow
    requireFacing = true,          -- Require players to be facing each other
    facingAngle = 60,              -- Max angle deviation (degrees) to be considered "facing"
    requireLineOfSight = true,     -- Require unobstructed line of sight
    enableInSafeZones = false,     -- Allow low blows in safe zones (if your server has them)
    requireEmptyHands = false,     -- Require no weapon drawn to execute
    checkVictimState = true        -- Validate victim is alive and not in vehicle
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ KEYS CONFIGURATION ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- RedM Control Hashes: https://docs.fivem.net/docs/game-references/controls/
Config.Keys = {
    lowblow = 0x760A9C6F,  -- G key - Primary low blow key
    modifier = nil         -- Optional modifier key (e.g., 0x4CC0E2FE for Left Shift), set to nil to disable
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TIMING & COOLDOWNS ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Cooldowns = {
    enabled = true,              -- Enable cooldown system
    duration = 10000,            -- Cooldown duration in milliseconds (10 seconds)
    perVictim = false,           -- Track cooldown per victim (true) or global (false)
    notifyOnCooldown = true      -- Notify player when action is on cooldown
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DAMAGE CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Damage = {
    type = 'absolute',           -- 'absolute' (fixed damage) or 'percentage' (% of max health)
    amount = 20,                 -- Damage amount (20 HP for absolute, 20% for percentage)
    canKill = true,              -- Can low blow kill the victim (false = leave at 1 HP minimum)
    applyToCore = false,         -- Apply damage to core stats (stamina, etc.) - framework dependent
    coreAmount = 10              -- Core damage amount if applyToCore is true
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ANIMATION CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Attacker animation (kick animation)
Config.Animation = {
    attacker = {
        dict = 'script_common@other@melee@unarmed@streamed_core',
        anim = 'kick_stand_r',
        duration = 1500,         -- Animation duration in milliseconds
        flag = 0,                -- Animation flag (0 = normal, 1 = repeat, etc.)
        blendIn = 0.2,           -- Blend in speed
        blendOut = -0.2,         -- Blend out speed
        enableLunge = true,      -- Apply forward lunge/push during animation
        lungeForce = 1.5         -- Lunge force magnitude
    },
    victim = {
        -- Victim uses ragdoll, no specific animation needed
        enableRagdoll = true,    -- Enable ragdoll on victim
        ragdollDuration = 3000,  -- Ragdoll duration in milliseconds
        ragdollType = 1          -- Ragdoll type (1 = normal, 2 = writhe)
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CAMERA SHAKE CONFIGURATION ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.CameraShake = {
    enabled = true,              -- Enable camera shake effect
    victim = {
        enabled = true,          -- Shake victim's camera
        shakeName = 'SMALL_EXPLOSION_SHAKE', -- Shake effect name
        intensity = 0.3,         -- Shake intensity (0.0 - 1.0)
        duration = 1000          -- Shake duration in milliseconds
    },
    attacker = {
        enabled = false,         -- Shake attacker's camera (for feedback)
        shakeName = 'SMALL_EXPLOSION_SHAKE',
        intensity = 0.1,
        duration = 500
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ NOTIFICATION CONFIGURATION ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Notifications = {
    enabled = true,              -- Enable notification system
    clientOnly = true,           -- Show notifications only to involved players (not broadcast)
    notifyAttacker = true,       -- Notify attacker on successful low blow
    notifyVictim = true,         -- Notify victim when hit
    notifyNearby = false,        -- Notify nearby players (not implemented in base version)
    notifyRadius = 10.0          -- Radius for nearby notifications (if enabled)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECURITY & ANTI-ABUSE █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Security = {
    enabled = true,                     -- Enable security checks
    serverSideValidation = true,        -- Perform all critical checks server-side
    maxDistanceCheck = 3.5,             -- Server-side max distance (slightly larger than client for lag)
    validatePlayerState = true,         -- Validate both players are in valid states
    maxActionsPerMinute = 6,            -- Max low blows per player per minute (spam protection)
    logSuspiciousActivity = true,       -- Log suspicious behavior to console
    kickOnExploit = false,              -- Kick player on detected exploit attempt
    banOnExploit = false,               -- Ban player on detected exploit (requires admin framework)
    webhookUrl = '',                    -- Discord webhook for security logs (optional)
    webhookEnabled = false              -- Enable Discord webhook logging
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ PERFORMANCE OPTIMIZATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Performance = {
    keyCheckInterval = 100,      -- How often to check for key press (milliseconds)
    nearbyPlayerCheck = 500,     -- How often to check for nearby players (milliseconds)
    cleanupInterval = 300000,    -- Cleanup old cooldowns every 5 minutes
    maxTrackedPlayers = 100,     -- Maximum players to track for cooldowns
    usePlayerCache = true,       -- Cache player data to reduce lookups
    cacheUpdateInterval = 5000   -- Update player cache every 5 seconds
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEBUG SETTINGS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = false -- Enable debug prints and extra logging

Config.DebugOptions = {
    printKeyPress = false,       -- Print when low blow key is pressed
    printValidation = false,     -- Print validation check results
    printDamage = false,         -- Print damage calculations
    printCooldowns = false,      -- Print cooldown information
    drawDebugLines = false,      -- Draw debug lines for distance/facing checks
    showTargetInfo = false       -- Show target player info on screen
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ END OF CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Startup banner
CreateThread(function()
    Wait(1000)
    local attackerAnim = Config.Animation.attacker.anim or 'N/A'
    local cooldownSec = Config.Cooldowns.duration / 1000
    local damageDisplay = Config.Damage.type == 'percentage' 
        and (Config.Damage.amount .. '%') 
        or (Config.Damage.amount .. ' HP')
    
    print([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        
            ██╗     ██╗  ██╗██████╗       ██╗      ██████╗ ██╗    ██╗
            ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗██║    ██║
            ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██║ █╗ ██║
            ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██║███╗██║
            ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝╚███╔███╔╝
            ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝  ╚══╝╚══╝ 
            
            ██████╗ ██╗      ██████╗ ██╗    ██╗    ███████╗██╗   ██╗███████╗
            ██╔══██╗██║     ██╔═══██╗██║    ██║    ██╔════╝╚██╗ ██╔╝██╔════╝
            ██████╔╝██║     ██║   ██║██║ █╗ ██║    ███████╗ ╚████╔╝ ███████╗
            ██╔══██╗██║     ██║   ██║██║███╗██║    ╚════██║  ╚██╔╝  ╚════██║
            ██████╔╝███████╗╚██████╔╝╚███╔███╔╝    ███████║   ██║   ███████║
            ╚═════╝ ╚══════╝ ╚═════╝  ╚══╝╚══╝     ╚══════╝   ╚═╝   ╚══════╝
        
        ═══════════════════════════════════════════════════════════════════════════════
        🐺 CLOSE-RANGE MELEE SYSTEM - SUCCESSFULLY LOADED
        ═══════════════════════════════════════════════════════════════════════════════
        
        Version:     1.0.0
        Server:      ]] .. Config.ServerInfo.name .. [[
        
        Framework:   Auto-detect enabled
        Language:    ]] .. Config.Lang .. [[
        
        Max Distance: ]] .. Config.General.maxDistance .. [[m
        Damage:      ]] .. damageDisplay .. [[
        Cooldown:    ]] .. cooldownSec .. [[s
        Ragdoll:     ]] .. (Config.Animation.victim.ragdollDuration / 1000) .. [[s
        
        Animation:   ]] .. attackerAnim .. [[
        Camera Shake: ]] .. (Config.CameraShake.enabled and 'ENABLED ✓' or 'DISABLED ✗') .. [[
        Security:    ]] .. (Config.Security.enabled and 'ENABLED ✓' or 'DISABLED ✗') .. [[
        Debug:       ]] .. (Config.Debug and 'ENABLED' or 'DISABLED') .. [[
        
        ═══════════════════════════════════════════════════════════════════════════════
        
        Developer:   iBoss21 / The Lux Empire
        Website:     https://www.wolves.land
        Discord:     https://discord.gg/CrKcWdfd3A
        
        🥊 Press G when facing another player to execute a low blow!
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]])
end)
