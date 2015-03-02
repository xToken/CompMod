//Dont want to always replace random files, so this.

local function ApplyCystGhostModelChanges()

	local CreateLine = GetUpValue( CystGhostModel.Update, "CreateLine", { LocateRecurse = true } )
	local UpdateLine = GetUpValue( CystGhostModel.Update, "UpdateLine", { LocateRecurse = true } )
	local UpdateCystModels = GetUpValue( CystGhostModel.Update, "UpdateCystModels", { LocateRecurse = true } )
	local kHalfFrameSize = GetUpValue( CystGhostModel.Update, "kHalfFrameSize" )

	local function UpdateConnectionLines(self, cystPoints, connected)

		local numCurrentLines = #self.lines
		local numNewLines = math.max(0, #cystPoints - 1)
		
		if numCurrentLines < numNewLines then
		
			for i = 1, numNewLines - numCurrentLines do
				table.insert(self.lines, CreateLine())
			end
		
		elseif numCurrentLines > numNewLines then
		
			for i = 1, numCurrentLines - numNewLines do
				
				local lastIndex = #self.lines
				GUI.DestroyItem(self.lines[lastIndex])
				table.remove(self.lines, lastIndex)
				
			end
		
		end
		
		for i = 1, numNewLines do
		
			local startPoint = GetClampedScreenPosition(cystPoints[i], -300)
			local endPoint = GetClampedScreenPosition(cystPoints[i + 1], -300)
		
			UpdateLine(startPoint, endPoint, self.lines[i], connected)
			
		end

	end

	local function CreateBuildTimeStuff(self)
		local kTextName = Fonts.kAgencyFB_Small
		local kTextScale = GUIScale(Vector(1,1,1))
		local kResIconSize = GUIScale(Vector(40, 40, 0))
		
		local bIcon = GUI.CreateItem()
		bIcon:SetTexture("ui/buildmenu.dds")
		bIcon:SetAnchor(GUIItem.Right, GUIItem.Top)
		bIcon:SetPosition(Vector(0, 40, 0))
		bIcon:SetSize(kResIconSize)
		bIcon:SetColor(kIconColors[kAlienTeamType])  
		bIcon:SetTexturePixelCoordinates(unpack(GetTextureCoordinatesForIcon(kTechId.DestroyHallucination)))
		
		local bText = GUI.CreateItem()
		bText:SetOptionFlag(GUIItem.ManageRender)
		bText:SetAnchor(GUIItem.Right, GUIItem.Top)
		bText:SetPosition(Vector(0, 60, 0))
		bText:SetTextAlignmentX(GUIItem.Align_Max)
		bText:SetTextAlignmentY(GUIItem.Align_Center)
		bText:SetFontName(kTextName)
		bText:SetScale(kTextScale)
		
		self.costDisplay.Frame:AddChild(bText)
		self.costDisplay.Frame:AddChild(bIcon)
		
		return bText, bIcon
	end

	function CystGhostModel:Update()

		local modelCoords = GhostModel.Update(self)
		
		local cystPoints = {}
		local parent = nil
		local normals = {}
		
		if modelCoords then        
			
			local player = Client.GetLocalPlayer()
			
			player:DestroyGhostGuides(true)
			
			cystPoints, parent, normals = GetCystPoints(modelCoords.origin)
			
			// use the last cyst point for the main ghost model
			if #cystPoints > 1 then
				self.renderModel:SetCoords(Coords.GetTranslation(cystPoints[#cystPoints]))
			end
			
			if self.costDisplay then
			
				local cost = (#cystPoints - 1) * kCystCost
			
				self.costDisplay.Frame:SetPosition( Client.WorldToScreen(modelCoords.origin) - kHalfFrameSize )
				self.costDisplay.Text:SetText(ToString(math.max(0, cost)))
				
				self.costDisplay.Frame:SetIsVisible(cost > 0 and self.isVisible)

			end
			
			local redeployCysts = GetEntitiesWithinRange("Cyst", modelCoords.origin, kCystRedeployRange)
			MarkPotentialDeployedCysts(redeployCysts, modelCoords.origin)
			
		end
		
		local connected = parent ~= nil and (not parent:isa("Cyst") or parent:GetIsConnected())
		
		UpdateConnectionLines(self, cystPoints, connected)
		UpdateCystModels(self, cystPoints)
		
	end

end

local oldLoadGhostModel = LoadGhostModel
function LoadGhostModel(className)
	oldLoadGhostModel(className)
	if className == "CystGhostModel" then
		ApplyCystGhostModelChanges()
	end
end
