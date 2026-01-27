# BANNION COMPANY - MODULAR TACTICAL SUITE (v9.01)
Unified Warrior Engine & Satellite Support - 2026
<a href="https://www.paypal.com/donate/?hosted_button_id=VLAFP6ZT8ATGU">
  <img src="https://github.com/ThePeregris/MainAssets/blob/main/Donate_PayPal.png" alt="Tips Appreciated!" align="right" width="120" height="75">
</a>
## TECHNICAL MANIFESTO | BANNION COMPANY

Version: v9.01-ULTIMATE  
Target: Turtle WoW (Client 1.12.1 - Patch 1.17.2+)  
Architecture: Hybrid Standalone Engine + Dynamic Modules  

BannionCompany is a "Fire & Forget" Decision Support System (DSS). The v9.01 iteration achieves **True Independence**: it no longer requires external libraries to function but will utilize them (UnitXP, ItemRack) if detected for enhanced performance. It features a User-Toggleable Gear Manager to suit both casual play and tactical power-gaming.

=========================================================================

## 1. THE HYBRID CORE (BANNION_CORE)
The Core is the engine's heartbeat. It features a dual-layer processing system.

**Intelligent Spell Engine** * **Layer A (Native):** Automatically scans the player's spellbook to manage cooldowns without any addons.  
* **Layer B (UnitXP):** If `UnitXP_SP3` is detected, the core seamlessly switches to it for microsecond-precision tracking.  

**Chat Filter & Debuff Recognition** * **Silent Mode:** Intercepts system error messages ("Ability not ready", "Spell not learned") to allow clean Cross-Spec execution.  
* **Texture Recognition:** Identifies specific debuffs (Rend, Hamstring) via icon texture string matching.  

## 2. CONFIGURATION MODULE (/bannion)
The Gear Management system is now **OPTIONAL** and protected by a "Feature Flag".

* **Default State:** `ItemRack OFF`. The script will NOT attempt to swap weapons. Safe for all users.  
* **Power User State:** `ItemRack ON`. Enables tactical weapon swapping based on Stance.  
* **Commands:** * `/bannion itemrack on` - Enables the swapper (Requires sets: TH, DW, WS).  
    * `/bannion itemrack off` - Disables the swapper.  
    * `/bannion status` - Checks current configuration.  

## 3. FURY MODULE (/BFury) - CROSS-SPEC ADAPTIVE
Works for Deep Fury, Deep Arms, and Hybrids. Adapts to current stance and weapon.

**Priority Matrix:** 1.  **Execute Phase:** Interrupts all flows.  
2.  **Stance:** Enforces Berserker Stance.  
3.  **Adaptive Gear Logic:** * If Config ON: Swaps to Dual Wield (DW). Uses Hamstring to mask GCD.  
    * If Config OFF: Uses current weapon.  
4.  **Cross-Spec Nuke:** Checks `Bloodthirst`. If missing, falls back to `Mortal Strike`.  
5.  **Turtle Meta:** Uses `Victory Rush` and `Master Strike` (if talented).  
6.  **Smart Filler:** * If 2H Weapon: Uses `Slam` (Higher DPR).  
    * If Dual Wield: Uses `Heroic Strike` (Dump).  

## 4. ARMS MODULE (/BArms) - TURTLE META
Optimized for the specific mechanics of Turtle WoW (1.0s Slam, Master Strike).

**Priority Matrix:** 1.  **Execute Phase:** Enforces Battle Stance if equipped with Shield.  
2.  **Stance:** Enforces Battle Stance.  
3.  **Cross-Spec Nuke:** Checks `Mortal Strike`. If missing, falls back to `Bloodthirst`.  
4.  **Utility Ace:** Uses `Master Strike` (Instant Cast / CC) to fill gaps.  
5.  **Reactive:** `Overpower` is Priority #1 if available.  
6.  **Turtle Filler:** Uses `Slam` (1.0s cast) whenever Rage > 20. Superior to Heroic Strike.  

## 5. TANK & SURVIVOR PROTOCOLS

_5A. TANK MODULE (/BTank)_  
* **Smart Equip:** Equips Shield only if ItemRack Module is ON.  
* **Auto-Taunt:** Scans targettarget. If the mob is NOT looking at you, it fires Taunt.  
* **Threat:** Shield Slam > Revenge > Sunder Armor.  

_5B. SURVIVOR MODULE (/BSurv)_  
* **Mitigation:** Shield Block (Spam) + Disarm.  
* **Panic:** Last Stand + Shield Wall.  
* **Debuffs:** Thunder Clap + Demo Shout.  

