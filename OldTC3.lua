-- // LOAD UI LIB ARRAYFIELD \\ --
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/frickwtcb/arff/main/arrayfieldcustom'))()
-- // LOAD UI LIB ARRAYFIELD \\ --

-- // VARIABLES \\ --
local CoreGui = game.CoreGui
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Char = Player.Character
local PlayerUser = Player.Name
local PlayerTeamColor = Players[PlayerUser].TeamColor
-- // Workspace / Game \\ --
local WS = game:GetService("Workspace")
local TeamSettings = WS.TeamSettings
local Map = WS.Map
local TeamUnits = WS.Teams
-- // Info  \\ --
local TotalTeams = #TeamSettings:GetChildren()
local RayfieldContainer = nil
local ActiveResearchFolder = nil
local LandmineFolder = nil
local TeamList = {}
local Allies = {}
local Enemys = {}

if WS.RoundSettings:FindFirstChild("New_Lobby") then
	CurrentGameFolder = WS.RoundSettings.New_Lobby.CurrentGame

	Gamemode = CurrentGameFolder.Gamemode.Value
	MapName = CurrentGameFolder.MapName.Value
	SubGamemode = CurrentGameFolder.SubGamemode.Value
else
	CurrentGameFolder = "Unknown"

	Gamemode = "Unknown"
	MapName = "Unknown"
	SubGamemode = "Unknown"
end
-- // The Units you want the script to display in the "Units" Tab
local UnitBuildings = {"Nuclear Silo","Headquarters", "Research Center", "Command Center", "Fort", "Space Link", "Airport", "Barracks", "Naval Shipyard", "Tank Factory"}
local UnitUnits = {"Medic", "Construction Soldier", "Sniper", "Humvee", "Jeep", "Hovercraft", "Nuclear Missile", "Fire Missile", "Medi-Truck", "Submarine", "Aircraft Carrier", "Oil Ship", "Artillery", "Stealth Bomber", "Transport Plane", "Mothership"}
local GarrisonUnits = {"Transport Ship", "Transport Plane", "Mothership", "Bunker", "Fort", "Command Center", "Medi-Truck", "Headquarters", "Helicopter"}
-- // SETTINGS VARIABLES  \\ --
local ValueRefreshInt = 5

-- // Inserts each team to the team list table.  \\ --
function UpdateTeamList()
	TeamList = {}

	for i,v in pairs(TeamSettings:GetChildren()) do

		table.insert(TeamList,tostring(v))
	end
end

function UpdateTeamAllies()
	Allies = {}

	for i,v in pairs(TeamSettings[tostring(PlayerTeamColor)].Allies:GetChildren()) do

		table.insert(Allies,tostring(v))
	end
end

function UpdateEnemys()
	Enemys = {}

	for i,v in pairs(TeamList) do
		if table.find(Allies,tostring(v)) or tostring(v) == tostring(PlayerTeamColor) then

		else

			table.insert(Enemys,tostring(v))
		end
	end
end

UpdateTeamList()
UpdateTeamAllies()
UpdateEnemys()

-- // Find the ScreenGui that Rayfield UI is stored in  \\ --
for i,v in pairs(CoreGui:GetChildren()) do
	if v:FindFirstChild("Rayfield") or v:FindFirstChild("Old Arrayfield") or v.Name == "Rayfield" then
		RayfieldContainer = v
		print("Rayfield Parent Folder = "..v.Name)
	end
end

-- // Find value active research is stored in  \\ --
for i,v in pairs(TeamSettings[tostring(PlayerTeamColor)]:GetChildren()) do
	if v:FindFirstChild("Artillery") and v.Name ~= "UnitsResearched" and v.Name ~= "CustomModelSettings" then
		ActiveResearchFolder = v
		print("Active Research Folder = "..v.Name)
	end
end

print("Current Game Info : "..Gamemode.." ("..SubGamemode..") On Map : "..MapName)

--// Function to remove decimals from cash values //--
local function round(n)
	return math.floor(n + 0.5)
end

function percentround(n)
	local Ratio = n / 1
	Ratio = math.floor(Ratio * 100 + 0.5)
	return Ratio.."%"
end

