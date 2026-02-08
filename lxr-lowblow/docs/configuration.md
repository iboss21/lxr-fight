# ⚙️ LXR LowBlow - Configuration Reference

```
🐺 LXR LowBlow - Complete Configuration Guide
The Land of Wolves | wolves.land
```

This document provides a complete reference for all configuration options in `config.lua`.

---

## Server Information

```lua
Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!',
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer = 'iBoss21 / The Lux Empire',
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'Melee', 'Combat', 'PVP', 'Immersive'}
}
```

Customize this section with your server's information.

---

## Framework Configuration

### Framework Selection

```lua
Config.Framework = 'auto'
```

**Options:**
- `'auto'` - Automatically detect installed framework (recommended)
- `'lxr-core'` - Force LXR-Core
- `'rsg-core'` - Force RSG-Core
- `'vorp_core'` - Force VORP Core
- `'redem_roleplay'` - Force RedEM:RP
- `'qbr-core'` - Force QBR-Core
- `'qr-core'` - Force QR-Core
- `'standalone'` - Force standalone mode

**Detection Priority:**
1. LXR-Core
2. RSG-Core
3. VORP Core
4. RedEM:RP
5. QBR-Core
6. QR-Core
7. Standalone (fallback)

---

## Language Configuration

```lua
Config.Lang = 'en'  -- 'en' or 'ge'
```

**Available Languages:**
- `'en'` - English
- `'ge'` - Georgian (ქართული)

### Adding Custom Languages

Add to `Config.Locale`:

```lua
Config.Locale.fr = {
    lowblow_executed = 'Coup bas exécuté!',
    lowblow_received = 'Vous avez reçu un coup bas!',
    cooldown_active = 'Vous devez attendre',
    too_far = 'Cible trop éloignée',
    not_facing = 'Vous devez faire face à votre cible',
    invalid_target = 'Cible invalide',
    must_be_alive = 'La cible doit être vivante'
}
```

Then set: `Config.Lang = 'fr'`

---

## General Settings

```lua
Config.General = {
    enabled = true,
    maxDistance = 2.5,
    requireFacing = true,
    facingAngle = 60,
    requireLineOfSight = true,
    enableInSafeZones = false,
    requireEmptyHands = false,
    checkVictimState = true
}
```

### Options Explained

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `enabled` | boolean | `true` | Master enable/disable switch |
| `maxDistance` | float | `2.5` | Max distance in meters to execute low blow |
| `requireFacing` | boolean | `true` | Both players must face each other |
| `facingAngle` | integer | `60` | Max angle deviation in degrees |
| `requireLineOfSight` | boolean | `true` | Require unobstructed view |
| `enableInSafeZones` | boolean | `false` | Allow in safe zones (if applicable) |
| `requireEmptyHands` | boolean | `false` | Must have no weapon drawn |
| `checkVictimState` | boolean | `true` | Validate victim is alive/not in vehicle |

**Recommended for Serious RP:**
- `requireFacing = true`
- `requireLineOfSight = true`
- `checkVictimState = true`
- `enableInSafeZones = false`

**Recommended for Casual Servers:**
- `requireFacing = false`
- `requireLineOfSight = false`
- `enableInSafeZones = true`

---

## Key Bindings

```lua
Config.Keys = {
    lowblow = 0x760A9C6F,  -- G key
    modifier = nil         -- Optional modifier (e.g., Left Shift)
}
```

### Common Key Hashes

| Key | Hash | Description |
|-----|------|-------------|
| G | `0x760A9C6F` | Default low blow key |
| E | `0xDFF812F9` | Alternate interaction key |
| F | `0xB2F377E8` | Common interaction key |
| X | `0x8CC9CD42` | Cancel/exit key |
| Left Shift | `0x4CC0E2FE` | Common modifier |
| Left Ctrl | `0xDB096B85` | Alternate modifier |

