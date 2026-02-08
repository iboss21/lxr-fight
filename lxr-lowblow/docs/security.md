# 🔒 LXR LowBlow - Security & Anti-Abuse

```
🐺 LXR LowBlow - Security Features
The Land of Wolves | wolves.land
```

## Security Philosophy

LXR LowBlow is built on the principle of **never trust the client**. All critical logic, validation, and state management happens server-side to prevent exploits.

---

## Security Layers

### Layer 1: Client-Side Validation (UX)

**Purpose:** Provide immediate feedback without server roundtrip

**Checks:**
- Distance to target
- Facing requirement
- Line of sight
- Local cooldown state
- Player state (alive, not in vehicle)

**Security Level:** ⚠️ Low - Can be bypassed by modified clients

**Why it exists:** Improves user experience by not requiring server validation for obvious failures

---

### Layer 2: Server-Side Validation (Authority)

**Purpose:** Enforce authoritative checks that cannot be bypassed

**Checks:**
- Re-validate distance server-side
- Verify both players exist and are loaded
- Check target is alive
- Enforce server-side cooldowns
- Rate limit actions per minute
- Validate player state

**Security Level:** ✅ High - Cannot be bypassed

**Code Location:** `server/main.lua` - Event handler for `lxr-lowblow:server:executeLowBlow`

---

### Layer 3: Rate Limiting (Anti-Spam)

**Purpose:** Prevent players from spamming low blows even if they bypass client checks

**Mechanism:**
- Track actions per player per minute
- Configurable max actions (default: 6/minute)
- Resets every 60 seconds
- Blocks excessive attempts

**Configuration:**
```lua
Config.Security.maxActionsPerMinute = 6
```

**Security Level:** ✅ High - Server-enforced

---

### Layer 4: Logging & Detection (Monitoring)

**Purpose:** Detect and log suspicious behavior for admin review

**Features:**
- Console logging of suspicious activity
- Optional Discord webhook alerts
- Detailed player and attempt information
- Configurable kick/ban on exploit detection

**Configuration:**
```lua
Config.Security.logSuspiciousActivity = true
Config.Security.webhookEnabled = true
Config.Security.webhookUrl = 'https://discord.com/api/webhooks/...'
```

**Security Level:** ✅ High - Detection and alerting

---

## Security Configuration

### Basic Security (Recommended)

```lua
Config.Security = {
    enabled = true,
    serverSideValidation = true,
    maxDistanceCheck = 3.5,
    validatePlayerState = true,
    maxActionsPerMinute = 6,
    logSuspiciousActivity = true,
    kickOnExploit = false,
    banOnExploit = false,
    webhookUrl = '',
    webhookEnabled = false
}
```

### Strict Security (Hardcore Servers)

```lua
Config.Security = {
    enabled = true,
    serverSideValidation = true,
    maxDistanceCheck = 3.0,  -- Stricter distance
    validatePlayerState = true,
    maxActionsPerMinute = 4,  -- Lower rate limit
    logSuspiciousActivity = true,
    kickOnExploit = true,  -- Auto-kick exploiters
    banOnExploit = false,  -- Review before ban
    webhookUrl = 'https://discord.com/api/webhooks/YOUR_WEBHOOK',
    webhookEnabled = true  -- Alert admins
}
```

### Relaxed Security (Testing/Development)

```lua
Config.Security = {
    enabled = true,
    serverSideValidation = true,
    maxDistanceCheck = 5.0,  -- More lenient
    validatePlayerState = false,  -- Allow edge cases
    maxActionsPerMinute = 20,  -- Higher limit for testing
    logSuspiciousActivity = true,
    kickOnExploit = false,
    banOnExploit = false,
    webhookUrl = '',
    webhookEnabled = false
}
```

---

## Common Exploits & Mitigations

### Exploit 1: Distance Manipulation

**Attack:** Modified client reports fake distance to allow low blow from far away

