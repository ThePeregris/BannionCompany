-- [[ BANNION COMPANY v1.18.84-STABLE ]]
-- Final Build: Anti-Recursion | Silent Engine | Iron-Toggle | Vanilla Fix

BannionPrefix = "|cffDAA520B|r|cff00ff00annionCompany|r"
local BannionLogFrame = nil
local isProcessingLog = false -- Trava de segurança contra Stack Overflow

-- [1. MÓDULO DE CONSOLE (BannionLog)]
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
    local ts = "|cff888888["..date("%H:%M:%S").."]|r "
    frame:AddMessage(ts .. BannionPrefix .. " " .. msg)
    isProcessingLog = false
end

-- [2. FILTRO DE SILÊNCIO (Silent Engine)]
local function ApplyDeepFilter()
    local block = {"You fail to perform", "not ready", "Not enough rage", "Another action", "Out of range", "No target", "Not yet recovered", "Ability is not ready"}
    for i = 1, 7 do
        local frame = _G["ChatFrame"..i]
        if frame and not frame.BHooked then
            local name = GetChatWindowInfo(i)
            local original = frame.AddMessage
            frame.AddMessage = function(self, msg, r, g, b, id)
                if isProcessingLog then original(self, msg, r, g, b, id) return end
                if msg and type(msg) == "string" then
                    for _, p in pairs(block) do
                        if string.find(msg, p) then
                            if name ~= "BannionLog" then 
                                BannionLog("|cffff8800[LOG]|r " .. msg)
                                return 
                            end
                        end
                    end
                end
                original(self, msg, r, g, b, id)
            end
            frame.BHooked = true
        end
    end
end

-- [3. GANCHOS DE ATAQUE (Iron-Toggle)]
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

-- [4. AUXILIARES DE STATUS (1.12.1 Fix)]
function Bannion_IsMounted()
    for i=0, 15 do
        local t = GetPlayerBuffTexture(i)
        if t and (string.find(t, "Mount") or string.find(t, "Turtlemount") or string.find(t, "Riding")) then return true end
    end
    return false
end

function Bannion_HP() return (UnitHealth("player")/UnitHealthMax("player")) * 100 end
function Bannion_TargetHP() return UnitExists("target") and (UnitHealth("target")/UnitHealthMax("target"))*100 or 100 end
function Bannion_GetStance() return GetShapeshiftForm() end

function Bannion_Core()
    if not attacking then AttackTarget() end 
    UIErrorsFrame:Clear()
    _Cast("Perception"); _Cast("Victory Rush"); _Cast("Bloodrage")
end

-- [5. MOTORES DE COMBATE (Prioridades)]

function BannionFury() -- PRIORIDADE: EXECUTE > BT > WW > DW
    if not UnitXP_SP3_Addon then BannionLog("|cffff0000ERRO:|r SP3 Addon Faltando!") return end
    Bannion_Core()
    local thp, hp = Bannion_TargetHP(), Bannion_HP()
    
    if thp <= 20 then -- Fase de Execução
        if Bannion_GetStance() ~= 3 then _Cast("Berserker Stance") else _Cast("Execute") end
        return
    end
    
    if Bannion_GetStance() ~= 3 then _Cast("Berserker Stance"); return end
    if hp > 60 then _Cast("Death Wish") end
    
    local lib = UnitXP_SP3_Addon
    if lib.SpellReady then
        if lib.SpellReady("Bloodthirst") then _Cast("Bloodthirst") end
        if lib.SpellReady("Whirlwind") then _Cast("Whirlwind") end
    end
    _Cast("Berserker Rage"); _Cast("Battle Shout")
end

function BannionArms() -- PRIORIDADE: EXECUTE > MS > REND
    Bannion_Core()
    local thp = Bannion_TargetHP()
    if thp <= 20 then
        if Bannion_GetStance() == 2 then _Cast("Battle Stance") else _Cast("Execute") end
        return
    end
    if Bannion_GetStance() ~= 1 then _Cast("Battle Stance"); return end
    local lib = UnitXP_SP3_Addon
    if lib and lib.SpellReady and lib.SpellReady("Mortal Strike") then _Cast("Mortal Strike") end
    _Cast("Rend"); _Cast("Battle Shout")
