--==================================================
-- JERRY FPS BOOSTER
-- Roblox Studio LocalScript
--==================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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

-- Theme colors
local COLOR_BG_TOP = Color3.fromRGB(38, 38, 48)
local COLOR_BG_BOTTOM = Color3.fromRGB(16, 16, 21)
local COLOR_ACCENT = Color3.fromRGB(90, 140, 255)
local COLOR_ON = Color3.fromRGB(45, 200, 115)
local COLOR_OFF = Color3.fromRGB(50, 50, 62)

local MAIN_SIZE = UDim2.new(0, 330, 0, 260)
local MAIN_SIZE_SMALL = UDim2.new(0, 291, 0, 221) -- 88% for open/close tween

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
-- WELCOME MESSAGE (FIXED)
--==================================================

local Welcome = Instance.new("TextLabel")
Welcome.Name = "WelcomeMessage"
Welcome.AnchorPoint = Vector2.new(0.5, 0.5)
Welcome.Position = UDim2.fromScale(0.5, 0.5)
Welcome.Size = UDim2.fromOffset(0, 0)
Welcome.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Welcome.BackgroundTransparency = 0.2
Welcome.BorderSizePixel = 0
Welcome.Text = "Welcome, " .. Player.DisplayName
Welcome.TextTransparency = 1
Welcome.TextSize = 26
Welcome.Font = Enum.Font.GothamBold
Welcome.TextXAlignment = Enum.TextXAlignment.Center
Welcome.TextYAlignment = Enum.TextYAlignment.Center
Welcome.ZIndex = 100 -- កែសម្រួល ZIndex មកត្រឹម 100 ដើម្បីកុំឱ្យបាំង Button
Welcome.Active = false -- បិទ Active ដើម្បីកុំឱ្យវាទប់ Blocking ការ Click/Touch
Welcome.Parent = ScreenGui

local WelcomeCorner = Instance.new("UICorner")
WelcomeCorner.CornerRadius = UDim.new(0, 14)
WelcomeCorner.Parent = Welcome

local WelcomeStroke = Instance.new("UIStroke")
WelcomeStroke.Thickness = 1
WelcomeStroke.Color = COLOR_ACCENT
WelcomeStroke.Transparency = 0.5
WelcomeStroke.Parent = Welcome

-- Pop-in entrance animation
TweenService:Create(Welcome, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.fromOffset(360, 70),
	TextTransparency = 0
}):Play()

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

-- Fade out and remove after a few seconds
task.delay(4, function()
	welcomeRainbowRunning = false
	if Welcome and Welcome.Parent then
		local fadeTween = TweenService:Create(Welcome, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.fromOffset(0, 0),
			TextTransparency = 1,
			BackgroundTransparency = 1
		})
		fadeTween:Play()
		fadeTween.Completed:Connect(function()
			Welcome:Destroy()
		end)
	end
end)

--==================================================
-- MAIN FRAME (CanvasGroup so the whole panel can fade as one)
--==================================================

local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = MAIN_SIZE_SMALL
MainFrame.GroupTransparency = 1
MainFrame.BackgroundColor3 = COLOR_BG_BOTTOM
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_BG_TOP),
	ColorSequenceKeypoint.new(1, COLOR_BG_BOTTOM),
})
MainGradient.Rotation = 90
MainGradient.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.2
MainStroke.Color = COLOR_ACCENT
MainStroke.Transparency = 0.55
MainStroke.Parent = MainFrame

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 65)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TopBar.BackgroundTransparency = 0.15
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local TopGradient = Instance.new("UIGradient")
TopGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 70)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 33)),
})
TopGradient.Rotation = 90
TopGradient.Parent = TopBar

-- Square off the bottom corners of the rounded top bar
local TopBarFix = Instance.new("Frame")
TopBarFix.Name = "CornerFix"
TopBarFix.Size = UDim2.new(1, 0, 0, 16)
TopBarFix.Position = UDim2.new(0, 0, 1, -16)
TopBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TopBarFix.BackgroundTransparency = 0.15
TopBarFix.BorderSizePixel = 0
TopBarFix.ZIndex = TopBar.ZIndex
TopBarFix.Parent = TopBar

--==================================================
-- LOGO
--==================================================

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 45, 0, 45)
Logo.Position = UDim2.new(0, 10, 0.5, -22)
Logo.BackgroundTransparency = 1
Logo.Image = LOGO_ID
Logo.ZIndex = 2
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
Title.Text = "JERRY RENDER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 2
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, -70, 0, 20)
Subtitle.Position = UDim2.new(0, 65, 0, 37)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Far Map Render • Smooth Mode"
Subtitle.TextColor3 = Color3.fromRGB(160, 160, 160)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 2
Subtitle.Parent = TopBar

--==================================================
-- SMOOTH DRAG MAIN FRAME
--==================================================

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
-- RENDER MAP BUTTON (with status dot + animated stroke)
--==================================================