**Mitigation:**
- Server re-calculates distance using `GetEntityCoords()` on both players
- Compares server distance to reported distance
- Rejects if server distance > `Config.Security.maxDistanceCheck`
- Logs suspicious activity if mismatch detected

**Code:**
```lua
local function ValidateDistance(source, target, reportedDistance)
    local sourcePed = GetPlayerPed(source)
    local targetPed = GetPlayerPed(target)
    local sourceCoords = GetEntityCoords(sourcePed)
    local targetCoords = GetEntityCoords(targetPed)
    local actualDistance = #(sourceCoords - targetCoords)
    
    if actualDistance > Config.Security.maxDistanceCheck then
        LogSuspiciousActivity(source, 'Distance validation failed')
        return false
    end
    
    return true
end
```

---

### Exploit 2: Spam/Rapid Fire

**Attack:** Bypassing client cooldown to spam low blow events

**Mitigation:**
- Server-side cooldown tracking per player
- Rate limiting (max actions per minute)
- Both cooldown AND rate limit must pass
- Logs excessive attempts

**Code:**
```lua
local function TrackAction(source)
    local identifier = Framework.GetPlayerIdentifier(source)
    local actionData = playerActionCounts[identifier]
    
    if actionData.count >= Config.Security.maxActionsPerMinute then
        LogSuspiciousActivity(source, 'Too many attempts', actionData.count)
        return false
    end
    
    actionData.count = actionData.count + 1
    return true
end
```

---

### Exploit 3: Targeting Invalid Players

**Attack:** Sending low blow event with invalid target IDs (spectators, dead players, self)

**Mitigation:**
- Validate source and target exist
- Check target is not self
- Verify target is loaded
- Confirm target is alive
- Ensure target is not in vehicle

**Code:**
```lua
-- Validate players exist
if not source or source <= 0 then return end
if not targetId or targetId <= 0 then return end
if source == targetId then return end

-- Check loaded state
if not Framework.IsPlayerLoaded(source) or not Framework.IsPlayerLoaded(targetId) then
    return
end

-- Check alive
local targetPed = GetPlayerPed(targetId)
if IsEntityDead(targetPed) then
    return
end
```

---

### Exploit 4: Cooldown Bypass

**Attack:** Clearing client cooldown state or using multiple characters

**Mitigation:**
- Server tracks cooldowns by license identifier (not player ID)
- Cooldown persists across character changes
- Server-side cooldown always authoritative
- Client cooldown is only for UX

**Code:**
```lua
local function IsOnCooldown(source)
    local identifier = Framework.GetPlayerIdentifier(source)
    if playerCooldowns[identifier] then
        local timeLeft = playerCooldowns[identifier] - os.time()
        if timeLeft > 0 then
            return true, timeLeft
        end
    end
    return false
end
```

---

### Exploit 5: Damage Manipulation

**Attack:** Modified client tries to set damage amount or disable canKill

**Mitigation:**
- Damage calculated entirely server-side
- Client never sends damage value
- Config values used directly on server
- No client input in damage calculation

**Code:**
```lua
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
```

---

## Discord Webhook Integration

### Setup

1. **Create webhook** in your Discord server:
   - Server Settings → Integrations → Webhooks → New Webhook
   - Choose channel for security alerts
   - Copy webhook URL

2. **Configure in config.lua:**
```lua
Config.Security.webhookUrl = 'https://discord.com/api/webhooks/1234567890/abcdefgh...'
Config.Security.webhookEnabled = true
```

### Webhook Format

Alerts include:
- **Player Name** - In-game name
- **Player ID** - Server ID
- **Identifier** - License identifier
- **Reason** - Why alert was triggered
- **Data** - Additional context (distance, attempt count, etc.)
- **Timestamp** - When it occurred

**Example Alert:**
```
🔒 LowBlow Security Alert

Player: John_Doe
ID: 42
Identifier: license:abc123...
Reason: Distance validation failed
Data: Actual: 5.23, Reported: 2.0

Timestamp: 2026-02-08 02:36:59
```

