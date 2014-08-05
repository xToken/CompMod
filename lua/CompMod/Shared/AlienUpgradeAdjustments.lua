//Dont want to always replace random files, so this.

local HasUpgrade = GetUpValue( GetHasCelerityUpgrade,  "HasUpgrade")

function GetHasCamouflageUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Camouflage)
end

function GetHasSilenceUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Silence)
end