--// Function to Color Text Labels Properly //--
local function toRichText(...)
	local args = {...}
	local texts = {}
	for i,v in next, args do
		local colors ={v[2].R, v[2].G, v[2].B}
		texts[i] = "<font color='rgb("..table.concat(colors, ', ')..")'>"..v[1].."</font>"
	end
	return table.concat(texts, '')
end

--// Converts Color3 Values to RGB and rounds them//--
function color3torgb(color3)
	return round(color3.R*255),round(color3.G*255),round(color3.B*255)
end

function CreateGarrisonLabel(String,Parent)
	local BillBoard = Instance.new("BillboardGui")
	BillBoard.StudsOffset = Vector3.new(0, 5, 0)
	BillBoard.Size = UDim2.new(0, 200,0, 50)
	local TextLabel = Instance.new("TextLabel")
	TextLabel.BackgroundTransparency = 1
	TextLabel.RichText = true
	TextLabel.TextScaled = true
	local TextRGB = BrickColor.new(tostring(Parent.Parent)).Color
	TextLabel.Font = Enum.Font.Code
	TextLabel.TextStrokeTransparency = 0
	TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	TextLabel.Text = toRichText({String, Color3.new(color3torgb(TextRGB))})
	TextLabel.Size = UDim2.new(0, 200,0, 50)
	TextLabel.Parent = BillBoard
	BillBoard.Parent = Parent
	BillBoard.Adornee = Parent
end

-- // Create Gui  \\ --
local Window = Rayfield:CreateWindow({
	Name = "零临时 | "..Gamemode.." ("..SubGamemode..") ".."🗺️ : "..MapName,
	LoadingTitle = "TC3 info panel | 零临时",
	LoadingSubtitle = "by temps",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "Big Hub"
	},
	Discord = {
		Enabled = true,
		Invite = "JQ3JJtG4j3", -- The Discord invite code, do not include discord.gg/
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
	},
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Sirius Hub",
		Subtitle = "Key System",
		Note = "Join the discord (discord.gg/sirius)",
		FileName = "SiriusKey",
		SaveKey = true,
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = "Hello"
	}
})

local RayElements = RayfieldContainer.Main.Elements



-- // Gui Tabs \\ --
local Cash = Window:CreateTab("Cash + CPM",14474505304)
local Research = Window:CreateTab("Research",14475585648) 
local ActiveResearch = Window:CreateTab("Active Research",13735241062) 
local PlayerInfo = Window:CreateTab("Player Info",11970046946) 
local Units = Window:CreateTab("Units",14476724652) 
local Econ = Window:CreateTab("Econ",13730648171)
local Misc = Window:CreateTab("Misc",11898743363)



