-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIEvent\post.lua
-- - Dragon

local GetUnlockIconParams = GetUpValue(GUIEvent.UpdateUnlockDisplay, "GetUnlockIconParams")

local function NewGetUnlockIconParams(techId)
    local desc, bottom = GetUnlockIconParams(techId)
    if desc then
        return desc, bottom
    end
    desc = LookupTechData(techId, kTechDataDescription)
    bottom = LookupTechData(techId, kTechDataUnlockAction)
    if desc then
        return Locale.ResolveString(desc), bottom and Locale.ResolveString(bottom) or nil
    end
    return nil, nil
end

ReplaceUpValue(GUIEvent.UpdateUnlockDisplay, "GetUnlockIconParams", NewGetUnlockIconParams)