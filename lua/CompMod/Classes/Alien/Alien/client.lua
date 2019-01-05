-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Alien\client.lua
-- - Dragon

AddClientUIScriptForClass("Alien", "CompMod/GUI/GUIAlienSensorBlips/GUIAlienSensorBlips")
AddClientUIScriptForClass("AlienCommander", "CompMod/GUI/GUIAlienSensorBlips/GUIAlienSensorBlips")

local kSensorBlipSize = 25

function AlienUI_GetSensorBlipInfo()

    PROFILE("AlienUI_GetSensorBlipInfo")
    
    local player = Client.GetLocalPlayer()
    local blips = {}

    if player then
        local hasAura = GetHasAuraUpgrade(player)
        local range = player:GetVeilLevel() * 10
        local eyePos = player:GetEyePos()

        for _, blip in ientitylist(Shared.GetEntitiesWithClassname("AlienSensorBlip")) do

            local blipOrigin = blip:GetOrigin()
            local blipEntId = blip.entId
            local blipName = ""
            
            -- Lookup more recent position of blip
            local blipEntity = Shared.GetEntity(blipEntId)
            
            -- Do not display a blip for the local player.
            if blipEntity ~= player then
                local checkRange = false

                if blipEntity then
                
                    if blipEntity:isa("Player") then
                        blipName = Scoreboard_GetPlayerData(blipEntity:GetClientIndex(), kScoreboardDataIndexName)
                    elseif blipEntity.GetTechId then
                        blipName = GetDisplayNameForTechId(blipEntity:GetTechId())
                    end
                    
                end
                
                if not blipName then
                    blipName = ""
                end

                if hasAura then
                    if not GetWallBetween(eyePos, blipOrigin, blipEntity) then
                        checkRange = true
                    end
                end
                
                -- Get direction to blip. If off-screen, don't render. Bad values are generated if
                -- Client.WorldToScreen is called on a point behind the camera.
                local normToEntityVec = GetNormalizedVector(blipOrigin - eyePos)
                local normViewVec = player:GetViewAngles():GetCoords().zAxis
               
                local dotProduct = normToEntityVec:DotProduct(normViewVec)
                if dotProduct > 0 then
                
                    -- Get distance to blip and determine radius
                    local distance = (eyePos - blipOrigin):GetLength()
                    local drawRadius = kSensorBlipSize/distance
                    
                    -- Compute screen xy to draw blip
                    local screenPos = Client.WorldToScreen(blipOrigin)

                    --[[
                    local trace = Shared.TraceRay(eyePos, blipOrigin, CollisionRep.LOS, PhysicsMask.Bullets, EntityFilterTwo(player, entity))                               
                    local obstructed = ((trace.fraction ~= 1) and ((trace.entity == nil) or trace.entity:isa("Door"))) 
                    
                    if not obstructed and entity and not entity:GetIsVisible() then
                        obstructed = true
                    end
                    --]]

                    if not checkRange or distance > range then
                    
                        -- Add to array (update numElementsPerBlip in GUISensorBlips:UpdateBlipList)
                        table.insert(blips, screenPos.x)
                        table.insert(blips, screenPos.y)
                        table.insert(blips, drawRadius)
                        table.insert(blips, true)
                        table.insert(blips, blipName)

                    end

                end
                
            end
            
        end
    
    end
    
    return blips
    
end