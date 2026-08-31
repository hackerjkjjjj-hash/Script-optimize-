-- Jerry Hub v7.6 (Removed Player Fly & Added Coming Soon)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("Jerry Hub v7.6: Initializing...")

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Smart GUI Parent (Bypass CoreGui blocking)
local parentContainer = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

-- Clear old UI if exists
pcall(function()
    if parentContainer:FindFirstChild("JerryHubUltimate") then
        parentContainer.JerryHubUltimate:Destroy()
    end
    if player.PlayerGui:FindFirstChild("JerryHubUltimate") then
        player.PlayerGui.JerryHubUltimate:Destroy()
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Jerry Hub Ultimate"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = parentContainer

print("Jerry Hub v7.6: UI successfully injected!")

-- States
local boostConnections = {}
local fastModeConnections = {}

-- Backup original settings
local originalShadows = Lighting.GlobalShadows
local originalTech = Lighting.Technology
local terrain = Workspace:FindFirstChildOfClass("Terrain")
local originalDecoration = false
if terrain then pcall(function() originalDecoration = terrain.Decoration end) end

local effects = {}
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then effects[v] = v.Enabled end
end

--=========================================
-- 1. NORMAL OPTIMIZE
--=========================================
local function applyOptimize(state)
    if state then
        pcall(function() Lighting.GlobalShadows = false end)
        pcall(function() Lighting.Technology = Enum.LightingTechnology.Compatibility end)
        if terrain then pcall(function() terrain.Decoration = false end) end
        for effect, _ in pairs(effects) do
            pcall(function() if effect.Parent then effect.Enabled = false end end)
        end
    else
        pcall(function() Lighting.GlobalShadows = originalShadows end)
        pcall(function() Lighting.Technology = originalTech end)
        if terrain then pcall(function() terrain.Decoration = originalDecoration end) end
        for effect, enabled in pairs(effects) do
            pcall(function() if effect.Parent then effect.Enabled = enabled end end)
        end
    end
end

--=========================================
-- 2. CLEAR FPS BOOST
--=========================================
local function optimizeObject(v)
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
        pcall(function() v.Enabled = false end)
    elseif v:IsA("BasePart") then
        pcall(function() v.CastShadow = false end)
    end
end

local function applyBoost(state)
    if state then
        if terrain then
            pcall(function()
                terrain.WaterWaveSize = 0
                terrain.WaterTransparency = 0.5
            end)
        end
        for _, v in ipairs(Workspace:GetDescendants()) do
            optimizeObject(v)
        end
        local conn = Workspace.DescendantAdded:Connect(function(v)
            optimizeObject(v)
        end)
        table.insert(boostConnections, conn)
    else
        for _, conn in ipairs(boostConnections) do
            pcall(function() conn:Disconnect() end)
        end
        boostConnections = {}
        if terrain then
            pcall(function()
                terrain.WaterWaveSize = 0.5
                terrain.WaterTransparency = 0.6
            end)
        end
    end
end

--=========================================
-- 3. FAST MODE (Flat Graphics)
--=========================================
local function applyFastObject(v)
    if v:IsA("Decal") or v:IsA("Texture") then
        pcall(function() v.Transparency = 1 end)
    elseif v:IsA("BasePart") then
        pcall(function()
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end)
    elseif v:IsA("MeshPart") then
        pcall(function()
            v.TextureID = ""
            v.Material = Enum.Material.SmoothPlastic
        end)
    end
end

local function applyFastMode(state)
    if state then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        for _, v in ipairs(Workspace:GetDescendants()) do
            applyFastObject(v)
        end
        local conn = Workspace.DescendantAdded:Connect(function(v)
            applyFastObject(v)
        end)
        table.insert(fastModeConnections, conn)
    else
        for _, conn in ipairs(fastModeConnections) do
            pcall(function() conn:Disconnect() end)
        end
        fastModeConnections = {}
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
    end
end

--=========================================
-- FLOATING OPEN BUTTON (Wrench)
--=========================================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 52, 0, 52)
openBtn.Position = UDim2.new(0, 30, 0.4, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
openBtn.Text = "🔧"
openBtn.TextSize = 24
openBtn.Parent = screenGui

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(147, 51, 234)
openStroke.Thickness = 2
openStroke.Parent = openBtn

--=========================================
-- MAIN MENU (Compact & Draggable)
--=========================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 460, 0, 320)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 13, 22)
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(110, 40, 190)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Jerry Hub v7.6 • Optimized"
title.TextColor3 = Color3.fromRGB(220, 180, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

--=========================================
-- SIDEBAR TABS
--=========================================
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -55)
sidebar.Position = UDim2.new(0, 12, 0, 45)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = sidebar

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -145, 1, -55)
contentContainer.Position = UDim2.new(0, 138, 0, 45)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local mainPage = Instance.new("ScrollingFrame")
mainPage.Size = UDim2.new(1, 0, 1, 0)
mainPage.BackgroundTransparency = 1
mainPage.ScrollBarThickness = 3
mainPage.Visible = true
mainPage.Parent = contentContainer
Instance.new("UIListLayout", mainPage).Padding = UDim.new(0, 8)
mainPage.CanvasSize = UDim2.new(0, 0, 0, 200)

