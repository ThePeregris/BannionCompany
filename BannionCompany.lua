-- [[ BANNION COMPANY v6.00 - GOLDEN MASTER ]]
-- Target: Turtle WoW (Patch 1.17.2)
-- Features: Cross-Spec Logic, Turtle Meta (Slam/MasterStrike), Smart Equip

local BannionVersion = "|cffDAA520[BANNION COMPANY v6.00 - GOLDEN LOADED]|r"

-- [1. FILTRO DE CHAT & UI]
-- Esconde spam de erro (vermelho) e mensagens de chat do sistema
local function ApplyDeepFilter()
    local block = {
        "fail", "not ready", "enough rage", "Another action", "range", 
        "No target", "recovered", "Ability", "Must be in", "nothing to attack", 
        "facing", "Unknown unit", "Inventory is full", "Cannot equip", 
        "Item is not ready", "Target needs to be", "You are dead",
        "spell is not learned" -- Adicionado para Master Strike
    }
    for i = 1, 7 do
        local frame = _G["ChatFrame"..i]
        if frame and not frame.BHooked then
            local original = frame.AddMessage
            frame.AddMessage = function(self, msg, r, g, b, id)
                if msg and type(msg) == "string" then
                    for _, p in pairs(block) do
                        if string.find(msg, p) then return end
                    end
                end
                original(self, msg, r, g, b, id)
            end
            frame.BHooked = true
        end
    end
end

-- [2. EVENTO DE CARREGAMENTO]
local loadFrame = CreateFrame("Frame")
loadFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
loadFrame:SetScript("OnEvent", function()
    ApplyDeepFilter()
    DEFAULT_CHAT_FRAME:AddMessage(BannionVersion)
end)

-- [3. TRACKING DE COMBATE]
local attacking = false
local f = CreateFrame'Frame'
f:RegisterEvent'PLAYER_ENTER_COMBAT'
f:RegisterEvent'PLAYER_LEAVE_COMBAT'
f:SetScript('OnEvent', function() attacking = (event == 'PLAYER_ENTER_COMBAT') end)

-- Wrapper seguro para CastSpellByName
local _Cast = CastSpellByName
function CastSpellByName(t, s) 
    if t == "Attack" and attacking then return end 
    _Cast(t, s) 
end

-- [4. HELPERS UNIVERSAIS]

-- Wrapper seguro para ItemRack (Moderno ou Clássico)
local function Bannion_Equip(setName)
    if ItemRack and type(ItemRack.EquipSet) == "function" then
        ItemRack.EquipSet(setName)
    elseif type(ItemRack_EquipSet) == "function" then
        ItemRack_EquipSet(setName)
    end
end

function Bannion_GetStance() 
    for i=1, 3 do local _, _, a = GetShapeshiftFormInfo(i) if a then return i end end
    return 1 
end

function Bannion_HasOffHand() return GetInventoryItemLink("player", 17) ~= nil end
function Bannion_HasShield()
    local link = GetInventoryItemLink("player", 17)
    if link and string.find(link, "Shield") then return true end
    return false
end

function Bannion_Ready(spellName)
    -- Integração com UnitXP_SP3 se existir, senão assume true e deixa o spam filter cuidar
    if UnitXP_SP3_Addon and UnitXP_SP3_Addon.SpellReady then
        return UnitXP_SP3_Addon.SpellReady(spellName)
    end
    return true 
end

function Bannion_HasBuff(texturePartialName)
    for i=0, 31 do
        local texture = GetPlayerBuffTexture(i)
        if texture and string.find(texture, texturePartialName) then return true end
    end
    return false
end

function Bannion_HasDebuff(texturePartialName)
    for i=1, 16 do
        local texture = UnitDebuff("target", i)
        if texture and string.find(texture, texturePartialName) then return true end
    end
    return false
end

-- [5. MÓDULOS DE COMBATE PRINCIPAIS]

