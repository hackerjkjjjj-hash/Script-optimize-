--// JERRY FPS BOOSTER
--// Roblox Studio LocalScript
--// Place in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local LOGO_ID = "rbxassetid://135995313313068"
local BoosterEnabled = false

local SavedParts = {}
local SavedEffects = {}
local SavedTextures = {}

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JerryFPSBooster"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- MAIN FRAME
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 330, 0, 260)
Main.Position = UDim2.new(0.5, -165, 0.5, -130)

-- Main ថ្លា 15%
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BackgroundTransparency = 0.15

Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 58)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)

-- TopBar ថ្លា 10%
TopBar.BackgroundTransparency = 0.10

TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

--==================================================
-- LOGO
--==================================================

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 42, 0, 42)
Logo.Position = UDim2.new(0, 9, 0.5, -21)
Logo.BackgroundTransparency = 1
Logo.Image = LOGO_ID
Logo.Parent = TopBar

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 30)
Title.Position = UDim2.new(0, 60, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "FPS BOOSTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -70, 0, 18)
Subtitle.Position = UDim2.new(0, 60, 0, 33)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Low Graphics • Smooth Mode"
Subtitle.TextColor3 = Color3.fromRGB(160, 160, 165)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

--==================================================
-- DRAG MAIN FRAME
--==================================================

local draggingMain = false
local mainDragStart
local mainStartPosition

TopBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingMain = true
		mainDragStart = input.Position
		mainStartPosition = Main.Position

	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not draggingMain then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - mainDragStart

		Main.Position = UDim2.new(
			mainStartPosition.X.Scale,
			mainStartPosition.X.Offset + delta.X,
			mainStartPosition.Y.Scale,
			mainStartPosition.Y.Offset + delta.Y
		)

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
PageTitle.Size = UDim2.new(1, -30, 0, 30)
PageTitle.Position = UDim2.new(0, 15, 0, 72)
PageTitle.BackgroundTransparency = 1
PageTitle.Text = "Booster"
PageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PageTitle.TextSize = 20
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.Parent = Main

--==================================================
-- FPS BOOSTER BUTTON
--==================================================

local BoosterButton = Instance.new("TextButton")
BoosterButton.Size = UDim2.new(1, -30, 0, 55)
BoosterButton.Position = UDim2.new(0, 15, 0, 112)

BoosterButton.BackgroundColor3 = Color3.fromRGB(40, 40, 46)

-- Button ថ្លា 35%
BoosterButton.BackgroundTransparency = 0.35

BoosterButton.BorderSizePixel = 0
BoosterButton.Text = "FPS BOOSTER : OFF"
BoosterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BoosterButton.TextSize = 16
BoosterButton.Font = Enum.Font.GothamBold
BoosterButton.AutoButtonColor = false
BoosterButton.Parent = Main

local BoosterCorner = Instance.new("UICorner")
BoosterCorner.CornerRadius = UDim.new(0, 10)
BoosterCorner.Parent = BoosterButton

--==================================================
-- RESTORE BUTTON
--==================================================

local RestoreButton = Instance.new("TextButton")
RestoreButton.Size = UDim2.new(1, -30, 0, 45)
RestoreButton.Position = UDim2.new(0, 15, 0, 178)

RestoreButton.BackgroundColor3 = Color3.fromRGB(32, 32, 37)

-- Restore ថ្លា 35%
RestoreButton.BackgroundTransparency = 0.35

RestoreButton.BorderSizePixel = 0
RestoreButton.Text = "RESTORE ORIGINAL"
RestoreButton.TextColor3 = Color3.fromRGB(210, 210, 215)
RestoreButton.TextSize = 14
RestoreButton.Font = Enum.Font.GothamBold
RestoreButton.AutoButtonColor = false
RestoreButton.Parent = Main

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(0, 10)
RestoreCorner.Parent = RestoreButton

--==================================================
-- FLOATING LOGO BUTTON
--==================================================

local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "FloatingOpenButton"
FloatingButton.Size = UDim2.new(0, 50, 0, 50)

-- ចាប់ផ្តើមនៅកណ្ដាល Screen
FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.Position = UDim2.new(0.5, 0, 0.5, 0)

FloatingButton.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
FloatingButton.BackgroundTransparency = 0.15
FloatingButton.BorderSizePixel = 0
FloatingButton.Image = LOGO_ID
FloatingButton.ZIndex = 1000
FloatingButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Thickness = 2
FloatStroke.Transparency = 0.2
FloatStroke.Parent = FloatingButton

--==================================================
-- DRAG FLOATING BUTTON
--==================================================

local draggingFloat = false
local floatDragStart
local floatStartPosition
local moved = false

FloatingButton.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingFloat = true
		moved = false
		floatDragStart = input.Position
		floatStartPosition = FloatingButton.Position

	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not draggingFloat then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - floatDragStart

		if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
			moved = true
		end

		FloatingButton.Position = UDim2.new(
			floatStartPosition.X.Scale,
			floatStartPosition.X.Offset + delta.X,
			floatStartPosition.Y.Scale,
			floatStartPosition.Y.Offset + delta.Y
		)

	end
end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingFloat = false

	end
end)

