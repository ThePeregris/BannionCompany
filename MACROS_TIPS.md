# BANNION COMPANY - OPERATIONAL MANUAL & MACROS
**Complementary Systems for the Bannion Tactical Suite**

While the **Bannion Core** handles the millisecond-decision rotation (Action Economy), the **Player** must handle the situational crisis management. This document outlines the macros and addons required to pilot the system at maximum efficiency on Turtle WoW.

---

## 1. THE "SPECIAL FORCES" MACROS
These macros utilize `CastSpellByName` with Lua logic to enable **Mouseover** functionality in Client 1.12.1. Do not rely on standard `/cast [target=mouseover]` macros from modern WoW; they do not function here.

### A. "The Sniper" (Hybrid Concussion Blow)
**Purpose:** Use for high threat generation on Bosses OR to stun a loose add without deselecting your main target.
* **Normal Click:** Stuns your current target.
* **Mouseover:** Stuns the enemy under your mouse cursor.

```lua
/run local u=UnitExists("mouseover") and "mouseover" or "target"; CastSpellByName("Concussion Blow", u)
```

### B. "The Savior" (Precision Taunt)
**Purpose:** Snatch a loose mob running towards your healer without losing your threat build-up on the main Boss.
* **Usage:** Point your mouse at the fleeing mob and press the key. Do not click.

```lua
/run local u=UnitExists("mouseover") and "mouseover" or "target"; CastSpellByName("Taunt", u)
```

### C. "AoE Nuclear" (Retaliation Swap)
**Purpose:** Transition from Tanking to massive AoE damage when pulling 5+ melee mobs.
* **Requirement:** Must have **Tactical Mastery (5/5)** talent, otherwise you will lose all Rage upon switching stances.
* **Operation:** Press ONCE to activate Retaliation. Then press your standard `/BTank` key to return to Defensive Stance immediately.

```lua
/cast Battle Stance
/cast Retaliation
```

### D. "The Executor" (Safe Recklessness)
**Purpose:** For DPS (Arms/Fury). Prevents accidental usage in the wrong stance.
* **Warning:** Never use this while main tanking. You will take 20% extra damage.

```lua
/cast Berserker Stance
/cast Recklessness
/script UIErrorsFrame:Clear()
```

---

## 2. RECOMMENDED ADDONS (VISUAL INTELLIGENCE)
The Bannion script runs the logic, but you need data to make decisions.

| Addon | Purpose | Why it is essential |
| :--- | :--- | :--- |
| **OmniCC** | Cooldown Timers | Places large numbers on your action bar icons. Essential to know exactly when *Shield Wall* or *Concussion Blow* is ready. |
| **ClassicThreatMeter** | Threat Tracking | (Or KTM). The script generates threat, but you need to see the "gap". If a Mage is at 90% threat, use "The Sniper" macro. |
| **EnemyCastBar** | Interrupts | (Or Natur). Shows what the enemy is casting. Essential for timing your Shield Bash or Concussion Blow stuns manually. |

---

## 3. OPERATIONAL DOCTRINE (HOW TO PLAY)

### The Pilot & The Autopilot
* **Keys 1-5 (The Autopilot):** Bind the Bannion scripts (`/BTank`, `/BArms`). Mash these keys constantly. They handle the "grunt work" (Sunder Armor, Shield Block, Heroic Strike management).
* **Keys Q, E, R (The Pilot):** Bind the Manual Macros here. These are your decision keys.

### Scenario: The Dungeon Pull
1.  **Engage:** Player uses `Charge` or `Range Pull`.
2.  **Stabilize:** Player mashes `/BTank`.
    * *Engine:* Casts Thunder Clap (AoE), Shield Block, and Shield Slam.
3.  **Crisis:** A mob breaks loose and runs to the Priest.
    * *Player:* Points mouse at mob, presses "The Savior" (Taunt Macro).
    * *Engine:* Continues tanking the main pack.
4.  **Mitigation:** Healer is struggling.
    * *Player:* Presses `/BSurv`.
    * *Engine:* Instantly applies Disarm and Demo Shout to reduce incoming damage.
5.  **Victory:** Player returns to `/BTank` to finish the fight.