local playerPage = Instance.new("Frame")
playerPage.Size = UDim2.new(1, 0, 1, 0)
playerPage.BackgroundTransparency = 1
playerPage.Visible = false
playerPage.Parent = contentContainer

--=========================================
-- PLAYER PAGE - ESP UI
--=========================================

local espBoxEnabled = false
local espLineEnabled = false

local playerPageLayout = Instance.new("UIListLayout")
playerPageLayout.Padding = UDim.new(0, 8)
playerPageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
playerPageLayout.Parent = playerPage

-- Header Card
local playerHeader = Instance.new("Frame")
playerHeader.Size = UDim2.new(1, -4, 0, 55)
playerHeader.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
playerHeader.Parent = playerPage

Instance.new("UICorner", playerHeader).CornerRadius = UDim.new(0, 8)

local playerHeaderTitle = Instance.new("TextLabel")
playerHeaderTitle.Size = UDim2.new(1, -24, 0, 22)
playerHeaderTitle.Position = UDim2.new(0, 12, 0, 7)
playerHeaderTitle.BackgroundTransparency = 1
playerHeaderTitle.Text = "Player Visuals"
playerHeaderTitle.TextColor3 = Color3.fromRGB(220, 180, 255)
playerHeaderTitle.TextSize = 14
playerHeaderTitle.Font = Enum.Font.GothamBold
playerHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
playerHeaderTitle.Parent = playerHeader

local playerHeaderDesc = Instance.new("TextLabel")
playerHeaderDesc.Size = UDim2.new(1, -24, 0, 18)
playerHeaderDesc.Position = UDim2.new(0, 12, 0, 29)
playerHeaderDesc.BackgroundTransparency = 1
playerHeaderDesc.Text = "Visual feature controls"
playerHeaderDesc.TextColor3 = Color3.fromRGB(140, 130, 170)
playerHeaderDesc.TextSize = 10
playerHeaderDesc.Font = Enum.Font.Gotham
playerHeaderDesc.TextXAlignment = Enum.TextXAlignment.Left
playerHeaderDesc.Parent = playerHeader


-- Toggle Card Creator
local function createPlayerToggle(titleText, descText, callback)

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 62)
    card.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    card.Parent = playerPage

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 0, 19)
    titleLabel.Position = UDim2.new(0, 12, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = titleText
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -70, 0, 18)
    descLabel.Position = UDim2.new(0, 12, 0, 29)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = descText
    descLabel.TextColor3 = Color3.fromRGB(140, 130, 170)
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = card

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -54, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = card

    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = toggleBtn

    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local enabled = false

    toggleBtn.MouseButton1Click:Connect(function()

        enabled = not enabled

        local targetPosition

        if enabled then
            targetPosition = UDim2.new(1, -19, 0.5, -8)

            TweenService:Create(
                toggleBtn,
                TweenInfo.new(0.2),
                {
                    BackgroundColor3 = Color3.fromRGB(126, 34, 206)
                }
            ):Play()

        else
            targetPosition = UDim2.new(0, 3, 0.5, -8)

            TweenService:Create(
                toggleBtn,
                TweenInfo.new(0.2),
                {
                    BackgroundColor3 = Color3.fromRGB(45, 40, 60)
                }
            ):Play()
        end

        TweenService:Create(
            circle,
            TweenInfo.new(0.2),
            {
                Position = targetPosition
            }
        ):Play()

        callback(enabled)
    end)

    return card
