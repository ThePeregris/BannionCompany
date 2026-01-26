# BannionCompany

=============================================================================
BANNIONCOMPANY - TACTICAL CORE SYSTEM (v1.30.00)
Unified Warrior Engine - 2026
=============================================================================

# TECHNICAL MANIFESTO | BANNION COMPANY

**Version:** v1.30.00-GOLD
**Target:** Turtle WoW (Client 1.12.1)

**BannionCompany** is not merely a collection of macros; it is a **Decision Support System (DSS)**. It operates in the abstraction layer between player intent and server execution, ensuring that combat entropy (input delays, rage errors, or missed windows of opportunity) is reduced to zero.

---

## 1. THE INVISIBLE CORE (BANNION_CORE)

The Core is the engine's heartbeat. It processes Action Economy on every click, ensuring that buffs without GCD costs are applied the millisecond they become available.

| Skill 		| Mechanical Condition 		| Tactical Objective 
| --- 			| --- 				| --- 
| **Auto-Attack** 	| If `attacking=false` 		| **Iron-Toggle:** Prevents the loss of White Hits via accidental double-clicks. 
| **Native Stance** 	| `GetShapeshiftFormInfo` 	| **1.12.1 Compliance:** Replaces modern APIs with native texture scanning for 100% accuracy. 
| **Victory Rush** 	| On Kill (Proc) 		| **Turtle Exclusive:** Prioritized instant HP sustain and free damage. 
| **Racials** 		| Dynamic 			| Auto-trigger for Blood Fury (Orc), Berserking (Troll), or Perception (Human). 
| **Bloodrage** 	| On Cooldown 			| HP-to-Rage conversion for rotation stabilization. 

---

## 2. FURY MODULE (/BFury) - AGGRESSIVE DUMP

Optimized for massive Attack Power (AP) scaling and **Zero-Waste Rage Management**.

**PRIORITY MATRIX ():**

1. **Execute Phase:** If TargetHP  20%. Interrupts all flows. Forces Berserker Stance. **Absolute Priority.**
2. **Stance Enforcement:** Ensures Berserker Stance is active.
3. **Cooldowns:** Casts *Death Wish* if HP > 50%.
4. **Primary Rotation:** *Bloodthirst* > *Whirlwind*.
5. **Rage Dump (Aggressive):** If Rage > 35, queues *Heroic Strike*. No rage is left unspent.

---

## 3. ARMS MODULE (/BArms) - TACTICAL BURST

Focused on weapon damage maximization and reaction to enemy avoidance.

**PRIORITY MATRIX ():**

1. **Execute Phase:** If TargetHP  20%. Uses *Execute* (or *Battle Stance* check).
2. **Mortal Strike:** Healing debuff application and concentrated damage.
3. **Overpower (Fire & Forget):** The engine blindly attempts this every cycle. If the enemy Dodged, it connects. If not, the **Silent Engine** suppresses the error.
4. **Rend:** Bleed maintenance (Priority lowered if target < 40% HP).
5. **Filler:** *Heroic Strike* if Rage > 45.

---

## 4. TANK & SURVIVOR PROTOCOLS (SPLIT SYSTEM)

The defensive suite has been bifurcated into two distinct operational modes: **Aggression** and **Mitigation**.

### 4A. TANK MODULE (/BTank) - THE AGGRO MACHINE

Designed to hold threat against high-DPS outputs.

* **Auto-Taunt:** Scans `targettarget`. If the mob is NOT looking at you, it fires *Taunt*.
* **Revenge Priority:** Uses *Shield Block* to force procs, then prioritizes *Revenge* (High Threat / Low Cost).
* **Sunder Spam:** Fills empty GCDs with *Sunder Armor*.

### 4B. SURVIVOR MODULE (/BSurv) - PANIC PROTOCOL

Triggered when death is imminent. Threat generation is ignored in favor of pure survival.

* **Primary:** *Shield Wall* (75% Mitigation) + *Last Stand*.
* **Secondary:** *Shield Block* (Crush immunity).
* **Control:** *Disarm* (Weapon removal) + *Thunder Clap* (Slow) + *Demo Shout* (Weakness).

---

## 5. TACTICAL SUPPORT (COMMANDER & UTILITY)

### COMMANDER SYSTEM (FOCUS/ASSIST)

Bypasses the server's inconsistent `/focus` command by using internal LUA memory.

* **Set Focus (`/BFocus`):** Captures the unit under the mouse cursor (Mouseover). If no mouseover, captures current Target.
* **Assist Focus (`/BAssist`):** Instantly targets the unit your Focus is attacking.

### OPPORTUNIST ENGINE (`/BOpty`)

A context-aware gap closer and executioner.

1. **Out of Combat:** Auto-switch to Battle Stance  *Charge*.
2. **In Combat (Range > 10y):** Detects distance via `CheckInteractDistance`. Auto-switch to Berserker Stance  *Intercept*.
3. **In Combat (Melee):** *Execute* > *Overpower* > *Rotation*.

### MOUNT MANAGER v2

* **Logic:** Detects buffs to Dismount.
* **Modifiers:** **ALT** = Snowball (Item/Spell) | **SHIFT** = White Stallion | **NONE** = Riding Turtle.

---

## 6. SLASH COMMANDS REGISTRY

| Command 		| Technical Description 	| Implementation
| --- 			| --- 				| --- 
| `/BFury` 		| **DPS PvE**	 		| Execute > BT > WW > HS Dump 
| `/BArms` 		| **DPS PvP** 			| MS > Overpower > Rend 
| `/BTank` 		| **Aggro/Tank** 		| Revenge > Block > Sunder > Taunt 
| `/BSurv` 		| **Panic Mode** 		| Wall > Disarm > Mitigation Spam 
| `/BCrwd` 		| **AoE Mode** 			| Cleave > WW > Thunder Clap 
| `/BOpty` 		| **Reactive** 			| Charge / Intercept (Distance Check) 
| `/BFocus` 		| **Tactical** 			| Set Focus (Mouseover > Target) 
| `/BAssist` 		| **Tactical** 			| Assist Internal Focus Name 
| `/BHeal` 		| **Resource** 			| Smart Potion/Bandage Scan 
| `/BMount` 		| **Movement** 			| Modifier-based Mount Selector

---

## 7. STABILITY & SECURITY NOTES

* **Fire & Forget Architecture:** To bypass 1.12.1 API limitations (lack of `IsUsableSpell`), the engine attempts to cast priority spells blindly.
* **Silent Engine:** A sophisticated chat filter intercepts server error messages ("Ability is not ready", "Must be in...", etc.) preventing UI spam caused by the "Fire & Forget" architecture.
* **Anti-Recursion:** The system uses `isProcessingLog` locks to prevent the chat filter from processing its own output, preventing Stack Overflows.

---

## 8. USER GUIDE

1. **Installation:** Create `BannionCompany.lua` and `.toc`. Dependency on `UnitXP_SP3_Addon` is recommended for CD tracking but the script now functions in **Standalone Mode** via Fallback Logic.
2. **Combat:**
* **Boss:** Spam `/BTank` (if Main Tank) or `/BFury`.
* **Trash:** Spam `/BCrwd` or `/BOpty`.
* **Oh Sh*t:** Hit `/BSurv`.


3. **Diagnostics:** Type `/BLog` to verify system status and module loading.
