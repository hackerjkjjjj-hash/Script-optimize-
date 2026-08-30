-- Jerry Hub v7.0 (Fast Mode + Safe Slow Fly + Anti-Cheat Protection)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- Safe GUI Parent for Executors
local guiParent
local success, res = pcall(function() return gethui() end)
if success and res then
    guiParent = res
else
    guiParent = CoreGui
end

pcall(function()
    if guiParent:FindFirstChild("JerryHubComplete") then
        guiParent.JerryHubComplete:Destroy()
    end
    if player.PlayerGui:FindFirstChild("JerryHubComplete") then
        player.PlayerGui.JerryHubComplete:Destroy()
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JerryHubComplete"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentSuccess = pcall(function()
    screenGui.Parent = guiParent
end)
if not parentSuccess then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- States
local optimizeActive = false
local boostActive = false
local fastModeActive = false
local boostConnections = {}
local activeTween = nil

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
    optimizeActive = state
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
-- 2. CLEAR FPS BOOST (Keep Textures Clear)
--=========================================
local function optimizeObject(v)
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
        pcall(function() v.Enabled = false end)
    elseif v:IsA("BasePart") then
        pcall(function() v.CastShadow = false end)
    end
end

local function applyBoost(state)
    boostActive = state
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
            if boostActive then optimizeObject(v) end
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
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                pcall(function() v.Enabled = true end)
            elseif v:IsA("BasePart") then
                pcall(function() v.CastShadow = true end)
            end
        end
    end
end

--=========================================
-- 3. FAST MODE (Max Performance / Low Quality)
--=========================================
local function applyFastMode(state)
    fastModeActive = state
    if state then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                pcall(function() v.Transparency = 1 end)
            end
        end
    else
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                pcall(function() v.Transparency = 0 end)
            end
        end
    end
end

--=========================================
-- FLOATING OPEN BUTTON (Wrench)
--=========================================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 48, 0, 48)
openBtn.Position = UDim2.new(0, 20, 0.4, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
openBtn.Text = "🔧"
openBtn.TextSize = 22
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
title.Text = "Jerry Hub 🔧 • Fast Mode & Safe Fly"
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

local playerPage = Instance.new("ScrollingFrame")
playerPage.Size = UDim2.new(1, 0, 1, 0)
playerPage.BackgroundTransparency = 1
playerPage.ScrollBarThickness = 3
playerPage.Visible = false
playerPage.Parent = contentContainer
Instance.new("UIListLayout", playerPage).Padding = UDim.new(0, 6)

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

createToggleCard("Fast Mode (Max Speed)", "Lowers graphics & quality for maximum FPS.", function(state)
    applyFastMode(state)
end)

--=========================================
-- POPULATE PLAYER PAGE (Safe Slow Fly)
--=========================================
local pHeader = Instance.new("TextLabel")
pHeader.Size = UDim2.new(1, 0, 0, 20)
pHeader.BackgroundTransparency = 1
pHeader.Text = "👥 Click Player to Safe Smooth Fly:"
pHeader.TextColor3 = Color3.fromRGB(200, 160, 255)
pHeader.TextSize, pHeader.Font = 11, Enum.Font.GothamBold
pHeader.TextXAlignment = Enum.TextXAlignment.Left
pHeader.Parent = playerPage

-- កែសម្រួលល្បឿនឱ្យយឺតជាងមុន និងមានសុវត្ថិភាពការពារ Anti-Cheat ចាប់
local function safeFlyTo(targetPlr)
    if not targetPlr or not targetPlr.Character or not targetPlr.Character:FindFirstChild("HumanoidRootPart") then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = player.Character.HumanoidRootPart
    local targetHrp = targetPlr.Character.HumanoidRootPart

    if activeTween then activeTween:Cancel() end

    local distance = (hrp.Position - targetHrp.Position).Magnitude
    -- កែតម្រូវល្បឿន: ចែកនឹង 25 (ធ្វើឱ្យហោះយឺត និងរលូនជាងមុន មិនលឿនពេកធار Anti-Cheat ចាប់)
    local travelTime = math.clamp(distance / 25, 2, 10) 

    activeTween = TweenService:Create(hrp, TweenInfo.new(travelTime, Enum.EasingStyle.Sine), {
        CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
    })
    activeTween:Play()
end

local function loadPlayerList()
    for _, child in pairs(playerPage:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            count += 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -4, 0, 36)
            btn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
            btn.Text = "        " .. p.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize, btn.Font = 11, Enum.Font.GothamSemibold
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = playerPage
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            local avatar = Instance.new("ImageLabel")
            avatar.Size = UDim2.new(0, 26, 0, 26)
            avatar.Position = UDim2.new(0, 5, 0.5, -13)
            avatar.BackgroundColor3 = Color3.fromRGB(15, 13, 22)
            avatar.Parent = btn
            Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
            
            task.spawn(function()
                local success, img = pcall(function()
                    return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                end)
                if success and img then avatar.Image = img end
            end)

            btn.MouseButton1Click:Connect(function()
                safeFlyTo(p)
            end)
        end
    end
    playerPage.CanvasSize = UDim2.new(0, 0, 0, count * 40)
end

loadPlayerList()
Players.PlayerAdded:Connect(loadPlayerList)
Players.PlayerRemoving:Connect(loadPlayerList)

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

print("Jerry Hub v7.0 Loaded Successfully (Fast Mode Added & Safe Slow Fly)!")