end

function BannionSurvivor() -- PRIORIDADE: SHIELD BLOCK > DISARM > DEMO
    Bannion_Core(); BannionLog("|cff00ffff[SURVIVOR]|r")
    if Bannion_GetStance() ~= 2 then _Cast("Defensive Stance"); return end
    _Cast("Shield Block"); _Cast("Disarm"); _Cast("Demoralizing Shout")
end

-- [6. SUPORTE E UTILIDADE]

function BannionHeal()
    if UnitAffectingCombat("player") then _Cast("Healing Potion"); return end
    local bestBag, bestSlot, maxP = nil, nil, 0
    local bPrio = {["Heavy Runecloth Bandage"]=100, ["Runecloth Bandage"]=90, ["Heavy Mageweave Bandage"]=80, ["Mageweave Bandage"]=70, ["Heavy Silk Bandage"]=60, ["Silk Bandage"]=50}
    for bag = 0, 4 do for slot = 1, GetContainerNumSlots(bag) do
        local link = GetContainerItemLink(bag, slot)
        if link then 
            local _,_,name = string.find(link, "%[(.+)%]")
            if name and bPrio[name] and bPrio[name] > maxP then
                maxP = bPrio[name]; bestBag, bestSlot = bag, slot 
            end
        end
    end end
    if bestBag then TargetUnit("player"); UseContainerItem(bestBag, bestSlot); TargetLastTarget() end
end

-- [7. SLASH COMMANDS REGISTRY]
SLASH_BFURY1 = "/BFury"; SlashCmdList["BFURY"] = BannionFury
SLASH_BARMS1 = "/BArms"; SlashCmdList["BARMS"] = BannionArms
SLASH_BSURV1 = "/BSurv"; SlashCmdList["BSURV"] = BannionSurvivor
SLASH_BHEAL1 = "/BHeal"; SlashCmdList["BHEAL"] = BannionHeal
SLASH_BMOUNT1 = "/BMount"; SlashCmdList["BMOUNT"] = function()
    if Bannion_IsMounted() then ExecuteChatLine("/dismount") 
    else _Cast(IsShiftKeyDown() and "White Stallion" or "Riding Turtle") end
end
SLASH_BVIS1 = "/BVis"; SlashCmdList["BVIS"] = function() SetCVar("cameraDistanceMax", 50); SetView(4); SetView(4) end
SLASH_BFOCUS1 = "/BFocus"; SlashCmdList["BFOCUS"] = function() ExecuteChatLine("/focus") end
SLASH_BASSIST1 = "/BAssist"; SlashCmdList["BASSIST"] = function() ExecuteChatLine("/assist focus") end
SLASH_BCLOSE1 = "/BClose"; SlashCmdList["BCLOSE"] = function()
    for i=1, 7 do if GetChatWindowInfo(i) == "BannionLog" then FCF_Close(_G["ChatFrame"..i]) end end
end
SLASH_BLOG1 = "/BLog"; SlashCmdList["BLOG"] = function()
    local exists = false
    for i=1, 7 do if GetChatWindowInfo(i) == "BannionLog" then exists = true break end end
    if not exists then FCF_OpenNewWindow("BannionLog") end
    BannionLog("Diagnóstico Sincronizado.")
end
SLASH_BCHECK1 = "/BCheck"; SlashCmdList["BCHECK"] = function() 
    BannionLog("HP: "..math.floor(Bannion_HP()).."% | SP3: "..(UnitXP_SP3_Addon and "OK" or "ERRO")) 
end

ApplyDeepFilter()
DEFAULT_CHAT_FRAME:AddMessage(BannionPrefix.." v1.18.84 Stable Loaded!")