## 6. OPPORTUNIST ENGINE (/BOpty)
Context-aware gap closer. Now features "Safe-Swap" logic.

1.  **Entry Logic:** * Combat + Range: Intercept (Berserker).  
    * No Combat + Range: Charge (Battle).  
2.  **Weapon Management:** * Only forces weapon swaps if `ItemRack Module` is ON.  
    * Otherwise, respects current equipment.  
3.  **Tactical Combo:** * Battle Stance: `Overpower` > `Rend` > `Slam`.  
    * Berserker Stance: `Whirlwind` > `Slam`.  

## 7. RECOMMENDED TALENTS (TURTLE WOW 1.17.2+)
Updates for Patch 1.17.2 have significantly changed the Protection tree.  
**Recommended Build:** 8/5/38 (Deep Mitigation)

* **Protection (38):**
    * **Shield Slam (Row 5):** Moved down, now accessible earlier. Mandatory.  
    * **Improved Shield Slam (Row 6):** NEW. Essential for Block chance.  
    * **Reprisal (Row 6):** NEW. Refunds Rage on Revenge. High Priority.  
    * *Removed:* "Improved Shield Block" and "Improved Sunder Armor" talents no longer exist or are baseline. Do not look for them.  
* **Arms (8):** Tactical Mastery (5/5) is now Tier 1.  
* **Fury (5):** Cruelty (5/5).  

## 8. SLASH COMMANDS REGISTRY

| Command   | Module   | Function
|--         | --       | --
| `/bannion`| Config   | **OPTIONS MENU (New)**
| `/BFury`  | Core     | Hybrid DPS Rotation
| `/BArms`  | Core     | Turtle Meta Rotation
| `/BTank`  | Core     | Aggro & Mitigation
| `/BSurv`  | Core     | Panic Mitigation
| `/BOpty`  | Core     | Gap Closer & Combo

=========================================================================
Bannion Company - Precision is not an option, it's a requirement.

---
# INSTRUÇÕES em PT-BR
---

# BANNION COMPANY - SUÍTE TÁTICA MODULAR (v9.01)
Motor Unificado de Guerreiro & Suporte Satélite - 2026

## MANIFESTO TÉCNICO | BANNION COMPANY

Versão: v9.01-ULTIMATE  
Alvo: Turtle WoW (Cliente 1.12.1 - Patch 1.17.2+)  
Arquitetura: Motor Híbrido Standalone + Módulos Dinâmicos  

O BannionCompany é um Sistema de Suporte à Decisão (DSS) do tipo "Dispare e Esqueça". A iteração v9.01 atinge a **Independência Real**: não requer mais bibliotecas externas para funcionar, mas as utilizará (UnitXP, ItemRack) se detectadas para performance aprimorada. Possui um Gerenciador de Equipamentos "User-Toggleable" para atender tanto o jogo casual quanto o "power-gaming" tático.

=========================================================================

## 1. O NÚCLEO HÍBRIDO (BANNION_CORE)
O Core é o coração do motor. Possui um sistema de processamento de camada dupla.

**Motor de Magia Inteligente** * **Camada A (Nativa):** Escaneia automaticamente o grimório do jogador para gerenciar cooldowns sem addons.  
* **Camada B (UnitXP):** Se `UnitXP_SP3` for detectado, o core muda para ele para rastreamento de precisão de microssegundos.  

**Filtro de Chat & Reconhecimento** * **Modo Silencioso:** Intercepta mensagens de erro do sistema ("Habilidade não pronta", "Magia não aprendida") para permitir execução Cross-Spec limpa.  
* **Reconhecimento de Textura:** Identifica debuffs específicos (Rend, Hamstring) via correspondência de string de textura do ícone.  

## 2. MÓDULO DE CONFIGURAÇÃO (/bannion)
O sistema de Gestão de Equipamentos agora é **OPCIONAL** e protegido por um "Interruptor".

* **Estado Padrão:** `ItemRack OFF`. O script NÃO tentará trocar armas. Seguro para todos os usuários.  
* **Estado Power User:** `ItemRack ON`. Habilita troca tática de armas baseada na Postura.  
* **Comandos:** * `/bannion itemrack on` - Ativa o trocador (Requer sets: TH, DW, WS).  
    * `/bannion itemrack off` - Desativa o trocador.  
    * `/bannion status` - Verifica a configuração atual.  

