-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\PowerConsumerMixin\shared.lua
-- - Dragon

-- Actually set these values since locals
function PowerConsumerMixin:OnUpdateAnimationInput(modelMixin)

    PROFILE("PowerConsumerMixin:OnUpdateAnimationInput")
    
    modelMixin:SetAnimationInput("powered", true)
    
end

if Server then
	PowerConsumerMixin.OnUpdate = nil
end

PowerConsumerMixin.OnUpdateRender = nil