-- [[ ARMS UNIVERSAL: Battle Stance + Turtle Meta ]]
function BannionArms() 
    if not attacking then AttackTarget() end 
    UIErrorsFrame:Clear()

    local stance = Bannion_GetStance()
    local thp = UnitHealth("target")/UnitHealthMax("target")*100
    local rage = UnitMana("player")

    -- 1. EXECUTE PHASE
    if thp <= 20 then
        if stance == 2 then _Cast("Battle Stance"); Bannion_Equip("TH") else _Cast("Execute") end
        return
    end

    -- 2. STANCE & GEAR
    if stance ~= 1 then 
        _Cast("Battle Stance")
        Bannion_Equip("TH")
        return 
    end
    -- Insistência na 2H (TH) se tiver algo na OffHand
    if Bannion_HasOffHand() then Bannion_Equip("TH") end

    -- 3. ROTAÇÃO HÍBRIDA (CROSS-SPEC)

    -- [PRIORIDADE 1] Overpower (Universal)
    _Cast("Overpower") 
    
    -- [PRIORIDADE 2] Nuke Principal
    -- Tenta Mortal Strike (Arms). Se não tiver, tenta Bloodthirst (Fury).
    if Bannion_Ready("Mortal Strike") then 
        _Cast("Mortal Strike") 
    elseif Bannion_Ready("Bloodthirst") then
        _Cast("Bloodthirst")
    end
    
    -- [PRIORIDADE 3] Master Strike (Utility - Turtle Talent)
    -- Se tiver o talento, usa para controle/dano extra instantâneo.
    if Bannion_Ready("Master Strike") then _Cast("Master Strike") end

    -- [PRIORIDADE 4] Rend (Sangramento)
    local hasRend = false
    for i=1,16 do 
        local t = UnitDebuff("target", i)
        if t and string.find(t, "Ability_Gouge") then hasRend=true break end 
    end
    if not hasRend and thp > 20 then _Cast("Rend") end

    -- [PRIORIDADE 5] Slam (Turtle Filler 1.0s)
    -- Filler principal para Arms. Superior ao Heroic Strike.
    if rage > 20 then _Cast("Slam") end
    
    -- [PRIORIDADE 6] Rage Dump Excessivo
    if rage > 60 then _Cast("Heroic Strike") end
    
    if not Bannion_HasBuff("BattleShout") then _Cast("Battle Shout") end
end

-- [[ FURY UNIVERSAL: Berserker Stance + Hamstring Fix ]]
function BannionFury() 
    if not attacking then AttackTarget() end 
    UIErrorsFrame:Clear() 

    local stance = Bannion_GetStance()
    
    -- 1. STANCE & GEAR
    if stance ~= 3 then _Cast("Berserker Stance"); Bannion_Equip("DW"); return end
    
    -- Hamstring Fix: Compra tempo de GCD para equipar as armas
    if Bannion_HasShield() or not Bannion_HasOffHand() then
        Bannion_Equip("DW")
        if UnitAffectingCombat("player") then _Cast("Bloodrage") end
        _Cast("Berserker Rage")
        if UnitMana("player") >= 10 then _Cast("Hamstring") end
    end

    local thp = UnitHealth("target")/UnitHealthMax("target")*100
    
    _Cast("Victory Rush") -- Turtle WoW racial/skill
    _Cast("Blood Fury"); _Cast("Berserking"); _Cast("Perception")

    -- 2. EXECUTE
    if thp <= 20 then _Cast("Execute"); return end
    if UnitHealth("player")/UnitHealthMax("player")*100 > 50 then _Cast("Death Wish") end
    
    -- 3. ROTAÇÃO HÍBRIDA (CROSS-SPEC)
    
    -- [PRIORIDADE 1] Nuke Principal
    if Bannion_Ready("Bloodthirst") then 
        _Cast("Bloodthirst") 
    elseif Bannion_Ready("Mortal Strike") then
        _Cast("Mortal Strike")
    end
    
    -- [PRIORIDADE 2] Whirlwind (AoE/Burst)
    if Bannion_Ready("Whirlwind") then _Cast("Whirlwind") end
    
    -- [PRIORIDADE 3] Master Strike (Utility)
    if Bannion_Ready("Master Strike") then _Cast("Master Strike") end
    
    -- [PRIORIDADE 4] Filler Dinâmico (Slam vs HS)
    if not Bannion_HasOffHand() then
        -- Se estiver de 2H (Arms visitando ou troca incompleta) -> Slam
        if UnitMana("player") > 20 then _Cast("Slam") end
    else
        -- Se estiver de Dual Wield (Fury) -> Heroic Strike
        if UnitMana("player") > 40 then _Cast("Heroic Strike") end
    end
    
    _Cast("Berserker Rage")
    if not Bannion_HasBuff("BattleShout") then _Cast("Battle Shout") end
