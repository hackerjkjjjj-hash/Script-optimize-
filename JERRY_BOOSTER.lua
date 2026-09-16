--==================================================
-- JERRY FPS BOOSTER
-- Roblox Studio LocalScript
--==================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local LOGO_ID = "rbxassetid://135995313313068"
local BUTTON_LOGO_ID = "rbxassetid://127978764819014"

local rotationSpeed = 90 -- degrees per second

-- Far render preference (requires StreamingEnabled)
local FAR_RENDER_RADIUS = 2048
local FAR_RENDER_MIN_RADIUS = 512

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JerryFPSBooster"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui


--==================================================
-- WELCOME MESSAGE
--==================================================

local Welcome = Instance.new("TextLabel")
Welcome.Name = "WelcomeMessage"
Welcome.Size = UDim2.fromOffset(360, 70)
Welcome.AnchorPoint = Vector2.new(0.5, 0.5)
Welcome.Position = UDim2.fromScale(0.5, 0.5)
Welcome.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Welcome.BackgroundTransparency = 0.2
Welcome.BorderSizePixel = 0
Welcome.Text = "Welcome, " .. Player.DisplayName
Welcome.TextSize = 26
Welcome.Font = Enum.Font.GothamBold
Welcome.TextXAlignment = Enum.TextXAlignment.Center
Welcome.TextYAlignment = Enum.TextYAlignment.Center
Welcome.ZIndex = 2000
Welcome.Parent = ScreenGui

local WelcomeCorner = Instance.new("UICorner")
WelcomeCorner.CornerRadius = UDim.new(0, 14)
WelcomeCorner.Parent = Welcome

-- Rainbow text animation
local welcomeRainbowRunning = true

task.spawn(function()
    local hue = 0
    while welcomeRainbowRunning and Welcome.Parent do
        hue = (hue + 0.008) % 1
        Welcome.TextColor3 = Color3.fromHSV(hue, 1, 1)
        task.wait(0.03)
    end
end)

-- Keep welcome visible for 5 seconds
 task.delay(5, function()
    welcomeRainbowRunning = false
    if Welcome and Welcome.Parent then
        Welcome:Destroy()
    end
end)

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 260)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 65)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TopBar.BackgroundTransparency = 0.35
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

--==================================================
-- LOGO
--==================================================

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 45, 0, 45)
Logo.Position = UDim2.new(0, 10, 0.5, -22)
Logo.BackgroundTransparency = 1
Logo.Image = LOGO_ID
Logo.Parent = TopBar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = Logo

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 0, 30)
Title.Position = UDim2.new(0, 65, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "FPS BOOSTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, -70, 0, 20)
Subtitle.Position = UDim2.new(0, 65, 0, 37)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Low Graphics • Smooth Mode"
Subtitle.TextColor3 = Color3.fromRGB(160, 160, 160)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

--==================================================
-- SMOOTH DRAG MAIN FRAME
--==================================================

local UserInputService = game:GetService("UserInputService")

local draggingMain = false
local dragStartMain
local startPosMain
local dragInputMain

TopBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingMain = true
		dragStartMain = input.Position
		startPosMain = MainFrame.Position

	end

end)

TopBar.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		dragInputMain = input

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if input == dragInputMain and draggingMain then

		local delta = input.Position - dragStartMain

		local targetPosition = UDim2.new(
			startPosMain.X.Scale,
			startPosMain.X.Offset + delta.X,
			startPosMain.Y.Scale,
			startPosMain.Y.Offset + delta.Y
		)

		-- Smooth movement
		MainFrame.Position = MainFrame.Position:Lerp(targetPosition, 0.35)

	end

end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingMain = false

	end

end)

--==================================================
-- PAGE TITLE
--==================================================

local PageTitle = Instance.new("TextLabel")
PageTitle.Name = "PageTitle"
PageTitle.Size = UDim2.new(1, -30, 0, 30)
PageTitle.Position = UDim2.new(0, 15, 0, 80)
PageTitle.BackgroundTransparency = 1
PageTitle.Text = "Booster"
PageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PageTitle.TextSize = 18
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.Parent = MainFrame

