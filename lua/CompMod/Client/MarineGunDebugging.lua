// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\MarineGunDebugging.lua
// - Dragon

local kRifleAttackFailures = { }
local kMaxAttackLogs = 10

local function CleanupOldFailures()
	local CleanupNeeded = #kRifleAttackFailures > kMaxAttackLogs
	if CleanupNeeded then
		for i = #kRifleAttackFailures - kMaxAttackLogs, 1, -1 do
			kRifleAttackFailures[i] = nil
		end
	end
end

local function AddAttackFailure(rifle, player)
	CleanupOldFailures()
	
	local messages = { }
	if not player then
		table.insert(messages, "Invalid player passed.")
		table.insert(kRifleAttackFailures, { m = messages, t = Shared.GetTime() })
		return
	end    
	
	if (Shared.GetTime() - rifle.lastTimeSprinted) < kMaxTimeToSprintAfterAttack then
		table.insert(messages, string.format("Sprinted too recently - %s:%s.", tostring(Shared.GetTime() - rifle.lastTimeSprinted), kMaxTimeToSprintAfterAttack))
	end
	if rifle:GetPrimaryAttackRequiresPress() and not player:GetPrimaryAttackLastFrame() then
		table.insert(messages, "Weapon requires button press for each attack.")
	end
	if rifle:GetIsReloading() and not rifle:GetPrimaryCanInterruptReload() then
		table.insert(messages, "Weapon currently being reloaded.")
	end
	
	if not rifle:GetIsDeployed() then
		table.insert(messages, "Weapon is not fully deployed yet.")
	end

	if rifle.GetPrimaryMinFireDelay then
		if (Shared.GetTime() - rifle.timeAttackFired) >= rifle:GetPrimaryMinFireDelay() then
			table.insert(messages, string.format("Fire rate exceeded - %s:%s.", tostring(Shared.GetTime() - rifle.timeAttackFired), rifle:GetPrimaryMinFireDelay()))
		end
	end
	table.insert(kRifleAttackFailures, { m = messages, t = Shared.GetTime() })
end

local oldRifleOnPrimaryAttack = Rifle.OnPrimaryAttack
function Rifle:OnPrimaryAttack(player)
	if not self:GetIsPrimaryAttackAllowed(player) then
		AddAttackFailure(self, player)
	end
	oldRifleOnPrimaryAttack(self, player)
end

local function DisplayRifleFailures()
	local t = Shared.GetTime()
	for i = #kRifleAttackFailures, 1, -1 do
		local e = kRifleAttackFailures[i]
		if e then
			Shared.Message(string.format("Failure entry below from %s seconds ago.", tostring(t - e.t)))
			for j = #e.m, 1, -1 do
				Shared.Message(e.m[j])
			end
			Shared.Message("End failure entry.")
		end
	end
	Shared.Message("All recent failures listed above.")
end

Event.Hook("Console_debugrifle", DisplayRifleFailures)