local BoosterButton = Instance.new("TextButton")
BoosterButton.Name = "BoosterButton"
BoosterButton.Size = UDim2.new(1, -30, 0, 55)
BoosterButton.Position = UDim2.new(0, 15, 0, 120)
BoosterButton.BackgroundColor3 = COLOR_OFF
BoosterButton.BackgroundTransparency = 0.45
BoosterButton.BorderSizePixel = 0
BoosterButton.Text = "  RENDER MAP : OFF"
BoosterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BoosterButton.TextSize = 16
BoosterButton.Font = Enum.Font.GothamBold
BoosterButton.AutoButtonColor = false
BoosterButton.Parent = MainFrame

local BoosterCorner = Instance.new("UICorner")
BoosterCorner.CornerRadius = UDim.new(0, 10)
BoosterCorner.Parent = BoosterButton

local BoosterStroke = Instance.new("UIStroke")
BoosterStroke.Thickness = 1.2
BoosterStroke.Color = COLOR_OFF
BoosterStroke.Transparency = 0.5
BoosterStroke.Parent = BoosterButton

local BoosterDot = Instance.new("Frame")
BoosterDot.Name = "StatusDot"
BoosterDot.AnchorPoint = Vector2.new(0.5, 0.5)
BoosterDot.Size = UDim2.fromOffset(10, 10)
BoosterDot.Position = UDim2.new(1, -18, 0.5, 0)
BoosterDot.BackgroundColor3 = COLOR_OFF
BoosterDot.BorderSizePixel = 0
BoosterDot.Parent = BoosterButton

local BoosterDotCorner = Instance.new("UICorner")
BoosterDotCorner.CornerRadius = UDim.new(1, 0)
BoosterDotCorner.Parent = BoosterDot

--==================================================
-- RESTORE BUTTON
--==================================================

local RestoreButton = Instance.new("TextButton")
RestoreButton.Name = "RestoreButton"
RestoreButton.Size = UDim2.new(1, -30, 0, 45)
RestoreButton.Position = UDim2.new(0, 15, 0, 185)
RestoreButton.BackgroundColor3 = COLOR_OFF
RestoreButton.BackgroundTransparency = 0.45
RestoreButton.BorderSizePixel = 0
RestoreButton.Text = "RESTORE RENDER"
RestoreButton.TextColor3 = Color3.fromRGB(220, 220, 220)
RestoreButton.TextSize = 14
RestoreButton.Font = Enum.Font.GothamBold
RestoreButton.AutoButtonColor = false
RestoreButton.Parent = MainFrame

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(0, 10)
RestoreCorner.Parent = RestoreButton

local RestoreStroke = Instance.new("UIStroke")
RestoreStroke.Thickness = 1
RestoreStroke.Color = Color3.fromRGB(255, 255, 255)
RestoreStroke.Transparency = 0.85
RestoreStroke.Parent = RestoreButton

--==================================================
-- SMALL HELPERS: BUTTON HOVER + PRESS ANIMATIONS
--==================================================

local function AttachHover(button, hoverTransparency, baseTransparency)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
			BackgroundTransparency = hoverTransparency
		}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
			BackgroundTransparency = baseTransparency
		}):Play()
	end)
end

local function ButtonPop(button)
	local originalSize = button.Size
	local shrunk = UDim2.new(
		originalSize.X.Scale, originalSize.X.Offset - 6,
		originalSize.Y.Scale, originalSize.Y.Offset - 4
	)

	TweenService:Create(button, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = shrunk
	}):Play()

	task.delay(0.07, function()
		TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = originalSize
		}):Play()
	end)
end

AttachHover(BoosterButton, 0.3, 0.45)
AttachHover(RestoreButton, 0.3, 0.45)

--==================================================
-- RENDER MAP ONLY
--==================================================

local BoosterEnabled = false

local OriginalStreamingEnabled
local OriginalStreamingTargetRadius
local OriginalStreamingMinRadius

pcall(function()
    OriginalStreamingEnabled = workspace.StreamingEnabled
    OriginalStreamingTargetRadius = workspace.StreamingTargetRadius
    OriginalStreamingMinRadius = workspace.StreamingMinRadius
end)

local function ApplyRenderMap()
    -- Render/streaming only.
    -- No Part material, shadow, reflection, texture, SurfaceAppearance,
    -- particle, or Lighting changes are made here.
    pcall(function()
        if workspace.StreamingEnabled then
            workspace.StreamingTargetRadius = FAR_RENDER_RADIUS
            workspace.StreamingMinRadius = FAR_RENDER_MIN_RADIUS
        end
    end)
end

