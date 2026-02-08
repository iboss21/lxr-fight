# 📸 LXR LowBlow - Screenshots & Media

```
🐺 LXR LowBlow - Visual Documentation
The Land of Wolves | wolves.land
```

## Screenshot Requirements

This document outlines the required screenshots for complete documentation of the LXR LowBlow resource.

---

## Required Screenshots

### 1. Startup Console (`01_startup_console.png`)

**What to capture:**
- Server console showing the LXR LowBlow ASCII banner
- Framework detection message
- Configuration summary
- Version information
- Load success message

**Location:** `/docs/assets/screenshots/01_startup_console.png`

**How to capture:**
1. Start server with lxr-lowblow
2. Look for startup banner in console
3. Screenshot the complete banner
4. Include framework detection line

**Expected output:**
```
═══════════════════════════════════════════════════════════════
    ██╗     ██╗  ██╗██████╗       ██╗      ██████╗ ██╗    ██╗
    (ASCII banner)
═══════════════════════════════════════════════════════════════
🐺 CLOSE-RANGE MELEE SYSTEM - SUCCESSFULLY LOADED
═══════════════════════════════════════════════════════════════
Version:     1.0.0
Framework:   lxr-core (detected)
...
```

---

### 2. Config Sections (`02_config_sections.png`)

**What to capture:**
- Open config.lua in your IDE/editor
- Show the bannered sections with ASCII dividers
- Highlight the section structure and organization

**Location:** `/docs/assets/screenshots/02_config_sections.png`

**What to show:**
- `████` section banners
- `═══` dividers
- Organized configuration blocks
- Comments explaining settings

---

### 3. UI Interaction (`03_ui_interaction.png`)

**What to capture:**
- In-game screenshot of low blow interaction
- Two players face-to-face
- Optional: Notification showing on screen
- Optional: Mid-animation or ragdoll effect

**Location:** `/docs/assets/screenshots/03_ui_interaction.png`

**Best practices:**
- Clear visibility of both players
- Close enough to see detail
- Good lighting
- High graphics settings for best presentation

**Scenarios to capture:**
1. **Pre-action:** Two players facing each other
2. **Animation:** Kick animation in progress
3. **Impact:** Victim in ragdoll state
4. **Notification:** Success message displayed

---

### 4. Framework Detection (`04_framework_detection.png`)

**What to capture:**
- Console output showing framework auto-detection
- Framework initialization message
- Any relevant framework-specific logs

**Location:** `/docs/assets/screenshots/04_framework_detection.png`

**Example content:**
```
[LXR-LowBlow] Framework detected: lxr-core
[LXR-LowBlow] Framework initialized: lxr-core
[LXR-LowBlow] Notification system: ox_lib
```

---

### 5. Discord Logs (`05_discord_logs.png`)

**What to capture:**
- Discord webhook security alert
- Showing player info, reason, and data
- Professional webhook embed format

**Location:** `/docs/assets/screenshots/05_discord_logs.png`

**Example webhook:**
```
🔒 LowBlow Security Alert

Player: John_Doe
ID: 42
Reason: Distance validation failed
Data: Actual: 5.23, Reported: 2.0

Timestamp: 2026-02-08 02:36:59
```

**Setup:**
1. Enable webhook in config
2. Trigger a validation failure
3. Capture the Discord message

---

### 6. txAdmin Performance (`06_txadmin_performance.png`)

**What to capture:**
- txAdmin resource monitor showing lxr-lowblow
- CPU usage percentage
- Memory usage
- Thread time

**Location:** `/docs/assets/screenshots/06_txadmin_performance.png`

**How to capture:**
1. Open txAdmin web interface
2. Navigate to Server → Resources or Live Console
3. Find lxr-lowblow in resource list
4. Screenshot performance metrics

**Expected metrics:**
- CPU: < 0.1%
- Memory: < 1 MB
- Status: Started

---

## Additional Screenshots (Optional)

### 7. Debug Visualization (`07_debug_lines.png`)

If `Config.Debug` and `Config.DebugOptions.drawDebugLines` are enabled:

**What to capture:**
- In-game debug lines showing distance
- Target info displayed on screen
- Line color indicating valid/invalid range

---

### 8. Configuration Options (`08_config_details.png`)

**What to capture:**
- Specific configuration sections
- Show different settings for different server types
- Example configurations

---

### 9. Multiple Frameworks (`09_framework_comparison.png`)

