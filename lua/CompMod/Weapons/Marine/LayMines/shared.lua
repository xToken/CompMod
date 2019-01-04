-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\LayMines\shared.lua
-- - Dragon

local networkVars =
{
    deployed_mines = "integer (0 to 5)"
}

local function GetInitDeployedMines(self)
	local player = self:GetParent()
	if player then
		local owner = Server.GetOwner(player)
		if owner then
			local clientId = owner:GetUserId()
			self:SetDeployedMines(Clamp(GetClientDeployedMines(clientId), 0, 5))
		end
	end
end

local originalLayMinesOnInitialized
originalLayMinesOnInitialized = Class_ReplaceMethod("LayMines", "OnInitialized",
	function(self)
		originalLayMinesOnInitialized(self)
		self.deployed_mines = 0
		if Server then
			self:AddTimedCallback(GetInitDeployedMines, 0.1)
		end
	end
)

function LayMines:GetHUDSlot()
    return 4
end

function LayMines:GetDeployedMines()
    return self.deployed_mines
end

function LayMines:SetDeployedMines(count)
    self.deployed_mines = Clamp(count, 0, 5)
end

if Client then

	function LayMines:GetUIDisplaySettings()
        return { xSize = 350, ySize = 417, script = "lua/GUIMineDisplay.lua" }
    end
	
end

Shared.LinkClassToMap("LayMines", LayMines.kMapName, networkVars)