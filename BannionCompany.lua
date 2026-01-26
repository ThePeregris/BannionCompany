-- [[ BANNION COMPANY v1.36.00-ULTIMATE ]]
-- Final Build: Pure Combat Core | Fully Modular | Lua 1.12.1

BannionPrefix = "|cffDAA520B|r|cff00ff00annion|r|cffdd0000Ultimate|r"
local BannionLogFrame = nil
local isProcessingLog = false 

-- [1. CONSOLE E LOG]
local function GetBannionLog()
    if BannionLogFrame then return BannionLogFrame end
    for i=1, 7 do
        if GetChatWindowInfo(i) == "BannionLog" then
            BannionLogFrame = _G["ChatFrame"..i]
            return BannionLogFrame
        end
    end
    return DEFAULT_CHAT_FRAME
end

function BannionLog(msg)
    if isProcessingLog then return end
    isProcessingLog = true
    local frame = GetBannionLog()
    frame:AddMessage("|cff888888["..date("%H:%M:%S").."]|r " .. BannionPrefix .. " " .. msg)
    isProcessingLog = false
end

-- [2. FILTRO DE SILÊNCIO (Silent Engine)]
local function ApplyDeepFilter()
    local block = {"fail", "not ready", "enough rage", "Another action", "range", "No target", "recovered", "Ability", "Must be in", "nothing to attack", "facing", "Unknown unit"}
    for i = 1, 7 do
        local frame = _G["ChatFrame"..i]
        if frame and not frame.BHooked then
            local original = frame.AddMessage
            frame.AddMessage = function(self, msg, r, g, b, id)
                if isProcessingLog then original(self, msg, r, g, b, id) return end
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

-- [3. COMBAT HOOKS (Iron Toggle)]
local attacking
do
    local f = CreateFrame'Frame'
    f:RegisterEvent'PLAYER_ENTER_COMBAT'
    f:RegisterEvent'PLAYER_LEAVE_COMBAT'
    f:SetScript('OnEvent', function() attacking = (event == 'PLAYER_ENTER_COMBAT') end)
end

local _Cast = CastSpellByName
function CastSpellByName(t, s) 
    if t == "Attack" and attacking then return end 
    _Cast(t, s) 
end

-- [4. CORE & HELPERS]
function Bannion_HP() return (UnitHealth("player")/UnitHealthMax("player")) * 100 end
function Bannion_TargetHP() return UnitExists("target") and (UnitHealth("target")/UnitHealthMax("target"))*100 or 100 end

function Bannion_GetStance() 
    for i=1, 3 do
        local _, _, active = GetShapeshiftFormInfo(i)
        if active then return i end
    end
    return 1 
end

function Bannion_Ready(spellName)
    if UnitXP_SP3_Addon and UnitXP_SP3_Addon.SpellReady then
        return UnitXP_SP3_Addon.SpellReady(spellName)
    end
    return true 
end

-- DETETOR DE DEBUFF (Texture Scan 1.12.1)
function Bannion_HasDebuff(texturePartialName)
    for i=1, 16 do
        local texture = UnitDebuff("target", i)
        if texture and string.find(texture, texturePartialName) then
            return true
        end
    end
    return false
end

function Bannion_Core()
    if not attacking then AttackTarget() end 
    UIErrorsFrame:Clear()
    _Cast("Victory Rush") 
    
    -- Bloodrage apenas em combate
    if UnitAffectingCombat("player") then _Cast("Bloodrage") end
    
    _Cast("Blood Fury"); _Cast("Berserking"); _Cast("Perception")
end

-- [5. MOTORES DE COMBATE]

function BannionFury() 
    Bannion_Core()
    local thp, hp, rage = Bannion_TargetHP(), Bannion_HP(), UnitMana("player")
    local stance = Bannion_GetStance()
    
    if thp <= 20 then 
        if stance ~= 3 and stance ~= 1 then _Cast("Berserker Stance") end
        _Cast("Execute")
        return
    end
    if stance ~= 3 then _Cast("Berserker Stance"); return end
    if hp > 50 then _Cast("Death Wish") end
    
    if Bannion_Ready("Bloodthirst") then _Cast("Bloodthirst") end
    if Bannion_Ready("Whirlwind") then _Cast("Whirlwind") end
    if rage > 35 then _Cast("Heroic Strike") end
    _Cast("Berserker Rage"); _Cast("Battle Shout")
end

