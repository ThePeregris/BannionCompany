=============================================================================
BANNIONCOMPANY - TACTICAL CORE SYSTEM (v1.18.84)
Unified Warrior Engine - 2026
=============================================================================
TECHNICAL MANIFESTO

BannionCompany is not merely a collection of macros; it is a Decision Support System (DSS). It operates in the abstraction layer between player intent and server execution, ensuring that combat entropy (input delays, rage errors, or missed windows of opportunity) is reduced to zero.
1. THE INVISIBLE CORE (BANNION_CORE)

The Core is the engine's heartbeat. It processes Action Economy on every click, ensuring that buffs without GCD costs are applied the millisecond they become available.
Skill	Mechanical Condition	Tactical Objective
Auto-Attack	If attacking=false	Iron-Toggle: Prevents the loss of White Hits.
Perception	On Cooldown	Increased uptime and passive detection.
Victory Rush	On Cooldown (Proc)	Instant HP sustain via Turtle WoW baseline.
Bloodrage	On Cooldown	HP-to-Rage conversion for rotation stabilization.
UIErrorsFrame	Per Click	UI Sanitization: Removes red error text clutter.

    Engineering Note: The Core utilizes a hook on the CastSpellByName function to intercept the native command and prevent Toggle-Off. If you are already in combat, the attack command is silenced by the engine.

2. FURY MODULE (/BFury) - DUAL WIELD ELITE
Optimized for massive Attack Power (AP) scaling and Rage Per Second (RPS) generation.

PRIORITY MATRIX (Pfury​):

    Execute (Rank 5): If TargetHP≤20%. Interrupts all flows. Absolute Priority.

    Bloodthirst (Rank 4): If Ready. The primary damage anchor.

    Death Wish: If PlayerHP>60%. Damage multiplier with a biometric safety lock.

    Whirlwind: Primary filler if BT is on cooldown and Rage≥25.

    Berserker Rage: Rage generation via "Enrage" and CC protection.

    Battle Shout (Rank 7): Constant APbuff​ maintenance.

3. ARMS MODULE (/BArms) - 2-HANDED BURST
Focused on damage window management and maximizing damage per hit (DPH).

    Execute (Rank 5): Finisher trigger.

    Mortal Strike: Healing debuff application and concentrated damage.

    Rend (Rank 7): In Turtle WoW 1.18, bleed scales with AP:
    Dtick​=Base+(AP×0.05)

    Overpower (Rank 4): Instant reaction to dodges detected by UnitXP_SP3.

4. SURVIVOR PROTOCOL (/BSurv) - TOTAL MITIGATION

Triggered in situations where incoming damage exceeds healing capacity.

    Trigger 0: Forces a swap to Defensive Stance and activates the shield set.

    Priority 1 - Shield Block: Instant physical mitigation.
    Block%=Base+75%

    Priority 2 - Disarm: Disables the enemy's primary physical damage source (Humanoids).

    Priority 3 - Demoralizing Shout: Passive reduction of the opponent's Attack Power.

5. TACTICAL SUPPORT (HEALING & MOVEMENT)

