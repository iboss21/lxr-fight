# LXR LowBlow - Close-Range Melee Action for RedM

```
    ██╗     ██╗  ██╗██████╗       ██╗      ██████╗ ██╗    ██╗██████╗ ██╗      ██████╗ ██╗    ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██║     ██╔═══██╗██║    ██║██╔══██╗██║     ██╔═══██╗██║    ██║
    ██║      ╚███╔╝ ██████╔╝█████╗██║     ██║   ██║██║ █╗ ██║██████╔╝██║     ██║   ██║██║ █╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝██║     ██║   ██║██║███╗██║██╔══██╗██║     ██║   ██║██║███╗██║
    ███████╗██╔╝ ██╗██║  ██║      ███████╗╚██████╔╝╚███╔███╔╝██████╔╝███████╗╚██████╔╝╚███╔███╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝ ╚═════╝  ╚══╝╚══╝ 
```

**🐺 A production-grade close-range melee combat system for RedM servers**

---

## 🌟 Overview

**LXR LowBlow** adds a brutal, immersive close-range melee interaction to your RedM server. Players can execute devastating low blows when face-to-face with another player, triggering kick animations, damage, camera shake, and ragdoll reactions — all fully configurable.

Designed to be **lightweight**, **sync-safe**, and **easy to install**, this script fits perfectly into roleplay servers that want gritty, realistic player interactions without overcomplication.

---

## ✨ Features

- ✅ **Face-to-face validation** (distance + line of sight)
- ✅ **Configurable cooldown system** (per-player or global)
- ✅ **Configurable damage** (absolute HP or percentage-based)
- ✅ **Victim ragdoll** with adjustable duration
- ✅ **Camera shake effect** on impact
- ✅ **Clean kick animation** with optional forward lunge
- ✅ **Optional client-only notifications**
- ✅ **Server-side validation** and anti-abuse protection
- ✅ **Multi-framework support** (LXR-Core, RSG-Core, VORP, RedEM:RP, QBR, QR, Standalone)
- ✅ **Lightweight & optimized** for performance
- ✅ **Standalone** (no framework dependency required)

---

## ⚙️ Configuration Options

All settings are easily adjustable via `config.lua`:

| Setting | Description |
|---------|-------------|
| **Max Distance** | Maximum distance to execute low blow |
| **Cooldown Time** | Time between allowed actions |
| **Damage Type** | Absolute (fixed HP) or percentage-based |
| **Damage Amount** | Configurable damage value |
| **Ragdoll Duration** | How long victim stays in ragdoll |
| **Camera Shake** | Intensity and duration of screen shake |
| **Forward Lunge** | Optional attacker lunge during animation |
| **Notifications** | Toggle client notifications |
| **Security** | Anti-abuse and validation settings |

---

## 🧩 Requirements

- **RedM** server
- **No framework required** (Standalone compatible)
- Optional: LXR-Core, RSG-Core, VORP Core, RedEM:RP, QBR-Core, or QR-Core for enhanced integration

---

## 📦 Installation

1. **Download** or clone this repository
2. **Drag** the `lxr-lowblow` folder into your server's `resources` directory
3. **Add** to your `server.cfg`:
   ```cfg
   ensure lxr-lowblow
   ```
4. **(Optional)** Configure settings in `config.lua`
5. **Restart** your server

---

## 🎮 Usage

### For Players

1. **Face another player** at close range (default: 2.5m)
2. **Press G** (default key) to execute a low blow
3. Watch the **kick animation**, **camera shake**, and **ragdoll** reaction!

### For Server Owners

- Edit `config.lua` to customize all behavior
- Set damage, cooldowns, animations, and security options
- Configure framework auto-detection or manually select your framework
- Enable/disable features as needed for your roleplay server

---

## 📚 Documentation

Comprehensive documentation is available in the `/docs` folder:

- [📖 Overview](docs/overview.md) - Detailed feature overview
- [🔧 Installation](docs/installation.md) - Step-by-step installation guide
- [⚙️ Configuration](docs/configuration.md) - Complete configuration reference
- [🔄 Frameworks](docs/frameworks.md) - Multi-framework support details
- [📡 Events](docs/events.md) - Event reference and adapter functions
- [🔒 Security](docs/security.md) - Security features and anti-abuse
- [⚡ Performance](docs/performance.md) - Performance optimization guide
- [📸 Screenshots](docs/screenshots.md) - Screenshot requirements

---

## 🔧 Framework Support

LXR LowBlow supports **automatic framework detection** with the following frameworks:

| Framework | Status | Priority |
|-----------|--------|----------|
| **LXR-Core** | ✅ Primary | 1st |
| **RSG-Core** | ✅ Primary | 2nd |
| **VORP Core** | ✅ Supported | 3rd |
| **RedEM:RP** | ✅ Compatible | 4th |
| **QBR-Core** | ✅ Compatible | 5th |
| **QR-Core** | ✅ Compatible | 6th |
| **Standalone** | ✅ Fallback | 7th |

The script will automatically detect your framework and adapt accordingly. No configuration needed!

---

## 🔒 Security Features

- ✅ **Server-side validation** for all critical actions
- ✅ **Distance verification** to prevent exploits
- ✅ **Rate limiting** to prevent spam (max actions per minute)
- ✅ **Cooldown tracking** (per-player or global)
- ✅ **Player state validation** (alive, not in vehicle, etc.)
- ✅ **Optional Discord webhook** for security logging
- ✅ **Configurable kick/ban** on exploit detection

---

## ⚡ Performance

- **Optimized key checking** (configurable interval)
- **Efficient player proximity detection**
- **Minimal server overhead** with cleanup routines
- **Client-side animation handling** to reduce server load
- **Configurable update intervals** for fine-tuning

---

## 🐺 Server Information

**Server:** The Land of Wolves 🐺  
**Tagline:** Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!  
**Description:** ისტორია ცოცხლდება აქ! (History Lives Here!)  
**Type:** Serious Hardcore Roleplay  
**Access:** Discord & Whitelisted  

---

## 🔗 Links

- **Website:** [wolves.land](https://www.wolves.land)
- **Discord:** [Join our Discord](https://discord.gg/CrKcWdfd3A)
- **GitHub:** [iBoss21](https://github.com/iBoss21)
- **Store:** [The Lux Empire Store](https://theluxempire.tebex.io)
- **Server Listing:** [RedM Servers](https://servers.redm.net/servers/detail/8gj7eb)

---

## 👨‍💻 Credits

**Script Author:** iBoss21 / The Lux Empire  
**Developed for:** The Land of Wolves  
**Original Concept:** Close-range melee combat for immersive roleplay  
**Inspired by:** Realistic fight mechanics and player interaction systems  

---

## 📝 License

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

---

## 🆘 Support

For support, bug reports, or feature requests:

1. Join our [Discord server](https://discord.gg/CrKcWdfd3A)
2. Open an issue on [GitHub](https://github.com/iBoss21)
3. Visit [wolves.land](https://www.wolves.land)

---

## 🎯 Tags

`RedM` `Georgian` `SeriousRP` `Whitelist` `Melee` `Combat` `PVP` `Immersive` `Roleplay` `Standalone`

---

**Made with 🐺 by iBoss21 for The Land of Wolves**
