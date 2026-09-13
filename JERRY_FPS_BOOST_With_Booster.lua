--[[
    JERRY v1.0
    Clean UI: Info + Steal
    Animation / Emote / Home / Player functions removed.
]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCustomUI"
ScreenGui.ResetOnSpawn = false

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main UI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

---------------------------------------------------------
-- Circular Floating Toggle Button
---------------------------------------------------------
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 15, 0.5, -25)
OpenButton.Image = "rbxassetid://135995313313068"
OpenButton.BackgroundTransparency = 1
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.Parent = ScreenGui

local openCorner = Instance.new("UICorner", OpenButton)
openCorner.CornerRadius = UDim.new(1, 0)

local openStroke = Instance.new("UIStroke", OpenButton)
openStroke.Color = Color3.fromRGB(150, 0, 255)
openStroke.Thickness = 2

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

---------------------------------------------------------
-- Top Header Logo, Title & Close Button
---------------------------------------------------------
local MainLogo = Instance.new("ImageLabel")
MainLogo.Name = "MainLogo"
MainLogo.Size = UDim2.new(0, 35, 0, 35)
MainLogo.Position = UDim2.new(0, 10, 0, 8)
MainLogo.Image = "rbxassetid://133870737244711"
MainLogo.BackgroundTransparency = 1
MainLogo.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 35)
Title.Position = UDim2.new(0, 50, 0, 8)
Title.Text = "JERRY v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 10)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Parent = MainFrame

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Sidebar Section
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Container for Pages
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -125, 1, -60)
PageContainer.Position = UDim2.new(0, 120, 0, 55)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- Page Instances
local InfoPage = Instance.new("Frame", PageContainer)
InfoPage.Size = UDim2.new(1, 0, 1, 0)
InfoPage.BackgroundTransparency = 1
InfoPage.Visible = true

local StealPage = Instance.new("Frame", PageContainer)
StealPage.Size = UDim2.new(1, 0, 1, 0)
StealPage.BackgroundTransparency = 1
StealPage.Visible = false

local EmotePage = Instance.new("Frame", PageContainer)
EmotePage.Size = UDim2.new(1, 0, 1, 0)
EmotePage.BackgroundTransparency = 1

local AnimPage = Instance.new("Frame", PageContainer)
AnimPage.Size = UDim2.new(1, 0, 1, 0)
AnimPage.BackgroundTransparency = 1

-- Booster Page
local BoosterPage = Instance.new("Frame", PageContainer)
BoosterPage.Name = "BoosterPage"
BoosterPage.Size = UDim2.new(1, 0, 1, 0)
BoosterPage.BackgroundTransparency = 1
BoosterPage.Visible = false

local function hideAllPages()
    InfoPage.Visible = false
    StealPage.Visible = false
    BoosterPage.Visible = false
end

-- Tab Button Generator
local function createTabBtn(name, pos, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.Parent = Sidebar
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        hideAllPages()
        page.Visible = true
    end)
end

createTabBtn("Info", 10, InfoPage)
createTabBtn("Steal", 50, StealPage)
createTabBtn("Booster", 90, BoosterPage)

---------------------------------------------------------
-- PAGE: BOOSTER
-- Client-side graphics optimization only.
---------------------------------------------------------

local BoosterTitle = Instance.new("TextLabel", BoosterPage)
BoosterTitle.Size = UDim2.new(1, -20, 0, 35)
BoosterTitle.Position = UDim2.new(0, 10, 0, 5)
BoosterTitle.BackgroundTransparency = 1
BoosterTitle.Text = "JERRY FPS BOOST"
BoosterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BoosterTitle.Font = Enum.Font.SourceSansBold
BoosterTitle.TextSize = 20
BoosterTitle.TextXAlignment = Enum.TextXAlignment.Left

local BoosterFPS = Instance.new("TextLabel", BoosterPage)
BoosterFPS.Size = UDim2.new(1, -20, 0, 38)
BoosterFPS.Position = UDim2.new(0, 10, 0, 42)
BoosterFPS.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BoosterFPS.Text = "FPS: --"
BoosterFPS.TextColor3 = Color3.fromRGB(80, 255, 140)
BoosterFPS.Font = Enum.Font.SourceSansBold
BoosterFPS.TextSize = 18
Instance.new("UICorner", BoosterFPS).CornerRadius = UDim.new(0, 6)

local BoosterStatus = Instance.new("TextLabel", BoosterPage)
BoosterStatus.Size = UDim2.new(1, -20, 0, 25)
BoosterStatus.Position = UDim2.new(0, 10, 0, 85)
BoosterStatus.BackgroundTransparency = 1
BoosterStatus.Text = "Mode: NONE"
BoosterStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
BoosterStatus.Font = Enum.Font.SourceSans
BoosterStatus.TextSize = 14
BoosterStatus.TextXAlignment = Enum.TextXAlignment.Left