function BannionArms() 
    Bannion_Core()
    local thp, rage = Bannion_TargetHP(), UnitMana("player")
    local stance = Bannion_GetStance()
    local hasRend = Bannion_HasDebuff("Ability_Gouge")
    
    if thp <= 20 then
        if stance == 2 then _Cast("Battle Stance") else _Cast("Execute") end
        return
    end
    if stance ~= 1 then _Cast("Battle Stance"); return end
    
    if Bannion_Ready("Mortal Strike") then _Cast("Mortal Strike") end
    _Cast("Overpower") 
    
    if not hasRend and thp > 20 then _Cast("Rend") end
    if hasRend then _Cast("Heroic Strike") end
    _Cast("Battle Shout")
end

function BannionCrowd() 
    Bannion_Core()
    local rage = UnitMana("player")
    local stance = Bannion_GetStance()
    if rage >= 20 then _Cast("Cleave") end
    if stance == 3 then 
        _Cast("Whirlwind"); if rage > 40 then _Cast("Demoralizing Shout") end
    elseif stance == 1 then
        _Cast("Thunder Clap"); _Cast("Berserker Stance") 
    else 
        _Cast("Thunder Clap")
    end
end

function BannionOpty() 
    Bannion_Core() 
    local stance = Bannion_GetStance()
    local inCombat = UnitAffectingCombat("player")
    local thp = Bannion_TargetHP()
    
    -- 1. Movimento
    if not inCombat then 
        if stance ~= 1 then _Cast("Battle Stance") else _Cast("Charge") end
        return
    end
    if inCombat and not CheckInteractDistance("target", 3) then
        if stance ~= 3 then _Cast("Berserker Stance") else _Cast("Intercept") end
        return
    end

    -- 2. Finalização
    if thp <= 20 then _Cast("Execute") return end

    -- 3. Reset para Battle Stance
    if stance == 3 then _Cast("Battle Stance"); return end

    -- 4. Overpower
    if stance == 1 then _Cast("Overpower") end
    
    -- 5. Combo Tático
    local hasRend = Bannion_HasDebuff("Ability_Gouge")      
    local hasHam = Bannion_HasDebuff("Ability_ShockWave")   
    
    if not hasRend then
        if stance ~= 1 and stance ~= 2 then _Cast("Battle Stance") else _Cast("Rend") end
    elseif not hasHam then
        _Cast("Hamstring") 
    else
        _Cast("Slam")
    end
    
    -- 6. Filler
    if stance == 1 then _Cast("Mortal Strike") end
    _Cast("Sunder Armor")
end

function BannionTank()
    Bannion_Core()
    local stance = Bannion_GetStance()
    local rage = UnitMana("player")

    if stance ~= 2 then _Cast("Defensive Stance"); return end

    if UnitExists("targettarget") and not UnitIsUnit("targettarget", "player") then
        _Cast("Taunt")
    end

    _Cast("Shield Block") 
    _Cast("Shield Slam")
    _Cast("Revenge")      
    _Cast("Sunder Armor") 
    
    if rage > 20 then _Cast("Demoralizing Shout") end
end

function BannionSurvivor() 
    Bannion_Core()
    BannionLog("|cffff0000[PANIC MODE]|r")
    local stance = Bannion_GetStance()
    
    if stance ~= 2 then _Cast("Defensive Stance"); return end
    
    _Cast("Last Stand")
    _Cast("Shield Wall") 
    _Cast("Shield Block")
    _Cast("Disarm")
    _Cast("Thunder Clap")
    _Cast("Demoralizing Shout")
end

-- [6. SLASH COMMANDS]

SLASH_BFURY1 = "/BFury"; SlashCmdList["BFURY"] = BannionFury
SLASH_BARMS1 = "/BArms"; SlashCmdList["BARMS"] = BannionArms
SLASH_BCRWD1 = "/BCrwd"; SlashCmdList["BCRWD"] = BannionCrowd
SLASH_BOPTY1 = "/BOpty"; SlashCmdList["BOPTY"] = BannionOpty
SLASH_BTANK1 = "/BTank"; SlashCmdList["BTANK"] = BannionTank       
SLASH_BSURV1 = "/BSurv"; SlashCmdList["BSURV"] = BannionSurvivor   

SLASH_BLOG1 = "/BLog"; SlashCmdList["BLOG"] = function()
    local exists = false
    for i=1, 7 do if GetChatWindowInfo(i) == "BannionLog" then exists = true break end end
    if not exists then FCF_OpenNewWindow("BannionLog") end
    BannionLog("System ULTIMATE. Full Modular Suite Active.")
end

ApplyDeepFilter()
DEFAULT_CHAT_FRAME:AddMessage(BannionPrefix.." v1.36.00 ULTIMATE Loaded!")