-- Jerry Optimize 🔧 v4.0 (Pro Max + Anti-Cheat Safe Fly)
-- Performance Optimizer & Player Tracker

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Fix for Executors like Delta, Fluxus
local guiParent
if gethui then
    guiParent = gethui()
else
    local success = pcall(function() guiParent = game:GetService("CoreGui") end)
    if not success or not guiParent then
        guiParent = player:WaitForChild("PlayerGui")
    end
end

pcall(function()
    local old = guiParent:FindFirstChild("JerryOptimize")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "JerryOptimize"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

-- State
local optimizeOn = false
local boostOn = false
local isFlying = false

-- Original settings
local originalShadows = Lighting.GlobalShadows
local terrain = Workspace:FindFirstChildOfClass("Terrain")
local originalDecoration = false
if terrain then pcall(function() originalDecoration = terrain.Decoration end) end

local effects = {}
for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then effects[v] = v.Enabled end
end

-- Open button (Icon 🔧)
local open = Instance.new("TextButton")
open.Size = UDim2.fromOffset(50, 50)
open.Position = UDim2.new(0, 15, 0.5, -25)
open.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
open.Text = "🔧"
open.TextSize = 25
open.Font = Enum.Font.GothamBold
open.TextColor3 = Color3.new(1, 1, 1)
open.AutoButtonColor = true
open.Parent = gui
local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = open

-- Main menu (ពង្រីកទំហំដើម្បីដាក់ Button ថ្មី)
local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(360, 360) 
menu.Position = UDim2.new(0.5, -180, 0.5, -180)
menu.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
menu.BorderSizePixel = 0
menu.Visible = false 
menu.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = menu

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -20, 0, 48)
header.Position = UDim2.fromOffset(10, 5)
header.BackgroundTransparency = 1
header.Text = "Jerry Optimize 🔧 v4.0"
header.TextColor3 = Color3.fromRGB(255, 215, 0)
header.TextSize = 22
header.Font = Enum.Font.GothamBold
header.Parent = menu

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 25)
status.Position = UDim2.fromOffset(15, 52)
status.BackgroundTransparency = 1
status.Text = "Status: Ready"
status.TextColor3 = Color3.fromRGB(150, 255, 150)
status.TextSize = 14
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = menu

-- FPS
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -30, 0, 25)
fpsLabel.Position = UDim2.fromOffset(15, 76)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.TextSize = 14
fpsLabel.Font = Enum.Font.GothamSemibold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = menu

local function makeButton(text, y, parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -40, 0, 50)
    b.Position = UDim2.fromOffset(20, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 16
    b.Font = Enum.Font.GothamSemibold
    b.Parent = parent or menu
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = b
    return b
end

local optimizeButton = makeButton("Normal Optimize  [OFF]", 105)
local boostButton = makeButton("MAX FPS BOOST  [OFF]", 165)
boostButton.TextColor3 = Color3.fromRGB(255, 100, 100)
local tpMenuButton = makeButton("🎯 Open Player List", 225)
local stopFlyButton = makeButton("🛑 Stop Flying", 285)
stopFlyButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
stopFlyButton.Visible = false -- លាក់សិន ឃើញតែពេលកំពុងហោះ

--=========================================
-- ផ្ទាំងថ្មី សម្រាប់បញ្ជីអ្នកលេង (Player List Menu)
--=========================================
local tpFrame = Instance.new("Frame")
tpFrame.Size = UDim2.fromOffset(360, 360)
tpFrame.Position = UDim2.new(1, 10, 0, 0) -- លេចចេញនៅខាងស្តាំ Main Menu
tpFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 25)
tpFrame.BorderSizePixel = 0
tpFrame.Visible = false
tpFrame.Parent = menu
local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 16)
tpCorner.Parent = tpFrame

local tpHeader = Instance.new("TextLabel")
tpHeader.Size = UDim2.new(1, -20, 0, 48)
tpHeader.Position = UDim2.fromOffset(10, 5)
tpHeader.BackgroundTransparency = 1
tpHeader.Text = "👥 Select a Player"
tpHeader.TextColor3 = Color3.fromRGB(100, 200, 255)
tpHeader.TextSize = 20
tpHeader.Font = Enum.Font.GothamBold
tpHeader.Parent = tpFrame

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.fromOffset(80, 30)
refreshBtn.Position = UDim2.new(1, -95, 0, 15)
refreshBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
refreshBtn.Text = "Refresh"
refreshBtn.TextColor3 = Color3.new(1,1,1)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.Parent = tpFrame
local refCorner = Instance.new("UICorner")
refCorner.CornerRadius = UDim.new(0, 6)
refCorner.Parent = refreshBtn

local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(1, -20, 1, -65)
scrollList.Position = UDim2.fromOffset(10, 55)
scrollList.BackgroundTransparency = 1
scrollList.ScrollBarThickness = 6
scrollList.Parent = tpFrame
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollList

tpMenuButton.MouseButton1Click:Connect(function()
    tpFrame.Visible = not tpFrame.Visible
end)

--=========================================
-- មុខងារ Bypass Anti-Cheat Safe Fly
--=========================================
local flyTween, noclipLoop

local function stopFlying()
    if flyTween then
        flyTween:Cancel()
        flyTween = nil
    end
    if noclipLoop then
        noclipLoop:Disconnect()
        noclipLoop = nil
    end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Anchored = false
    end
    isFlying = false
    stopFlyButton.Visible = false
    status.Text = "Status: Flight Stopped."
end