end

-- [[ OPTY: Oportunista / Gap Closer ]]
function BannionOpty() 
    if not attacking then AttackTarget() end 
    local stance = Bannion_GetStance()
    local inCombat = UnitAffectingCombat("player")
    local thp = UnitHealth("target")/UnitHealthMax("target")*100
    local rage = UnitMana("player")
    
    -- 1. MOVIMENTO
    if not inCombat then 
        if stance ~= 1 then _Cast("Battle Stance"); Bannion_Equip("TH") else _Cast("Charge") end
        return
    end
    if inCombat and not CheckInteractDistance("target", 3) then
        if stance ~= 3 then _Cast("Berserker Stance"); Bannion_Equip("DW") else _Cast("Intercept") end
        return
    end

    -- 2. EXECUTE
    if thp <= 20 then _Cast("Execute"); return end

    -- 3. PÓS-INTERCEPT & CC
    if Bannion_HasOffHand() then Bannion_Equip("TH") end
    
    local hasHam = Bannion_HasDebuff("Ability_ShockWave")
    if not hasHam and rage >= 10 then _Cast("Hamstring") end

    -- 4. DANO TÁTICO
    if stance == 1 then
        _Cast("Overpower")
        local hasRend = Bannion_HasDebuff("Ability_Gouge")
        if not hasRend and thp > 20 then _Cast("Rend") end
        if rage > 30 then _Cast("Slam") end
    elseif stance == 3 then
        if Bannion_Ready("Whirlwind") then _Cast("Whirlwind") end
        if rage > 30 then _Cast("Slam") end
        if not Bannion_Ready("Whirlwind") and rage < 25 then _Cast("Battle Stance"); Bannion_Equip("TH") end
    end
end

-- [[ SURV: Sobrevivência Extrema ]]
function BannionSurvivor() 
    if not attacking then AttackTarget() end 
    local stance = Bannion_GetStance()
    
    if stance ~= 2 then _Cast("Defensive Stance"); Bannion_Equip("WS"); return end
    if not Bannion_HasShield() then Bannion_Equip("WS"); return end
    
    _Cast("Shield Block") -- Prioridade #1
    _Cast("Disarm")       -- Prioridade #2
    _Cast("Thunder Clap"); _Cast("Demoralizing Shout")
    _Cast("Last Stand"); _Cast("Shield Wall")
    _Cast("Revenge"); _Cast("Sunder Armor") 
end

-- [[ TANK: Aggro & Controle ]]
function BannionTank()
    if not attacking then AttackTarget() end 
    local stance = Bannion_GetStance()
    if stance ~= 2 then _Cast("Defensive Stance"); Bannion_Equip("WS"); return end
    if not Bannion_HasShield() then Bannion_Equip("WS") end
    if UnitExists("targettarget") and not UnitIsUnit("targettarget", "player") then _Cast("Taunt") end
    _Cast("Shield Block"); _Cast("Shield Slam"); _Cast("Revenge"); _Cast("Sunder Armor") 
end

-- [[ CROWD: AoE ]]
function BannionCrowd()
    if not attacking then AttackTarget() end 
     local stance = Bannion_GetStance()
     if stance == 1 then 
        _Cast("Thunder Clap"); _Cast("Berserker Stance"); Bannion_Equip("DW")
        return 
    end
     if stance == 3 then 
        _Cast("Whirlwind"); _Cast("Cleave") -- Aqui pode adicionar Sweeping Strikes se desejar manual
     end
     _Cast("Thunder Clap")
end

-- [6. SLASH COMMANDS]
SLASH_BFURY1 = "/BFury"; SlashCmdList["BFURY"] = BannionFury
SLASH_BARMS1 = "/BArms"; SlashCmdList["BARMS"] = BannionArms
SLASH_BCRWD1 = "/BCrwd"; SlashCmdList["BCRWD"] = BannionCrowd
SLASH_BOPTY1 = "/BOpty"; SlashCmdList["BOPTY"] = BannionOpty
SLASH_BTANK1 = "/BTank"; SlashCmdList["BTANK"] = BannionTank       
SLASH_BSURV1 = "/BSurv"; SlashCmdList["BSURV"] = BannionSurvivor
