//Dont want to always replace random files, so this.

local function TriggerBlinkOutEffects(self, player)
	player:TriggerEffects("blink_out", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})
	if Client and player:GetIsLocalPlayer() and not Shared.GetIsRunningPrediction() then
		player:TriggerEffects("blink_out_local", { effecthostcoords = Coords.GetTranslation(player:GetOrigin()) })
	end
end

local function TriggerBlinkInEffects(self, player)
    player:TriggerEffects("blink_in", { effecthostcoords = Coords.GetTranslation(player:GetOrigin()) })
end

ReplaceLocals(Blink.SetEthereal, { TriggerBlinkOutEffects = TriggerBlinkOutEffects })
ReplaceLocals(Blink.SetEthereal, { TriggerBlinkInEffects = TriggerBlinkInEffects })