--==================================================
-- BOOSTER BUTTON
--==================================================

local BoosterButton = Instance.new("TextButton")
BoosterButton.Name = "BoosterButton"
BoosterButton.Size = UDim2.new(1, -30, 0, 55)
BoosterButton.Position = UDim2.new(0, 15, 0, 120)
BoosterButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
BoosterButton.BackgroundTransparency = 0.45
BoosterButton.BorderSizePixel = 0
BoosterButton.Text = "FPS BOOSTER : OFF"
BoosterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BoosterButton.TextSize = 16
BoosterButton.Font = Enum.Font.GothamBold
BoosterButton.Parent = MainFrame

local BoosterCorner = Instance.new("UICorner")
BoosterCorner.CornerRadius = UDim.new(0, 10)
BoosterCorner.Parent = BoosterButton

--==================================================
-- RESTORE BUTTON
--==================================================

local RestoreButton = Instance.new("TextButton")
RestoreButton.Name = "RestoreButton"
RestoreButton.Size = UDim2.new(1, -30, 0, 45)
RestoreButton.Position = UDim2.new(0, 15, 0, 185)
RestoreButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
RestoreButton.BackgroundTransparency = 0.45
RestoreButton.BorderSizePixel = 0
RestoreButton.Text = "RESTORE ORIGINAL"
RestoreButton.TextColor3 = Color3.fromRGB(220, 220, 220)
RestoreButton.TextSize = 14
RestoreButton.Font = Enum.Font.GothamBold
RestoreButton.Parent = MainFrame

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(0, 10)
RestoreCorner.Parent = RestoreButton

--==================================================
-- ORIGINAL SETTINGS STORAGE
--==================================================

local OriginalParts = {}
local OriginalEffects = {}
local OriginalTextures = {}
local OriginalSurfaceAppearances = {}
local SurfaceStorage = Instance.new("Folder")
SurfaceStorage.Name = "_JerrySurfaceStorage"
SurfaceStorage.Parent = nil

local BoosterEnabled = false
local OriginalGlobalShadows = Lighting.GlobalShadows
local OriginalTechnology = Lighting.Technology
local OriginalAtmosphereDensity = nil
local OriginalFogEnd = workspace.FogEnd
local OriginalTerrainDecoration = workspace.Terrain.Decoration
local OriginalWaterReflectance = workspace.Terrain.WaterReflectance
local OriginalWaterWaveSize = workspace.Terrain.WaterWaveSize
local OriginalMeshFidelity = {}

--==================================================
-- SAVE PART
--==================================================

local function SavePart(part)

	if not OriginalParts[part] then

		OriginalParts[part] = {
			Material = part.Material,
			CastShadow = part.CastShadow
		}

	end

end

--==================================================
-- SAVE EFFECT
--==================================================

local function SaveEffect(object)

	if object:IsA("PostEffect")
		or object:IsA("ParticleEmitter")
		or object:IsA("Trail")
		or object:IsA("Beam") then

		if OriginalEffects[object] == nil then
			OriginalEffects[object] = object.Enabled
		end

	end

end

--==================================================
-- SAVE TEXTURE
--==================================================

local function SaveTexture(object)

	if object:IsA("Decal") or object:IsA("Texture") then

		if OriginalTextures[object] == nil then
			OriginalTextures[object] = object.Transparency
		end

	end

end

--==================================================
-- FAR RENDER / STREAMING
--==================================================

-- These properties are controlled by the experience and are most
-- reliable when configured from a normal Server Script in Workspace.
pcall(function()
	if workspace.StreamingEnabled then
		workspace.StreamingTargetRadius = FAR_RENDER_RADIUS
		workspace.StreamingMinRadius = FAR_RENDER_MIN_RADIUS
	end
end)

