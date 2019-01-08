-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIAuraDisplay\post.lua
-- - Dragon

local kIconSize = Vector(80, 80, 0)
local kHeartOffset = Vector(0, 1.25, 0)
local kExoHeartOffset = Vector(0, 2.25, 0)
local kTexture = "ui/aura.dds"
local kHeartbeatMinSoundRate = 2
local kHeartbeatMaxSoundRate = 4

local function CreateAuaIcon(self)

    local icon = GetGUIManager():CreateGraphicItem()
    icon:SetTexture(kTexture)
    icon:SetShader("shaders/GUIAura.surface_shader")
    icon:SetBlendTechnique(GUIItem.Add)
    self.background:AddChild(icon)
    
    return icon

end

function GUIAuraDisplay:Update(deltaTime)
            
    PROFILE("GUIAuraDisplay:Update")
    
    local players = {}

    if not self.soundTrigger then
        self.soundTrigger = { }
    end
    
    local player = Client.GetLocalPlayer()
    if player and GetHasAuraUpgrade(player) then
    
        local viewDirection = player:GetViewCoords().zAxis
        local eyePos = player:GetEyePos()
        
        local range = player:GetVeilLevel() * 10

        for _, enemyPlayer in ipairs( GetEntitiesForTeamWithinRange("Player", GetEnemyTeamNumber(player:GetTeamNumber()), eyePos, range) ) do
        
            if not enemyPlayer:isa("Spectator") and not enemyPlayer:isa("Commander") then

                if enemyPlayer:GetIsAlive() then
                    if viewDirection:DotProduct(GetNormalizedVector(enemyPlayer:GetOrigin() - eyePos)) > 0 then
                        if not GetWallBetween(eyePos, enemyPlayer:GetOrigin(), enemyPlayer) then
                            table.insert(players, enemyPlayer)
                        --elseif (self.soundTrigger[enemyPlayer:GetId()] or 0) < Shared.GetTime() then
                            --StartSoundEffectAtOrigin("sound/NS2.fev/alien/structures/shift/idle", enemyPlayer:GetOrigin(), 1.5, nil)
                            --self.soundTrigger[enemyPlayer:GetId()] = Shared.GetTime() + math.random(kHeartbeatMinSoundRate, kHeartbeatMaxSoundRate)
                        end
                    end
                    
                end
                
            end
        
        end
    
    end

    local numPlayers = #players
    local numIcons = #self.icons
    
    if numPlayers > numIcons then
    
        for i = 1, numPlayers - numIcons do
            
            local icon = CreateAuaIcon(self)
            table.insert(self.icons, icon)
            
        end
    
    elseif numIcons > numPlayers then
    
        for i = 1, numIcons - numPlayers do
            
            GUI.DestroyItem(self.icons[#self.icons])
            self.icons[#self.icons] = nil
            
        end
    
    end
    
    local eyePos = player:GetEyePos()
    
    for i = 1, numPlayers do
    
        local enemy = players[i]
        local icon = self.icons[i]
        
        local healthScalar = enemy:GetHealthScalar()        
        local color = Color(1, healthScalar, 0, 1)
        
        local offset = enemy:isa("Exo") and kExoHeartOffset or kHeartOffset
        
        local worldPos = enemy:GetOrigin() + offset
        local screenPos = Client.WorldToScreen(worldPos)
        local distanceFraction = 1 - Clamp((worldPos - eyePos):GetLength() / 20, 0, 0.8)

        local size = GUIScale(Vector(kIconSize.x, kIconSize.y, 0)) * distanceFraction
        icon:SetPosition(screenPos - size * 0.5)
        icon:SetSize(size)
        icon:SetColor(color)
    
    end

end