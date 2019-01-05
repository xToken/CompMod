-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\CommAbilities\Rupture\shared.lua
-- - Dragon

function Rupture:OnAbilityOptionalEnd()    
end

function Rupture:GetType()
    return CommanderAbility.kType.Repeat
end

function Rupture:OnDestroy()
    if Client then
        local effect = Client.CreateCinematic(RenderScene.Zone_Default)    
        effect:SetCinematic(Rupture.kRuptureEffect)   
        effect:SetCoords(self:GetCoords())
        
        Shared.PlayWorldSound(nil, Rupture.kBurstSound, nil, self:GetOrigin(), 1)
    end
end