--==================================================
-- DISABLE LIGHTING / VISUAL EFFECTS
--==================================================

local function DisableLightingEffects()

	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.Technology = Enum.Technology.Compatibility
	end)

	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere and OriginalAtmosphereDensity == nil then
		OriginalAtmosphereDensity = atmosphere.Density
		atmosphere.Density = 0
	end

	for _, object in ipairs(Lighting:GetDescendants()) do

		if object:IsA("PostEffect")
			or object:IsA("BloomEffect")
			or object:IsA("BlurEffect")
			or object:IsA("SunRaysEffect")
			or object:IsA("ColorCorrectionEffect")
			or object:IsA("DepthOfFieldEffect") then

			SaveEffect(object)
			object.Enabled = false

		end

	end

end

--==================================================
-- APPLY BOOST
--==================================================

local function ApplyBoost()

	-- No shadow graphics / lighting post effects
	DisableLightingEffects()

	-- Terrain & fog cost reduction
	pcall(function()
		workspace.Terrain.Decoration = false
		workspace.Terrain.WaterReflectance = 0
		workspace.Terrain.WaterWaveSize = 0
		workspace.FogEnd = math.max(workspace.FogEnd, 100000)
	end)

	for _, object in ipairs(workspace:GetDescendants()) do

		if object:IsA("BasePart") then

			SavePart(object)

			object.Material = Enum.Material.SmoothPlastic
			object.CastShadow = false
			object.Reflectance = 0

			if object:IsA("MeshPart") and OriginalMeshFidelity[object] == nil then
				OriginalMeshFidelity[object] = object.RenderFidelity
				object.RenderFidelity = Enum.RenderFidelity.Performance
			end

			local surface = object:FindFirstChildOfClass("SurfaceAppearance")
			if surface and not OriginalSurfaceAppearances[surface] then
				OriginalSurfaceAppearances[surface] = object
				surface.Parent = SurfaceStorage
			end

		elseif object:IsA("PostEffect")
			or object:IsA("ParticleEmitter")
			or object:IsA("Trail")
			or object:IsA("Beam") then

			SaveEffect(object)

			object.Enabled = false

		elseif object:IsA("Decal")
			or object:IsA("Texture") then

			SaveTexture(object)

			object.Transparency = 1

		end

	end

	-- Lighting effects
	for _, object in ipairs(Lighting:GetDescendants()) do

		if object:IsA("PostEffect")
			or object:IsA("ParticleEmitter")
			or object:IsA("Trail")
			or object:IsA("Beam") then

			SaveEffect(object)

			object.Enabled = false

		end

	end

end

--==================================================
-- RESTORE ORIGINAL
--==================================================

local function RestoreOriginal()

	-- Restore the original global shadow / technology setting.
	pcall(function()
		Lighting.GlobalShadows = OriginalGlobalShadows
		Lighting.Technology = OriginalTechnology
	end)

	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere and OriginalAtmosphereDensity ~= nil then
		atmosphere.Density = OriginalAtmosphereDensity
		OriginalAtmosphereDensity = nil
	end

	pcall(function()
		workspace.Terrain.Decoration = OriginalTerrainDecoration
		workspace.Terrain.WaterReflectance = OriginalWaterReflectance
		workspace.Terrain.WaterWaveSize = OriginalWaterWaveSize
		workspace.FogEnd = OriginalFogEnd
	end)

	for part, fidelity in pairs(OriginalMeshFidelity) do
		if part and part.Parent then
			part.RenderFidelity = fidelity
		end
	end
	OriginalMeshFidelity = {}

	for part, data in pairs(OriginalParts) do

		if part and part.Parent then

			part.Material = data.Material
			part.CastShadow = data.CastShadow

		end

	end

	for object, enabled in pairs(OriginalEffects) do

		if object and object.Parent then
			object.Enabled = enabled
		end

	end

	for object, transparency in pairs(OriginalTextures) do

		if object and object.Parent then
			object.Transparency = transparency
		end

	end

	for surface, parentPart in pairs(OriginalSurfaceAppearances) do

		if surface and parentPart and parentPart.Parent then
			surface.Parent = parentPart
		end

	end