local BoosterSaved = {}
local BoosterMode = "NONE"

local function boosterSave(obj, property)
    if not obj then return end
    BoosterSaved[obj] = BoosterSaved[obj] or {}
    if BoosterSaved[obj][property] == nil then
        pcall(function()
            BoosterSaved[obj][property] = obj[property]
        end)
    end
end

local function boosterSet(obj, property, value)
    if not obj then return end
    boosterSave(obj, property)
    pcall(function()
        obj[property] = value
    end)
end

local function boosterCommon()
    boosterSet(Lighting, "GlobalShadows", false)
    boosterSet(Lighting, "EnvironmentDiffuseScale", 0)
    boosterSet(Lighting, "EnvironmentSpecularScale", 0)

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") then
            boosterSet(obj, "Enabled", false)
        end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Beam") then
            boosterSet(obj, "Enabled", false)

        elseif obj:IsA("PointLight")
        or obj:IsA("SpotLight")
        or obj:IsA("SurfaceLight") then
            boosterSet(obj, "Enabled", false)

        elseif obj:IsA("BasePart") then
            boosterSet(obj, "CastShadow", false)
        end
    end
end

local function boosterLow()
    boosterCommon()
    BoosterMode = "LOW"
    BoosterStatus.Text = "Mode: LOW"
end

local function boosterExtreme()
    boosterCommon()

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            boosterSet(obj, "Material", Enum.Material.SmoothPlastic)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            boosterSet(obj, "Transparency", 1)
        end
    end

    BoosterMode = "EXTREME"
    BoosterStatus.Text = "Mode: EXTREME"
end

local function boosterUltra()
    boosterCommon()

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            boosterSet(obj, "Material", Enum.Material.SmoothPlastic)
            boosterSet(obj, "Reflectance", 0)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            boosterSet(obj, "Transparency", 1)
        end
    end

    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        boosterSet(terrain, "Decoration", false)
        boosterSet(terrain, "WaterWaveSize", 0)
        boosterSet(terrain, "WaterWaveSpeed", 0)
        boosterSet(terrain, "WaterReflectance", 0)
    end

    BoosterMode = "ULTRA"
    BoosterStatus.Text = "Mode: ULTRA"
end

local function boosterRestore()
    for obj, properties in pairs(BoosterSaved) do
        if obj then
            for property, value in pairs(properties) do
                pcall(function()
                    obj[property] = value
                end)
            end
        end
    end

    table.clear(BoosterSaved)
    BoosterMode = "NONE"
    BoosterStatus.Text = "Mode: NONE"
end

local function boosterButton(text, y, callback)
    local btn = Instance.new("TextButton", BoosterPage)
    btn.Size = UDim2.new(1, -20, 0, 34)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
end

boosterButton("LOW", 118, boosterLow)
boosterButton("EXTREME", 158, boosterExtreme)
boosterButton("ULTRA", 198, boosterUltra)
boosterButton("RESTORE", 238, boosterRestore)

local BoosterHint = Instance.new("TextLabel", BoosterPage)
BoosterHint.Size = UDim2.new(1, -20, 0, 45)
BoosterHint.Position = UDim2.new(0, 10, 0, 280)
BoosterHint.BackgroundTransparency = 1
BoosterHint.Text = "Client graphics optimizer • RESTORE returns settings changed by Booster"
BoosterHint.TextColor3 = Color3.fromRGB(140, 140, 140)
BoosterHint.Font = Enum.Font.SourceSans
BoosterHint.TextSize = 12
BoosterHint.TextWrapped = true
BoosterHint.TextXAlignment = Enum.TextXAlignment.Left
BoosterHint.TextYAlignment = Enum.TextYAlignment.Top

-- FPS counter
local boosterFrames = 0
local boosterLast = tick()

RunService.RenderStepped:Connect(function()
    boosterFrames += 1
    local now = tick()

    if now - boosterLast >= 1 then
        BoosterFPS.Text = "FPS: " .. boosterFrames
        boosterFrames = 0
        boosterLast = now
    end
end)

---------------------------------------------------------
-- PAGE: STEAL
-- Safe UI toggle only; does not activate or modify prompts.
---------------------------------------------------------

