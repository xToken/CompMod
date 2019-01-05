-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUILeftRailgunAmmoDisplay\view.lua
-- - Dragon

ammoCountleft = 0
ammoTimeleft = 0

function Update(dt)
    UpdateAmmoDisplay(dt, ammoCountleft, ammoTimeleft)
end

Script.Load("lua/CompMod/GUI/GUIRailgunAmmo/view.lua")