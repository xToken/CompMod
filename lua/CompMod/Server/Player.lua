-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Server\Player.lua
-- - Dragon

function Player:OnTechOrResearchUpdated()
end

function Player:TechOrResearchUpdated()
	-- We know something changed... NS2 doesnt track these events well, relies normally on constant polling.
	-- We will use this new event to trigger a scan on anything we care about, and trigger the same on all our children.
	-- Later this should be enhanced to know exactly what has changed.
	if self:GetIsAlive() then
		for i = 0, self:GetNumChildren() - 1 do
			local child = self:GetChildAtIndex(i)
			if child.OnTechOrResearchUpdated then
				child:OnTechOrResearchUpdated()
			end
		end
		self:OnTechOrResearchUpdated()
	end
end