**What to capture:**
- Side-by-side comparison of resource running on different frameworks
- Show auto-detection working for each

---

### 10. Action Sequence (`10_action_sequence.gif`)

**Animated GIF showing:**
1. Player approaching target
2. Pressing key
3. Animation playing
4. Victim ragdolling
5. Recovery

---

## Screenshot Guidelines

### Technical Requirements

- **Resolution:** Minimum 1920x1080 (1080p)
- **Format:** PNG for static images, GIF for animations
- **Compression:** Optimized but not overly compressed
- **File size:** < 2MB per screenshot

### Content Guidelines

- **Clarity:** Clear, readable text
- **Lighting:** Well-lit scenes (in-game)
- **Focus:** Main subject in focus
- **Context:** Include enough context to understand what's shown
- **Branding:** Show LXR branding where applicable

### Naming Convention

```
[number]_[description].png
```

Examples:
- `01_startup_console.png`
- `02_config_sections.png`
- `03_ui_interaction_01.png`
- `03_ui_interaction_02.png`

---

## Screenshot Checklist

Mark complete as screenshots are added:

- [ ] 01 - Startup console banner
- [ ] 02 - Config file sections
- [ ] 03 - UI interaction (in-game)
- [ ] 04 - Framework detection
- [ ] 05 - Discord webhook logs
- [ ] 06 - txAdmin performance metrics
- [ ] 07 - Debug visualization (optional)
- [ ] 08 - Config examples (optional)
- [ ] 09 - Multi-framework comparison (optional)
- [ ] 10 - Action sequence GIF (optional)

---

## Storage Location

All screenshots must be stored in:

```
/docs/assets/screenshots/
```

**Directory structure:**
```
lxr-lowblow/
├── docs/
│   ├── assets/
│   │   └── screenshots/
│   │       ├── 01_startup_console.png
│   │       ├── 02_config_sections.png
│   │       ├── 03_ui_interaction.png
│   │       ├── 04_framework_detection.png
│   │       ├── 05_discord_logs.png
│   │       ├── 06_txadmin_performance.png
│   │       └── (optional screenshots)
│   └── screenshots.md (this file)
```

---

## Using Screenshots in Documentation

### In README.md

```markdown
## Screenshots

![Startup Console](docs/assets/screenshots/01_startup_console.png)
*LXR LowBlow successfully loaded with framework detection*

![In-Game Action](docs/assets/screenshots/03_ui_interaction.png)
*Close-range low blow in action*
```

### In Documentation

Reference screenshots in relevant sections:

```markdown
See [Screenshots](screenshots.md) for visual examples.

![Framework Detection](assets/screenshots/04_framework_detection.png)
```

---

## Video Documentation (Future)

Consider creating video documentation:

### Tutorial Video
- Installing the resource
- Configuring settings
- Testing functionality
- Troubleshooting

### Showcase Video
- In-game action
- Various scenarios
- Different configurations
- Server integration

**Recommended platforms:**
- YouTube
- Vimeo
- Direct hosting

---

## Branding in Screenshots

When creating promotional screenshots, include:

- 🐺 Wolves.land branding
- LXR LowBlow name visible
- Professional presentation
- Clear demonstration of features

---

## Screenshot Creation Tools

### Recommended Tools

**For Console:**
- Terminal screenshots
- Windows Snipping Tool
- macOS Screenshot utility
- Linux: GNOME Screenshot, Flameshot

**For In-Game:**
- RedM built-in screenshot (F8 → `screenshot`)
- GeForce Experience / AMD ReLive
- OBS Studio (for gameplay capture)

**For Editing:**
- GIMP (free)
- Photoshop (paid)
- Paint.NET (free, Windows)
- Preview (macOS)

**For GIFs:**
- ScreenToGif (Windows)
- Gifox (macOS)
- Peek (Linux)

---

## Contributing Screenshots

If you have high-quality screenshots to contribute:

1. Ensure they meet technical requirements
2. Follow naming convention
3. Submit via pull request or Discord
4. Include description of what's shown

---

## Copyright & Attribution

All screenshots should:
- Be original content
- Not include copyrighted material (except game content)
- Follow server rules for media capture
- Credit The Land of Wolves / iBoss21 when shared

---

## Notes for Future Updates

As new features are added, update screenshot requirements:

- New UI elements
- New configuration options
- New framework integrations
- New effects or animations

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**

**Screenshot Status:** 📸 Awaiting creation  
**Last Updated:** 2026-02-08  
**Maintainer:** iBoss21  
