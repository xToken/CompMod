-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\TechMaps\MarineTechMap\replace.lua
-- - Dragon

-- Utility Func
function GetLinePositionForTechMap(techMap, fromTechId, toTechId)

    local positions = { 0, 0, 0, 0 }
    local foundFrom = false
    local foundTo = false

    for i = 1, #techMap do
		local row = techMap[i]
		for j = 1, #row do
			local entry = row[j]
			if entry[1] == fromTechId then

				positions[1] = j
				positions[2] = i
				foundFrom = true

			elseif entry[1] == toTechId then

				positions[3] = j
				positions[4] = i
				foundTo = true

			end

			if foundFrom and foundTo then
				break
			end
		end
    end

    return positions

end

kMarineTechMapYStart = -1
kMarineTechMapIconSize = Vector(50, 50, 0)
kMarineTechMapSize = 20
kMarineTechMap =
{
        { {kTechId.CommandStation}, {}, {}, {}, {kTechId.Extractor}, {}, {}, {}, {kTechId.InfantryPortal} },
		{ {}, {kTechId.Observatory} },
		{ {}, {}, {kTechId.Scan}, {}, {}, {}, {kTechId.DistressBeacon}, {}, {}, {}, {kTechId.PhaseTech}, {}, {}, {}, {kTechId.PhaseGate} },
		{ {}, {}, {kTechId.Armory}, {}, {kTechId.Welder}, {}, {kTechId.Flamethrower}, {}, {kTechId.Shotgun}, {}, {kTechId.HeavyMachineGun}, {}, {kTechId.GrenadeLauncher}, {}, {kTechId.LayMines}, {}, {kTechId.ClusterGrenade} },
		{ {}, {}, {}, {kTechId.FlamethrowerUpgrade1, nil, "FT Upgrade"}, {}, {}, {kTechId.GrenadeTech, nil, "Grenades Research"}, {}, {}, {kTechId.MinesTech, nil, "Mines Research"} },
		{ {}, {}, {kTechId.AdvancedArmory} },
		{ {}, {}, {}, {kTechId.ShotgunUpgrade1, nil, "SG Upgrade 1"}, {}, {}, {kTechId.MGUpgrade1, nil, "MG Upgrade 1"}, {}, {}, {kTechId.GLUpgrade1, nil, "GL Upgrade 1"}, {}, {} }, --, {kTechId.MinigunUpgrade1, nil, "Minigun UPG 1"}, {}, {}, {kTechId.RailgunUpgrade1, nil, "Railgun UPG 1"} },
		{ {}, {}, {}, {kTechId.ShotgunUpgrade2, nil, "SG Upgrade 2"}, {}, {}, {kTechId.MGUpgrade2, nil, "MG Upgrade 2"}, {}, {} }, --, {kTechId.MinigunUpgrade2, nil, "Minigun UPG 2"} },
		{ {}, {}, {kTechId.PrototypeLab} },
		{ {}, {}, {}, {kTechId.JetpackTech}, {}, {}, {kTechId.NanoArmor}, {}, {}, {kTechId.ExoUpgrade1, nil, "Exo Upgrade 1"}, {}, {} }, --, {kTechId.ExoUpgrade2, nil, "EXO Upgrade 2"} },
		{ {}, { kTechId.ArmsLab}, {}, {}, {}, {kTechId.Weapons1}, {}, {}, {}, {kTechId.Weapons2}, {}, {}, {}, { kTechId.Weapons3} },
        { {}, {}, {},{kTechId.Armor1}, {}, {}, {}, {kTechId.Armor2}, {}, {}, {}, {kTechId.Armor3} },		
        { {}, {kTechId.RoboticsFactory}, {}, {}, {}, {kTechId.MAC}, {}, {}, {}, {kTechId.DualMinigunExosuit, nil, "Dual Minigun Exosuit"}, {}, {}, {}, {kTechId.DualRailgunExosuit, nil, "Dual Railgun Exosuit"} },
		{ {}, {}, {kTechId.ARCRoboticsFactory}, {}, {}, {}, {kTechId.ARC}, {}, {}, {}, {kTechId.ARCUpgrade1, nil, "ARC Upgrade 1"}, {}, {}, {}, {kTechId.ARCUpgrade2, nil, "ARC Upgrade 2"} },
		{ {}, {}, {kTechId.SentryBattery}, {}, {}, {}, {kTechId.Sentry}, {}, {}, {}, {} }
}

