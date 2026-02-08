# 📡 LXR LowBlow - Events & API Reference

```
🐺 LXR LowBlow - Events and Functions
The Land of Wolves | wolves.land
```

## Overview

LXR LowBlow uses a minimal event system focused on security and performance. This document describes all events, exports, and API functions.

---

## Client Events

### Receive Hit

**Event:** `lxr-lowblow:client:receiveHit`  
**Triggered:** Server → Client when player receives a low blow  
**Parameters:** None

**Purpose:**
- Trigger camera shake effect
- Apply ragdoll to victim
- Display victim notification

**Example:**
```lua
RegisterNetEvent('lxr-lowblow:client:receiveHit', function()
    -- Automatically handled by client script
    -- Camera shake applied
    -- Ragdoll triggered
    -- Notification displayed
end)
```

**Manual Trigger (for testing):**
```lua
TriggerEvent('lxr-lowblow:client:receiveHit')
```

---

## Server Events

### Execute Low Blow

**Event:** `lxr-lowblow:server:executeLowBlow`  
**Triggered:** Client → Server when player attempts low blow  
**Parameters:**
- `targetId` (integer) - Server ID of target player
- `distance` (float) - Reported distance to target

**Purpose:**
- Validate low blow attempt
- Apply damage to victim
- Track cooldowns
- Trigger victim effects
- Log security events

**Example:**
```lua
RegisterNetEvent('lxr-lowblow:server:executeLowBlow', function(targetId, distance)
    local source = source
    -- Automatically handled by server script
    -- Validation performed
    -- Damage applied
    -- Cooldown set
end)
```

**Manual Trigger (from client):**
```lua
TriggerServerEvent('lxr-lowblow:server:executeLowBlow', targetServerId, 2.0)
```

---

## Framework Adapter API

### Notifications

#### Framework.Notify

**Client-side:**
```lua
Framework.Notify(nil, type, message)
```

**Server-side:**
```lua
Framework.Notify(source, type, message)
```

**Parameters:**
- `source` - Player server ID (server) or nil (client)
- `type` - `'success'`, `'error'`, `'info'`, `'warning'`
- `message` - Text to display

**Examples:**
```lua
-- Success notification
Framework.Notify(nil, 'success', 'Low blow executed!')

-- Error notification
Framework.Notify(nil, 'error', 'Target too far away')

-- Server notifying specific player
Framework.Notify(playerId, 'info', 'You received a low blow')
```

---

### Health System

#### Get Player Health (Server)

```lua
local health = Framework.GetPlayerHealth(source)
```

**Returns:** Current health (integer)

#### Get Player Max Health (Server)

```lua
local maxHealth = Framework.GetPlayerMaxHealth(source)
```

**Returns:** Maximum health (integer)

#### Set Player Health (Server)

```lua
Framework.SetPlayerHealth(source, amount)
```

**Parameters:**
- `source` - Player server ID
- `amount` - New health value

#### Apply Damage (Server)

```lua
Framework.ApplyDamage(source, damageAmount)
```

**Parameters:**
- `source` - Player server ID
- `damageAmount` - Damage to apply (reduces health)

**Features:**
- Respects `Config.Damage.canKill` setting
- Logs damage in debug mode
- Handles min/max health bounds

---

### Player Validation

#### Is Player Loaded (Server)

```lua
local isLoaded = Framework.IsPlayerLoaded(source)
```

**Returns:** Boolean - true if player exists and is loaded

#### Get Player Identifier (Server)

```lua
local identifier = Framework.GetPlayerIdentifier(source)
```

**Returns:** License identifier string or nil

**Uses:**
- Cooldown tracking
- Security logging
- Player data persistence

---

### Localization

#### Get Locale String

```lua
local text = Framework.GetLocale(key)
```

**Parameters:**
- `key` - Locale key from `Config.Locale`

**Returns:** Localized string

**Example:**
```lua
local msg = Framework.GetLocale('cooldown_active')
Framework.Notify(nil, 'error', msg)
```

---

## Exports

### Get Framework Object

```lua
local Framework = exports['lxr-lowblow']:GetFramework()
```

**Returns:** Framework adapter object with all functions

**Uses:**
- External scripts wanting to use the framework bridge
- Custom integrations
- Third-party compatibility

**Example:**
```lua
local LowBlowFramework = exports['lxr-lowblow']:GetFramework()

if LowBlowFramework.Name == 'lxr-core' then
    print('LXR-Core detected')
end
```

---

## Admin Commands

### Clear Player Cooldown

**Command:** `lowblow_clearcooldown <player_id>`  
**Permission:** Console only  
**Purpose:** Remove cooldown for specific player

**Example:**
```
lowblow_clearcooldown 1
```

### Clear All Cooldowns

**Command:** `lowblow_clearall`  
**Permission:** Console only  
**Purpose:** Reset all cooldowns and action trackers

**Example:**
```
lowblow_clearall
```

---

## Internal Functions (Client)

### GetClosestPlayer

```lua
local closestPlayer, distance = GetClosestPlayer(maxDistance)
```

**Parameters:**
- `maxDistance` - Optional max distance to check

**Returns:**
- `closestPlayer` - Player ID or -1 if none
- `distance` - Distance to closest player

### IsFacingTarget

```lua
local facing = IsFacingTarget(playerPed, targetPed)
```

**Returns:** Boolean - true if player faces target

### AreFacingEachOther

