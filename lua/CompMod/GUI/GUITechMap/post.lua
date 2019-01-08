-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUITechMap\post.lua
-- - Dragon

local UpdateItemsGUIScale = GetUpValue( GUITechMap.Initialize, "UpdateItemsGUIScale" )
local kTechMaps = GetUpValue( GUITechMap.Initialize, "kTechMaps" )
local kStartOffset = GetUpValue( GUITechMap.Initialize, "kStartOffset" )
local CreateTechIcon = GetUpValue( GUITechMap.Initialize, "CreateTechIcon" )
local kLines = GetUpValue( GUITechMap.Initialize, "kLines" )
local kLineTexture = "ui/mapconnector_line.dds"
--local CreateLine = GetUpValue( GUITechMap.Initialize, "CreateLine" )
local kLineColors =
{
    [kMarineTeamType] = Color(0, 0.8, 1, 0.5),
    [kAlienTeamType] = Color(1, 0.4, 0, 0.5),
}

local kIconSize
local kHalfIconSize
local kBackgroundSize
local kProgressMeterSize

local function NewUpdateItemsGUIScale(self, teamType)
    kIconSize = GUIScale(teamType == kMarineTeamType and kMarineTechMapIconSize or kAlienTechMapIconSize)
    kHalfIconSize = kIconSize * 0.5
    local size = teamType == kMarineTeamType and kMarineTechMapSize or kAlienTechMapSize
    kBackgroundSize = Vector(size * kIconSize.x, size * kIconSize.y * .75, 0)
    kProgressMeterSize = Vector(kIconSize.x, GUIScale(10), 0)
	
	ReplaceUpValue(UpdateItemsGUIScale, "kIconSize", kIconSize)
	ReplaceUpValue(UpdateItemsGUIScale, "kHalfIconSize", kHalfIconSize)
	ReplaceUpValue(UpdateItemsGUIScale, "kBackgroundSize", kBackgroundSize)
	ReplaceUpValue(UpdateItemsGUIScale, "kProgressMeterSize", kProgressMeterSize)
end

local function CreateLine(self, startPoint, endPoint, teamType)

    local lineStartPoint = Vector(startPoint.x * kIconSize.x, startPoint.y * kIconSize.y, 0) + kHalfIconSize
    local lineEndPoint = Vector(endPoint.x * kIconSize.x, endPoint.y * kIconSize.y, 0) + kHalfIconSize
    
    local delta = lineStartPoint - lineEndPoint
    local direction = GetNormalizedVector(delta)
    local length = math.sqrt(delta.x ^ 2 + delta.y ^ 2)
    local rotation = math.atan2(direction.x, direction.y)
    
    if rotation < 0 then
        rotation = rotation + math.pi * 2
    end

    rotation = rotation + math.pi * 0.5
    local rotationVec = Vector(0, 0, rotation)
    
    local line = GUI.CreateItem()
    line:SetSize(Vector(length, GUIScale(10), 0))
    line:SetPosition(lineStartPoint)
    line:SetRotationOffset(Vector(-length, 0, 0))
    line:SetRotation(rotationVec)
	line:SetTexture(kLineTexture)
	line:SetTexturePixelCoordinates(0, 16, length, 32)
    line:SetColor(kLineColors[teamType])
    line:SetLayer(0)
    
    self.background:AddChild(line)
    
    return line

end

local originalGUITechMapInitialize
originalGUITechMapInitialize = Class_ReplaceMethod("GUITechMap", "Initialize",
	function(self, teamNumber)
	
		GUIScript.Initialize(self)

		self.teamType = PlayerUI_GetTeamType()

		-- Support NSL MOD
		if teamNumber then
			self.teamType = teamNumber == 1 and kMarineTeamType or kAlienTeamType
		end

		NewUpdateItemsGUIScale(self, self.teamType)
		
		self.showtechMap = false
		self.techMapButton = false

		self.techIcons = {}
		self.lines = {}
		
		self.background = GetGUIManager():CreateGraphicItem()
		self.background:SetSize(kBackgroundSize)
		self.background:SetPosition(-kBackgroundSize * 0.5)
		self.background:SetAnchor(GUIItem.Middle, GUIItem.Center)
		self.background:SetIsVisible(false)
		self.background:SetColor(Color(0.0,0.0,0.0,0.4))
		self.background:SetLayer(kGUILayerScoreboard)
		
		local techMap = kTechMaps[self.teamType]
		local offset = kStartOffset[self.teamType]
		local iconSize = teamType == kMarineTeamType and kMarineTechMapIconSize or kAlienTechMapIconSize
		
		for i = 1, #techMap do
		
			local row = techMap[i]
			
			for j = 1, #row do
			
				local entry = row[j]
				
				if entry[1] and entry[1] ~= kTechId.None then

					local position = Vector(j, i + offset, 0)
					table.insert(self.techIcons, CreateTechIcon(self, entry[1], position, self.teamType, entry[2], entry[3]))
					if self.techIcons[#self.techIcons].Text then
						self.techIcons[#self.techIcons].Text:SetAnchor(GUIItem.Right, GUIItem.Bottom)
						self.techIcons[#self.techIcons].Text:SetPosition(Vector(GUIScale(-3), GUIScale(-10), 0))
						self.techIcons[#self.techIcons].Text:SetFontSize(GUIScale(iconSize.x/6))
					end
				end
			end
		end
		
		local lines = kLines[self.teamType]
		
		for i = 1, #lines do
		
			local line = lines[i]
			local startPoint = Vector(line[1], line[2] + offset, 0)
			local endPoint = Vector(line[3], line[4] + offset, 0)
			table.insert(self.lines, CreateLine(self, startPoint, endPoint, self.teamType))
		
		end
		
		self.visible = not HelpScreen_GetHelpScreen():GetIsBeingDisplayed()
		self:Update(0)
		
	end
)