## 3. MÓDULO FURY (/BFury) - CROSS-SPEC ADAPTATIVO
Funciona para Deep Fury, Deep Arms e Híbridos. Adapta-se à postura e arma atual.

**Matriz de Prioridade:** 1.  **Fase Execute:** Interrompe todos os fluxos.  
2.  **Postura:** Força Postura Berserker.  
3.  **Lógica Adaptativa de Gear:** * Se Config ON: Troca para Dual Wield (DW). Usa Hamstring para mascarar o GCD.  
    * Se Config OFF: Usa a arma atual.  
4.  **Nuke Cross-Spec:** Checa `Bloodthirst`. Se ausente, recorre ao `Mortal Strike`.  
5.  **Turtle Meta:** Usa `Victory Rush` e `Master Strike` (se tiver talento).  
6.  **Filler Inteligente:** * Se Arma 2H: Usa `Slam` (Maior Dano por Raiva).  
    * Se Dual Wield: Usa `Heroic Strike` (Dump).  

## 4. MÓDULO ARMS (/BArms) - TURTLE META
Otimizado para as mecânicas específicas do Turtle WoW (Slam 1.0s, Master Strike).

**Matriz de Prioridade:** 1.  **Fase Execute:** Força Postura de Batalha se estiver de escudo.  
2.  **Postura:** Força Postura de Batalha.  
3.  **Nuke Cross-Spec:** Checa `Mortal Strike`. Se ausente, recorre ao `Bloodthirst`.  
4.  **Utility Ace:** Usa `Master Strike` (Instant Cast / CC) para preencher lacunas.  
5.  **Reativo:** `Overpower` é Prioridade #1 se disponível.  
6.  **Turtle Filler:** Usa `Slam` (cast de 1.0s) sempre que Raiva > 20. Superior ao Heroic Strike.  

## 5. PROTOCOLOS TANK & SURVIVOR

_5A. MÓDULO TANK (/BTank)_  
* **Smart Equip:** Equipa Escudo apenas se o Módulo ItemRack estiver ON.  
* **Auto-Taunt:** Escaneia targettarget. Se o mob NÃO estiver olhando para você, dispara Taunt.  
* **Ameaça:** Shield Slam > Revenge > Sunder Armor.  

_5B. MÓDULO SURVIVOR (/BSurv)_  
* **Mitigação:** Shield Block (Spam) + Disarm.  
* **Pânico:** Last Stand + Shield Wall.  
* **Debuffs:** Thunder Clap + Demo Shout.  

## 6. MOTOR OPORTUNISTA (/BOpty)
Encurtador de distância consciente do contexto. Agora com lógica "Safe-Swap".

1.  **Lógica de Entrada:** * Combate + Alcance: Intercept (Berserker).  
    * Sem Combate + Alcance: Charge (Batalha).  
2.  **Gestão de Armas:** * Só força troca de armas se `Módulo ItemRack` estiver ON.  
    * Caso contrário, respeita o equipamento atual.  
3.  **Combo Tático:** * Postura de Batalha: `Overpower` > `Rend` > `Slam`.  
    * Postura Berserker: `Whirlwind` > `Slam`.  

## 7. TALENTOS RECOMENDADOS (TURTLE WOW 1.17.2+)
O Patch 1.17.2 alterou significativamente a árvore de Protection.  
**Build Recomendada:** 8/5/38 (Mitigação Profunda)

* **Protection (38):**
    * **Shield Slam (Linha 5):** Movido para baixo, acessível mais cedo. Obrigatório.  
    * **Improved Shield Slam (Linha 6):** NOVO. Essencial para chance de Block.  
    * **Reprisal (Linha 6):** NOVO. Devolve Raiva no Revenge. Alta Prioridade.  
    * *Removidos:* Talentos "Improved Shield Block" e "Improved Sunder Armor" não existem mais ou são nativos. Não os procure.  
* **Arms (8):** Tactical Mastery (5/5) agora é Tier 1.  
* **Fury (5):** Cruelty (5/5).  

## 8. REGISTRO DE COMANDOS SLASH

| Comando   | Módulo   | Função
|--         | --       | --
| `/bannion`| Config   | **MENU DE OPÇÕES (Novo)**
| `/BFury`  | Core     | Rotação DPS Híbrida
| `/BArms`  | Core     | Rotação Turtle Meta
| `/BTank`  | Core     | Aggro & Mitigação
| `/BSurv`  | Core     | Mitigação de Pânico
| `/BOpty`  | Core     | Gap Closer & Combo

=========================================================================
Bannion Company - Precisão não é uma opção, é um requisito.