kMarineLines = 
{
    GetLinePositionForTechMap(kMarineTechMap, kTechId.CommandStation, kTechId.Extractor),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.CommandStation, kTechId.InfantryPortal),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.CommandStation, kTechId.Armory),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.CommandStation, kTechId.ArmsLab),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.CommandStation, kTechId.RoboticsFactory),

    GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.Welder),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.Flamethrower),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.Shotgun),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.HeavyMachineGun),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.FlamethrowerUpgrade1),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.GrenadeTech),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.MinesTech),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.LayMines),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.ClusterGrenade),
	
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.FlamethrowerUpgrade1),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.GrenadeTech),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.MinesTech),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Armory, kTechId.AdvancedArmory),
    
	GetLinePositionForTechMap(kMarineTechMap, kTechId.AdvancedArmory, kTechId.ShotgunUpgrade1),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.AdvancedArmory, kTechId.MGUpgrade1),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.AdvancedArmory, kTechId.GLUpgrade1),
	--GetLinePositionForTechMap(kMarineTechMap, kTechId.AdvancedArmory, kTechId.MinigunUpgrade1),
	--GetLinePositionForTechMap(kMarineTechMap, kTechId.AdvancedArmory, kTechId.RailgunUpgrade1),
	
	GetLinePositionForTechMap(kMarineTechMap, kTechId.ShotgunUpgrade1, kTechId.ShotgunUpgrade2),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.MGUpgrade1, kTechId.MGUpgrade2),
	--GetLinePositionForTechMap(kMarineTechMap, kTechId.MinigunUpgrade1, kTechId.MinigunUpgrade2),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.PrototypeLab, kTechId.ShotgunUpgrade2),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.PrototypeLab, kTechId.MGUpgrade2),
	--GetLinePositionForTechMap(kMarineTechMap, kTechId.PrototypeLab, kTechId.MinigunUpgrade2),
	
    GetLinePositionForTechMap(kMarineTechMap, kTechId.AdvancedArmory, kTechId.PrototypeLab),
    
    GetLinePositionForTechMap(kMarineTechMap, kTechId.PrototypeLab, kTechId.JetpackTech),
    --GetLinePositionForTechMap(kMarineTechMap, kTechId.PrototypeLab, kTechId.CatPackTech),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.PrototypeLab, kTechId.NanoArmor),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.PrototypeLab, kTechId.ExoUpgrade1),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.PrototypeLab, kTechId.ExoUpgrade2),
	--GetLinePositionForTechMap(kMarineTechMap, kTechId.ExoUpgrade1, kTechId.ExoUpgrade2),
	
    GetLinePositionForTechMap(kMarineTechMap, kTechId.Observatory, kTechId.Scan),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Observatory, kTechId.DistressBeacon),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.Observatory, kTechId.PhaseTech),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.PhaseTech, kTechId.PhaseGate),
    
    GetLinePositionForTechMap(kMarineTechMap, kTechId.ArmsLab, kTechId.Weapons1),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.Weapons1, kTechId.Weapons2),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.Weapons2, kTechId.Weapons3),
    
    GetLinePositionForTechMap(kMarineTechMap, kTechId.ArmsLab, kTechId.Armor1),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.Armor1, kTechId.Armor2),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.Armor2, kTechId.Armor3),
    
    GetLinePositionForTechMap(kMarineTechMap, kTechId.RoboticsFactory, kTechId.ARCRoboticsFactory),	
    GetLinePositionForTechMap(kMarineTechMap, kTechId.ARCRoboticsFactory, kTechId.ARC),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.ARCRoboticsFactory, kTechId.ARCUpgrade1),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.ARCRoboticsFactory, kTechId.ARCUpgrade2),
	GetLinePositionForTechMap(kMarineTechMap, kTechId.ARCUpgrade1, kTechId.ARCUpgrade2),

    GetLinePositionForTechMap(kMarineTechMap, kTechId.RoboticsFactory, kTechId.MAC),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.RoboticsFactory, kTechId.SentryBattery),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.RoboticsFactory, kTechId.DualMinigunExosuit),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.RoboticsFactory, kTechId.DualRailgunExosuit),
    GetLinePositionForTechMap(kMarineTechMap, kTechId.SentryBattery, kTechId.Sentry),
	--GetLinePositionForTechMap(kMarineTechMap, kTechId.RoboticsFactory, kTechId.SentryUpgrade1),
    
}