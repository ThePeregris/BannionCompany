=============================================================================
BANNION COMPANY - MODULAR TACTICAL SUITE (v1.36.00)
Unified Warrior Engine & Satellite Support - 2026
=============================================================================

# TECHNICAL MANIFESTO | BANNION COMPANY

**Version:** v1.36.00-ULTIMATE
**Target:** Turtle WoW (Client 1.12.1)
**Architecture:** Modular Core + Satellite Addons

**BannionCompany** is not merely a collection of macros; it is a **Decision Support System (DSS)**. It operates in the abstraction layer between player intent and server execution. The v1.36 iteration introduces a **Modular Architecture**, decoupling utility functions from the combat core to maximize processing speed and stability.

---

## 1. THE INVISIBLE CORE (BANNION_CORE)

The Core is the engine's heartbeat. It processes Action Economy on every click.

| Skill            | Mechanical Condition         | Tactical Objective |
| :---             | :---                         | :--- |
| **Auto-Attack** | If `attacking=false`         | **Iron-Toggle:** Prevents white hit loss via accidental double-clicks. |
| **Bloodrage** | `UnitAffectingCombat`        | **Stealth Safety:** Only triggers if already in combat to prevent accidental aggro/breaking stealth logic. |
| **Debuff Scan** | `GetPlayerBuffTexture`       | **Texture Recognition:** Identifies specific debuffs (Rend, Hamstring) via icon texture string matching (1.12.1 workaround). |
| **Racials** | Dynamic                      | Auto-trigger for Blood Fury, Berserking, or Perception. |

---

## 2. FURY MODULE (/BFury) - AGGRESSIVE DUMP
Optimized for massive Attack Power (AP) scaling and **Zero-Waste Rage Management**.

**PRIORITY MATRIX ($P_{fury}$):**
1.  **Execute Phase:** If TargetHP <= 20%. Interrupts all flows. Forces Berserker Stance.
2.  **Stance Enforcement:** Ensures Berserker Stance is active.
3.  **Cooldowns:** Casts *Death Wish* if HP > 50%.
4.  **Primary Rotation:** *Bloodthirst* > *Whirlwind*.
5.  **Rage Dump:** If Rage > 35, queues *Heroic Strike*.

---

## 3. ARMS MODULE (/BArms) - TACTICAL BURST
Focused on weapon damage maximization and debuff management.

**PRIORITY MATRIX ($P_{arms}$):**
1.  **Execute Phase:** If TargetHP <= 20%. Uses *Execute*.
2.  **Mortal Strike:** Primary damage dealer.
3.  **Overpower:** "Fire & Forget" logic. If available, it fires instantly.
4.  **Rend Logic:** Scans target for `Ability_Gouge` texture. If missing & HP > 20%, applies Rend.
5.  **Filler:** *Heroic Strike* if Rend is active.

---

## 4. TANK & SURVIVOR PROTOCOLS

### 4A. TANK MODULE (/BTank) - THE AGGRO MACHINE
* **Auto-Taunt:** Scans `targettarget`. If the mob is NOT looking at you, it fires *Taunt*.
* **Shield Slam:** Primary threat generator (checks for talent/availability implicitly).
* **Revenge Priority:** Uses *Shield Block* to force procs, then prioritizes *Revenge*.
* **Sunder Spam:** Fills empty GCDs.

### 4B. SURVIVOR MODULE (/BSurv) - PANIC PROTOCOL
* **Primary:** *Last Stand* + *Shield Wall* (75% Mitigation).
* **Secondary:** *Shield Block* (Crush immunity).
* **Control:** *Disarm* (Weapon removal) + *Thunder Clap* (Slow) + *Demo Shout*.

---

## 5. OPPORTUNIST ENGINE (/BOpty) - STANCE DANCER
A context-aware gap closer and combo executor. This is the most complex module.

1.  **Entry Logic:**
    * Range > 10y + Out of Combat -> **Charge**.
    * Range > 10y + In Combat -> **Intercept**.
2.  **Stance Reset:** If inside melee range and in Berserker Stance, forces return to **Battle Stance**.
3.  **Overpower:** Priority #1 once in Battle Stance.
4.  **Tactical Combo:**
    * Check **Rend**? No -> Cast *Rend*.
    * Check **Hamstring**? No -> Cast *Hamstring*.
    * Have Both? -> Cast **Slam**.

---

## 6. SATELLITE MODULES (STANDALONE ADDONS)
Utility functions have been moved to dedicated addons to reduce Core entropy.

### [B]annion Nurse (`/BNurse`)
* **Combat State:** If in combat, attempts *Healing Potion*.
* **Idle State:** Scans bags for the highest tier Bandage available and applies it to self.

### [B]annion Focus (`/BFocus`)
* **Virtual Memory:** Simulates a "Focus" frame (absent in 1.12.1).
* **Mouseover:** Captures unit name via tooltip hook.
* **Assist (`/BAssist`):** Targets the Focus's target.

### [B]annion Vision (`/BVis`)
* **CVar Injection:** Safely injects `cameraDistanceMax` (50y) and `nameplateDistance` (41y).
* **Safety:** Uses `pcall` to prevent Lua errors on clients that lack specific CVars.

### [B]annion Mounts (`/BMount`)
* **Smart Dismount:** Detects buff textures to cancel mounts instantly.
* **Selector:** ALT (Snowball) | SHIFT (Horse) | NONE (Turtle).

---

## 7. SLASH COMMANDS REGISTRY

| Command | Module | Function |
| :--- | :--- | :--- |
| `/BFury` | **Core** | DPS PvE Rotation |
| `/BArms` | **Core** | DPS PvP / Leveling |
| `/BTank` | **Core** | Aggro & Mitigation |
| `/BSurv` | **Core** | Panic Mitigation |
| `/BOpty` | **Core** | Charge/Intercept/Slam Combo |
| `/BNurse`| **Nurse** | Smart Potion/Bandage |
| `/BFocus`| **Focus** | Set Virtual Focus |
| `/BAssist`| **Focus** | Assist Virtual Focus |
| `/BVis` | **Vision** | Fix Camera & Nameplates |
| `/BMount`| **Mounts** | Mount/Dismount Logic |

---

## 8. STABILITY NOTES

* **Silent Engine:** A sophisticated chat filter intercepts server error messages ("Ability is not ready", "Must be in...", etc.) allowing the "Fire & Forget" architecture to function without UI spam.
* **Anti-Recursion:** The system uses `isProcessingLog` locks to prevent Stack Overflows during chat filtering.
* **Modular Isolation:** A crash in the *Mounts* module will not affect the *Combat Core*.

---
*Bannion Company - Precision is not an option, it's a requirement.*
