-- [[ BANNION COMPANY v2.13-RAW ]]
-- No Filters. Pure Logic.

-- [TESTE DE VIDA]
DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[BANNION COMPANY v2.13 LOADED]|r")

local isProcessing = false 
local attacking = false

-- Rastreio de Combate
local f = CreateFrame'Frame'
f:RegisterEvent'PLAYER_ENTER_COMBAT'
f:RegisterEvent'PLAYER_LEAVE_COMBAT'
f:SetScript('OnEvent', function() attacking = (event == 'PLAYER_ENTER_COMBAT') end)

-- Hook de Cast
local _Cast = CastSpellByName
function CastSpellByName(t, s) 
    if t == "Attack" and attacking then return end 
    _Cast(t, s) 
end

-- Helpers
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

-- MOTORES DE COMBATE (LÓGICA PERSISTENTE)

function BannionFury()
    if not attacking then AttackTarget() end 
    UIErrorsFrame:Clear()

    local stance = Bannion_GetStance()
    
    -- 1. STANCE
    if stance ~= 3 then
        _Cast("Berserker Stance")
        if ItemRack then ItemRack.EquipSet("DW") end
        return 
    end

    -- 2. INSISTÊNCIA DE GEAR
    if not Bannion_HasOffHand() then
        if ItemRack then ItemRack.EquipSet("DW") end
        -- Se estiver em combate, aborta para forçar o clique/equip novamente
        if UnitAffectingCombat("player") then return end
    end

    -- 3. AÇÃO
    local thp = UnitHealth("target")/UnitHealthMax("target")*100
    if thp <= 20 then _Cast("Execute"); return end
    
    if UnitXP_SP3_Addon and UnitXP_SP3_Addon.SpellReady("Bloodthirst") then _Cast("Bloodthirst") end
    if UnitXP_SP3_Addon and UnitXP_SP3_Addon.SpellReady("Whirlwind") then _Cast("Whirlwind") end
    if UnitMana("player") > 35 then _Cast("Heroic Strike") end
    
    _Cast("Berserker Rage")
    _Cast("Blood Fury"); _Cast("Berserking")
end

function BannionTank()
    if not attacking then AttackTarget() end 
    local stance = Bannion_GetStance()

    if stance ~= 2 then 
        _Cast("Defensive Stance")
        if ItemRack then ItemRack.EquipSet("WS") end
        return 
    end

    if not Bannion_HasShield() then
        if ItemRack then ItemRack.EquipSet("WS") end
        if UnitAffectingCombat("player") then return end
    end

    if UnitExists("targettarget") and not UnitIsUnit("targettarget", "player") then _Cast("Taunt") end
    _Cast("Shield Block"); _Cast("Shield Slam"); _Cast("Revenge"); _Cast("Sunder Armor")
end

function BannionArms()
    if not attacking then AttackTarget() end
    local stance = Bannion_GetStance()
    local thp = UnitHealth("target")/UnitHealthMax("target")*100

    if thp <= 20 then if stance==2 then _Cast("Battle Stance") else _Cast("Execute") end return end
    if stance ~= 1 then _Cast("Battle Stance"); if ItemRack then ItemRack.EquipSet("TH") end return end
    
    _Cast("Mortal Strike"); _Cast("Overpower")
    if not UnitDebuff("target", 1) then _Cast("Rend") end -- Simplificado para teste
end

-- COMANDOS
SLASH_BFURY1 = "/BFury"; SlashCmdList["BFURY"] = BannionFury
SLASH_BTANK1 = "/BTank"; SlashCmdList["BTANK"] = BannionTank
SLASH_BARMS1 = "/BArms"; SlashCmdList["BARMS"] = BannionArms