local function RestoreRenderMap()
    pcall(function()
        if OriginalStreamingTargetRadius ~= nil then
            workspace.StreamingTargetRadius = OriginalStreamingTargetRadius
        end

        if OriginalStreamingMinRadius ~= nil then
            workspace.StreamingMinRadius = OriginalStreamingMinRadius
        end

        if OriginalStreamingEnabled ~= nil then
            workspace.StreamingEnabled = OriginalStreamingEnabled
        end
    end)
end

--==================================================
-- RENDER MAP ON/OFF (animated stroke + status dot pulse)
--==================================================

local boosterPulseId = 0

local function SetBoosterVisual(enabled)

	boosterPulseId += 1
	local myPulseId = boosterPulseId

	if enabled then

		BoosterButton.Text = "  RENDER MAP : ON"

		TweenService:Create(BoosterButton, TweenInfo.new(0.2), {
			BackgroundColor3 = COLOR_ON,
			BackgroundTransparency = 0.35
		}):Play()

		TweenService:Create(BoosterStroke, TweenInfo.new(0.2), {
			Color = COLOR_ON,
			Transparency = 0.1
		}):Play()

		TweenService:Create(BoosterDot, TweenInfo.new(0.2), {
			BackgroundColor3 = COLOR_ON
		}):Play()

		-- Gentle glow pulse on the status dot while boost is active
		task.spawn(function()
			while myPulseId == boosterPulseId do
				TweenService:Create(BoosterDot, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
					BackgroundTransparency = 0.6
				}):Play()
				task.wait(0.6)
				if myPulseId ~= boosterPulseId then break end
				TweenService:Create(BoosterDot, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
					BackgroundTransparency = 0
				}):Play()
				task.wait(0.6)
			end
		end)

	else

		BoosterButton.Text = "  RENDER MAP : OFF"

		TweenService:Create(BoosterButton, TweenInfo.new(0.2), {
			BackgroundColor3 = COLOR_OFF,
			BackgroundTransparency = 0.45
		}):Play()

		TweenService:Create(BoosterStroke, TweenInfo.new(0.2), {
			Color = COLOR_OFF,
			Transparency = 0.5
		}):Play()

		TweenService:Create(BoosterDot, TweenInfo.new(0.2), {
			BackgroundColor3 = COLOR_OFF,
			BackgroundTransparency = 0
		}):Play()

	end

end

BoosterButton.Activated:Connect(function()

	ButtonPop(BoosterButton)

	BoosterEnabled = not BoosterEnabled
	SetBoosterVisual(BoosterEnabled)

	if BoosterEnabled then
		ApplyBoost()
	else
		RestoreOriginal()
	end

end)

--==================================================
-- RESTORE BUTTON
--==================================================

RestoreButton.Activated:Connect(function()

	ButtonPop(RestoreButton)

	BoosterEnabled = false
	SetBoosterVisual(false)

	RestoreOriginal()

end)

--==================================================
-- OPTIMIZE NEW OBJECTS
--==================================================

--==================================================
-- FLOATING OPEN / CLOSE BUTTON
--==================================================

local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "OpenCloseButton"
FloatingButton.Size = UDim2.fromOffset(58, 58)
FloatingButton.Position = UDim2.new(0.5, -29, 0.5, -29)

-- Button itself is transparent, only the image is visible
FloatingButton.BackgroundTransparency = 1
FloatingButton.Image = BUTTON_LOGO_ID
FloatingButton.AutoButtonColor = false
FloatingButton.ZIndex = 1000
FloatingButton.Parent = ScreenGui

--==================================================
-- SMOOTH DRAG SYSTEM (floating button)
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

UserInputService.InputChanged:Connect(function(input)

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

RunService.RenderStepped:Connect(function(deltaTime)

	FloatingButton.Rotation =
		(FloatingButton.Rotation + rotationSpeed * deltaTime) % 360

end)

--==================================================
-- OPEN / CLOSE (animated: scale + fade via CanvasGroup)
--==================================================

local menuOpen = false
local menuTweening = false

local function OpenMenu()

	if menuOpen or menuTweening then return end
	menuTweening = true
	menuOpen = true

	MainFrame.Size = MAIN_SIZE_SMALL
	MainFrame.GroupTransparency = 1
	MainFrame.Visible = true

	local tween = TweenService:Create(MainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = MAIN_SIZE,
		GroupTransparency = 0
	})

	tween:Play()
	tween.Completed:Connect(function()
		menuTweening = false
	end)

end

local function CloseMenu()

	if not menuOpen or menuTweening then return end
	menuTweening = true
	menuOpen = false

	local tween = TweenService:Create(MainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = MAIN_SIZE_SMALL,
		GroupTransparency = 1
	})

	tween:Play()
	tween.Completed:Connect(function()
		MainFrame.Visible = false
		menuTweening = false
	end)

end

FloatingButton.Activated:Connect(function()

	if menuOpen then
		CloseMenu()
	else
		OpenMenu()
	end

end)

--==================================================
-- DONE
--==================================================

print("JERRY FPS BOOSTER Loaded")
