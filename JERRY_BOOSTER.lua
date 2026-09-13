--==================================================
-- JERRY FPS BOOSTER
-- Roblox Studio LocalScript
--==================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local LOGO_ID = "rbxassetid://135995313313068"

-- Open / Close Button Image
local BUTTON_IMAGE_ID = "rbxassetid://127978764819014"

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JerryFPSBooster"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(330, 260)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 65)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TopBar.BackgroundTransparency = 0.1
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

--==================================================
-- LOGO
--==================================================

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.fromOffset(45, 45)
Logo.Position = UDim2.fromOffset(10, 10)
Logo.BackgroundTransparency = 1
Logo.Image = LOGO_ID
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Parent = TopBar

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 0, 30)
Title.Position = UDim2.fromOffset(65, 8)
Title.BackgroundTransparency = 1
Title.Text = "FPS BOOSTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, -70, 0, 22)
Subtitle.Position = UDim2.fromOffset(65, 35)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Low Graphics • Smooth Mode"
Subtitle.TextColor3 = Color3.fromRGB(170, 170, 170)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

--==================================================
-- DRAG MAIN FRAME
--==================================================

local draggingMain = false
local dragStart
local startPos

TopBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingMain = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingMain = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not draggingMain then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

--==================================================
-- PAGE TITLE
--==================================================

local PageTitle = Instance.new("TextLabel")
PageTitle.Name = "PageTitle"
PageTitle.Size = UDim2.new(1, -30, 0, 30)
PageTitle.Position = UDim2.fromOffset(15, 78)
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
BoosterButton.Position = UDim2.fromOffset(15, 115)
BoosterButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
BoosterButton.BackgroundTransparency = 0.35
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
RestoreButton.Position = UDim2.fromOffset(15, 180)
RestoreButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
RestoreButton.BackgroundTransparency = 0.35
RestoreButton.BorderSizePixel = 0
RestoreButton.Text = "RESTORE ORIGINAL"
RestoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RestoreButton.TextSize = 14
RestoreButton.Font = Enum.Font.GothamBold
RestoreButton.Parent = MainFrame

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(0, 10)
RestoreCorner.Parent = RestoreButton

--==================================================
-- SAVE ORIGINAL SETTINGS
--==================================================

local SavedParts = {}
local SavedEffects = {}
local SavedTextures = {}

local BoosterEnabled = false

--==================================================
-- SAVE PART
--==================================================

local function SavePart(part)

	if SavedParts[part] then
		return
	end

	SavedParts[part] = {
		Material = part.Material,
		CastShadow = part.CastShadow
	}
end

--==================================================
-- SAVE EFFECT
--==================================================

local function SaveEffect(effect)

	if SavedEffects[effect] then
		return
	end

	if effect:IsA("BloomEffect")
		or effect:IsA("BlurEffect")
		or effect:IsA("SunRaysEffect")
		or effect:IsA("ColorCorrectionEffect")
		or effect:IsA("DepthOfFieldEffect")
		or effect:IsA("ParticleEmitter")
		or effect:IsA("Trail")
		or effect:IsA("Beam") then

		SavedEffects[effect] = {
			Enabled = effect.Enabled
		}
	end
end

--==================================================
-- SAVE TEXTURE / DECAL
--==================================================

local function SaveTexture(object)

	if SavedTextures[object] then
		return
	end

	if object:IsA("Decal") or object:IsA("Texture") then

		SavedTextures[object] = {
			Transparency = object.Transparency
		}
	end
end

--==================================================
-- BOOST PART
--==================================================

local function BoostObject(object)

	-- Parts
	if object:IsA("BasePart") then

		SavePart(object)

		-- Flat material
		object.Material = Enum.Material.SmoothPlastic

		-- Disable shadows
		object.CastShadow = false
	end

	-- Effects
	if object:IsA("ParticleEmitter")
		or object:IsA("Trail")
		or object:IsA("Beam") then

		SaveEffect(object)

		object.Enabled = false
	end

	-- Decals / Textures
	if object:IsA("Decal") or object:IsA("Texture") then

		SaveTexture(object)

		object.Transparency = 1
	end

	-- Lighting Effects
	if object:IsA("BloomEffect")
		or object:IsA("BlurEffect")
		or object:IsA("SunRaysEffect")
		or object:IsA("ColorCorrectionEffect")
		or object:IsA("DepthOfFieldEffect") then

		SaveEffect(object)

		object.Enabled = false
	end
