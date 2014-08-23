//Dont want to always replace random files, so this.

function Railgun:ModifyMaxSpeed(maxSpeedTable)
end

function Railgun:GetIsThrusterAllowed()
    return true
end

function Railgun:OnUpdateRender()
end

function Railgun:GetBarrelPoint()

    local player = self:GetParent()
    if player then
    
        if player:GetIsLocalPlayer() then
        
            local origin = player:GetEyePos()
            local viewCoords = player:GetViewCoords()
            
            if self:GetIsLeftSlot() then
                return origin + viewCoords.zAxis * 0.9 + viewCoords.xAxis * 0.65 + viewCoords.yAxis * -0.19
            else
                return origin + viewCoords.zAxis * 0.9 + viewCoords.xAxis * -0.65 + viewCoords.yAxis * -0.19
            end    
        
        else
    
            local origin = player:GetEyePos()
            local viewCoords = player:GetViewCoords()
			origin.y = origin.y - 0.45
            
            if self:GetIsLeftSlot() then
                return origin + viewCoords.zAxis * 0.9 + viewCoords.xAxis * 0.35 + viewCoords.yAxis * -0.15
            else
                return origin + viewCoords.zAxis * 0.9 + viewCoords.xAxis * -0.35 + viewCoords.yAxis * -0.15
            end
            
        end    
        
    end
    
    return self:GetOrigin()
    
end

ReplaceUpValue( Railgun.OnTag, "kBulletSize", kRailgunBulletSize, { LocateRecurse = true } )
//ReplaceUpValue( Railgun.OnProcessMove, "kBulletSize", kRailgunBulletSize )
ReplaceUpValue( Railgun.OnPrimaryAttack, "kRailgunChargeTime", kRailgunCooldown )