local function flyToTarget(targetName)
    local targetPlr = Players:FindFirstChild(targetName)
    if not targetPlr or not targetPlr.Character or not targetPlr.Character:FindFirstChild("HumanoidRootPart") then 
        status.Text = "Status: Player not found or dead!"
        return 
    end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = player.Character.HumanoidRootPart
    local targetHrp = targetPlr.Character.HumanoidRootPart

    -- ការពារ Anti-Cheat ដោយប្រើ TweenService
    local distance = (hrp.Position - targetHrp.Position).Magnitude
    local speed = 150 -- ល្បឿនសុវត្ថិភាព (Studs ក្នុង ១ វិនាទី) (បើដាក់លឿនពេក AC អាចទាត់)
    local flyTime = distance / speed
    
    if flyTime < 0.5 then flyTime = 0.5 end -- ការពារ Error ពេលនៅជិតពេក

    local tweenInfo = TweenInfo.new(flyTime, Enum.EasingStyle.Linear)
    -- ហោះទៅពីក្រោយខ្នងគេបន្តិច ដើម្បីកុំឲ្យបុកគ្នា
    local targetGoal = targetHrp.CFrame * CFrame.new(0, 0, 3) 
    
    flyTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetGoal})

    -- ចាប់ផ្តើម Noclip (ដើរធ្លុះ) និង Anchor
    isFlying = true
    stopFlyButton.Visible = true
    hrp.Anchored = true -- ការពារកុំឲ្យ Fall Damage និង Physics Anti-Cheat
    
    noclipLoop = RunService.Stepped:Connect(function()
        if player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)

    status.Text = "Status: Flying to " .. targetName .. "..."
    flyTween:Play()

    flyTween.Completed:Connect(function()
        stopFlying()
        status.Text = "Status: Arrived at " .. targetName
    end)
end

stopFlyButton.MouseButton1Click:Connect(stopFlying)

--=========================================
-- មុខងារ Scan អ្នកលេងចូលក្នុងបញ្ជី
--=========================================
local function loadPlayers()
    for _, child in pairs(scrollList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then -- កុំដាក់ឈ្មោះខ្លួនឯង
            count += 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
            btn.Text = "  " .. p.Name .. " (@" .. p.DisplayName .. ")"
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 14
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = scrollList
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn

            btn.MouseButton1Click:Connect(function()
                if not isFlying then
                    flyToTarget(p.Name)
                end
            end)
        end
    end
    scrollList.CanvasSize = UDim2.new(0, 0, 0, count * 45)
end

refreshBtn.MouseButton1Click:Connect(loadPlayers)
loadPlayers() -- លោតចូលហ្គេមភ្លាម Scan ភ្លាម

--=========================================
-- មុខងារ Optimize ដដែល
--=========================================
local function applyOptimize()
    pcall(function() Lighting.GlobalShadows = false end)
    pcall(function() if terrain then terrain.Decoration = false end end)
    for effect, _ in pairs(effects) do
        pcall(function() if effect.Parent then effect.Enabled = false end end)
    end
end
local function restoreOptimize()
    pcall(function() Lighting.GlobalShadows = originalShadows end)
    pcall(function() if terrain then terrain.Decoration = originalDecoration end end)
    for effect, enabled in pairs(effects) do
        pcall(function() if effect.Parent then effect.Enabled = enabled end end)
    end
end

optimizeButton.MouseButton1Click:Connect(function()
    optimizeOn = not optimizeOn
    if optimizeOn then
        applyOptimize()
        optimizeButton.Text = "Normal Optimize  [ON]"
        optimizeButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        status.Text = "Status: Optimized"
    else
        restoreOptimize()
        optimizeButton.Text = "Normal Optimize  [OFF]"
        optimizeButton.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
        status.Text = "Status: Ready"
    end
end)

boostButton.MouseButton1Click:Connect(function()
    if not boostOn then
        boostOn = true
        boostButton.Text = "MAX FPS BOOST  [ON]"
        boostButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "Status: Applying MAX Boost..."
        task.wait(0.1)
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false Lighting.FogEnd = 9e9
            Lighting.Brightness = 1 Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
        end)
        task.spawn(function()
            local c = 0
            for _, obj in pairs(Workspace:GetDescendants()) do
                c += 1 if c % 1000 == 0 then task.wait() end
                if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic obj.Reflectance = 0 obj.CastShadow = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
                    pcall(function() obj.Transparency = 1 end) pcall(function() obj.Enabled = false end)
                end
            end
            status.Text = "Status: MAX FPS BOOST ACTIVE!"
        end)
    else
        status.Text = "Status: Rejoin to disable MAX Boost!"
        task.wait(2) status.Text = "Status: MAX FPS BOOST ACTIVE!"
    end
end)

-- FPS Counter
local frames, lastTime = 0, os.clock()
RunService.RenderStepped:Connect(function()
    frames += 1 local now = os.clock()
    if now - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. frames
        frames = 0 lastTime = now
    end
end)

-- Dragging Logic (Open Button & Menu)
local function makeDraggable(guiItem, dragHandle)
    local drag, start, pos, dragged
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag, dragged = true, false start, pos = input.Position, guiItem.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - start
            if delta.Magnitude > 5 then dragged = true guiItem.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y) end
        end
    end)
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    return function() return dragged end
end

local isBtnDragged = makeDraggable(open, open)
open.MouseButton1Click:Connect(function() if not isBtnDragged() then menu.Visible = not menu.Visible end end)
makeDraggable(menu, header)

UIS.InputBegan:Connect(function(input, p)
    if not p and input.KeyCode == Enum.KeyCode.K then menu.Visible = not menu.Visible end
end)

print("Jerry Optimize 🔧 v4.0 (Anti-Cheat Bypass Fly) Loaded!")
