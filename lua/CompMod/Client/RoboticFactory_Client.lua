-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Client\RoboticsFactory_Client.lua
-- - Dragon

function RoboticsFactory:OnUse(player, elapsedTime, useSuccessTable)

    if GetIsUnitActive(self) and not Shared.GetIsRunningPrediction() and not player.buyMenu then

        if Client.GetLocalPlayer() == player then
		
            Client.SetCursor("ui/Cursor_MarineCommanderDefault.dds", 0, 0)
            
            -- Play looping "active" sound while logged in
            -- Shared.PlayPrivateSound(player, Armory.kResupplySound, player, 1.0, Vector(0, 0, 0))
            
            -- Tell the player to show the lua menu.
            player:BuyMenu(self)
            
        end
        
    end
    
end