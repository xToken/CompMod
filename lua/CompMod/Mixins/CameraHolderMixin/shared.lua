-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\CameraHolderMixin\shared.lua
-- - Dragon

function CameraHolderMixin:OnProcessMove(input)

    if Client and self.clientResetMouse ~= self.resetMouse then
        self.clientResetMouse = self.resetMouse
        Client.SetYaw(self.viewYaw)
        Client.SetPitch(self.viewPitch)
        Print(ToString("Mouse Reset!"))
    end
    
    self:UpdateCamera(input.time)
    
end

local oldCameraHolderMixin__initmixin = CameraHolderMixin.__initmixin
function CameraHolderMixin:__initmixin()
    
    oldCameraHolderMixin__initmixin(self)

    if Server then
    	self.resetMouse = 0
    end

end