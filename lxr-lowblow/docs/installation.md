# 🔧 LXR LowBlow - Installation Guide

```
🐺 LXR LowBlow - Step-by-Step Installation
The Land of Wolves | wolves.land
```

## Prerequisites

Before installing LXR LowBlow, ensure you have:

- ✅ **RedM server** (any version compatible with FiveM/RedM resources)
- ✅ **Server access** (FTP, file manager, or direct access)
- ✅ **Server.cfg editing** permissions
- ✅ **(Optional)** Compatible framework installed (LXR-Core, RSG-Core, VORP, etc.)

---

## Installation Methods

### Method 1: Standard Installation (Recommended)

#### Step 1: Download the Resource

1. **Download** the latest release from GitHub
2. **Extract** the ZIP file to a temporary location
3. **Verify** folder name is exactly `lxr-lowblow`

#### Step 2: Upload to Server

1. **Navigate** to your server's `resources` folder
2. **Upload** the `lxr-lowblow` folder
3. **Verify** the structure looks like this:
   ```
   resources/
   └── lxr-lowblow/
       ├── fxmanifest.lua
       ├── config.lua
       ├── client/
       │   └── main.lua
       ├── server/
       │   └── main.lua
       ├── shared/
       │   └── framework.lua
       ├── docs/
       └── README.md
   ```

#### Step 3: Add to server.cfg

1. **Open** your `server.cfg` file
2. **Add** the following line:
   ```cfg
   ensure lxr-lowblow
   ```
3. **Save** the file

#### Step 4: Restart Server

1. **Restart** your entire server (or use `refresh` + `ensure lxr-lowblow`)
2. **Check** the console for the startup banner
3. **Look for** the framework detection message

#### Step 5: Verify Installation

1. **Join** your server
2. **Find** another player
3. **Face** them at close range
4. **Press G** to test the low blow
5. **Check** for damage, animation, and ragdoll effects

---

### Method 2: Git Clone (For Developers)

If you're using Git for resource management:

```bash
cd resources/
git clone https://github.com/iBoss21/lxr-lowblow.git
```

Then follow steps 3-5 from Method 1.

---

## Framework-Specific Setup

### LXR-Core

1. **No additional setup required** - Auto-detected
2. Notifications will use `ox_lib` by default
3. Health system uses native framework health

### RSG-Core

1. **No additional setup required** - Auto-detected
2. Notifications will use `ox_lib` by default
3. Health system uses native framework health

### VORP Core

1. **No additional setup required** - Auto-detected
2. Notifications will use VORP's notification system
3. Health system uses native framework health

### RedEM:RP

1. **No additional setup required** - Auto-detected
2. Notifications will use RedEM's notification system
3. Health system uses native framework health

### QBR-Core / QR-Core

1. **No additional setup required** - Auto-detected
2. Notifications will use `ox_lib` by default
3. Health system uses native framework health

### Standalone (No Framework)

1. **Works out of the box**
2. Uses print-based notifications
3. Uses native health system directly

---

## Configuration

### Basic Configuration

Edit `config.lua` to customize basic settings:

```lua
-- Enable/disable the system
Config.General.enabled = true

-- Set max distance
Config.General.maxDistance = 2.5

-- Set damage
Config.Damage.type = 'absolute'  -- or 'percentage'
Config.Damage.amount = 20

-- Set cooldown
Config.Cooldowns.duration = 10000  -- milliseconds
```

### Advanced Configuration

See [Configuration Guide](configuration.md) for detailed settings.

---

## Verification Checklist

After installation, verify:

- [ ] ✅ Resource loads without errors in console
- [ ] ✅ Startup banner displays in console
- [ ] ✅ Framework is detected correctly (or standalone)
- [ ] ✅ Players can join without issues
- [ ] ✅ G key triggers low blow action
- [ ] ✅ Animations play correctly
- [ ] ✅ Damage is applied to victim
- [ ] ✅ Ragdoll effect works
- [ ] ✅ Camera shake occurs (if enabled)
- [ ] ✅ Cooldown prevents spam
- [ ] ✅ Notifications display (if enabled)

---

## Troubleshooting

### Resource Won't Start

**Problem:** Resource fails to start or shows errors

**Solutions:**
1. Check folder name is exactly `lxr-lowblow`
2. Verify all files are present (check structure above)
3. Check server console for specific error messages
4. Ensure `server.cfg` has `ensure lxr-lowblow`

### Framework Not Detected

**Problem:** Shows "standalone" but you have a framework

**Solutions:**
1. Ensure framework resource is started **before** lxr-lowblow
2. Check framework resource name matches expected name
3. Try manual framework selection in `config.lua`:
   ```lua
   Config.Framework = 'lxr-core'  -- or 'rsg-core', 'vorp_core', etc.
   ```

### Key Press Not Working

**Problem:** G key doesn't trigger low blow

**Solutions:**
1. Check if another resource is using the same key
2. Verify key binding in config.lua:
   ```lua
   Config.Keys.lowblow = 0x760A9C6F  -- G key
   ```
3. Try changing to a different key
4. Check if player is within range of target

### Animation Not Playing

**Problem:** No kick animation displays

**Solutions:**
1. Check server console for animation errors
2. Verify animation dictionary loads correctly
3. Try a different animation in config.lua
4. Ensure client script is loaded properly

### Damage Not Applied

**Problem:** Victim doesn't take damage

**Solutions:**
1. Check server console for error messages
2. Verify server-side validation passes
3. Enable debug mode to see damage calculations:
   ```lua
   Config.Debug = true
   Config.DebugOptions.printDamage = true
   ```
4. Check if victim is valid target (alive, not in vehicle)

### Cooldown Not Working

**Problem:** Can spam low blow without cooldown

**Solutions:**
1. Ensure cooldowns are enabled:
   ```lua
   Config.Cooldowns.enabled = true
   ```
2. Check cooldown duration is set correctly
3. Verify server-side cooldown tracking works
4. Enable debug to see cooldown messages:
   ```lua
   Config.Debug = true
   Config.DebugOptions.printCooldowns = true
   ```

---

## Performance Optimization

After installation, optimize for your server:

### For Large Servers (100+ players)

```lua
Config.Performance.keyCheckInterval = 200  -- Less frequent checks
Config.Performance.nearbyPlayerCheck = 1000  -- Slower proximity checks
Config.Performance.cleanupInterval = 600000  -- Cleanup every 10 minutes
```

### For Small Servers (< 50 players)

```lua
Config.Performance.keyCheckInterval = 50  -- More responsive
Config.Performance.nearbyPlayerCheck = 200  -- Faster proximity checks
Config.Performance.cleanupInterval = 300000  -- Cleanup every 5 minutes
```

---

## Updating

To update to a new version:

1. **Backup** your `config.lua` file
2. **Download** the new version
3. **Replace** all files except `config.lua`
4. **Compare** new config.lua with your backup
5. **Merge** any new settings into your config
6. **Restart** the resource

---

## Uninstallation

To remove LXR LowBlow:

1. **Stop** the resource: `stop lxr-lowblow`
2. **Remove** from `server.cfg`
3. **Delete** the `lxr-lowblow` folder from resources
4. **Restart** server

---

## Support

Need help with installation?

- **Discord:** [Join our Discord](https://discord.gg/CrKcWdfd3A)
- **Website:** [wolves.land](https://www.wolves.land)
- **GitHub:** [Report an issue](https://github.com/iBoss21)

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**
