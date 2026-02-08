# 🔄 LXR LowBlow - Framework Support

```
🐺 LXR LowBlow - Multi-Framework Architecture
The Land of Wolves | wolves.land
```

## Overview

LXR LowBlow uses a **unified adapter architecture** that allows it to work seamlessly with multiple frameworks or completely standalone. The system automatically detects your framework and adapts accordingly.

---

## Supported Frameworks

| Framework | Status | Priority | Auto-Detect | Resource Name |
|-----------|--------|----------|-------------|---------------|
| **LXR-Core** | ✅ Primary | 1st | ✅ Yes | `lxr-core` |
| **RSG-Core** | ✅ Primary | 2nd | ✅ Yes | `rsg-core` |
| **VORP Core** | ✅ Supported | 3rd | ✅ Yes | `vorp_core` |
| **RedEM:RP** | ✅ Compatible | 4th | ✅ Yes | `redem_roleplay` |
| **QBR-Core** | ✅ Compatible | 5th | ✅ Yes | `qbr-core` |
| **QR-Core** | ✅ Compatible | 6th | ✅ Yes | `qr-core` |
| **Standalone** | ✅ Fallback | 7th | ✅ Yes | N/A |

---

## How Auto-Detection Works

### Detection Order

The framework bridge (`shared/framework.lua`) checks for frameworks in priority order:

1. **Check resource state** using `GetResourceState()`
2. **Verify resource is started** or starting
3. **Select first match** and stop checking
4. **Fallback to standalone** if none found

### Detection Code

```lua
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
        return fw.name
    end
end

Framework.Name = 'standalone'
```

---

## Manual Framework Selection

If auto-detection fails or you want to force a specific framework:

```lua
Config.Framework = 'lxr-core'  -- Force LXR-Core
```

**Valid values:**
- `'auto'` - Auto-detect (default)
- `'lxr-core'`
- `'rsg-core'`
- `'vorp_core'`
- `'redem_roleplay'`
- `'qbr-core'`
- `'qr-core'`
- `'standalone'`

---

## Framework Adapter Functions

The framework bridge provides a **unified API** that works across all frameworks:

### Notification System

```lua
Framework.Notify(source, type, message)
```

**Parameters:**
- `source` - Player server ID (server-side) or nil (client-side)
- `type` - Notification type: `'success'`, `'error'`, `'info'`, `'warning'`
- `message` - Message text to display

**Example:**
```lua
Framework.Notify(nil, 'success', 'Low blow executed!')
```

### Health System

**Server-side:**

```lua
-- Get player current health
local health = Framework.GetPlayerHealth(source)

-- Get player max health
local maxHealth = Framework.GetPlayerMaxHealth(source)

-- Set player health
Framework.SetPlayerHealth(source, 100)

-- Apply damage
Framework.ApplyDamage(source, 20)  -- Reduces health by 20
```

**Client-side:**

```lua
-- Get player current health
local health = Framework.GetPlayerHealth()

-- Get player max health
local maxHealth = Framework.GetPlayerMaxHealth()

-- Set player health
Framework.SetPlayerHealth(100)
```

### Player Validation

**Server-side:**

```lua
-- Check if player is loaded
local isLoaded = Framework.IsPlayerLoaded(source)

-- Get player identifier (license)
local identifier = Framework.GetPlayerIdentifier(source)
```

**Client-side:**

```lua
-- Check if player is loaded
local isLoaded = Framework.IsPlayerLoaded()
```

### Localization

```lua
-- Get localized text
local text = Framework.GetLocale('lowblow_executed')
```

---

## Framework-Specific Details

### LXR-Core

**Initialization:**
```lua
TriggerEvent('lxr-core:getSharedObject', function(obj) 
    Framework.Object = obj 
end)
-- or
exports['lxr-core']:GetCoreObject(function(obj) 
    Framework.Object = obj 
end)
```

**Notifications:**
- Uses `ox_lib` by default
- Fallback to framework notifications

**Health:**
- Uses native health system
- Framework health tracking integrated

**Events:**
- Server: `lxr-core:server:<feature>:<action>`
- Client: `lxr-core:client:<feature>:<action>`
- Callback: `lxr-core:callback:<feature>:<action>`

---

### RSG-Core

**Initialization:**
```lua
Framework.Object = exports['rsg-core']:GetCoreObject()
```

**Notifications:**
- Uses `ox_lib` by default
- Supports RSG notifications

**Health:**
- Uses native health system
- RSG health wrapper integrated

**Events:**
- Server: `RSGCore:Server:<Feature>`
- Client: `RSGCore:Client:<Feature>`
- Callback: `RSGCore:Callback:<Feature>`

---

### VORP Core

**Initialization:**
```lua
Framework.Object = exports.vorp_core:GetCore()
```