-- 0.0s ProximityPrompt setting (for prompts owned by this UI's game)
local PromptToggleFrame = Instance.new("Frame", StealPage)
PromptToggleFrame.Size = UDim2.new(1, -20, 0, 45)
PromptToggleFrame.Position = UDim2.new(0, 10, 0, 55)
PromptToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", PromptToggleFrame).CornerRadius = UDim.new(0, 6)

local PromptLabel = Instance.new("TextLabel", PromptToggleFrame)
PromptLabel.Size = UDim2.new(1, -70, 1, 0)
PromptLabel.Position = UDim2.new(0, 12, 0, 0)
PromptLabel.BackgroundTransparency = 1
PromptLabel.Text = "ProximityPrompt 0.0s"
PromptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PromptLabel.Font = Enum.Font.SourceSansBold
PromptLabel.TextSize = 15
PromptLabel.TextXAlignment = Enum.TextXAlignment.Left

local PromptToggle = Instance.new("TextButton", PromptToggleFrame)
PromptToggle.Size = UDim2.new(0, 45, 0, 24)
PromptToggle.Position = UDim2.new(1, -55, 0.5, -12)
PromptToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
PromptToggle.Text = ""
Instance.new("UICorner", PromptToggle).CornerRadius = UDim.new(1, 0)

local PromptEnabled = false

PromptToggle.MouseButton1Click:Connect(function()
    PromptEnabled = not PromptEnabled
    PromptToggle.BackgroundColor3 = PromptEnabled
        and Color3.fromRGB(46, 204, 113)
        or Color3.fromRGB(70, 70, 70)
end)

local StealTitle = Instance.new("TextLabel", StealPage)
StealTitle.Size = UDim2.new(1, -20, 0, 35)
StealTitle.Position = UDim2.new(0, 10, 0, 10)
StealTitle.BackgroundTransparency = 1
StealTitle.Text = "Steal"
StealTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
StealTitle.Font = Enum.Font.SourceSansBold
StealTitle.TextSize = 20
StealTitle.TextXAlignment = Enum.TextXAlignment.Left

local PromptFrame = Instance.new("Frame", StealPage)
PromptFrame.Size = UDim2.new(1, -20, 0, 45)
PromptFrame.Position = UDim2.new(0, 10, 0, 55)
PromptFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", PromptFrame).CornerRadius = UDim.new(0, 6)

local PromptLabel = Instance.new("TextLabel", PromptFrame)
PromptLabel.Size = UDim2.new(1, -70, 1, 0)
PromptLabel.Position = UDim2.new(0, 12, 0, 0)
PromptLabel.BackgroundTransparency = 1
PromptLabel.Text = "ProximityPrompt"
PromptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PromptLabel.Font = Enum.Font.SourceSansBold
PromptLabel.TextSize = 15
PromptLabel.TextXAlignment = Enum.TextXAlignment.Left

local PromptToggle = Instance.new("TextButton", PromptFrame)
PromptToggle.Size = UDim2.new(0, 45, 0, 24)
PromptToggle.Position = UDim2.new(1, -55, 0.5, -12)
PromptToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
PromptToggle.Text = ""
Instance.new("UICorner", PromptToggle).CornerRadius = UDim.new(1, 0)

local PromptEnabled = false

PromptToggle.MouseButton1Click:Connect(function()
    PromptEnabled = not PromptEnabled
    PromptToggle.BackgroundColor3 = PromptEnabled
        and Color3.fromRGB(46, 204, 113)
        or Color3.fromRGB(70, 70, 70)
end)

local PromptStatus = Instance.new("TextLabel", StealPage)
PromptStatus.Size = UDim2.new(1, -20, 0, 30)
PromptStatus.Position = UDim2.new(0, 10, 0, 110)
PromptStatus.BackgroundTransparency = 1
PromptStatus.Text = "Status: OFF"
PromptStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
PromptStatus.Font = Enum.Font.SourceSans
PromptStatus.TextSize = 14
PromptStatus.TextXAlignment = Enum.TextXAlignment.Left

PromptToggle.MouseButton1Click:Connect(function()
    PromptStatus.Text = PromptEnabled and "Status: ON" or "Status: OFF"
end)

---------------------------------------------------------
-- PAGE 3: INFO
---------------------------------------------------------
local MyAvatar = Instance.new("ImageLabel")
MyAvatar.Size = UDim2.new(0, 85, 0, 85)
MyAvatar.Position = UDim2.new(0, 0, 0, 10)
MyAvatar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MyAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
MyAvatar.Parent = InfoPage
Instance.new("UICorner", MyAvatar).CornerRadius = UDim.new(0, 8)

local MyInfoText = Instance.new("TextLabel")
MyInfoText.Size = UDim2.new(1, -95, 0, 85)
MyInfoText.Position = UDim2.new(0, 95, 0, 10)
MyInfoText.Text = "Username: " .. LocalPlayer.Name .. "\nNickname: " .. LocalPlayer.DisplayName .. "\nAccount ID: " .. LocalPlayer.UserId
MyInfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
MyInfoText.TextXAlignment = Enum.TextXAlignment.Left
MyInfoText.TextYAlignment = Enum.TextYAlignment.Top
MyInfoText.BackgroundTransparency = 1
MyInfoText.Font = Enum.Font.SourceSans
MyInfoText.TextSize = 16
MyInfoText.Parent = InfoPage

---------------------------------------------------------
