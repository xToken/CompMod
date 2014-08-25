//Dont want to always replace random files, so this.

local function CreateFlame(self)
end

local function BurnSporesAndUmbra(self, startPoint, endPoint)

    local toTarget = endPoint - startPoint
    local distanceToTarget = toTarget:GetLength()
    toTarget:Normalize()
    
    local stepLength = 2

    for i = 1, 5 do
    
        // stop when target has reached, any spores would be behind
        if distanceToTarget < i * stepLength then
            break
        end
    
        local checkAtPoint = startPoint + toTarget * i * stepLength
        local bombs = GetEntitiesWithinRange("Bomb", checkAtPoint, 1.6)
        table.copy(GetEntitiesWithinRange("WhipBomb", checkAtPoint, 1.6), bombs, true)
        
        for index, bomb in ipairs(bombs) do
            bomb:TriggerEffects("burn_bomb", { effecthostcoords = Coords.GetTranslation(bomb:GetOrigin()) } )
            DestroyEntity(bomb)
        end
		
    end

end

ReplaceUpValue( Flamethrower.FirePrimary, "CreateFlame", CreateFlame, { LocateRecurse = true } )
ReplaceUpValue( Flamethrower.FirePrimary, "kConeWidth", kFlamethrowerAttackCone, { LocateRecurse = true } )
ReplaceUpValue( Flamethrower.FirePrimary, "BurnSporesAndUmbra", BurnSporesAndUmbra, { LocateRecurse = true } )

function Flamethrower:GetRange()
    return kFlamethrowerRange
end

function Flamethrower:GetHUDSlot()
    return kSecondaryWeaponSlot
end

local oldFireMixinGetIsOnFire = FireMixin.GetIsOnFire
function FireMixin:GetIsOnFire()
	if self.BlockFireState then
		return false
	end
	return oldFireMixinGetIsOnFire(self)
end

local oldCragGetTechAllowed = Crag.GetTechAllowed
function Crag:GetTechAllowed(techId, techNode, player)
	local allowed, canAfford
    self.BlockFireState = true
    allowed, canAfford = oldCragGetTechAllowed(self, techId, techNode, player)
	self.BlockFireState = false
	return allowed, canAfford
end

local oldShadeGetTechAllowed = Shade.GetTechAllowed
function Shade:GetTechAllowed(techId, techNode, player)
	local allowed, canAfford
    self.BlockFireState = true
    allowed, canAfford = oldShadeGetTechAllowed(self, techId, techNode, player)
	self.BlockFireState = false
	return allowed, canAfford
end

local oldShiftGetTechAllowed = Shift.GetTechAllowed
function Shift:GetTechAllowed(techId, techNode, player)
	local allowed, canAfford
    self.BlockFireState = true
    allowed, canAfford = oldShiftGetTechAllowed(self, techId, techNode, player)
	self.BlockFireState = false
	return allowed, canAfford
end