--==================================================
-- OPEN / CLOSE MAIN
--==================================================

FloatingButton.Activated:Connect(function()

	if moved then
		moved = false
		return
	end

	Main.Visible = not Main.Visible

end)

--==================================================
-- OPTIMIZER
--==================================================

local function OptimizeObject(obj)

	if obj:IsA("BasePart") then

		if not SavedParts[obj] then

			SavedParts[obj] = {
				Material = obj.Material,
				CastShadow = obj.CastShadow
			}

		end

		obj.Material = Enum.Material.SmoothPlastic
		obj.CastShadow = false

	end

	if obj:IsA("ParticleEmitter")
		or obj:IsA("Trail")
		or obj:IsA("Beam") then

		if not SavedEffects[obj] then

			SavedEffects[obj] = {
				Enabled = obj.Enabled
			}

		end

		obj.Enabled = false

	end

	if obj:IsA("BloomEffect")
		or obj:IsA("BlurEffect")
		or obj:IsA("SunRaysEffect")
		or obj:IsA("ColorCorrectionEffect")
		or obj:IsA("DepthOfFieldEffect") then

		if not SavedEffects[obj] then

			SavedEffects[obj] = {
				Enabled = obj.Enabled
			}

		end

		obj.Enabled = false

	end

	if obj:IsA("Decal") or obj:IsA("Texture") then

		if not SavedTextures[obj] then

			SavedTextures[obj] = {
				Transparency = obj.Transparency
			}

		end

		obj.Transparency = 1

	end

end

--==================================================
-- ENABLE BOOSTER
--==================================================

local function EnableBooster()

	BoosterEnabled = true

	for _, obj in ipairs(Workspace:GetDescendants()) do
		OptimizeObject(obj)
	end

	for _, obj in ipairs(Lighting:GetDescendants()) do
		OptimizeObject(obj)
	end

	BoosterButton.Text = "FPS BOOSTER : ON"

	BoosterButton.BackgroundColor3 =
		Color3.fromRGB(45, 130, 75)

	BoosterButton.BackgroundTransparency = 0.35

end

--==================================================
-- RESTORE
--==================================================

local function RestoreOriginal()

	BoosterEnabled = false

	for obj, data in pairs(SavedParts) do

		if obj and obj.Parent then

			obj.Material = data.Material
			obj.CastShadow = data.CastShadow

		end

	end

	for obj, data in pairs(SavedEffects) do

		if obj and obj.Parent then
			obj.Enabled = data.Enabled
		end

	end

	for obj, data in pairs(SavedTextures) do

		if obj and obj.Parent then
			obj.Transparency = data.Transparency
		end

	end

	BoosterButton.Text = "FPS BOOSTER : OFF"

	BoosterButton.BackgroundColor3 =
		Color3.fromRGB(40, 40, 46)

	BoosterButton.BackgroundTransparency = 0.35

end

--==================================================
-- NEW OBJECTS
--==================================================

Workspace.DescendantAdded:Connect(function(obj)

	if BoosterEnabled then

		task.defer(function()
			OptimizeObject(obj)
		end)

	end

end)

Lighting.DescendantAdded:Connect(function(obj)

	if BoosterEnabled then

		task.defer(function()
			OptimizeObject(obj)
		end)

	end

end)

--==================================================
-- BUTTON EVENTS
--==================================================

BoosterButton.Activated:Connect(function()

	if BoosterEnabled then
		RestoreOriginal()
	else
		EnableBooster()
	end

end)

RestoreButton.Activated:Connect(function()
	RestoreOriginal()
end)
