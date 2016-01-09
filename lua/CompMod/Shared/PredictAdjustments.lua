// Natural Selection 2 'Tweaks' Mod
// Source located at - https://github.com/xToken/NS2-Tweaks
// lua\Shared\PredictAdjustments.lua
// - Dragon

if Predict then

	local kPredictTable = { }
	local kPredictUpdateRate = 0.5
	local kPredictFullUpdateRate = 0.025
	local kPredictUpdateClasses = { "Clog", "Door", "TunnelEntrance" }
	local kPredictFullUpdateClasses = { }
	local kPredictUpdateClassHooks = { }
	
	local function RemoveOldId(entId)
		for i = #kPredictTable, 1, -1 do
			if kPredictTable[i] then
				if kPredictTable[i].i == entId then
					kPredictTable[i] = nil
				end
			end		
		end
	end
	
	local function BuildClassHooks(className)
		local oldClassCreateHook
		oldClassCreateHook = Class_ReplaceMethod(className, "OnCreate",
			function(self)
				oldClassCreateHook(self)
				table.insert(kPredictTable, {i = self:GetId(), t = kPredictUpdateRate})
			end
		)
		local oldClassDestroyHook
		oldClassDestroyHook = Class_ReplaceMethod(className, "OnDestroy",
			function(self)
				RemoveOldId(self:GetId())
				oldClassDestroyHook(self)
			end
		)
		table.insert(kPredictUpdateClassHooks, {classname = className, create = oldClassCreateHook, destroy = oldClassDestroyHook})
	end
	
	function AddClassToPredictionUpdate(className, fullyUpdateFunction)
		BuildClassHooks(className)
		if fullyUpdateFunction and type(fullyUpdateFunction) == "function" then
			kPredictFullUpdateClasses[className] = fullyUpdateFunction
		end
	end
	
	for i = 1, #kPredictUpdateClasses do
		BuildClassHooks(kPredictUpdateClasses[i])
	end
	
	local oldPlayerOnUpdatePlayer
	oldPlayerOnUpdatePlayer = Class_ReplaceMethod("Player", "OnUpdatePlayer",
		function(self, deltaTime)
			for i = #kPredictTable, 1, -1 do
				if kPredictTable[i] then
					kPredictTable[i].t = math.max(kPredictTable[i].t - deltaTime, 0)
					if kPredictTable[i].t == 0 then
						local ent = Shared.GetEntity(kPredictTable[i].i)
						if ent and table.contains(kPredictUpdateClasses, ent:GetClassName()) then
							ent:OnUpdate(deltaTime)
							if kPredictFullUpdateClasses[ent:GetClassName()] and kPredictFullUpdateClasses[ent:GetClassName()](ent) then
								kPredictTable[i].t = kPredictFullUpdateRate
							else
								kPredictTable[i].t = kPredictUpdateRate
							end
						else
							kPredictTable[i] = nil
						end
					end
				end
			end
		end
	)
	
end