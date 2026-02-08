# 📖 LXR LowBlow - Overview

```
🐺 LXR LowBlow - Detailed Feature Overview
The Land of Wolves | wolves.land
```

## Purpose

**LXR LowBlow** is a close-range melee combat system designed for serious roleplay servers. It adds realistic, immersive player-to-player combat interactions without requiring complex controls or breaking immersion.

---

## Core Mechanics

### 1. Face-to-Face Validation

The system requires both players to be:
- **Within range** (default 2.5 meters)
- **Facing each other** (configurable angle tolerance)
- **In line of sight** (no obstructions between players)

This ensures the action feels natural and prevents unrealistic "back attacks" that break immersion.

### 2. Kick Animation

When executed, the attacker plays a realistic **kick animation** from the game's native animation library:
- Animation: `kick_standing` from `melee@unarmed@streamed_core`
- Duration: 1.5 seconds (configurable)
- Optional forward lunge for added impact feel

### 3. Damage System

Two damage modes available:

**Absolute Damage:**
- Fixed HP damage amount (e.g., 20 HP)
- Predictable and consistent across all players

**Percentage Damage:**
- Percentage of victim's max health (e.g., 20%)
- Scales with player health values
- Fair across different character builds

Optional "can't kill" mode leaves victim at 1 HP minimum.

### 4. Ragdoll System

Victim enters ragdoll state:
- **Duration:** 3 seconds (configurable)
- **Type:** Normal or writhe ragdoll
- Creates realistic knockdown effect
- Player regains control after duration

### 5. Camera Shake

Immersive camera effects on impact:

**Victim:**
- Stronger shake (default intensity: 0.3)
- Longer duration (default: 1 second)
- Simulates disorientation from hit

**Attacker:**
- Optional lighter shake (default: 0.1)
- Shorter duration (default: 0.5 seconds)
- Provides action feedback

### 6. Cooldown System

Prevents spam and encourages tactical use:
- **Duration:** 10 seconds (configurable)
- **Per-victim or global** tracking options
- Client and server-side enforcement
- Optional cooldown notifications

---

## Technical Features

### Multi-Framework Architecture

- **Auto-detection** of installed frameworks
- **Unified adapter layer** for consistent API
- **No framework required** - standalone compatible
- Supports LXR-Core, RSG-Core, VORP, RedEM:RP, QBR, QR

### Server Authority

All critical logic runs server-side:
- **Distance validation** prevents teleport exploits
- **State validation** ensures valid player conditions
- **Damage application** can't be manipulated by clients
- **Cooldown tracking** enforced by server

### Anti-Abuse Protection

Multiple layers of security:
- **Rate limiting:** Max actions per minute
- **Distance checks:** Server-side verification
- **State validation:** Alive, not in vehicle, etc.
- **Suspicious activity logging** with optional Discord webhooks
- **Configurable kick/ban** on exploit attempts

### Performance Optimization

Designed for minimal impact:
- **Efficient key checking** with configurable intervals
- **Smart player proximity detection**
- **Automatic cleanup** of old cooldown data
- **Client-side animations** reduce server load
- **Configurable update rates** for fine-tuning

---

## Use Cases

### Roleplay Scenarios

1. **Bar Fights:** Escalation of verbal confrontations
2. **Gang Conflicts:** Street fights without weapons
3. **Training:** Combat training between characters
4. **Self-Defense:** Quick reaction to threats
5. **Immersive Combat:** Fistfights that feel impactful

### Server Types

- **Serious RP:** Adds realism to physical confrontations
- **Hardcore RP:** Consequences for aggressive actions
- **Gang RP:** Street-level combat mechanics
- **Western RP:** Saloon brawls and dustups
- **Any server:** Works standalone without dependencies

---

## Design Philosophy

### Simplicity First

- **One key press** - No complex combos
- **Clear feedback** - Animations, effects, notifications
- **Intuitive mechanics** - Face player, press key, done

### Realism & Immersion

- **Face-to-face requirement** - No unrealistic attacks
- **Natural animations** - Uses native game animations
- **Impact effects** - Camera shake, ragdoll reactions
- **Cooldowns** - Prevents spam, adds realism

### Performance & Security

- **Server authority** - All critical logic server-side
- **Validation** - Multiple layers of checks
- **Optimized** - Minimal overhead
- **Anti-abuse** - Rate limiting and logging

### Configurability

- **Every aspect configurable** - Distance, damage, cooldowns
- **Enable/disable features** - Cameras shake, notifications, etc.
- **Framework agnostic** - Works with or without frameworks
- **Server-specific tuning** - Adjust for your playstyle

---

## Integration

### With Frameworks

Seamlessly integrates with:
- **Damage systems** - Applies damage through framework health
- **Notification systems** - Uses framework notifications
- **Player data** - Leverages framework player objects
- **Event systems** - Follows framework event patterns

### Standalone

Works perfectly without frameworks:
- **Native health system** - Direct health manipulation
- **Print notifications** - Console/chat fallback
- **No dependencies** - Zero external requirements
- **Plug and play** - Install and go

---

## Future Expansion Possibilities

While this is a complete, production-ready system, it's designed to be extended:

- **Multiple attack types** (punch, headbutt, etc.)
- **Combo systems** (multi-hit sequences)
- **Skill progression** (damage increases with use)
- **Injury systems** (limping, bleeding effects)
- **Sound effects** (impact sounds, grunts)
- **Particle effects** (dust, sweat particles)
- **Block/dodge mechanics** (defensive counters)

The modular architecture makes additions straightforward without breaking existing functionality.

---

## Summary

**LXR LowBlow** is a carefully balanced, production-grade melee combat system that adds depth to player interactions without complexity. It's secure, performant, and configurable — ready for any serious roleplay server.

---

**© 2026 iBoss21 / The Lux Empire | wolves.land**