**Find more:** [RedM Controls Reference](https://docs.fivem.net/docs/game-references/controls/)

### Using Modifiers

To require Shift+G:

```lua
Config.Keys = {
    lowblow = 0x760A9C6F,
    modifier = 0x4CC0E2FE
}
```

---

## Cooldown System

```lua
Config.Cooldowns = {
    enabled = true,
    duration = 10000,
    perVictim = false,
    notifyOnCooldown = true
}
```

### Options Explained

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `enabled` | boolean | `true` | Enable cooldown system |
| `duration` | integer | `10000` | Cooldown time in milliseconds (10s) |
| `perVictim` | boolean | `false` | Track per victim or globally |
| `notifyOnCooldown` | boolean | `true` | Notify when on cooldown |

**Examples:**

Short cooldown (5 seconds):
```lua
Config.Cooldowns.duration = 5000
```

Long cooldown (30 seconds):
```lua
Config.Cooldowns.duration = 30000
```

Per-victim tracking (can hit different players):
```lua
Config.Cooldowns.perVictim = true
```

---

## Damage Configuration

```lua
Config.Damage = {
    type = 'absolute',
    amount = 20,
    canKill = true,
    applyToCore = false,
    coreAmount = 10
}
```

### Damage Types

#### Absolute Damage (Fixed HP)

```lua
Config.Damage = {
    type = 'absolute',
    amount = 20  -- Fixed 20 HP damage
}
```

**Use when:** You want consistent, predictable damage

#### Percentage Damage (% of Max Health)

```lua
Config.Damage = {
    type = 'percentage',
    amount = 20  -- 20% of max health
}
```

**Use when:** Players have varying max health values

### Safety Options

```lua
Config.Damage.canKill = false  -- Leaves victim at 1 HP minimum
```

**Recommended for:** Roleplay servers where death should require consent

### Core Damage (Framework-Dependent)

```lua
Config.Damage.applyToCore = true
Config.Damage.coreAmount = 10
```

Applies damage to stamina/core stats (if framework supports it).

---

## Animation Configuration

```lua
Config.Animation = {
    attacker = {
        dict = 'melee@unarmed@streamed_core',
        anim = 'kick_standing',
        duration = 1500,
        flag = 0,
        blendIn = 0.2,
        blendOut = -0.2,
        enableLunge = true,
        lungeForce = 1.5
    },
    victim = {
        enableRagdoll = true,
        ragdollDuration = 3000,
        ragdollType = 1
    }
}
```

### Attacker Animation

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `dict` | string | (see above) | Animation dictionary |
| `anim` | string | `'kick_standing'` | Animation name |
| `duration` | integer | `1500` | Animation length (ms) |
| `flag` | integer | `0` | Animation flags |
| `blendIn` | float | `0.2` | Blend in speed |
| `blendOut` | float | `-0.2` | Blend out speed |
| `enableLunge` | boolean | `true` | Push forward during kick |
| `lungeForce` | float | `1.5` | Lunge intensity |

### Alternative Animations

Punch animation:
```lua
Config.Animation.attacker.anim = 'punch_standing'
```

Headbutt animation (if available in your game):
```lua
Config.Animation.attacker.dict = 'melee@unarmed@streamed_core'
Config.Animation.attacker.anim = 'headbutt_standing'
```

### Victim Ragdoll

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `enableRagdoll` | boolean | `true` | Enable ragdoll effect |
| `ragdollDuration` | integer | `3000` | Ragdoll time (ms) |
| `ragdollType` | integer | `1` | Ragdoll type (1=normal, 2=writhe) |

**Shorter ragdoll (more forgiving):**
```lua
Config.Animation.victim.ragdollDuration = 1500  -- 1.5 seconds
```

**Longer ragdoll (more punishing):**
```lua
Config.Animation.victim.ragdollDuration = 5000  -- 5 seconds
```

---

## Camera Shake Configuration

```lua
Config.CameraShake = {
    enabled = true,
    victim = {
        enabled = true,
        shakeName = 'SMALL_EXPLOSION_SHAKE',
        intensity = 0.3,
        duration = 1000
    },
    attacker = {
        enabled = false,
        shakeName = 'SMALL_EXPLOSION_SHAKE',
        intensity = 0.1,
        duration = 500
    }
}
```

### Shake Effects

| Shake Name | Description |
|------------|-------------|
| `SMALL_EXPLOSION_SHAKE` | Light shake (default) |
| `MEDIUM_EXPLOSION_SHAKE` | Medium shake |
| `LARGE_EXPLOSION_SHAKE` | Heavy shake |
| `HAND_SHAKE` | Subtle hand shake |
| `JOLT_SHAKE` | Quick jolt |
| `VIBRATE_SHAKE` | Continuous vibration |

### Intensity Levels

- `0.1` - Very subtle
- `0.3` - Moderate (default)
- `0.5` - Strong
- `1.0` - Maximum

**Disable for victim:**
```lua
Config.CameraShake.victim.enabled = false
```

---

## Notification Configuration

```lua
Config.Notifications = {
    enabled = true,
    clientOnly = true,
    notifyAttacker = true,
    notifyVictim = true,
    notifyNearby = false,
    notifyRadius = 10.0
}
```

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `enabled` | boolean | `true` | Master notification toggle |
| `clientOnly` | boolean | `true` | Show only to involved players |
| `notifyAttacker` | boolean | `true` | Notify attacker on success |
| `notifyVictim` | boolean | `true` | Notify victim when hit |
| `notifyNearby` | boolean | `false` | Notify nearby players |
| `notifyRadius` | float | `10.0` | Radius for nearby notifications |

---

## Security & Anti-Abuse

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

### Security Options

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `enabled` | boolean | `true` | Master security toggle |
| `serverSideValidation` | boolean | `true` | Validate all actions server-side |
| `maxDistanceCheck` | float | `3.5` | Server-side max distance (lag buffer) |
| `validatePlayerState` | boolean | `true` | Check player states |
| `maxActionsPerMinute` | integer | `6` | Rate limit per player |
| `logSuspiciousActivity` | boolean | `true` | Log suspicious behavior |
| `kickOnExploit` | boolean | `false` | Auto-kick exploiters |
| `banOnExploit` | boolean | `false` | Auto-ban exploiters |
| `webhookUrl` | string | `''` | Discord webhook URL |
| `webhookEnabled` | boolean | `false` | Enable webhook logging |

### Discord Webhook Setup

1. Create a Discord webhook in your server
2. Copy the webhook URL
3. Configure:

```lua
Config.Security.webhookUrl = 'https://discord.com/api/webhooks/...'
Config.Security.webhookEnabled = true
```

---

## Performance Optimization

```lua
Config.Performance = {
    keyCheckInterval = 100,
    nearbyPlayerCheck = 500,
    cleanupInterval = 300000,
    maxTrackedPlayers = 100,
    usePlayerCache = true,
    cacheUpdateInterval = 5000
}
```

### Performance Options

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `keyCheckInterval` | integer | `100` | Key check frequency (ms) |
| `nearbyPlayerCheck` | integer | `500` | Proximity check frequency (ms) |
| `cleanupInterval` | integer | `300000` | Cleanup old data (ms) |
| `maxTrackedPlayers` | integer | `100` | Max cooldown entries |
| `usePlayerCache` | true | `boolean` | Cache player data |
| `cacheUpdateInterval` | integer | `5000` | Cache update frequency (ms) |

### Tuning for Your Server

**High performance (sacrifice responsiveness):**
```lua
Config.Performance.keyCheckInterval = 200
Config.Performance.nearbyPlayerCheck = 1000
```

**High responsiveness (more CPU usage):**
```lua
Config.Performance.keyCheckInterval = 50
Config.Performance.nearbyPlayerCheck = 200
```

---

## Debug Settings

```lua
Config.Debug = false

Config.DebugOptions = {
    printKeyPress = false,
    printValidation = false,
    printDamage = false,
    printCooldowns = false,
    drawDebugLines = false,
    showTargetInfo = false
}
```

Enable for troubleshooting:

```lua
Config.Debug = true
Config.DebugOptions.printDamage = true  -- See damage calculations
Config.DebugOptions.printCooldowns = true  -- See cooldown tracking
```

**Warning:** Disable in production for performance.

---

## Configuration Examples

### Hardcore RP Server

```lua
Config.General.maxDistance = 2.0  -- Closer range
Config.General.requireFacing = true
Config.General.requireLineOfSight = true
Config.Damage.type = 'absolute'
Config.Damage.amount = 30  -- Higher damage
Config.Cooldowns.duration = 30000  -- Longer cooldown
Config.Animation.victim.ragdollDuration = 5000  -- Longer stun
```

### Casual Server

```lua
Config.General.maxDistance = 4.0  -- Farther range
Config.General.requireFacing = false
Config.General.requireLineOfSight = false
Config.Damage.type = 'absolute'
Config.Damage.amount = 10  -- Lower damage
Config.Damage.canKill = false  -- Can't kill
Config.Cooldowns.duration = 5000  -- Shorter cooldown
Config.Animation.victim.ragdollDuration = 2000  -- Shorter stun
```

### PVP Server

```lua
Config.General.maxDistance = 3.0
Config.Damage.type = 'percentage'
Config.Damage.amount = 25  -- 25% health
Config.Damage.canKill = true
Config.Cooldowns.duration = 8000
Config.Security.maxActionsPerMinute = 10  -- Higher limit
```

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**