function ResearchFunction(TeamName)
	for i,v in pairs(TeamName) do
		local TextRGB = BrickColor.new(tostring(v)).Color

		local UnitsResearched = TeamSettings[v].UnitsResearched:GetChildren()
		local ResearchedTable = {}
		for i2 = 1, #UnitsResearched do
			ResearchedTable[#ResearchedTable + 1] = tostring(UnitsResearched[i2])
		end

		if #UnitsResearched > 0 then
			local TextRGB = BrickColor.new(tostring(v)).Color
			local Label = Research:CreateParagraph({Title = toRichText({tostring(v), Color3.new(color3torgb(TextRGB))}).." Research", Content = "Has Researched "..table.concat(ResearchedTable, ", ")})
		else
			local TextRGB = BrickColor.new(tostring(v)).Color
			local Label = Research:CreateParagraph({Title = toRichText({tostring(v), Color3.new(color3torgb(TextRGB))}).." Research", Content = "Has Researched Nothing"})
		end

	end
end


-- // Cash CPM Tab \\ --

function RefreshCashView()
	--Remove Old Labels
	for i,v in pairs(RayElements["Cash + CPM"]:GetChildren()) do
		if v.Name == "Label" or v.Name == "SectionTitle" then
			v:Destroy()
		end
	end

	local Section = Cash:CreateSection("CASH + CPM INFORMATION PANEL",true)

	local Section = Cash:CreateSection("Enemy Values",true)
	-- Create New ones

	for i,v in pairs(Enemys) do
		local TextRGB = BrickColor.new(tostring(v)).Color
		local Label = Cash:CreateLabel((toRichText({tostring(v), Color3.new(color3torgb(TextRGB))}).." Cash : $"..round(TeamSettings[v].Cash.Value).." | CPM : "..TeamSettings[v].CashPerMinute.Value))
	end

	local AllyCash = Cash:CreateSection("Ally Values",false)

	for i,v in pairs(Allies) do
		local TextRGB = BrickColor.new(tostring(v)).Color
		local Label = Cash:CreateLabel((toRichText({tostring(v), Color3.new(color3torgb(TextRGB))}).." Cash : $"..round(TeamSettings[v].Cash.Value).." | CPM : "..TeamSettings[v].CashPerMinute.Value),AllyCash)
	end
end

-- // Finished Research Tab \\ --

function RefreshResearch()
	--Remove Old Labels
	for i,v in pairs(RayElements.Research:GetChildren()) do
		if v.Name == "Paragraph" or v.Name == "SectionTitle" then
			v:Destroy()
		end
	end

	local Section = Research:CreateSection("RESEARCH INFORMATION PANEL",true)

	local Section = Research:CreateSection("Enemy Research",true)

	ResearchFunction(Enemys)

	local AllyResearch = Research:CreateSection("Ally Research",true)

	ResearchFunction(Allies)


end

function RefreshActiveResearch()
	--Remove Old Labels
	for i,v in pairs(RayElements["Active Research"]:GetChildren()) do
		if v.Name == "Label" or v.Name == "SectionTitle" then
			v:Destroy()
		end
	end

	local Section = ActiveResearch:CreateSection("ACTIVE RESEARCH INFORMATION PANEL",true)

	local Section = ActiveResearch:CreateSection("Enemy Research",true)

	for i,v in pairs(Enemys) do
		local ActResearchFolder = TeamSettings[tostring(v)][tostring(ActiveResearchFolder)]

		for i2,v2 in pairs(ActResearchFolder:GetChildren()) do
			if v2.Progress.Value == 0 or v2.Progress.Value == 1 then

			else
				local TextRGB = BrickColor.new(tostring(v)).Color
				local Label = ActiveResearch:CreateLabel((toRichText({tostring(v), Color3.new(color3torgb(TextRGB))}).." "..v2.Name.." "..percentround(v2.Progress.Value).." Completed"))
			end
		end
	end

	local Section = ActiveResearch:CreateSection("Ally Research",true)

	for i,v in pairs(Allies) do
		local ActResearchFolder = TeamSettings[tostring(v)][tostring(ActiveResearchFolder)]

		for i2,v2 in pairs(ActResearchFolder:GetChildren()) do
			if v2.Progress.Value == 0 or v2.Progress.Value == 1 then

			else
				local TextRGB = BrickColor.new(tostring(v)).Color
				local Label = ActiveResearch:CreateLabel((toRichText({tostring(v), Color3.new(color3torgb(TextRGB))}).." "..v2.Name.." "..percentround(v2.Progress.Value).." Completed"))
			end
		end
	end


end

function RefreshPlayerInfo()

	--Remove Old Labels
	for i,v in pairs(RayElements["Player Info"]:GetChildren()) do
		if v.Name == "Label" or v.Name == "SectionTitle" then
			v:Destroy()
		end
	end


	for i,v in pairs(Players:GetChildren()) do
		local NumOfSkins = v.Stats:WaitForChild("skinsOwned"):GetChildren()
		local Team = v.TeamColor
		local FirstJoinTime = v.Stats.firstJoinTime.Value
		local ConvertTable = os.date("*t", FirstJoinTime)
		local TextRGB = BrickColor.new(tostring(Team)).Color
		local Level = v.Stats.levelsRewarded:GetChildren()

		local Label = PlayerInfo:CreateLabel(toRichText({tostring(v), Color3.new(color3torgb(TextRGB))}).." Level : "..#Level.." | Number of Skins : "..#NumOfSkins.." | First Join Date : "..ConvertTable.month.."/"..ConvertTable.day.."/"..ConvertTable.year)
	end
end

function RefreshUnits()
	--Remove Old Labels
	for i,v in pairs(RayElements["Units"]:GetChildren()) do
		if v:IsA("Frame") and v.Name ~= "Placeholder" then
			v:Destroy()
		end
	end

	local Section = Units:CreateSection("UNIT / BUILDING INFORMATION PANEL",true)
	local Section = Units:CreateSection("Units",true)
	local UnitList = WS.Teams[tostring(PlayerTeamColor)]

	for i,v in pairs(UnitList:GetChildren()) do
		if table.find(UnitUnits,tostring(v)) then
			local Button = Units:CreateButton({
				Name = v.Name.." <font color='#1aff00'>("..round(v.Torso.Health.Value).."/"..round(v.Torso.MaxHealth.Value)..")</font>",
				Interact = 'Teleport to',
				Callback = function()
					Char.HumanoidRootPart.CFrame = v.Torso.CFrame * CFrame.new(0, 5, 0)
				end,
			})
		end
	end
	local Section = Units:CreateSection("Buildings",true)

	for i,v in pairs(UnitList:GetChildren()) do
		if table.find(UnitBuildings,tostring(v)) then
			local Button = Units:CreateButton({
				Name = v.Name.." <font color='#1aff00'>("..round(v.Torso.Health.Value).."/"..round(v.Torso.MaxHealth.Value)..")</font>",
				Interact = 'Teleport to',
				Callback = function()
					Char.HumanoidRootPart.CFrame = v.Torso.CFrame * CFrame.new(0, 5, 0)
				end,
			})
		end
	end
end

function RefreshEcon()
	--Remove Old Labels
	for i,v in pairs(RayElements["Econ"]:GetChildren()) do
		if v:IsA("Frame") and v.Name ~= "Placeholder" then
			v:Destroy()
		end
	end

	local Section = Econ:CreateSection("CRYSTAL / OIL INFORMATION PANEL",true)
	local Section = Econ:CreateSection(" Crystals ",true)
	for i,v in pairs(Map.EnergyCrystals:GetChildren()) do
		local CryName = "Crystal "..v.Name

		if v.Torso.Using:FindFirstChild(tostring(PlayerTeamColor)) then
			CryName = "Crystal "..v.Name.."<font color='#1aff00'> (Owned)</font>"
		end

		if v.Torso:FindFirstChild("SuperCrystal") then 
			CryName = "<font color='#05f5ed'> Super Crystal "..v.Name.." </font>"
			if v.Torso.Using:FindFirstChild(tostring(PlayerTeamColor)) then
				CryName = "<font color='#05f5ed'> Super Crystal "..v.Name.." </font>"
			end
		end

		local Button = Econ:CreateButton({
			Name = CryName,
			Interact = 'Teleport to',
			Callback = function()
				Char.HumanoidRootPart.CFrame = v.Torso.CFrame * CFrame.new(0, 5, 0)
			end,
		})

	end
	local Section = Econ:CreateSection("Oil",true)
	for i,v in pairs(Map.OilSpots:GetChildren()) do
		local CryName = v.Name

		if v.Torso.Using:FindFirstChild(tostring(PlayerTeamColor)) then
			CryName = v.Name.."<font color='#1aff00'> (Owned)</font>"
		end

		local Button = Econ:CreateButton({
			Name = CryName,
			Interact = 'Teleport to',
			Callback = function()
				Char.HumanoidRootPart.CFrame = v.Torso.CFrame * CFrame.new(0, 5, 0)
			end,
		})
	end
end

local RemoveFog = Misc:CreateButton({
	Name = "Remove Fog",
	Info = "Removes fog on snowy maps", -- Speaks for itself, Remove if none.
	Interact = 'Remove',
	Callback = function()
		game:GetService("Lighting").FogStart = 1000
		game:GetService("Lighting").FogEnd = 1000
	end,
})

local Button = Misc:CreateButton({
	Name = "Reveal Landmines",
	Info = "Shows Enemy Landminds (Only Push once)", -- Speaks for itself, Remove if none.
	Interact = 'Reveal',
	Callback = function()
		LandmineFolder = nil
		while true do
			--find landmind folder
			for i,v in pairs(game.Workspace:GetChildren()) do
				if v:IsA("Folder") then
					mine = v:FindFirstChild("Landmine")
					watermine = v:FindFirstChild("Watermine")

					if mine then
						print("found"..v.Name)
						LandmineFolder = v
					elseif watermine then
						print("found"..v.Name)
						LandmineFolder = v
					end
				end
			end


			if LandmineFolder == nil then
				print("No mines yet")
			else
				for i,v in pairs(LandmineFolder:GetChildren()) do
					v.Base.Transparency = 0
					v.Base.Material = Enum.Material.Neon
					if v.Name == "Watermine" then
						v.Torso.Transparency = 0
						v.Torso.Material = Enum.Material.Neon
					end
				end
			end
			wait(10)
		end
	end,
})

local TPLobby = Misc:CreateButton({
	Name = "Teleport Back to Lobby",
	Info = "get outa here", -- Speaks for itself, Remove if none.
	Interact = 'Teleport',
	Callback = function()
		local tps = game:GetService("TeleportService")
		local placeid = 8377997
		local Player = game.Players.LocalPlayer
		tps:Teleport(placeid,Player)
	end,
})

local Input = Misc:CreateInput({
	Name = "Set Time (Uses 24 hour time)",
	PlaceholderText = "nil",
	NumbersOnly = true, -- If the user can only type numbers. Remove if none.
	CharacterLimit = 15, --max character limit. Remove if none.
	OnEnter = true, -- Will callback only if the user pressed ENTER while the box is focused.
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		game:GetService("Lighting").TimeOfDay = Text
	end,
})

local Freecam = Misc:CreateButton({
	Name = "Run Freecam Script (Shift + P)",
	Interact = 'Run',
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/frickwtcb/arff/main/freecam'))()
	end,
})

local Walkspeed = Misc:CreateInput({
	Name = "Walkspeed ",
	PlaceholderText = "24",
	NumbersOnly = true, -- If the user can only type numbers. Remove if none.
	CharacterLimit = 15, --max character limit. Remove if none.
	OnEnter = true, -- Will callback only if the user pressed ENTER while the box is focused.
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		Char.Humanoid.WalkSpeed = tonumber(Text)
	end,
})

local Freecam = Misc:CreateButton({
	Name = "No-Clip",
	Interact = 'Run',
	Callback = function()
		while true do
			for i,v in pairs(Char:GetChildren()) do
				if v:IsA("Part") then
					v.CanCollide = false
				end
			end
			wait(5)
		end
	end,
})

local ColorPicker = Misc:CreateColorPicker({
	Name = "Set Force Field Color",
	Color = Color3.fromRGB(2,255,255),
	Flag = "ColorPicker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		for i,v in pairs(Char:GetChildren()) do
			if v:IsA("Part") then
				v.Transparency = 0.5
				v.Material = Enum.Material.ForceField
				v.Color = Value
			end
		end
	end
})

function ViewGarrisonUnits()
	local HoldingTable = {}
	for i,v in pairs(WS.Teams:GetChildren()) do
		for i2,v2 in pairs(v:GetChildren()) do
			if v2:FindFirstChild("BillboardGui") then
				v2.BillboardGui:Destroy()
			end
			if table.find(GarrisonUnits, tostring(v2)) then
				local GarrisonHolder = v2.Torso.Garrisoned
				local GH = GarrisonHolder:GetChildren()
				if #GH > 0 then
					for i3,v3 in pairs(GH) do
						table.insert(HoldingTable,tostring(v3))
					end
					if #HoldingTable > 0 then
						CreateGarrisonLabel(table.concat(HoldingTable,", "), v2)
						HoldingTable = {}
					end
					HoldingTable = {}
				end
			end
		end
	end
end



RayfieldContainer.Main.BackgroundTransparency = 1
while true do
	UpdateTeamList()
	UpdateTeamAllies()
	UpdateEnemys()



	ViewGarrisonUnits()
	RefreshEcon()
	RefreshUnits()
	RefreshPlayerInfo()
	RefreshCashView()
	RefreshResearch()
	RefreshActiveResearch()
	wait(ValueRefreshInt)
end