**Notifications:**
- Uses VORP native notification system
- `vorp:NotifyLeft` events

**Health:**
- Uses native health system
- VORP health tracking compatible

**Events:**
- Server: `vorp:server:<feature>`
- Client: `vorp:client:<feature>`

---

### RedEM:RP

**Initialization:**
```lua
TriggerEvent('redemrp:getSharedObject', function(obj) 
    Framework.Object = obj 
end)
```

**Notifications:**
- Uses RedEM native notifications
- `redem_roleplay:NotifyLeft` events

**Health:**
- Uses native health system
- RedEM health tracking compatible

**Events:**
- Server: `redem:<feature>:server`
- Client: `redem:<feature>:client`

---

### QBR-Core / QR-Core

**Initialization:**
```lua
Framework.Object = exports['qbr-core']:GetCoreObject()
-- or
Framework.Object = exports['qr-core']:GetCoreObject()
```

**Notifications:**
- Uses `ox_lib` by default
- Supports QB notifications

**Health:**
- Uses native health system
- QB health wrapper integrated

**Events:**
- Server: `QBR:Server:<Feature>` or `QR:Server:<Feature>`
- Client: `QBR:Client:<Feature>` or `QR:Client:<Feature>`

---

### Standalone

**No Initialization Required**

**Notifications:**
- Uses `print()` to console
- Optional chat messages

**Health:**
- Direct native health manipulation
- No framework wrapper needed

**Events:**
- Standard RedM events only

---

## Adding a New Framework

To add support for a new framework:

### 1. Add to Config

Edit `config.lua`:

```lua
Config.FrameworkSettings['my-framework'] = {
    resource = 'my-framework',
    notifications = 'native',
    health = 'native',
    events = {
        server = 'myfw:server:%s',
        client = 'myfw:client:%s'
    }
}
```

### 2. Add to Detection

Edit `shared/framework.lua`:

```lua
local detectionOrder = {
    -- ... existing frameworks ...
    {name = 'my-framework', resource = 'my-framework'}
}
```

### 3. Add Initialization

Edit `shared/framework.lua`:

```lua
elseif Framework.Name == 'my-framework' then
    while Framework.Object == nil do
        Framework.Object = exports['my-framework']:GetCore()
        Wait(100)
    end
```

### 4. Add Notification Handler

Edit `shared/framework.lua`:

```lua
if settings.notifications == 'myfw' then
    TriggerClientEvent('myfw:notify', source, message, type)
```

### 5. Test

```lua
Config.Framework = 'my-framework'  -- Force your framework
Config.Debug = true  -- Enable debug logging
```

---

## Framework Compatibility Matrix

| Feature | LXR | RSG | VORP | RedEM | QBR | QR | Standalone |
|---------|-----|-----|------|-------|-----|----|-----------| 
| **Auto-Detect** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Notifications** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| **Health System** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Damage Apply** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Player Validation** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Cooldown Tracking** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Event System** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

Legend:
- ✅ Full support
- ⚠️ Basic/console only
- ❌ Not supported

---

## Troubleshooting Framework Issues

### Framework Not Detected

**Check:**
1. Framework resource is started before lxr-lowblow
2. Framework resource name matches expected name
3. Framework is actually loaded (check with `/status`)

**Solution:**
```lua
Config.Framework = 'your-framework'  -- Force manual selection
```

### Notifications Not Working

**Check:**
1. Notification system is installed (e.g., ox_lib)
2. Framework notification events are correct
3. Player is actually receiving events

**Solution:**
```lua
Config.Debug = true  -- See notification attempts
```

### Health Not Updating

**Check:**
1. Server-side health system is working
2. Framework health wrapper is functional
3. No conflicts with other health resources

**Solution:**
```lua
Config.Debug = true
Config.DebugOptions.printDamage = true  -- See damage calculations
```

---

## Best Practices

### For Server Owners

1. **Use auto-detect** unless you have issues
2. **Verify detection** in server console on startup
3. **Test all features** after installation
4. **Enable debug** if troubleshooting

### For Developers

1. **Use unified API** - don't call framework directly
2. **Test standalone mode** - ensure no hard dependencies
3. **Handle nil objects** - frameworks may not initialize
4. **Follow event patterns** - use framework conventions

### For Framework Developers

1. **Document your core object** - how to get it
2. **Use consistent naming** - follow community standards
3. **Provide notification exports** - standardize UI
4. **Test with adapters** - ensure compatibility

---

## Framework Load Order

Ensure proper load order in `server.cfg`:

```cfg
# Framework (first)
ensure lxr-core
# or
ensure rsg-core
# or
ensure vorp_core

# Dependencies (if any)
ensure ox_lib

# LXR LowBlow (after framework)
ensure lxr-lowblow
```

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**
