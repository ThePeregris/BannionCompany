-- [[ BANNION COMPANY v10.2 - COMBAT CORE ]]
-- Modules: Core, Tank(Wall), Arms(Meta), Fury, Opty, Crowd, Survivor
-- Target: Turtle WoW (Patch 1.17.2+)

local BannionVersion = "|cffDAA520[BANNION v10.2 - COMBAT CORE]|r"

-- ============================================================
-- [STATIC CONFIGURATION]
-- ============================================================
local BannionSets = {
    TwoHand   = "TH", 
    DualWield = "DW", 
    Shield    = "WS"  
}

-- ============================================================
-- [1. INITIALIZATION & UTILS]
-- ============================================================
local loadFrame = CreateFrame("Frame")
loadFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
loadFrame:SetScript("OnEvent", function()
    if not BannionDB then BannionDB = { UseItemRack = false } end
    
    -- Chat Filter (Anti-Spam)
    local block = {
        "fail", "not ready", "enough rage", "Another action", "range", 
        "No target", "recovered", "Ability", "Must be in", "nothing to attack", 
        "facing", "Unknown unit", "Inventory is full", "Cannot equip", 
        "Item is not ready", "Target needs to be", "You are dead", "spell is not learned"
    }
    for i = 1, 7 do
        local frame = _G["ChatFrame"..i]
        if frame and not frame.BHooked then
            local original = frame.AddMessage
            frame.AddMessage = function(self, msg, r, g, b, id)
                if msg and type(msg) == "string" then
                    for _, p in pairs(block) do if string.find(msg, p) then return end end
                end
                original(self, msg, r, g, b, id)
            end
            frame.BHooked = true
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage(BannionVersion)
end)

-- Spell Cache & Checks
local SpellCache = {}
local _Cast = CastSpellByName

local function GetSpellID(spellName)
    if SpellCache[spellName] then return SpellCache[spellName] end
    for i = 1, 200 do
        local n = GetSpellName(i, "spell")
        if not n then break end
        if n == spellName then 
            SpellCache[spellName] = i
            return i 
        end
    end
    return nil
end

-- Global Function (Used by other modules if needed)
function Bannion_Ready(spellName)
    if UnitXP_SP3_Addon and UnitXP_SP3_Addon.SpellReady then
        return UnitXP_SP3_Addon.SpellReady(spellName)
    end
    local id = GetSpellID(spellName)
    if not id then return false end
    local start, duration = GetSpellCooldown(id, "spell")
    return start == 0
end

local function Bannion_Equip(mode)
    if not BannionDB.UseItemRack then return end
    local EquipFunc = nil
    if ItemRack and type(ItemRack.EquipSet) == "function" then EquipFunc = ItemRack.EquipSet
    elseif type(ItemRack_EquipSet) == "function" then EquipFunc = ItemRack_EquipSet end
    if not EquipFunc then return end 
    if mode == "TH" then EquipFunc(BannionSets.TwoHand)
    elseif mode == "DW" then EquipFunc(BannionSets.DualWield)
    elseif mode == "WS" then EquipFunc(BannionSets.Shield)
    end
end

local attacking = false
local f = CreateFrame'Frame'
f:RegisterEvent'PLAYER_ENTER_COMBAT'; f:RegisterEvent'PLAYER_LEAVE_COMBAT'
f:SetScript('OnEvent', function() attacking = (event == 'PLAYER_ENTER_COMBAT') end)

function CastSpellByName(t, s) 
    if t == "Attack" and attacking then return end 
    _Cast(t, s) 
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

function Bannion_HasBuff(texturePartialName)
    for i=0, 31 do
        local texture = GetPlayerBuffTexture(i)
        if texture and string.find(texture, texturePartialName) then return true end
    end
    return false
end

-- ============================================================
-- [2. COMBAT MODULES]
-- ============================================================

