BANNION COMPANY - MODULAR TACTICAL SUITE (v1.36.00)
Unified Warrior Engine & Satellite Support - 2026

TECHNICAL MANIFESTO | BANNION COMPANY

Version: v1.36.00-ULTIMATE
Target: Turtle WoW (Client 1.12.1)
Architecture: Modular Core + Satellite Addons

BannionCompany is not merely a collection of macros; it is a Decision Support
System (DSS). It operates in the abstraction layer between player intent and
server execution. The v1.36 iteration introduces a Modular Architecture,
decoupling utility functions from the combat core to maximize processing
speed and stability.

=========================================================================

1. THE INVISIBLE CORE (BANNION_CORE)
The Core is the engine's heartbeat. It processes Action Economy on every
click.
Auto-Attack
Condition: If attacking=false
Objective: Iron-Toggle (Prevents white hit loss via accidental double-clicks).
Bloodrage
Condition: UnitAffectingCombat
Objective: Stealth Safety (Only triggers if already in combat).
Debuff Scan
Condition: GetPlayerBuffTexture
Objective: Texture Recognition (Identifies specific debuffs like Rend
or Hamstring via icon texture string matching).
Racials
Condition: Dynamic
Objective: Auto-trigger for Blood Fury, Berserking, or Perception.
2. FURY MODULE (/BFury) - AGGRESSIVE DUMP
Optimized for massive Attack Power (AP) scaling and Zero-Waste Rage
Management.
Priority Matrix:
1. Execute Phase: If TargetHP <= 20%. Interrupts all flows. Forces
Berserker Stance.
2. Stance Enforcement: Ensures Berserker Stance is active.
3. Cooldowns: Casts Death Wish if HP > 50%.
4. Primary Rotation: Bloodthirst > Whirlwind.
5. Rage Dump: If Rage > 35, queues Heroic Strike.


3. ARMS MODULE (/BArms) - TACTICAL BURST
Focused on weapon damage maximization and debuff management.
Priority Matrix:
1. Execute Phase: If TargetHP <= 20%. Uses Execute.
2. Mortal Strike: Primary damage dealer.
3. Overpower: "Fire & Forget" logic. If available, it fires instantly.
4. Rend Logic: Scans target for Ability_Gouge texture. If missing &
HP > 20%, applies Rend.
5. Filler: Heroic Strike if Rend is active.


4. TANK & SURVIVOR PROTOCOLS
4A. TANK MODULE (/BTank) - THE AGGRO MACHINE
* Auto-Taunt: Scans targettarget. If the mob is NOT looking at you,
it fires Taunt.
* Shield Slam: Primary threat generator.
* Revenge Priority: Uses Shield Block to force procs, then prioritizes
Revenge.
* Sunder Spam: Fills empty GCDs.


4B. SURVIVOR MODULE (/BSurv) - PANIC PROTOCOL
* Primary: Last Stand + Shield Wall (75% Mitigation).
* Secondary: Shield Block (Crush immunity).
* Control: Disarm (Weapon removal) + Thunder Clap (Slow) + Demo Shout.


5. OPPORTUNIST ENGINE (/BOpty) - STANCE DANCER
A context-aware gap closer and combo executor. This is the most complex
module.
1. Entry Logic:
* Range > 10y + Out of Combat -> Charge.
* Range > 10y + In Combat -> Intercept.


2. Stance Reset:
If inside melee range and in Berserker Stance, forces return to
Battle Stance.
3. Overpower:
Priority #1 once in Battle Stance.
4. Tactical Combo:
* Check Rend? No -> Cast Rend.
* Check Hamstring? No -> Cast Hamstring.
* Have Both? -> Cast Slam.


6. SATELLITE MODULES (STANDALONE ADDONS)
Utility functions have been moved to dedicated addons to reduce Core
entropy.
[B]annion Nurse (/BNurse)
* Combat State: If in combat, attempts Healing Potion.
* Idle State: Scans bags for the highest tier Bandage available and
applies it to self.


[B]annion Focus (/BFocus)
* Virtual Memory: Simulates a "Focus" frame (absent in 1.12.1).
* Mouseover: Captures unit name via tooltip hook.
* Assist (/BAssist): Targets the Focus's target.


