--[[
    ██╗     ██╗  ██╗██████╗       ██╗      ██████╗ ██╗    ██╗██████╗ ██╗      ██████╗ ██╗    ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗██║    ██║██╔══██╗██║     ██╔═══██╗██║    ██║
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██║ █╗ ██║██████╔╝██║     ██║   ██║██║ █╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██║███╗██║██╔══██╗██║     ██║   ██║██║███╗██║
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝╚███╔███╔╝██████╔╝███████╗╚██████╔╝╚███╔███╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝ ╚═════╝  ╚══╝╚══╝ 
                                                                                                   
    🐺 LXR LowBlow - Close-Range Melee Action System
    
    FiveM/RedM resource manifest for the LowBlow melee combat system.
    This manifest defines the resource structure, dependencies, and load order
    for the close-range combat mechanics.
    
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
    Performance Target: Minimal overhead, optimized for player combat interactions
    
    Tags: RedM, Georgian, SeriousRP, Whitelist, Melee, Combat, PVP
    
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
    Original Concept: Close-range combat mechanics for immersive roleplay
    Inspired by: Realistic melee combat and player interaction systems
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FXMANIFEST CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════

fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

-- Resource Information
name 'lxr-lowblow'
author 'iBoss21 / The Lux Empire'
description 'Close-range melee action system for RedM - brutal, immersive face-to-face combat'
version '1.0.0'

-- Script Load Order
lua54 'yes'

-- ═══════════════════════════════════════════════════════════════════════════════
-- SHARED SCRIPTS (Loaded on both client and server)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Scope: Configuration, framework bridge, and shared utilities

shared_scripts {
    'config.lua',
    'shared/framework.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CLIENT SCRIPTS (Player-side only)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Scope: Key detection, animations, camera shake, ragdoll, face-to-face validation

client_scripts {
    'client/main.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVER SCRIPTS (Server-side authority)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Scope: Damage application, cooldown tracking, security validation, anti-abuse

server_scripts {
    'server/main.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEPENDENCIES (Optional - Auto-detected frameworks)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Note: No hard dependencies required - supports multiple frameworks via auto-detection

-- Optional framework dependencies (will use if available)
-- dependencies {
--     -- Framework auto-detection handles this
-- }

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF MANIFEST
-- ═══════════════════════════════════════════════════════════════════════════════