-- [[ TANK: v10.1 Turtle Wall ]]
function BannionTank()
    if not attacking then AttackTarget() end 
    UIErrorsFrame:Clear()
    local stance = Bannion_GetStance()
    local rage = UnitMana("player")
    
    if stance ~= 2 then _Cast("Defensive Stance"); Bannion_Equip("WS"); return end
    if BannionDB.UseItemRack and not Bannion_HasShield() then Bannion_Equip("WS") end
    
    _Cast("Shield Block"); _Cast("Thunder Clap")
    
    if UnitExists("targettarget") and not UnitIsUnit("targettarget", "player") then 
        _Cast("Taunt") 
    end

    if Bannion_Ready("Shield Slam") then _Cast("Shield Slam") end
    _Cast("Revenge"); _Cast("Sunder Armor") 
    if rage > 50 then _Cast("Heroic Strike") end
end

-- [[ ARMS: Turtle Meta ]]
function BannionArms() 
    if not attacking then AttackTarget() end 
    UIErrorsFrame:Clear()
    local stance = Bannion_GetStance()
    local thp = UnitHealth("target")/UnitHealthMax("target")*100
    local rage = UnitMana("player")

    if thp <= 20 then
        if stance == 2 then _Cast("Battle Stance"); Bannion_Equip("TH") else _Cast("Execute") end
        return
    end

    if stance ~= 1 then _Cast("Battle Stance"); Bannion_Equip("TH"); return end
    if BannionDB.UseItemRack and Bannion_HasOffHand() then Bannion_Equip("TH") end

    _Cast("Overpower") 
    if Bannion_Ready("Mortal Strike") then _Cast("Mortal Strike") 
    elseif Bannion_Ready("Bloodthirst") then _Cast("Bloodthirst") end
    if Bannion_Ready("Master Strike") then _Cast("Master Strike") end

    local hasRend = false
    for i=1,16 do local t = UnitDebuff("target", i); if t and string.find(t, "Ability_Gouge") then hasRend=true break end end
    if not hasRend and thp > 20 then _Cast("Rend") end

    if rage > 20 then _Cast("Slam") end
    if rage > 60 then _Cast("Heroic Strike") end
    if not Bannion_HasBuff("BattleShout") then _Cast("Battle Shout") end
end

-- [[ FURY: Adaptive ]]
function BannionFury() 
    if not attacking then AttackTarget() end 
    UIErrorsFrame:Clear() 
    local stance = Bannion_GetStance()
    
    if stance ~= 3 then _Cast("Berserker Stance"); Bannion_Equip("DW"); return end
    if BannionDB.UseItemRack then
        if Bannion_HasShield() or not Bannion_HasOffHand() then
            Bannion_Equip("DW")
            if UnitAffectingCombat("player") then _Cast("Bloodrage") end
            _Cast("Berserker Rage"); if UnitMana("player") >= 10 then _Cast("Hamstring") end
        end
    end

    local thp = UnitHealth("target")/UnitHealthMax("target")*100
    _Cast("Victory Rush"); _Cast("Blood Fury"); _Cast("Berserking"); _Cast("Perception")

    if thp <= 20 then _Cast("Execute"); return end
    if UnitHealth("player")/UnitHealthMax("player")*100 > 50 then _Cast("Death Wish") end
    
    if Bannion_Ready("Bloodthirst") then _Cast("Bloodthirst") 
    elseif Bannion_Ready("Mortal Strike") then _Cast("Mortal Strike") end
    
    if Bannion_Ready("Whirlwind") then _Cast("Whirlwind") end
    if Bannion_Ready("Master Strike") then _Cast("Master Strike") end
    
    if not Bannion_HasOffHand() then if UnitMana("player") > 20 then _Cast("Slam") end 
    else if UnitMana("player") > 40 then _Cast("Heroic Strike") end end
    
    _Cast("Berserker Rage")
    if not Bannion_HasBuff("BattleShout") then _Cast("Battle Shout") end
end

-- [[ CROWD: The Blender ]]
function BannionCrowd()
    if not attacking then AttackTarget() end 
    local stance = Bannion_GetStance()
    local rage = UnitMana("player")
    
    if stance == 1 then 
        _Cast("Sweeping Strikes"); _Cast("Thunder Clap")
        _Cast("Berserker Stance"); Bannion_Equip("TH") 
        return 
    end
    if stance == 3 then 
        _Cast("Whirlwind"); if rage >= 20 then _Cast("Cleave") end
        return
    end
    if stance == 2 then _Cast("Battle Stance"); Bannion_Equip("TH") end
