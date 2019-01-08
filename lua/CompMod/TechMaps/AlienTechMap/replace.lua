-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\TechMaps\AlienTechMap\replace.lua
-- - Dragon

local function CheckHasTech(techId)

    local techTree = GetTechTree()
    return techTree ~= nil and techTree:GetHasTech(techId)

end

local function SetShellIcon(icon)

    if CheckHasTech(kTechId.ThreeShells) then
        icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.ThreeShells)))
    elseif CheckHasTech(kTechId.TwoShells) then
        icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.TwoShells)))
    else
        icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.Shell)))
    end    

end

local function SetVeilIcon(icon)

    if CheckHasTech(kTechId.ThreeVeils) then
        icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.ThreeVeils)))
    elseif CheckHasTech(kTechId.TwoVeils) then
        icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.TwoVeils)))
    else
        icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.Veil)))
    end
    
end

local function SetSpurIcon(icon)    

    if CheckHasTech(kTechId.ThreeSpurs) then
        icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.ThreeSpurs)))
    elseif CheckHasTech(kTechId.TwoSpurs) then
        icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.TwoSpurs)))
    else
        icon:SetTexturePixelCoordinates(GUIUnpackCoords(GetTextureCoordinatesForIcon(kTechId.Spur)))
    end 

end

kAlienTechMapYStart = 0
kAlienTechMapIconSize = Vector(70, 70, 0)
kAlienTechMapSize = 16

kAlienTechMap =
{
        { {kTechId.Whip}, {kTechId.WhipBombard}, {}, {kTechId.Shift}, {kTechId.ShiftEnergize}, {}, {kTechId.Shade}, {kTechId.ShadeInk}, {}, {kTechId.Crag}, {kTechId.HealWave}, {}, {kTechId.Harvester} },
        { {kTechId.Veil, SetVeilIcon}, {}, {kTechId.OffensiveTraits, nil, "Offense Traits" }, {}, {}, {}, {kTechId.DefensiveTraits, nil, "Defense Traits" }, {}, {kTechId.Shell, SetShellIcon} },
        { {kTechId.Crush}, {}, {kTechId.Aura}, {}, {}, {}, {}, {}, {kTechId.Carapace}, {}, {kTechId.Regeneration} },
        { {kTechId.Spur, SetSpurIcon}, {}, {kTechId.MovementTraits, nil, "Movement Traits" }, {}, {}, {}, {kTechId.AdditionalTraitSlot1, nil, "2nd Trait Slot"}, {}, {kTechId.AdditionalTraitSlot2, nil, "3rd Trait Slot"}, {}, {}, {} },
        { {kTechId.Celerity}, {}, {kTechId.Adrenaline}, {}, {}, {}, {}, {kTechId.NutrientMist, nil, "Nutrient Mist" }, {}, {}, {}, {kTechId.StructureMenu, nil, "Build Structures"}, {kTechId.EnzymeCloud}, {kTechId.ParasiteCloud, nil, "Parasite Cloud" } },
        { {}, {}, {}, {}, {}, {}, {kTechId.Hive}, {}, {}, {}, {}, {}, {kTechId.Drifter} },
        { {}, {kTechId.GorgeTunnelTech}, {}, {kTechId.BileBomb}, {}, {kTechId.HealingRoost}, {}, {kTechId.MetabolizeEnergy}, {}, { kTechId.Charge}, {}, {kTechId.AdvancedStructureMenu, nil, "Build Adv Structures"}, {kTechId.Hallucinate}, {kTechId.TeleportStructure, nil, "Echo" } },
        { {}, {}, {}, {}, {}, {}, {kTechId.TwoHives, nil, "Two Hives" }, {}, {}, {}, {}, {} },
        { {}, {}, {}, {kTechId.Leap}, {}, {kTechId.Umbra}, {}, {kTechId.MetabolizeHealth}, {}, {kTechId.BoneShield} },
        { {}, {}, {}, {}, {}, {}, {kTechId.ThreeHives, nil, "Three Hives" } },
        { {}, {}, {}, {kTechId.Xenocide}, {}, {kTechId.Spores}, {}, {kTechId.Stab}, {}, {kTechId.Stomp} }
}

kAlienLines = 
{
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Whip, kTechId.WhipBombard),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Shift, kTechId.ShiftEnergize),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Shade, kTechId.ShadeInk),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Crag, kTechId.HealWave),

    GetLinePositionForTechMap(kAlienTechMap, kTechId.Drifter, kTechId.TeleportStructure),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Drifter, kTechId.EnzymeCloud),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Drifter, kTechId.ParasiteCloud),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Drifter, kTechId.Hallucinate),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Drifter, kTechId.StructureMenu),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Drifter, kTechId.AdvancedStructureMenu),

    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.NutrientMist),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Drifter),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.DefensiveTraits),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.OffensiveTraits),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.MovementTraits),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.AdditionalTraitSlot1),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.AdditionalTraitSlot1, kTechId.AdditionalTraitSlot2),

    GetLinePositionForTechMap(kAlienTechMap, kTechId.DefensiveTraits, kTechId.Shell),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.OffensiveTraits, kTechId.Veil),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.MovementTraits, kTechId.Spur),
    
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Shell, kTechId.Carapace),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Shell, kTechId.Regeneration),
    
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Veil, kTechId.Crush),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Veil, kTechId.Aura),
    
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Spur, kTechId.Celerity),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Spur, kTechId.Adrenaline),

    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.GorgeTunnelTech),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.BileBomb),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.HealingRoost),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.MetabolizeEnergy),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Charge),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.TwoHives),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.TwoHives, kTechId.Leap),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.TwoHives, kTechId.Umbra),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.TwoHives, kTechId.MetabolizeHealth),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.TwoHives, kTechId.BoneShield),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.TwoHives, kTechId.ThreeHives),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.ThreeHives, kTechId.Xenocide),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.ThreeHives, kTechId.Spores),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.ThreeHives, kTechId.Stab),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.ThreeHives, kTechId.Stomp),
}