-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Client\TechTreeButtons.lua
-- - Dragon

-- The Tech ICONS MAN
local kTechIdToMaterialOffset = GetUpValue( GetMaterialXYOffset, "kTechIdToMaterialOffset" )
for k, v in pairs(ReturnNewTechButtons()) do
	kTechIdToMaterialOffset[k] = v
end

-- Dunno if this is needed, but IMO its best to be sure.
ReplaceLocals(GetMaterialXYOffset, { kTechIdToMaterialOffset = kTechIdToMaterialOffset })