end

-- [[ OPTY: Gap Closer ]]
function BannionOpty() 
    if not attacking then AttackTarget() end 
    local stance = Bannion_GetStance()
    local inCombat = UnitAffectingCombat("player")
    local thp = UnitHealth("target")/UnitHealthMax("target")*100
    local rage = UnitMana("player")
    
    if not inCombat then 
        if stance ~= 1 then _Cast("Battle Stance"); Bannion_Equip("TH") else _Cast("Charge") end
        return
    end
    if inCombat and not CheckInteractDistance("target", 3) then
        if stance ~= 3 then _Cast("Berserker Stance"); Bannion_Equip("DW") else _Cast("Intercept") end
        return
    end
    if thp <= 20 then _Cast("Execute"); return end
    if BannionDB.UseItemRack and Bannion_HasOffHand() then Bannion_Equip("TH") end
    local hasHam = false
    for i=1,16 do local t = UnitDebuff("target", i); if t and string.find(t, "Ability_ShockWave") then hasHam=true break end end
    if not hasHam and rage >= 10 then _Cast("Hamstring") end

    if stance == 1 then
        _Cast("Overpower")
        local hasRend = false
        for i=1,16 do local t = UnitDebuff("target", i); if t and string.find(t, "Ability_Gouge") then hasRend=true break end end
        if not hasRend and thp > 20 then _Cast("Rend") end
        if rage > 30 then _Cast("Slam") end
    elseif stance == 3 then
        if Bannion_Ready("Whirlwind") then _Cast("Whirlwind") end
        if rage > 30 then _Cast("Slam") end
        if not Bannion_Ready("Whirlwind") and rage < 25 then _Cast("Battle Stance"); Bannion_Equip("TH") end
    end
end

-- [[ SURVIVOR ]]
function BannionSurvivor() 
    if not attacking then AttackTarget() end 
    local stance = Bannion_GetStance()
    if stance ~= 2 then _Cast("Defensive Stance"); Bannion_Equip("WS"); return end
    if BannionDB.UseItemRack and not Bannion_HasShield() then Bannion_Equip("WS"); return end
    _Cast("Shield Block"); _Cast("Disarm")
    _Cast("Thunder Clap"); _Cast("Demoralizing Shout")
    _Cast("Last Stand"); _Cast("Shield Wall")
    _Cast("Revenge"); _Cast("Sunder Armor") 
end

-- [3. SLASH COMMANDS]
SLASH_BANNIONCMD1 = "/bannion"
SlashCmdList["BANNIONCMD"] = function(msg)
    msg = string.lower(msg)
    if string.find(msg, "itemrack on") then
        BannionDB.UseItemRack = true
        DEFAULT_CHAT_FRAME:AddMessage("|cffDAA520[Bannion]|r ItemRack Module: |cff00ff00ENABLED|r")
    elseif string.find(msg, "itemrack off") then
        BannionDB.UseItemRack = false
        DEFAULT_CHAT_FRAME:AddMessage("|cffDAA520[Bannion]|r ItemRack Module: |cffff0000DISABLED|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffDAA520[Bannion Configuration]|r")
        local status = BannionDB.UseItemRack and "|cff00ff00ON|r" or "|cffff0000OFF|r"
        DEFAULT_CHAT_FRAME:AddMessage("ItemRack Swap: " .. status)
        DEFAULT_CHAT_FRAME:AddMessage("Commands: /bannion itemrack on | off")
    end
end

SLASH_BFURY1 = "/BFury"; SlashCmdList["BFURY"] = BannionFury
SLASH_BARMS1 = "/BArms"; SlashCmdList["BARMS"] = BannionArms
SLASH_BCRWD1 = "/BCrwd"; SlashCmdList["BCRWD"] = BannionCrowd
SLASH_BOPTY1 = "/BOpty"; SlashCmdList["BOPTY"] = BannionOpty
SLASH_BTANK1 = "/BTank"; SlashCmdList["BTANK"] = BannionTank       
SLASH_BSURV1 = "/BSurv"; SlashCmdList["BSURV"] = BannionSurvivor