[B]annion Vision (/BVis)
* CVar Injection: Safely injects cameraDistanceMax (50y) and
nameplateDistance (41y).
* Safety: Uses pcall to prevent Lua errors on clients that lack
specific CVars.


[B]annion Mounts (/BMount)
* Smart Dismount: Detects buff textures to cancel mounts instantly.
* Selector: ALT (Snowball) | SHIFT (Horse) | NONE (Turtle).

7. SLASH COMMANDS REGISTRY
Command   Module   Function
/BFury    Core     DPS PvE Rotation
/BArms    Core     DPS PvP / Leveling
/BTank    Core     Aggro & Mitigation
/BSurv    Core     Panic Mitigation
/BOpty    Core     Charge/Intercept/Slam Combo
/BNurse   Nurse    Smart Potion/Bandage
/BFocus   Focus    Set Virtual Focus
/BAssist  Focus    Assist Virtual Focus
/BVis     Vision   Fix Camera & Nameplates
/BMount   Mounts   Mount/Dismount Logic

8. STABILITY NOTES
* Silent Engine: A sophisticated chat filter intercepts server error
messages ("Ability is not ready", "Must be in...", etc.) allowing the
"Fire & Forget" architecture to function without UI spam.
* Anti-Recursion: The system uses isProcessingLog locks to prevent Stack
Overflows during chat filtering.
* Modular Isolation: A crash in the Mounts module will not affect the
Combat Core.



=========================================================================

INSTRUCOES EM PORTUGUES (PT-BR)


BANNION COMPANY - SUITE TATICA MODULAR (v1.36.00)
Motor Unificado de Warrior & Suporte Satelite - 2026

MANIFESTO TECNICO | BANNION COMPANY

Versao: v1.36.00-ULTIMATE
Alvo: Turtle WoW (Cliente 1.12.1)
Arquitetura: Core Modular + Addons Satelites

O BannionCompany nao e apenas uma colecao de macros; e um Sistema de Suporte
a Decisao (DSS). Ele opera na camada de abstracao entre a intencao do
jogador e a execucao do servidor. A iteracao v1.36 introduz uma Arquitetura
Modular, desacoplando funcoes utilitarias do nucleo de combate para
maximizar a velocidade de processamento e a estabilidade.

=========================================================================

1. O NUCLEO INVISIVEL (BANNION_CORE)
O Core e o coracao do motor. Ele processa a Economia de Acao em cada
clique.
Auto-Attack
Condicao: Se attacking=false
Objetivo: Iron-Toggle (Evita a perda de "white hits" por cliques
duplos acidentais).
Bloodrage
Condicao: UnitAffectingCombat
Objetivo: Seguranca de Stealth (So dispara se ja estiver em combate).
Debuff Scan
Condicao: GetPlayerBuffTexture
Objetivo: Reconhecimento de Textura (Identifica debuffs especificos
como Rend ou Hamstring atraves da leitura da string da textura do
icone).
Racials
Condicao: Dinamico
Objetivo: Auto-disparo para Blood Fury, Berserking ou Perception.
2. MODULO FURY (/BFury) - DESCARGA AGRESSIVA
Otimizado para escala massiva de Attack Power (AP) e Gestao de Rage
"Zero-Desperdicio".
Matriz de Prioridade:
1. Fase Execute: Se HP do Alvo <= 20%. Interrompe todos os fluxos.
Forca Berserker Stance.
2. Reforco de Postura: Garante que Berserker Stance esta ativa.
3. Cooldowns: Usa Death Wish se HP > 50%.
4. Rotacao Primaria: Bloodthirst > Whirlwind.
5. Rage Dump: Se Rage > 35, enfileira Heroic Strike.


3. MODULO ARMS (/BArms) - BURST TATICO
Focado na maximizacao de dano da arma e gestao de debuffs.
Matriz de Prioridade:
1. Fase Execute: Se HP do Alvo <= 20%. Usa Execute.
2. Mortal Strike: Principal causador de dano.
3. Overpower: Logica "Fire & Forget". Se disponivel, dispara
instantaneamente.
4. Logica Rend: Escaneia o alvo pela textura Ability_Gouge. Se ausente &
HP > 20%, aplica Rend.
5. Filler: Heroic Strike se Rend estiver ativo.