SMART HEALING LOGIC (BHeal)
The engine evaluates the player's state (Sp​) before deciding on the resource:
Resources={Healing PotionBest Bandage​if Sp​=Combatif Sp​=Idle​

The O(n) linear scan traverses bags, prioritizing healing density (e.g., Heavy Runecloth > Runecloth).
MOUNT LOGIC (VANILLA DETECT)

Since the 1.12.1 engine is limited, we implemented a buff texture scan:

    Scans slots 0 to 15.

    Searches for patterns: Interface\\Icons\\Ability_Mount_...

    If positive → /dismount. If negative → Cast mount.

6. SLASH COMMANDS SUMMARY

Command	Technical Description	Implementation
/BFury	Elite Fury Rotation	BT > WW > DW
/BArms	Arms/2H Rotation	MS > Rend > Execute
/BSurv	Panic Protocol	Def Stance > Block > Disarm
/BHeal	Resource Manager	Smart Potion/Bandage Scan
/BMount	Movement	Buff-based Mount Detect
/BLog	Telemetry Console	Anti-spam log isolation
/BVis	FOV Adjustment	Camera Dist = 50m
/BOpty	Reactive Engine	Charge/Intercept + Overpower

7. STABILITY & SECURITY NOTES

    Anti-Recursion (Soverflow​): The system uses the isProcessingLog variable to prevent the chat filter from processing itself, which would cause a fatal UI crash.

    Iron-Toggle: We redefined the attack logic. In standard macros, pressing the button twice toggles the attack off. In Bannion, the first click toggles it on, and subsequent clicks are ignored if the state is attacking.

    Silent Engine: All "Out of Range" or "Not Enough Rage" failures are diverted to the silent log, allowing you to hear raid sound alerts without visual noise.

8. OPERATION INSTRUCTIONS (USER GUIDE)

    Installation: Ensure UnitXP_SP3_Addon is in your Addons folder.

    First Use: Type /BLog to create the side telemetry tab.

    Combat: Spam your main command (/BFury or /BArms). The engine will handle the Execute window and Bloodrage.

    Diagnostics: If you feel a performance drop, check /BLog. It will indicate if the issue is distance, GCD, or lack of resources.

=============================================================================
BANNIONCOMPANY - SISTEMA CENTRAL TÁTICO (v1.18.84)
Motor Unificado de Guerreiro - 2026
=============================================================================
MANIFESTO TÉCNICO

O BannionCompany não é meramente um conjunto de macros; é um Sistema de Suporte à Decisão (DSS). Ele atua na camada de abstração entre a intenção do jogador e a execução do servidor, garantindo que a entropia do combate (atrasos de input, erros de raiva ou janelas de oportunidade perdidas) seja reduzida a zero.

1. O NÚCLEO INVISÍVEL (BANNION_CORE)

O Core é o batimento cardíaco do motor. Ele processa a Economia de Ação em cada clique, garantindo que buffs sem custo de GCD sejam aplicados no milissegundo em que ficam disponíveis.
Habilidade	Condição Mecânica	Objetivo Tático
Auto-Attack	Se attacking=false	Iron-Toggle: Impede a perda de White Hits.
Perception	On Cooldown	Aumento de uptime e detecção passiva.
Victory Rush	On Cooldown (Proc)	Sustain de HP instantâneo via Turtle WoW baseline.
Bloodrage	On Cooldown	Conversão de HP em Raiva para estabilização de rotação.
UIErrorsFrame	Per Click	UI Sanitization: Remove a poluição visual de erros.

    Nota de Engenharia: O Core utiliza um hook na função CastSpellByName para interceptar o comando nativo e impedir o Toggle-Off. Se você já está em combate, o comando de ataque é silenciado pelo motor.

2. MÓDULO FURY (/BFury) - DUAL WIELD ELITE
Otimizado para o escalonamento massivo de Attack Power (AP) e geração de raiva por segundo (RPS).

MATRIZ DE PRIORIDADE (Pfury​):

    Execute (Rank 5): Se TargetHP≤20%. Interrompe todos os fluxos. Prioridade Absoluta.

    Bloodthirst (Rank 4): Se Ready. É a âncora de dano.

    Death Wish: Se PlayerHP>60%. Multiplicador de dano com trava de segurança biométrica.

    Whirlwind: Filler principal se BT estiver em cooldown e Rage≥25.

    Berserker Rage: Geração de raiva por "Enrage" e proteção contra CC.

    Battle Shout (Rank 7): Manutenção de APbuff​ constante.

3. MÓDULO ARMS (/BArms) - 2-HANDED BURST
Focado na gestão de janelas de dano e maximização do dano por acerto (DPH).

    Execute (Rank 5): Gatilho de finalização.

    Mortal Strike: Aplicação de debuff de cura e dano concentrado.

    Rend (Rank 7): No Turtle WoW 1.18, o sangramento escala com AP:
    Dtick​=Base+(AP×0.05)

    Overpower (Rank 4): Reação instantânea a esquivas (Dodge) detectadas pelo UnitXP_SP3.

4. PROTOCOLO SURVIVOR (/BSurv) - MITIGAÇÃO TOTAL
Acionado em situações onde o dano recebido excede a capacidade de cura.

    Gatilho 0: Força a troca para Defensive Stance e ativa o set de escudo.

    Prioridade 1 - Shield Block: Mitigação física instantânea.
    Block%=Base+75%

    Prioridade 2 - Disarm: Desativa a principal fonte de dano físico do inimigo (Humanoides).

    Prioridade 3 - Demoralizing Shout: Redução passiva do Attack Power do oponente.

5. SUPORTE TÁTICO (CURA E MOVIMENTAÇÃO)

LÓGICA DE CURA INTELIGENTE (BHeal)

O motor avalia o estado do jogador (Sp​) antes de decidir o recurso:
Resources={Healing PotionBest Bandage​if Sp​=Combatif Sp​=Idle​

O scan linear O(n) percorre as bolsas priorizando a densidade de cura (ex: Heavy Runecloth > Runecloth).
LÓGICA DE MONTARIA (DETECÇÃO VANILLA)

Como o motor 1.12.1 é limitado, implementamos um scan de texturas de buffs:

    Varre os slots de 0 a 15.

    Busca por padrões: Interface\\Icons\\Ability_Mount_...

    Se positivo → /dismount. Se negativo → Cast mount.

6. RESUMO DOS COMANDOS (SLASH COMMANDS)

Comando	Descrição Técnica		Implementação
/BFury	Rotação Fury Elite		BT > WW > DW
/BArms	Rotação Arms/2H			MS > Rend > Execute
/BSurv	Protocolo de Pânico		Def Stance > Block > Disarm
/BHeal	Gestor de Recursos		Scan Inteligente Pot/Bandagem
/BMount	Movimentação			Detecção de Montaria via Buff
/BLog	Console de Telemetria	Isolamento de log anti-spam
/BVis	Ajuste de FOV			Distância da Câmera = 50m
/BOpty	Motor Reativo			Charge/Intercept + Overpower

7. NOTAS DE ESTABILIDADE E SEGURANÇA

    Anti-Recursão (Soverflow​): O sistema utiliza a variável isProcessingLog para evitar que o filtro de chat tente processar a si mesmo, o que causaria um crash fatal na interface.

    Iron-Toggle: Redefinimos a lógica de ataque. Em macros comuns, apertar o botão duas vezes desliga o ataque. No Bannion, o primeiro clique liga, e os subsequentes são ignorados se o estado for attacking.

    Silent Engine: Todas as falhas de "Fora de Alcance" ou "Raiva Insuficiente" são desviadas para o log silencioso, permitindo que você ouça os avisos sonoros da raid sem ruído visual.


8. INSTRUÇÃO DE OPERAÇÃO (GUIA DO USUÁRIO)

    Instalação: Garanta o UnitXP_SP3_Addon na pasta Addons.

    Primeiro Uso: Digite /BLog para criar a aba de telemetria lateral.

    Combate: Mantenha o spam do seu comando principal (/BFury ou /BArms). O motor cuidará da janela de Execute e Bloodrage.

    Diagnóstico: Se sentir perda de performance, cheque o /BLog. Ele indicará se o problema é distância, GCD ou falta de recursos.