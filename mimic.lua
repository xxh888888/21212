-- 这是一个模仿 script.lua 的 Lua 脚本
-- 该脚本复制了原始脚本的核心功能结构

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- 功能状态变量
local speedEnabled, currentSpeed = false, 50
local climbEnabled, climbConnection = false, nil
local flyEnabled, flyConnection, flySpeed = false, nil, 50
local spinEnabled, spinConnection, spinSpeed = false, nil, 50
local espEnabled, espConnection = false, nil
local playerCollisionEnabled, collisionConnection = false, nil
local aimbotEnabled, aimbotConnection = false, nil
local dodgeEnabled, dodgeConnection = false, nil
local orbitEnabled, orbitConnection = false, nil
local teleportEnabled, teleportConnection = false, nil

-- 创建主 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MimicUI"
gui.Parent = pgui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999

-- 创建菜单按钮
local menuButton = Instance.new("TextButton")
menuButton.Parent = gui
menuButton.Size = UDim2.new(0, 50, 0, 50)
menuButton.Position = UDim2.new(1, -70, 1, -70)
menuButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
menuButton.BackgroundTransparency = 0.1
menuButton.AutoButtonColor = false
menuButton.Text = "菜单"
menuButton.TextColor3 = Color3.new(1, 1, 1)
menuButton.TextSize = 14
menuButton.Font = Enum.Font.GothamBold
menuButton.ZIndex = 10000

-- 创建菜单面板
local menuPanel = Instance.new("Frame")
menuPanel.Parent = gui
menuPanel.Size = UDim2.new(0, 360, 0, 400)
menuPanel.Position = menuButton.Position + UDim2.new(0, 60, 0, 0)
menuPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuPanel.BackgroundTransparency = 0.1
menuPanel.BorderSizePixel = 0
menuPanel.Visible = false
menuPanel.ZIndex = 9999

-- 标题
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = menuPanel
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.BackgroundTransparency = 0.2
titleLabel.Text = "模仿脚本菜单"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.ZIndex = 10000

-- 菜单按钮点击事件
local menuVisible = false
menuButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    menuPanel.Visible = menuVisible
end)

-- 创建功能卡片函数
local function createFeatureButton(parent, name, yOffset)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, yOffset)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BackgroundTransparency = 0.3
    button.Text = name .. " [关闭]"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 13
    button.Font = Enum.Font.Gotham
    button.ZIndex = 10001
    
    return button
end

-- 创建功能按钮
local speedButton = createFeatureButton(menuPanel, "加速", 40)
local climbButton = createFeatureButton(menuPanel, "攀爬", 90)
local flyButton = createFeatureButton(menuPanel, "飞行", 140)
local spinButton = createFeatureButton(menuPanel, "旋转", 190)
local espButton = createFeatureButton(menuPanel, "内透", 240)
local collisionButton = createFeatureButton(menuPanel, "碰撞", 290)
local aimbotButton = createFeatureButton(menuPanel, "自瞄", 340)

-- 功能实现
local function toggleSpeed()
    speedEnabled = not speedEnabled
    speedButton.Text = "加速 [" .. (speedEnabled and "开启" or "关闭") .. "]"
    speedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedEnabled and currentSpeed or 16
        end
    end
end

local function toggleClimb()
    climbEnabled = not climbEnabled
    climbButton.Text = "攀爬 [" .. (climbEnabled and "开启" or "关闭") .. "]"
    climbButton.BackgroundColor3 = climbEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end

local function toggleFly()
    flyEnabled = not flyEnabled
    flyButton.Text = "飞行 [" .. (flyEnabled and "开启" or "关闭") .. "]"
    flyButton.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end

local function toggleSpin()
    spinEnabled = not spinEnabled
    spinButton.Text = "旋转 [" .. (spinEnabled and "开启" or "关闭") .. "]"
    spinButton.BackgroundColor3 = spinEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end

local function toggleESP()
    espEnabled = not espEnabled
    espButton.Text = "内透 [" .. (espEnabled and "开启" or "关闭") .. "]"
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end

local function toggleCollision()
    playerCollisionEnabled = not playerCollisionEnabled
    collisionButton.Text = "碰撞 [" .. (playerCollisionEnabled and "开启" or "关闭") .. "]"
    collisionButton.BackgroundColor3 = playerCollisionEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    aimbotButton.Text = "自瞄 [" .. (aimbotEnabled and "开启" or "关闭") .. "]"
    aimbotButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end

-- 绑定按钮事件
speedButton.MouseButton1Click:Connect(toggleSpeed)
climbButton.MouseButton1Click:Connect(toggleClimb)
flyButton.MouseButton1Click:Connect(toggleFly)
spinButton.MouseButton1Click:Connect(toggleSpin)
espButton.MouseButton1Click:Connect(toggleESP)
collisionButton.MouseButton1Click:Connect(toggleCollision)
aimbotButton.MouseButton1Click:Connect(toggleAimbot)

-- 加速功能循环
RunService.Heartbeat:Connect(function()
    if speedEnabled and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end
end)

print("✓ 模仿脚本已加载！")