4. PROTOCOLOS TANK & SURVIVOR
4A. MODULO TANK (/BTank) - A MAQUINA DE AGGRO
* Auto-Taunt: Escaneia targettarget. Se o mob NAO estiver a olhar para
ti, dispara Taunt.
* Shield Slam: Gerador primario de ameaca.
* Prioridade Revenge: Usa Shield Block para forcar procs, depois
prioriza Revenge.
* Sunder Spam: Preenche GCDs vazios.


4B. MODULO SURVIVOR (/BSurv) - PROTOCOLO DE PANICO
* Primario: Last Stand + Shield Wall (75% Mitigacao).
* Secundario: Shield Block (Imunidade a Crushing Blows).
* Controle: Disarm (Remover arma) + Thunder Clap (Slow) + Demo Shout.


5. MOTOR OPORTUNISTA (/BOpty) - DANCA DE POSTURAS
Um executor de combos e encurtador de distancia consciente do contexto.
Este e o modulo mais complexo.
1. Logica de Entrada:
* Alcance > 10y + Fora de Combate -> Charge.
* Alcance > 10y + Em Combate -> Intercept.


2. Reset de Postura:
Se dentro do alcance melee e em Berserker Stance, forca o retorno para
Battle Stance.
3. Overpower:
Prioridade #1 assim que estiver em Battle Stance.
4. Combo Tatico:
* Checar Rend? Nao -> Cast Rend.
* Checar Hamstring? Nao -> Cast Hamstring.
* Tem Ambos? -> Cast Slam.




6. MODULOS SATELITES (ADDONS INDEPENDENTES)
Funcoes utilitarias foram movidas para addons dedicados para reduzir a
entropia do Core.
[B]annion Nurse (/BNurse)
* Estado de Combate: Se em combate, tenta Healing Potion.
* Estado Ocioso: Escaneia bolsas pela ligadura de maior tier disponivel
e aplica em si mesmo.


[B]annion Focus (/BFocus)
* Memoria Virtual: Simula um frame de "Focus" (ausente no 1.12.1).
* Mouseover: Captura o nome da unidade via hook no tooltip.
* Assist (/BAssist): Seleciona o alvo do Focus.


[B]annion Vision (/BVis)
* Injecao de CVar: Injeta com seguranca cameraDistanceMax (50y) e
nameplateDistance (41y).
* Seguranca: Usa pcall para prevenir erros de Lua em clientes que nao
suportam CVars especificas.


[B]annion Mounts (/BMount)
* Desmontar Inteligente: Detecta texturas de buffs para cancelar
montarias instantaneamente.
* Seletor: ALT (Snowball) | SHIFT (Cavalo) | NENHUM (Tartaruga).


7. REGISTRO DE COMANDOS SLASH
Comando   Modulo   Funcao
/BFury    Core     Rotacao DPS PvE
/BArms    Core     DPS PvP / Upar
/BTank    Core     Aggro & Mitigacao
/BSurv    Core     Mitigacao de Panico
/BOpty    Core     Combo Charge/Intercept/Slam
/BNurse   Nurse    Potion/Ligadura Inteligente
/BFocus   Focus    Definir Focus Virtual
/BAssist  Focus    Assistir Focus Virtual
/BVis     Vision   Corrigir Camera & Nameplates
/BMount   Mounts   Logica de Montar/Desmontar
8. NOTAS DE ESTABILIDADE
* Motor Silencioso: Um filtro de chat sofisticado intercepta mensagens de
erro do servidor ("Ability is not ready", "Must be in...", etc.)
permitindo que a arquitetura "Fire & Forget" funcione sem spam na UI.
* Anti-Recursao: O sistema usa travas isProcessingLog para prevenir
Stack Overflows durante a filtragem de chat.
* Isolamento Modular: Um erro critico no modulo Mounts nao afetara o
Core de Combate.



=========================================================================
Bannion Company - Precision is not an option, it's a requirement.