// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Post\ConstructMixin.lua
// - Dragon

//Interpolation on this field does not work anyways, measured client side ingame.
//Most likely would need to be networked at full precision for it to be accurate.
//also, deltaTime passed from timedcallbacks IS NOT 100% accurate.  Tends to underestimate actual time elapsed, by a small margin
ConstructMixin.networkVars.buildFraction = "float (0 to 1 by 0.01)"