-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Balance\post.lua
-- - Dragon

-- Balance.lua loads the other balance files - so just load everything once here.
Script.Load("lua/CompMod/Utilities/Elixer/shared.lua")
AppendToEnum(kDamageType, 'QuadStructural')
AppendToEnum(kDamageType, 'HalfStructural')

Script.Load( "lua/CompMod/Balance/Balance_Globals.lua" )
Script.Load( "lua/CompMod/Balance/Balance_Health.lua" )
Script.Load( "lua/CompMod/Balance/Balance_Misc.lua" )
Script.Load( "lua/CompMod/Balance/Balance_Alien_Lifeforms.lua" )
Script.Load( "lua/CompMod/Balance/Balance_Alien_Structures.lua" )
Script.Load( "lua/CompMod/Balance/Balance_Alien_Tech.lua" )
Script.Load( "lua/CompMod/Balance/Balance_Marine_Structures.lua" )
Script.Load( "lua/CompMod/Balance/Balance_Marine_Tech.lua" )
Script.Load( "lua/CompMod/Balance/Balance_Marine_Weapons.lua" )
Script.Load( "lua/CompMod/Balance/Balance_Movement.lua" )