---
# MANUAL OPERACIONAL (PT-BR)
**Sistemas Complementares para a Suíte Bannion**

Enquanto o **Bannion Core** cuida da rotação de milissegundos, o **Jogador** deve cuidar da gestão de crise situacional. Este documento descreve as macros e addons necessários para pilotar o sistema com eficiência máxima no Turtle WoW.

---

## 1. MACROS "FORÇAS ESPECIAIS"
Estas macros utilizam lógica Lua para habilitar a funcionalidade **Mouseover** no Cliente 1.12.1.

### A. "O Sniper" (Concussion Blow Híbrido)
**Propósito:** Usar para gerar aggro no Boss OU para stunar um add solto sem desselecionar seu alvo principal.
* **Clique Normal:** Stuna seu alvo atual.
* **Mouseover:** Stuna o inimigo sob o cursor do mouse.

```lua
/run local u=UnitExists("mouseover") and "mouseover" or "target"; CastSpellByName("Concussion Blow", u)
```

### B. "O Salvador" (Taunt de Precisão)
**Propósito:** Pegar um mob solto correndo para o healer sem perder o aggro no Boss principal.
* **Uso:** Aponte o mouse para o mob fugitivo e aperte a tecla.

```lua
/run local u=UnitExists("mouseover") and "mouseover" or "target"; CastSpellByName("Taunt", u)
```

### C. "AoE Nuclear" (Retaliation)
**Propósito:** Transição de Tank para dano massivo em área ao puxar 5+ mobs físicos.
* **Requisito:** Deve ter o talento **Tactical Mastery (5/5)**, caso contrário perderá toda a raiva na troca.
* **Operação:** Aperte UMA VEZ para ativar. Depois aperte sua tecla padrão `/BTank` para voltar à Postura Defensiva imediatamente.

```lua
/cast Battle Stance
/cast Retaliation
```

### D. "O Executor" (Recklessness Seguro)
**Propósito:** Para DPS. Evita uso acidental na postura errada.
* **Aviso:** Nunca use isso enquanto estivar tankando. Você receberá 20% de dano extra.

```lua
/cast Berserker Stance
/cast Recklessness
/script UIErrorsFrame:Clear()
```

---

## 2. ADDONS RECOMENDADOS (INTELIGÊNCIA VISUAL)

| Addon | Propósito | Por que é essencial |
| :--- | :--- | :--- |
| **OmniCC** | Timer de Cooldown | Coloca números grandes nos ícones. Essencial para saber quando o *Shield Wall* está pronto. |
| **ClassicThreatMeter** | Medidor de Aggro | (Ou KTM). O script gera ameaça, mas você precisa ver a "margem". Se um Mago está com 90% de aggro, use a macro "O Sniper". |
| **EnemyCastBar** | Interrupções | (Ou Natur). Mostra o cast do inimigo. Vital para acertar o timing do Shield Bash ou Stun manualmente. |

---

## 3. DOUTRINA OPERACIONAL (COMO JOGAR)

### O Piloto & O Piloto Automático
* **Teclas 1-5 (Autopilot):** Use os scripts Bannion (`/BTank`, `/BArms`). Spamme essas teclas constantemente. Elas cuidam do trabalho braçal.
* **Teclas Q, E, R (O Piloto):** Coloque as Macros Manuais aqui. Estas são suas teclas de decisão.

### Cenário: O Pull da Masmorra
1.  **Engajamento:** Jogador usa `Charge` ou `Tiro`.
2.  **Estabilização:** Jogador spamma `/BTank`.
    * *Motor:* Usa Thunder Clap (AoE), Shield Block e Shield Slam.
3.  **Crise:** Um mob foge em direção ao Priest.
    * *Jogador:* Aponta o mouse, aperta "O Salvador" (Taunt Macro).
    * *Motor:* Continua tankando o grupo principal.
4.  **Mitigação:** Healer está sofrendo.
    * *Jogador:* Aperta `/BSurv`.
    * *Motor:* Aplica Disarm e Demo Shout instantaneamente.
5.  **Vitória:** Jogador retorna ao `/BTank` para finalizar.