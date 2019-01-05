-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIRightRailgunAmmoDisplay\view.lua
-- - Dragon

ammoCountright = 0
ammoTimeright = 0

function Update(dt)
    UpdateAmmoDisplay(dt, ammoCountright, ammoTimeright)
end

Script.Load("lua/CompMod/GUI/GUIRailgunAmmo/view.lua")