end


-- ESP BOX
createPlayerToggle(
    "ESP Box",
    "Box visual control",
    function(state)
        espBoxEnabled = state

        print("ESP Box UI:", state and "ON" or "OFF")
    end
)


-- ESP LINE
createPlayerToggle(
    "ESP Line",
    "Line visual control",
    function(state)
        espLineEnabled = state

        print("ESP Line UI:", state and "ON" or "OFF")
    end
)

local function createTabBtn(name, icon, targetPage)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = (targetPage == mainPage) and Color3.fromRGB(126, 34, 206) or Color3.fromRGB(22, 18, 32)
    btn.Text = "  " .. icon .. "  " .. name
    btn.TextColor3 = (targetPage == mainPage) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 160, 200)
    btn.TextSize, btn.Font = 12, Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        mainPage.Visible = (targetPage == mainPage)
        playerPage.Visible = (targetPage == playerPage)
        for _, child in pairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
                child.TextColor3 = Color3.fromRGB(170, 160, 200)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(126, 34, 206)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

createTabBtn("Main", "🏠", mainPage)
createTabBtn("Players", "👤", playerPage)

--=========================================
-- POPULATE MAIN PAGE
--=========================================
local function createToggleCard(titleText, descText, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 56)
    card.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    card.Parent = mainPage
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local tL = Instance.new("TextLabel")
    tL.Size = UDim2.new(1, -60, 0, 18)
    tL.Position = UDim2.new(0, 12, 0, 9)
    tL.BackgroundTransparency = 1
    tL.Text = titleText
    tL.TextColor3 = Color3.fromRGB(255, 255, 255)
    tL.TextSize = 13
    tL.Font = Enum.Font.GothamBold
    tL.TextXAlignment = Enum.TextXAlignment.Left
    tL.Parent = card
    
    local dL = Instance.new("TextLabel")
    dL.Size = UDim2.new(1, -60, 0, 20)
    dL.Position = UDim2.new(0, 12, 0, 27)
    dL.BackgroundTransparency = 1
    dL.Text = descText
    dL.TextColor3 = Color3.fromRGB(140, 130, 170)
    dL.TextSize = 10
    dL.Font = Enum.Font.Gotham
    dL.TextXAlignment = Enum.TextXAlignment.Left
    dL.Parent = card
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 42, 0, 22)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    toggleBtn.Text = ""
    toggleBtn.Parent = card
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = toggleBtn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local isOn = false
    toggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        local goalPos = isOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local goalColor = isOn and Color3.fromRGB(126, 34, 206) or Color3.fromRGB(45, 40, 60)
        
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = goalPos}):Play()
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
        
        callback(isOn)
    end)
end

createToggleCard("Normal Optimize", "Disables shadows, lighting effects & terrain decoration.", function(state)
    applyOptimize(state)
end)

createToggleCard("Clear FPS Boost", "Removes laggy particles & trails safely.", function(state)
    applyBoost(state)
end)

createToggleCard("Fast Mode (Flat Graphics)", "Removes textures & simplifies map for max FPS.", function(state)
    applyFastMode(state)
end)

--=========================================
-- DRAGGING LOGIC
--=========================================
local function makeDraggable(guiItem, dragHandle)
    local dragging, dragStart, startPos
    local hasDragged = false

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasDragged = false
            dragStart = input.Position
            startPos = guiItem.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 3 then hasDragged = true end
            guiItem.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return function() return hasDragged end
end

local wasDragged = makeDraggable(openBtn, openBtn)
openBtn.MouseButton1Click:Connect(function()
    if not wasDragged() then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

makeDraggable(mainFrame, topBar)

print("Jerry Hub v7.6 Fully Loaded Successfully!")