end

--==================================================
-- ENABLE BOOSTER
--==================================================

local function EnableBooster()

	if BoosterEnabled then
		return
	end

	BoosterEnabled = true

	-- Workspace
	for _, object in ipairs(Workspace:GetDescendants()) do
		BoostObject(object)
	end

	-- Lighting
	for _, object in ipairs(Lighting:GetDescendants()) do
		BoostObject(object)
	end

	BoosterButton.Text = "FPS BOOSTER : ON"
	BoosterButton.BackgroundColor3 = Color3.fromRGB(35, 150, 75)
	BoosterButton.BackgroundTransparency = 0.35
end

--==================================================
-- RESTORE ORIGINAL
--==================================================

local function RestoreOriginal()

	-- Restore Parts
	for object, data in pairs(SavedParts) do

		if object and object.Parent then

			object.Material = data.Material
			object.CastShadow = data.CastShadow
		end
	end

	-- Restore Effects
	for object, data in pairs(SavedEffects) do

		if object and object.Parent then

			object.Enabled = data.Enabled
		end
	end

	-- Restore Textures
	for object, data in pairs(SavedTextures) do

		if object and object.Parent then

			object.Transparency = data.Transparency
		end
	end

	BoosterEnabled = false

	BoosterButton.Text = "FPS BOOSTER : OFF"
	BoosterButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	BoosterButton.BackgroundTransparency = 0.35
end

--==================================================
-- BOOSTER BUTTON CLICK
--==================================================

BoosterButton.Activated:Connect(function()

	if BoosterEnabled then
		RestoreOriginal()
	else
		EnableBooster()
	end
end)

--==================================================
-- RESTORE BUTTON CLICK
--==================================================

RestoreButton.Activated:Connect(function()
	RestoreOriginal()
end)

--==================================================
-- NEW OBJECT OPTIMIZATION
--==================================================

Workspace.DescendantAdded:Connect(function(object)

	if BoosterEnabled then

		task.wait()

		if object and object.Parent then
			BoostObject(object)
		end
	end
end)

Lighting.DescendantAdded:Connect(function(object)

	if BoosterEnabled then

		task.wait()

		if object and object.Parent then
			BoostObject(object)
		end
	end
end)

--==================================================
-- SMALL OPEN / CLOSE BUTTON
--==================================================

local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "OpenCloseButton"
FloatingButton.Parent = ScreenGui

-- Small size
FloatingButton.Size = UDim2.fromOffset(50, 50)

FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.Position = UDim2.new(0.5, 0, 0.5, 0)

FloatingButton.BackgroundTransparency = 1

-- Your image
FloatingButton.Image = BUTTON_IMAGE_ID

FloatingButton.ScaleType = Enum.ScaleType.Fit
FloatingButton.AutoButtonColor = false
FloatingButton.ZIndex = 1000

--==================================================
-- DRAG OPEN / CLOSE BUTTON
--==================================================

local draggingButton = false
local buttonDragStart
local buttonStartPos

FloatingButton.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingButton = true
		buttonDragStart = input.Position
		buttonStartPos = FloatingButton.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				draggingButton = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not draggingButton then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - buttonDragStart

		FloatingButton.Position = UDim2.new(
			buttonStartPos.X.Scale,
			buttonStartPos.X.Offset + delta.X,
			buttonStartPos.Y.Scale,
			buttonStartPos.Y.Offset + delta.Y
		)
	end
end)

--==================================================
-- OPEN / CLOSE MAIN FRAME
--==================================================

FloatingButton.Activated:Connect(function()

	MainFrame.Visible = not MainFrame.Visible

end)

--==================================================
-- DONE
--==================================================

print("JERRY FPS BOOSTER Loaded")