end

--==================================================
-- BOOSTER ON/OFF
--==================================================

BoosterButton.Activated:Connect(function()

	BoosterEnabled = not BoosterEnabled

	if BoosterEnabled then

		BoosterButton.Text = "FPS BOOSTER : ON"
		BoosterButton.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
		BoosterButton.BackgroundTransparency = 0.45

		ApplyBoost()

	else

		BoosterButton.Text = "FPS BOOSTER : OFF"
		BoosterButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
		BoosterButton.BackgroundTransparency = 0.45

		RestoreOriginal()

	end

end)

--==================================================
-- RESTORE BUTTON
--==================================================

RestoreButton.Activated:Connect(function()

	BoosterEnabled = false

	BoosterButton.Text = "FPS BOOSTER : OFF"
	BoosterButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	BoosterButton.BackgroundTransparency = 0.45

	RestoreOriginal()

end)

--==================================================
-- OPTIMIZE NEW OBJECTS
--==================================================

workspace.DescendantAdded:Connect(function(object)

	if not BoosterEnabled then
		return
	end

	task.wait()

	if object:IsA("BasePart") then

		SavePart(object)

		object.Material = Enum.Material.SmoothPlastic
		object.CastShadow = false
		object.Reflectance = 0

		if object:IsA("MeshPart") and OriginalMeshFidelity[object] == nil then
			OriginalMeshFidelity[object] = object.RenderFidelity
			object.RenderFidelity = Enum.RenderFidelity.Performance
		end

		local surface = object:FindFirstChildOfClass("SurfaceAppearance")
		if surface then
			surface:Destroy()
		end

	elseif object:IsA("PostEffect")
		or object:IsA("ParticleEmitter")
		or object:IsA("Trail")
		or object:IsA("Beam") then

		SaveEffect(object)

		object.Enabled = false

	elseif object:IsA("Decal")
		or object:IsA("Texture") then

		SaveTexture(object)

		object.Transparency = 1

	end

end)

--==================================================
-- FLOATING OPEN / CLOSE BUTTON
--==================================================

local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "OpenCloseButton"
FloatingButton.Size = UDim2.fromOffset(58, 58)
FloatingButton.Position = UDim2.new(0.5, -29, 0.5, -29)

-- Button itself is transparent, only the image is visible
FloatingButton.BackgroundTransparency = 1
FloatingButton.Image = "rbxassetid://127978764819014"
FloatingButton.AutoButtonColor = false
FloatingButton.ZIndex = 1000
FloatingButton.Parent = ScreenGui

--==================================================
-- FIX MAIN FRAME TRANSPARENCY
--==================================================

MainFrame.BackgroundTransparency = 0.45
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

--==================================================
-- SMOOTH DRAG SYSTEM
--==================================================

local dragging = false
local dragStart
local startPosition
local dragInput

local function updateDrag(input)

	local delta = input.Position - dragStart

	FloatingButton.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)

end

FloatingButton.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = FloatingButton.Position

	end

end)

FloatingButton.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input

	end

end)

game:GetService("UserInputService").InputChanged:Connect(function(input)

	if input == dragInput and dragging then
		updateDrag(input)
	end

end)

FloatingButton.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false

	end

end)

--==================================================
-- ROTATION
--==================================================

local rotationSpeed = 90

RunService.RenderStepped:Connect(function(deltaTime)

	FloatingButton.Rotation =
		(FloatingButton.Rotation + rotationSpeed * deltaTime) % 360

end)

--==================================================
-- OPEN / CLOSE
--==================================================

FloatingButton.Activated:Connect(function()

	MainFrame.Visible = not MainFrame.Visible

end)

--==================================================
-- DONE
--==================================================

print("JERRY FPS BOOSTER Loaded")