---

## Logging Examples

### Console Logging

**Distance Validation Failure:**
```
[LXR-LowBlow SECURITY] Player: John_Doe (license:abc123) - Reason: Distance validation failed - Data: Actual: 5.23, Reported: 2.0
```

**Rate Limit Exceeded:**
```
[LXR-LowBlow SECURITY] Player: Jane_Smith (license:xyz789) - Reason: Too many low blow attempts - Data: 12
```

**Invalid Target:**
```
[LXR-LowBlow SECURITY] Player: Bad_Actor (license:def456) - Reason: Invalid target player - Data: target_id: 0
```

---

## Admin Actions

### Viewing Logs

Enable debug mode to see all security events:

```lua
Config.Debug = true
Config.Security.logSuspiciousActivity = true
```

### Clearing Cooldowns

If a legitimate player is stuck on cooldown:

**Console command:**
```
lowblow_clearcooldown <player_id>
```

**Example:**
```
lowblow_clearcooldown 5
```

### Clearing All Data

Reset all cooldowns and rate limiters:

**Console command:**
```
lowblow_clearall
```

---

## Kick/Ban Configuration

### Auto-Kick on Exploit

```lua
Config.Security.kickOnExploit = true
```

**When triggered:**
- Player is dropped from server
- Kick message: "LowBlow exploit detected. Contact server administration."
- Event is logged
- Webhook alert sent (if enabled)

**Use case:** Servers with zero tolerance for exploits

### Auto-Ban on Exploit

```lua
Config.Security.banOnExploit = true
```

**When triggered:**
- Requires admin framework with ban capability
- Attempts to ban player using framework ban system
- Falls back to kick if ban not available

**Use case:** Extremely strict servers with automated moderation

**⚠️ Warning:** Test thoroughly before enabling auto-ban in production!

---

## Security Best Practices

### For Server Owners

1. ✅ **Always enable security:** `Config.Security.enabled = true`
2. ✅ **Enable server validation:** `Config.Security.serverSideValidation = true`
3. ✅ **Set up webhooks** for real-time alerts
4. ✅ **Monitor logs regularly** for patterns
5. ✅ **Review security settings** based on server culture
6. ⚠️ **Test before auto-kick/ban** to avoid false positives
7. ✅ **Keep resource updated** for security patches

### For Developers

1. ✅ **Never trust client data** for critical operations
2. ✅ **Always validate server-side** before applying effects
3. ✅ **Use authoritative state** (server health, server coords)
4. ✅ **Log suspicious activity** for debugging
5. ✅ **Test security** with modified clients
6. ✅ **Rate limit everything** that players can trigger
7. ✅ **Use identifiers** not player IDs for persistence

---

## Security Checklist

Before going live, verify:

- [ ] ✅ `Config.Security.enabled = true`
- [ ] ✅ `Config.Security.serverSideValidation = true`
- [ ] ✅ `Config.Security.maxDistanceCheck` is reasonable (3.0-3.5m)
- [ ] ✅ `Config.Security.maxActionsPerMinute` prevents spam (4-6)
- [ ] ✅ `Config.Security.logSuspiciousActivity = true`
- [ ] ✅ Webhook configured for alerts (optional but recommended)
- [ ] ✅ Tested with debug enabled to verify logging
- [ ] ✅ Kick/ban settings match server policy
- [ ] ✅ All admins aware of security features
- [ ] ✅ Regular log monitoring scheduled

---

## Reporting Security Issues

Found a security vulnerability?

**DO NOT** post publicly!

**Contact:**
- **Discord:** [Join our Discord](https://discord.gg/CrKcWdfd3A) and DM staff
- **Email:** Contact through wolves.land
- **GitHub:** Private security advisory on repository

We take security seriously and will respond promptly to legitimate reports.

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**