```lua
local facing = AreFacingEachOther(playerPed, targetPed)
```

**Returns:** Boolean - true if both face each other

### HasLineOfSight

```lua
local los = HasLineOfSight(playerPed, targetPed)
```

**Returns:** Boolean - true if unobstructed view

### IsValidTarget

```lua
local valid = IsValidTarget(targetPed)
```

**Returns:** Boolean - true if target is valid (alive, not in vehicle)

### PlayAttackerAnimation

```lua
PlayAttackerAnimation()
```

**Purpose:** Play kick animation for attacker

### ApplyCameraShake

```lua
ApplyCameraShake(shakeConfig)
```

**Parameters:**
- `shakeConfig` - Shake configuration table

---

## Internal Functions (Server)

### IsOnCooldown

```lua
local onCooldown, timeLeft = IsOnCooldown(source)
```

**Returns:**
- `onCooldown` - Boolean
- `timeLeft` - Seconds remaining (if on cooldown)

### SetCooldown

```lua
SetCooldown(source)
```

**Purpose:** Set cooldown for player

### TrackAction

```lua
local allowed = TrackAction(source)
```

**Returns:** Boolean - true if action allowed (not spam)

**Purpose:** Rate limiting anti-spam protection

### LogSuspiciousActivity

```lua
LogSuspiciousActivity(source, reason, extraData)
```

**Parameters:**
- `source` - Player server ID
- `reason` - String description
- `extraData` - Additional information

**Purpose:** Security logging and webhook alerts

### ValidateDistance

```lua
local valid = ValidateDistance(source, target, reportedDistance)
```

**Returns:** Boolean - true if distance is valid

**Purpose:** Server-side distance verification

### CalculateDamage

```lua
local damage = CalculateDamage(target)
```

**Returns:** Integer - calculated damage amount

**Purpose:** Calculate damage based on config (absolute or percentage)

---

## Event Flow

### Successful Low Blow

```
1. Player presses G key (client)
   ↓
2. Client checks: distance, facing, line of sight
   ↓
3. Client plays attacker animation
   ↓
4. Client triggers: lxr-lowblow:server:executeLowBlow
   ↓
5. Server validates: distance, player states, cooldown
   ↓
6. Server applies damage
   ↓
7. Server sets cooldown
   ↓
8. Server triggers: lxr-lowblow:client:receiveHit → victim
   ↓
9. Victim client: camera shake, ragdoll, notification
```

### Failed Low Blow (Validation)

```
1. Player presses G key (client)
   ↓
2. Client checks: distance, facing, line of sight
   ↓
3. Validation fails → notification → STOP
```

### Failed Low Blow (Cooldown)

```
1. Player presses G key (client)
   ↓
2. Client checks: local cooldown active
   ↓
3. Cooldown active → notification → STOP
```

### Failed Low Blow (Server Validation)

```
1. Player presses G key (client)
   ↓
2. Client passes local checks
   ↓
3. Client triggers server event
   ↓
4. Server validates: distance, states, cooldown
   ↓
5. Server validation fails
   ↓
6. Server logs suspicious activity (if distance mismatch)
   ↓
7. Server sends error notification → STOP
```

---

## Custom Integration Examples

### External Damage Modifier

```lua
-- In your custom resource
AddEventHandler('lxr-lowblow:server:executeLowBlow', function(targetId, distance)
    local source = source
    
    -- Apply custom damage multiplier based on your system
    local playerSkill = GetPlayerSkillLevel(source)
    local multiplier = 1.0 + (playerSkill * 0.1)
    
    -- Damage will be calculated with base config
    -- You can modify it after with SetEntityHealth
end)
```

### Custom Notification System

```lua
-- Override Framework.Notify in your resource
local OriginalNotify = Framework.Notify

Framework.Notify = function(source, type, message)
    -- Your custom notification logic
    TriggerClientEvent('my-notify:show', source, {
        type = type,
        message = message,
        icon = 'fist'
    })
end
```

### Log to Database

```lua
-- Server-side logging to database
RegisterNetEvent('lxr-lowblow:server:executeLowBlow', function(targetId, distance)
    local source = source
    
    -- Log to your database
    MySQL.Async.execute('INSERT INTO lowblow_logs (attacker, victim, distance, timestamp) VALUES (@attacker, @victim, @distance, @time)', {
        ['@attacker'] = Framework.GetPlayerIdentifier(source),
        ['@victim'] = Framework.GetPlayerIdentifier(targetId),
        ['@distance'] = distance,
        ['@time'] = os.time()
    })
end)
```

### Achievement System Integration

```lua
-- Give achievement for first low blow
local playerFirstLowBlow = {}

AddEventHandler('lxr-lowblow:server:executeLowBlow', function(targetId, distance)
    local source = source
    local identifier = Framework.GetPlayerIdentifier(source)
    
    if not playerFirstLowBlow[identifier] then
        playerFirstLowBlow[identifier] = true
        -- Trigger your achievement system
        TriggerEvent('achievements:unlock', source, 'first_lowblow')
    end
end)
```

---

## Debugging Events

Enable debug mode to see all events:

```lua
Config.Debug = true
Config.DebugOptions.printKeyPress = true
Config.DebugOptions.printValidation = true
Config.DebugOptions.printDamage = true
```

**Console output will show:**
- Key press detection
- Validation results
- Damage calculations
- Cooldown tracking
- Event triggers

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**
