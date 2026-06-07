local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

local speedEnabled, originalWalkSpeed, currentSpeed = false, 16, 50
local climbEnabled, climbConnection = false, nil
local flyEnabled, flyConnection, flySpeed, flyControlPanel, moveDirection, moveConnections, originalMotor6DValues = false, nil, 50, nil, Vector3.zero, {}, {}
local spinEnabled, spinConnection, spinSpeed = false, nil, 50
local espEnabled, espConnection, espHighlights = false, nil, {}
local playerCollisionEnabled, collisionConnection = false, nil
local aimbotEnabled, aimbotConnection, aimbotRadius, aimbotActive = false, nil, 200, false
local dodgeEnabled, dodgeConnection, dodgeRadius = false, nil, 15
local orbitEnabled, orbitConnection, orbitRadius, orbitSpeed, orbitDistance, orbitTarget = false, nil, 20, 10, 5, nil
local aimTriggerVisible, aimTriggerMoving, aimTriggerPos, aimTriggerSize, aimStrength = false, false, UDim2.new(0.5, -100, 0.5, -100), 200, 1
local teleportEnabled, teleportWindow = false, nil
local followEnabled, followConnection, followTarget = false, nil, nil

local gui = Instance.new("ScreenGui")
gui.Name = "ProFloatUI"
gui.Parent = pgui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999

local ball = Instance.new("TextButton")
ball.Parent = gui
ball.Size = UDim2.new(0, 50, 0, 50)
ball.Position = UDim2.new(1, -70, 1, -70)
ball.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ball.BackgroundTransparency = 0.1
ball.AutoButtonColor = false
ball.Text = "菜单"
ball.TextColor3 = Color3.new(1, 1, 1)
ball.TextSize = 14
ball.Font = Enum.Font.GothamBold
ball.ZIndex = 10000

local menu = Instance.new("Frame")
menu.Parent = gui
menu.Size = UDim2.new(0, 360, 0, 380)
menu.Position = ball.Position + UDim2.new(0, 60, 0, 0)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.BackgroundTransparency = 0.1
menu.BorderSizePixel = 0
menu.Visible = false
menu.ClipsDescendants = true
menu.ZIndex = 9999

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = menu
scrollingFrame.Size = UDim2.new(1, -20, 1, -20)
scrollingFrame.Position = UDim2.new(0, 10, 0, 10)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
scrollingFrame.ScrollBarImageTransparency = 0.5
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local uiList = Instance.new("UIListLayout")
uiList.Parent = scrollingFrame
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment = Enum.VerticalAlignment.Top
uiList.Padding = UDim.new(0, 8)
uiList.SortOrder = Enum.SortOrder.LayoutOrder

local function createCard(parent, layoutOrder, height)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = UDim2.new(1, 0, 0, height)
    card.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.LayoutOrder = layoutOrder
    return card
end

local function createHeader(parent, title)
    local header = Instance.new("Frame")
    header.Parent = parent
    header.Size = UDim2.new(1, 0, 0, 25)
    header.Position = UDim2.new(0, 10, 0, 6)
    header.BackgroundTransparency = 1
    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    local toggle = Instance.new("TextButton", header)
    toggle.Size = UDim2.new(0, 50, 0, 22)
    toggle.Position = UDim2.new(1, -55, 0, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    toggle.AutoButtonColor = false
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.TextSize = 11
    toggle.Font = Enum.Font.GothamBold
    return header, toggle
end

local function createSlider(parent, min, max, default)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 28)
    container.BackgroundTransparency = 1
    local bg = Instance.new("Frame", container)
    bg.Size = UDim2.new(1, 0, 0, 5)
    bg.Position = UDim2.new(0, 0, 0, 10)
    bg.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    bg.BorderSizePixel = 0
    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.BorderSizePixel = 0
    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(0, 16, 0, 16)
    btn.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    btn.BackgroundColor3 = Color3.new(1, 1, 1)
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.ZIndex = 2
    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.Size = UDim2.new(1, 0, 0, 14)
    valueLabel.Position = UDim2.new(0, 0, 1, 2)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    return container, fill, btn, valueLabel
end

-- 自瞄红圈
local aimbotCircle = Instance.new("Frame", gui)
aimbotCircle.Size = UDim2.new(0, aimbotRadius * 2, 0, aimbotRadius * 2)
aimbotCircle.Position = UDim2.new(0.5, -aimbotRadius, 0.5, -aimbotRadius)
aimbotCircle.BackgroundTransparency = 1
aimbotCircle.Visible = false
aimbotCircle.ZIndex = 10000
local aimbotCircleStroke = Instance.new("UIStroke", aimbotCircle)
aimbotCircleStroke.Color = Color3.fromRGB(255, 0, 0)
aimbotCircleStroke.Transparency = 0.3
aimbotCircleStroke.Thickness = 2

-- 自瞄触发按钮（Active = false 穿透点击）
local aimTriggerBtn = Instance.new("TextButton", gui)
aimTriggerBtn.Size = UDim2.new(0, aimTriggerSize, 0, aimTriggerSize)
aimTriggerBtn.Position = aimTriggerPos
aimTriggerBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
aimTriggerBtn.BackgroundTransparency = 0.8
aimTriggerBtn.BorderSizePixel = 0
aimTriggerBtn.Text = ""
aimTriggerBtn.Visible = false
aimTriggerBtn.ZIndex = 10001
aimTriggerBtn.Active = false
local aimTriggerStroke = Instance.new("UIStroke", aimTriggerBtn)
aimTriggerStroke.Color = Color3.fromRGB(255, 50, 50)
aimTriggerStroke.Transparency = 0.2
aimTriggerStroke.Thickness = 3
local aimTriggerLabel = Instance.new("TextLabel", aimTriggerBtn)
aimTriggerLabel.Size = UDim2.new(1, 0, 0, 20)
aimTriggerLabel.Position = UDim2.new(0, 0, 0.5, -10)
aimTriggerLabel.BackgroundTransparency = 1
aimTriggerLabel.Text = "按住自瞄"
aimTriggerLabel.TextColor3 = Color3.new(1, 1, 1)
aimTriggerLabel.TextSize = 14
aimTriggerLabel.Font = Enum.Font.GothamBold

-- 卡片创建
local speedCard = createCard(scrollingFrame, 1, 100)
local speedHeader, speedToggle = createHeader(speedCard, "加速")
local speedDisplay = Instance.new("TextLabel", speedCard)
speedDisplay.Size = UDim2.new(1, -20, 0, 18)
speedDisplay.Position = UDim2.new(0, 10, 0, 34)
speedDisplay.BackgroundTransparency = 1
speedDisplay.Text = "速度: 16"
speedDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
speedDisplay.TextSize = 13
speedDisplay.Font = Enum.Font.Gotham
speedDisplay.TextXAlignment = Enum.TextXAlignment.Left
local speedSlider, speedFill, speedBtn, speedValue = createSlider(speedCard, 16, 1000, 50)
speedSlider.Position = UDim2.new(0, 10, 0, 60)

local climbCard = createCard(scrollingFrame, 2, 42)
local climbHeader, climbToggle = createHeader(climbCard, "强制攀爬")

local flyCard = createCard(scrollingFrame, 3, 130)
local flyHeader, flyToggle = createHeader(flyCard, "飞行模式")
local flySpeedDisplay = Instance.new("TextLabel", flyCard)
flySpeedDisplay.Size = UDim2.new(1, -20, 0, 18)
flySpeedDisplay.Position = UDim2.new(0, 10, 0, 34)
flySpeedDisplay.BackgroundTransparency = 1
flySpeedDisplay.Text = "飞行速度: 50"
flySpeedDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
flySpeedDisplay.TextSize = 13
flySpeedDisplay.Font = Enum.Font.Gotham
flySpeedDisplay.TextXAlignment = Enum.TextXAlignment.Left
local flySpeedSlider, flySpeedFill, flySpeedBtn, flySpeedValue = createSlider(flyCard, 10, 500, 50)
flySpeedSlider.Position = UDim2.new(0, 10, 0, 56)
local flyPanelSizeDisplay = Instance.new("TextLabel", flyCard)
flyPanelSizeDisplay.Size = UDim2.new(1, -20, 0, 18)
flyPanelSizeDisplay.Position = UDim2.new(0, 10, 0, 88)
flyPanelSizeDisplay.BackgroundTransparency = 1
flyPanelSizeDisplay.Text = "面板大小: 100"
flyPanelSizeDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
flyPanelSizeDisplay.TextSize = 13
flyPanelSizeDisplay.Font = Enum.Font.Gotham
flyPanelSizeDisplay.TextXAlignment = Enum.TextXAlignment.Left
local flyPanelSizeSlider, flyPanelSizeFill, flyPanelSizeBtn, flyPanelSizeValue = createSlider(flyCard, 80, 200, 100)
flyPanelSizeSlider.Position = UDim2.new(0, 10, 0, 110)

local spinCard = createCard(scrollingFrame, 4, 100)
local spinHeader, spinToggle = createHeader(spinCard, "陀螺旋转")
local spinSpeedDisplay = Instance.new("TextLabel", spinCard)
spinSpeedDisplay.Size = UDim2.new(1, -20, 0, 18)
spinSpeedDisplay.Position = UDim2.new(0, 10, 0, 34)
spinSpeedDisplay.BackgroundTransparency = 1
spinSpeedDisplay.Text = "转速: 50"
spinSpeedDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
spinSpeedDisplay.TextSize = 13
spinSpeedDisplay.Font = Enum.Font.Gotham
spinSpeedDisplay.TextXAlignment = Enum.TextXAlignment.Left
local spinSlider, spinFill, spinBtn, spinValue = createSlider(spinCard, 1, 1000, 50)
spinSlider.Position = UDim2.new(0, 10, 0, 56)

local espCard = createCard(scrollingFrame, 5, 42)
local espHeader, espToggle = createHeader(espCard, "人物内透")

local collisionCard = createCard(scrollingFrame, 6, 42)
local collisionHeader, collisionToggle = createHeader(collisionCard, "强制碰撞")

local aimbotCard = createCard(scrollingFrame, 7, 195)
local aimbotHeader, aimbotToggle = createHeader(aimbotCard, "人物自瞄")
local aimTriggerToggle = Instance.new("TextButton", aimbotCard)
aimTriggerToggle.Size = UDim2.new(1, -20, 0, 22)
aimTriggerToggle.Position = UDim2.new(0, 10, 0, 34)
aimTriggerToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
aimTriggerToggle.AutoButtonColor = false
aimTriggerToggle.Text = "显示触发: 关"
aimTriggerToggle.TextColor3 = Color3.new(1, 1, 1)
aimTriggerToggle.TextSize = 12
aimTriggerToggle.Font = Enum.Font.GothamBold
aimTriggerToggle.ZIndex = 10001
local aimTriggerMoveBtn = Instance.new("TextButton", aimbotCard)
aimTriggerMoveBtn.Size = UDim2.new(1, -20, 0, 22)
aimTriggerMoveBtn.Position = UDim2.new(0, 10, 0, 60)
aimTriggerMoveBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
aimTriggerMoveBtn.AutoButtonColor = false
aimTriggerMoveBtn.Text = "触发移动: 关"
aimTriggerMoveBtn.TextColor3 = Color3.new(1, 1, 1)
aimTriggerMoveBtn.TextSize = 12
aimTriggerMoveBtn.Font = Enum.Font.GothamBold
aimTriggerMoveBtn.ZIndex = 10001
local aimbotRadiusDisplay = Instance.new("TextLabel", aimbotCard)
aimbotRadiusDisplay.Size = UDim2.new(1, -20, 0, 18)
aimbotRadiusDisplay.Position = UDim2.new(0, 10, 0, 88)
aimbotRadiusDisplay.BackgroundTransparency = 1
aimbotRadiusDisplay.Text = "自瞄范围: 200"
aimbotRadiusDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
aimbotRadiusDisplay.TextSize = 12
aimbotRadiusDisplay.Font = Enum.Font.Gotham
aimbotRadiusDisplay.TextXAlignment = Enum.TextXAlignment.Left
local aimbotSlider, aimbotFill, aimbotBtn, aimRadiusValue = createSlider(aimbotCard, 50, 500, 200)
aimbotSlider.Position = UDim2.new(0, 10, 0, 110)
local aimTriggerSizeDisplay = Instance.new("TextLabel", aimbotCard)
aimTriggerSizeDisplay.Size = UDim2.new(1, -20, 0, 18)
aimTriggerSizeDisplay.Position = UDim2.new(0, 10, 0, 142)
aimTriggerSizeDisplay.BackgroundTransparency = 1
aimTriggerSizeDisplay.Text = "触发大小: 200"
aimTriggerSizeDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
aimTriggerSizeDisplay.TextSize = 12
aimTriggerSizeDisplay.Font = Enum.Font.Gotham
aimTriggerSizeDisplay.TextXAlignment = Enum.TextXAlignment.Left
local aimTriggerSizeSlider, aimTriggerSizeFill, aimTriggerSizeBtn, _ = createSlider(aimbotCard, 80, 400, 200)
aimTriggerSizeSlider.Position = UDim2.new(0, 10, 0, 164)

local dodgeCard = createCard(scrollingFrame, 8, 100)
local dodgeHeader, dodgeToggle = createHeader(dodgeCard, "人物躲避")
local dodgeRadiusDisplay = Instance.new("TextLabel", dodgeCard)
dodgeRadiusDisplay.Size = UDim2.new(1, -20, 0, 18)
dodgeRadiusDisplay.Position = UDim2.new(0, 10, 0, 34)
dodgeRadiusDisplay.BackgroundTransparency = 1
dodgeRadiusDisplay.Text = "躲避范围: 15"
dodgeRadiusDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
dodgeRadiusDisplay.TextSize = 13
dodgeRadiusDisplay.Font = Enum.Font.Gotham
dodgeRadiusDisplay.TextXAlignment = Enum.TextXAlignment.Left
local dodgeSlider, dodgeFill, dodgeBtn, dodgeValue = createSlider(dodgeCard, 5, 50, 15)
dodgeSlider.Position = UDim2.new(0, 10, 0, 56)

local orbitCard = createCard(scrollingFrame, 9, 175)
local orbitHeader, orbitToggle = createHeader(orbitCard, "围绕旋转")
local orbitRadiusDisplay = Instance.new("TextLabel", orbitCard)
orbitRadiusDisplay.Size = UDim2.new(1, -20, 0, 18)
orbitRadiusDisplay.Position = UDim2.new(0, 10, 0, 34)
orbitRadiusDisplay.BackgroundTransparency = 1
orbitRadiusDisplay.Text = "检测范围: 20"
orbitRadiusDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
orbitRadiusDisplay.TextSize = 12
orbitRadiusDisplay.Font = Enum.Font.Gotham
orbitRadiusDisplay.TextXAlignment = Enum.TextXAlignment.Left
local orbitRadiusSlider, orbitRadiusFill, orbitRadiusBtn, _ = createSlider(orbitCard, 5, 50, 20)
orbitRadiusSlider.Position = UDim2.new(0, 10, 0, 56)
local orbitDistanceDisplay = Instance.new("TextLabel", orbitCard)
orbitDistanceDisplay.Size = UDim2.new(1, -20, 0, 18)
orbitDistanceDisplay.Position = UDim2.new(0, 10, 0, 88)
orbitDistanceDisplay.BackgroundTransparency = 1
orbitDistanceDisplay.Text = "围绕间距: 5"
orbitDistanceDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
orbitDistanceDisplay.TextSize = 12
orbitDistanceDisplay.Font = Enum.Font.Gotham
orbitDistanceDisplay.TextXAlignment = Enum.TextXAlignment.Left
local orbitDistanceSlider, orbitDistanceFill, orbitDistanceBtn, _ = createSlider(orbitCard, 2, 20, 5)
orbitDistanceSlider.Position = UDim2.new(0, 10, 0, 110)
local orbitSpeedDisplay = Instance.new("TextLabel", orbitCard)
orbitSpeedDisplay.Size = UDim2.new(1, -20, 0, 18)
orbitSpeedDisplay.Position = UDim2.new(0, 10, 0, 142)
orbitSpeedDisplay.BackgroundTransparency = 1
orbitSpeedDisplay.Text = "旋转速度: 10"
orbitSpeedDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
orbitSpeedDisplay.TextSize = 12
orbitSpeedDisplay.Font = Enum.Font.Gotham
orbitSpeedDisplay.TextXAlignment = Enum.TextXAlignment.Left
local orbitSpeedSlider, orbitSpeedFill, orbitSpeedBtn, _ = createSlider(orbitCard, 1, 100, 10)
orbitSpeedSlider.Position = UDim2.new(0, 10, 0, 164)

local teleportCard = createCard(scrollingFrame, 10, 42)
local teleportHeader, teleportToggle = createHeader(teleportCard, "传送玩家")

-- 更新函数
local function updateToggle(btn, state)
    btn.Text = state and "ON" or "OFF"
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end

local function updateSlider(fill, btn, value, min, max)
    local ratio = (value - min) / (max - min)
    fill.Size = UDim2.new(ratio, 0, 1, 0)
    btn.Position = UDim2.new(ratio, -8, 0.5, -8)
end

local function setSpeed(v)
    currentSpeed = math.clamp(v, 16, 1000)
    speedDisplay.Text = "速度: " .. currentSpeed
    speedValue.Text = tostring(currentSpeed)
    updateSlider(speedFill, speedBtn, currentSpeed, 16, 1000)
    if speedEnabled and player.Character then
        local h = player.Character:FindFirstChild("Humanoid")
        if h then h.WalkSpeed = currentSpeed end
    end
end

local function setFlySpeed(v)
    flySpeed = math.clamp(v, 10, 500)
    flySpeedDisplay.Text = "飞行速度: " .. flySpeed
    flySpeedValue.Text = tostring(flySpeed)
    updateSlider(flySpeedFill, flySpeedBtn, flySpeed, 10, 500)
end

local function setFlyPanelSize(v)
    v = math.clamp(v, 80, 200)
    flyPanelSizeDisplay.Text = "面板大小: " .. v
    flyPanelSizeValue.Text = tostring(v)
    updateSlider(flyPanelSizeFill, flyPanelSizeBtn, v, 80, 200)
    if flyControlPanel then flyControlPanel.Size = UDim2.new(0, v, 0, v * 1.6) end
end

local function setAimbotRadius(v)
    aimbotRadius = math.clamp(v, 50, 500)
    aimbotRadiusDisplay.Text = "自瞄范围: " .. aimbotRadius
    aimRadiusValue.Text = tostring(aimbotRadius)
    updateSlider(aimbotFill, aimbotBtn, aimbotRadius, 50, 500)
    aimbotCircle.Size = UDim2.new(0, aimbotRadius * 2, 0, aimbotRadius * 2)
    aimbotCircle.Position = UDim2.new(0.5, -aimbotRadius, 0.5, -aimbotRadius)
end

local function setAimTriggerSize(v)
    aimTriggerSize = math.clamp(v, 80, 400)
    aimTriggerSizeDisplay.Text = "触发大小: " .. aimTriggerSize
    updateSlider(aimTriggerSizeFill, aimTriggerSizeBtn, aimTriggerSize, 80, 400)
    aimTriggerBtn.Size = UDim2.new(0, aimTriggerSize, 0, aimTriggerSize)
end

local function setSpinSpeed(v)
    spinSpeed = math.clamp(v, 1, 1000)
    spinSpeedDisplay.Text = "转速: " .. spinSpeed
    spinValue.Text = tostring(spinSpeed)
    updateSlider(spinFill, spinBtn, spinSpeed, 1, 1000)
    if spinEnabled and player.Character then
        local rp = player.Character:FindFirstChild("HumanoidRootPart")
        if rp then
            local av = rp:FindFirstChild("SpinAngular")
            if av and av:IsA("BodyAngularVelocity") then av.AngularVelocity = Vector3.new(0, spinSpeed, 0) end
        end
    end
end

local function setDodgeRadius(v)
    dodgeRadius = math.clamp(v, 5, 50)
    dodgeRadiusDisplay.Text = "躲避范围: " .. dodgeRadius
    dodgeValue.Text = tostring(dodgeRadius)
    updateSlider(dodgeFill, dodgeBtn, dodgeRadius, 5, 50)
end

local function setOrbitRadius(v)
    orbitRadius = math.clamp(v, 5, 50)
    orbitRadiusDisplay.Text = "检测范围: " .. orbitRadius
    updateSlider(orbitRadiusFill, orbitRadiusBtn, orbitRadius, 5, 50)
end

local function setOrbitDistance(v)
    orbitDistance = math.clamp(v, 2, 20)
    orbitDistanceDisplay.Text = "围绕间距: " .. orbitDistance
    updateSlider(orbitDistanceFill, orbitDistanceBtn, orbitDistance, 2, 20)
end

local function setOrbitSpeed(v)
    orbitSpeed = math.clamp(v, 1, 100)
    orbitSpeedDisplay.Text = "旋转速度: " .. orbitSpeed
    updateSlider(orbitSpeedFill, orbitSpeedBtn, orbitSpeed, 1, 100)
end

-- 停止跟随功能
local function stopFollow()
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    followEnabled = false
    followTarget = nil
end

-- 传送玩家功能
local function createTeleportWindow()
    if teleportWindow then teleportWindow:Destroy() end
    stopFollow() -- 关闭窗口时停止跟随
    
    teleportWindow = Instance.new("Frame", gui)
    teleportWindow.Size = UDim2.new(0, 260, 0, 300)
    teleportWindow.Position = UDim2.new(0.5, -130, 0.5, -150)
    teleportWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    teleportWindow.BackgroundTransparency = 0.05
    teleportWindow.BorderSizePixel = 0
    teleportWindow.ZIndex = 10002
    
    -- 标题栏
    local titleBar = Instance.new("Frame", teleportWindow)
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 10003
    
    local titleText = Instance.new("TextLabel", titleBar)
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "玩家列表 - 传送"
    titleText.TextColor3 = Color3.new(1, 1, 1)
    titleText.TextSize = 15
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.ZIndex = 10003
    
    -- 提示标签
    local hintLabel = Instance.new("TextLabel", teleportWindow)
    hintLabel.Size = UDim2.new(1, -10, 0, 16)
    hintLabel.Position = UDim2.new(0, 5, 1, -20)
    hintLabel.BackgroundTransparency = 1
    hintLabel.Text = "点击=传送 | 长按=跟随"
    hintLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    hintLabel.TextSize = 11
    hintLabel.Font = Enum.Font.Gotham
    hintLabel.TextXAlignment = Enum.TextXAlignment.Center
    hintLabel.ZIndex = 10003
    
    -- 关闭按钮
    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -28, 0, 3)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 10003
    
    -- 玩家列表滚动框架
    local playerScrollingFrame = Instance.new("ScrollingFrame", teleportWindow)
    playerScrollingFrame.Size = UDim2.new(1, -10, 1, -70)
    playerScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
    playerScrollingFrame.BackgroundTransparency = 1
    playerScrollingFrame.ScrollBarThickness = 4
    playerScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
    playerScrollingFrame.ScrollBarImageTransparency = 0.5
    playerScrollingFrame.BorderSizePixel = 0
    playerScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playerScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    playerScrollingFrame.ZIndex = 10003
    
    local playerListLayout = Instance.new("UIListLayout", playerScrollingFrame)
    playerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    playerListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    playerListLayout.Padding = UDim.new(0, 4)
    playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- 刷新按钮
    local refreshBtn = Instance.new("TextButton", teleportWindow)
    refreshBtn.Size = UDim2.new(0, 60, 0, 24)
    refreshBtn.Position = UDim2.new(0, 10, 1, -44)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    refreshBtn.BackgroundTransparency = 0.2
    refreshBtn.Text = "刷新"
    refreshBtn.TextColor3 = Color3.new(1, 1, 1)
    refreshBtn.TextSize = 12
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.ZIndex = 10003
    
    -- 传送函数（无视距离）
    local function teleportToPlayer(targetPlayer)
        local localChar = player.Character
        if not localChar then return end
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")
        if not localRoot then return end
        
        local targetChar = targetPlayer.Character
        if not targetChar then return end
        local targetHead = targetChar:FindFirstChild("Head")
        if not targetHead then return end
        
        -- 使用CFrame直接设置位置，无视距离
        local teleportPos = targetHead.Position + Vector3.new(0, 3, 0)
        localRoot.CFrame = CFrame.new(teleportPos)
    end
    
    -- 开始跟随功能
    local function startFollow(targetPlayer)
        stopFollow() -- 先停止之前的跟随
        
        followTarget = targetPlayer
        followEnabled = true
        
        followConnection = RunService.Heartbeat:Connect(function()
            if not followEnabled or not followTarget then
                stopFollow()
                return
            end
            
            local localChar = player.Character
            if not localChar then
                stopFollow()
                return
            end
            
            local localRoot = localChar:FindFirstChild("HumanoidRootPart")
            if not localRoot then
                stopFollow()
                return
            end
            
            local targetChar = followTarget.Character
            if not targetChar then
                stopFollow()
                return
            end
            
            local targetHead = targetChar:FindFirstChild("Head")
            if not targetHead then
                stopFollow()
                return
            end
            
            -- 持续跟随到目标头顶
            local teleportPos = targetHead.Position + Vector3.new(0, 3, 0)
            localRoot.CFrame = CFrame.new(teleportPos)
        end)
    end
    
    -- 更新玩家列表函数
    local function updatePlayerList()
        -- 清除现有列表
        for _, child in ipairs(playerScrollingFrame:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        local orderIndex = 0
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                orderIndex = orderIndex + 1
                
                local playerEntry = Instance.new("Frame", playerScrollingFrame)
                playerEntry.Size = UDim2.new(1, -10, 0, 36)
                playerEntry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                playerEntry.BackgroundTransparency = 0.3
                playerEntry.BorderSizePixel = 0
                playerEntry.LayoutOrder = orderIndex
                playerEntry.ZIndex = 10003
                
                local nameLabel = Instance.new("TextLabel", playerEntry)
                nameLabel.Size = UDim2.new(1, -70, 1, 0)
                nameLabel.Position = UDim2.new(0, 8, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = targetPlayer.Name
                nameLabel.TextColor3 = Color3.new(1, 1, 1)
                nameLabel.TextSize = 14
                nameLabel.Font = Enum.Font.Gotham
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.ZIndex = 10003
                
                -- 如果正在跟随该玩家，改变背景色提示
                if followEnabled and followTarget == targetPlayer then
                    playerEntry.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                    playerEntry.BackgroundTransparency = 0.4
                    nameLabel.Text = targetPlayer.Name .. " [跟随中]"
                end
                
                local teleportBtn = Instance.new("TextButton", playerEntry)
                teleportBtn.Size = UDim2.new(0, 56, 0, 28)
                teleportBtn.Position = UDim2.new(1, -62, 0, 4)
                teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
                teleportBtn.BackgroundTransparency = 0.2
                teleportBtn.Text = "传送"
                teleportBtn.TextColor3 = Color3.new(1, 1, 1)
                teleportBtn.TextSize = 12
                teleportBtn.Font = Enum.Font.GothamBold
                teleportBtn.ZIndex = 10003
                
                -- 长按检测
                local pressStartTime = 0
                local isLongPress = false
                local longPressConnection
                local pressConnection
                
                -- 按下时记录时间
                teleportBtn.MouseButton1Down:Connect(function()
                    pressStartTime = tick()
                    isLongPress = false
                    
                    -- 0.3秒后检测是否为长按
                    longPressConnection = RunService.Heartbeat:Connect(function()
                        if tick() - pressStartTime >= 0.3 and not isLongPress then
                            isLongPress = true
                            -- 开始跟随
                            startFollow(targetPlayer)
                            
                            -- 更新按钮外观
                            teleportBtn.Text = "跟随中"
                            teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
                            
                            -- 更新列表显示
                            updatePlayerList()
                        end
                    end)
                end)
                
                -- 松开时判断
                teleportBtn.MouseButton1Up:Connect(function()
                    if longPressConnection then
                        longPressConnection:Disconnect()
                        longPressConnection = nil
                    end
                    
                    if not isLongPress then
                        -- 短按：停止跟随并传送到目标位置
                        if followEnabled and followTarget == targetPlayer then
                            stopFollow()
                            teleportBtn.Text = "传送"
                            teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
                            updatePlayerList()
                        else
                            -- 单次传送
                            teleportToPlayer(targetPlayer)
                        end
                    end
                    
                    pressStartTime = 0
                    isLongPress = false
                end)
                
                -- 鼠标离开按钮时取消长按检测
                teleportBtn.MouseLeave:Connect(function()
                    if longPressConnection then
                        longPressConnection:Disconnect()
                        longPressConnection = nil
                    end
                    pressStartTime = 0
                    isLongPress = false
                end)
            end
        end
    end
    
    -- 初始加载玩家列表
    updatePlayerList()
    
    -- 刷新按钮点击
    refreshBtn.MouseButton1Click:Connect(updatePlayerList)
    
    -- 关闭按钮点击
    closeBtn.MouseButton1Click:Connect(function()
        stopFollow()
        teleportWindow:Destroy()
        teleportWindow = nil
        teleportEnabled = false
        updateToggle(teleportToggle, false)
    end)
    
    -- 窗口拖动
    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = teleportWindow.Position
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        dragging = false
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            teleportWindow.Position = UDim2.new(
                startPos.X.Scale, 
                math.clamp(startPos.X.Offset + delta.X, 0, gui.AbsoluteSize.X - teleportWindow.AbsoluteSize.X),
                startPos.Y.Scale,
                math.clamp(startPos.Y.Offset + delta.Y, 0, gui.AbsoluteSize.Y - teleportWindow.AbsoluteSize.Y)
            )
        end
    end)
    
    -- 监听玩家加入/离开自动更新列表
    local playerAddedConnection = Players.PlayerAdded:Connect(function(newPlayer)
        updatePlayerList()
    end)
    
    local playerRemovingConnection = Players.PlayerRemoving:Connect(function(leavingPlayer)
        if followEnabled and followTarget == leavingPlayer then
            stopFollow()
        end
        updatePlayerList()
    end)
    
    -- 窗口销毁时断开连接并停止跟随
    teleportWindow.Destroying:Connect(function()
        stopFollow()
        playerAddedConnection:Disconnect()
        playerRemovingConnection:Disconnect()
    end)
end

local function enableTeleport()
    teleportEnabled = true
    createTeleportWindow()
end

local function disableTeleport()
    stopFollow()
    if teleportWindow then
        teleportWindow:Destroy()
        teleportWindow = nil
    end
    teleportEnabled = false
end

-- 功能实现
local function setHorizontalPose(char)
    originalMotor6DValues = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("Motor6D") then originalMotor6DValues[part] = {C0 = part.C0, C1 = part.C1} end
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local rj = hrp:FindFirstChild("RootJoint") or hrp:FindFirstChild("Root")
        if rj and rj:IsA("Motor6D") then rj.C0 = CFrame.Angles(math.rad(-90), 0, 0) end
    end
end

local function restorePose(char)
    for m, ov in pairs(originalMotor6DValues) do
        if m and m.Parent then m.C0 = ov.C0; m.C1 = ov.C1 end
    end
    originalMotor6DValues = {}
end

local function toggleSpeed()
    speedEnabled = not speedEnabled
    if player.Character then
        local h = player.Character:FindFirstChild("Humanoid")
        if h then
            if speedEnabled then originalWalkSpeed = h.WalkSpeed; h.WalkSpeed = currentSpeed
            else h.WalkSpeed = originalWalkSpeed end
        end
    end
    updateToggle(speedToggle, speedEnabled)
end

local function enableClimb()
    local char = player.Character
    if not char then return end
    local humanoid, rootPart = char:FindFirstChild("Humanoid"), char:FindFirstChild("HumanoidRootPart")
    if not rootPart or not humanoid then return end
    climbConnection = RunService.Heartbeat:Connect(function()
        if not rootPart or not rootPart.Parent then disableClimb(); return end
        local lv = rootPart.CFrame.LookVector
        local dirs = {Vector3.new(lv.X, 0, lv.Z).Unit, -Vector3.new(lv.X, 0, lv.Z).Unit, rootPart.CFrame.RightVector, -rootPart.CFrame.RightVector}
        local tw, wn = false, Vector3.zero
        for _, dir in ipairs(dirs) do
            local rp = RaycastParams.new(); rp.FilterDescendantsInstances = {char}; rp.FilterType = Enum.RaycastFilterType.Blacklist
            local r = workspace:Raycast(rootPart.Position, dir * 3, rp)
            if r then tw = true; wn = r.Normal; break end
        end
        if tw then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            if wn.Magnitude > 0 then rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position - Vector3.new(wn.X, 0, wn.Z)) end
        else
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        end
    end)
    climbEnabled = true
end

local function disableClimb()
    if climbConnection then climbConnection:Disconnect(); climbConnection = nil end
    if player.Character then
        local h = player.Character:FindFirstChild("Humanoid")
        if h then
            h:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            h:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        end
    end
    climbEnabled = false
end

local function createFlyControlPanel()
    if flyControlPanel then flyControlPanel:Destroy() end
    for _, c in ipairs(moveConnections) do c:Disconnect() end
    moveConnections = {}
    local psize = tonumber(flyPanelSizeValue.Text) or 100
    flyControlPanel = Instance.new("Frame", gui)
    flyControlPanel.Size = UDim2.new(0, psize, 0, psize * 1.6)
    flyControlPanel.Position = UDim2.new(0.5, -psize/2, 0.5, -psize*0.8)
    flyControlPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    flyControlPanel.BackgroundTransparency = 0.3
    flyControlPanel.BorderSizePixel = 0
    flyControlPanel.ZIndex = 10001
    local dragBar = Instance.new("TextButton", flyControlPanel)
    dragBar.Size = UDim2.new(1, 0, 0, 15)
    dragBar.BackgroundTransparency = 0.5
    dragBar.Text = "≡"
    dragBar.TextColor3 = Color3.new(1, 1, 1)
    dragBar.TextSize = 12
    dragBar.Font = Enum.Font.GothamBold
    dragBar.ZIndex = 10002
    local pd, psp, pst = false, nil, nil
    dragBar.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            pd = true; psp = flyControlPanel.AbsolutePosition; pst = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then pd = false end
    end)
    RunService.Heartbeat:Connect(function()
        if pd and psp and pst then
            local mp = UserInputService:GetMouseLocation()
            if mp then
                local d = Vector2.new(mp.X, mp.Y) - pst
                flyControlPanel.Position = UDim2.fromOffset(math.clamp((psp + d).X, 0, gui.AbsoluteSize.X - psize), math.clamp((psp + d).Y, 0, gui.AbsoluteSize.Y - psize * 1.6))
            end
        end
    end)
    local function cb(text, pos, color)
        local b = Instance.new("TextButton", flyControlPanel)
        b.Size = UDim2.new(0, psize*0.25, 0, psize*0.25); b.Position = pos
        b.BackgroundColor3 = color; b.BackgroundTransparency = 0.3
        b.Text = text; b.TextColor3 = Color3.new(1, 1, 1); b.TextSize = 14
        b.Font = Enum.Font.GothamBold; b.ZIndex = 10002
        return b
    end
    local btnSize = psize * 0.25
    local cx = 0.5 - btnSize/(2*psize)
    local uBtn = cb("↑", UDim2.new(cx, 0, 0, psize*0.2), Color3.fromRGB(0, 150, 255))
    local dBtn = cb("↓", UDim2.new(cx, 0, 0, psize*0.8), Color3.fromRGB(0, 150, 255))
    local lBtn = cb("←", UDim2.new(cx - btnSize/psize - 0.02, 0, 0, psize*0.5), Color3.fromRGB(0, 150, 255))
    local rBtn = cb("→", UDim2.new(cx + btnSize/psize + 0.02, 0, 0, psize*0.5), Color3.fromRGB(0, 150, 255))
    local fBtn = cb("↗", UDim2.new(cx + btnSize/psize + 0.02, 0, 0, psize*0.2), Color3.fromRGB(0, 200, 100))
    local bBtn = cb("↙", UDim2.new(cx - btnSize/psize - 0.02, 0, 0, psize*0.2), Color3.fromRGB(0, 200, 100))
    local step = 0.3
    local function sm(dir)
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not workspace.CurrentCamera then return end
        local rp = char.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local cf = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
        local cr = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit
        if dir == "Up" then moveDirection = Vector3.new(0, 1, 0)
        elseif dir == "Down" then moveDirection = Vector3.new(0, -1, 0)
        elseif dir == "Left" then moveDirection = -cr
        elseif dir == "Right" then moveDirection = cr
        elseif dir == "Forward" then moveDirection = cf
        elseif dir == "Backward" then moveDirection = -cf end
        rp.CFrame = rp.CFrame + moveDirection * step * (flySpeed / 50)
        local cn = RunService.Heartbeat:Connect(function()
            if rp and rp.Parent then rp.CFrame = rp.CFrame + moveDirection * step * (flySpeed / 50) else cn:Disconnect() end
        end)
        return cn
    end
    local function sb(btn, dir)
        local cn, pr = nil, false
        btn.MouseButton1Down:Connect(function() pr = true; cn = sm(dir) end)
        btn.MouseButton1Up:Connect(function() pr = false; if cn then cn:Disconnect(); cn = nil end; moveDirection = Vector3.zero end)
        btn.MouseLeave:Connect(function() if pr then pr = false; if cn then cn:Disconnect(); cn = nil end; moveDirection = Vector3.zero end end)
    end
    sb(uBtn, "Up"); sb(dBtn, "Down"); sb(lBtn, "Left"); sb(rBtn, "Right"); sb(fBtn, "Forward"); sb(bBtn, "Backward")
end

local function enableFly()
    local char = player.Character
    if not char then return end
    local h, rp = char:FindFirstChild("Humanoid"), char:FindFirstChild("HumanoidRootPart")
    if not rp or not h then return end
    setHorizontalPose(char)
    h.WalkSpeed = 0; h.JumpPower = 0; h.AutoRotate = false
    local bv = Instance.new("BodyVelocity", rp)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.zero
    local bg = Instance.new("BodyGyro", rp)
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.CFrame = rp.CFrame
    createFlyControlPanel()
    flyConnection = RunService.Heartbeat:Connect(function()
        if not rp or not rp.Parent or not h or h.Health <= 0 then disableFly(); return end
        if moveDirection.Magnitude == 0 then bv.Velocity = Vector3.zero end
        local cam = workspace.CurrentCamera
        if cam then
            local cf = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
            if cf.Magnitude > 0.1 then bg.CFrame = CFrame.lookAt(rp.Position, rp.Position + cf.Unit) end
        end
    end)
    flyEnabled = true
end

local function disableFly()
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    moveDirection = Vector3.zero
    if flyControlPanel then flyControlPanel:Destroy(); flyControlPanel = nil end
    for _, c in ipairs(moveConnections) do c:Disconnect() end
    moveConnections = {}
    if player.Character then
        restorePose(player.Character)
        local h, rp = player.Character:FindFirstChild("Humanoid"), player.Character:FindFirstChild("HumanoidRootPart")
        if h then h.WalkSpeed = 16; h.JumpPower = 50; h.AutoRotate = true end
        if rp then for _, c in ipairs(rp:GetChildren()) do if c:IsA("BodyVelocity") or c:IsA("BodyGyro") then c:Destroy() end end end
    end
    flyEnabled = false
end

local function enableSpin()
    local char = player.Character
    if not char then return end
    local h, rp = char:FindFirstChild("Humanoid"), char:FindFirstChild("HumanoidRootPart")
    if not rp or not h then return end
    setHorizontalPose(char)
    for _, s in ipairs({Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.Physics, Enum.HumanoidStateType.Ragdoll}) do
        h:SetStateEnabled(s, false)
    end
    local gy = Instance.new("BodyGyro", rp)
    gy.Name = "SpinGyro"; gy.MaxTorque = Vector3.new(math.huge, 0, math.huge); gy.CFrame = CFrame.new(rp.Position)
    local av = Instance.new("BodyAngularVelocity", rp)
    av.Name = "SpinAngular"; av.MaxTorque = Vector3.new(0, math.huge, 0); av.AngularVelocity = Vector3.new(0, spinSpeed, 0)
    spinConnection = RunService.Heartbeat:Connect(function()
        if not rp or not rp.Parent or not h or h.Health <= 0 then disableSpin(); return end
        av.AngularVelocity = Vector3.new(0, spinSpeed, 0); gy.CFrame = CFrame.new(rp.Position)
        h:ChangeState(Enum.HumanoidStateType.Running)
        h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end)
    spinEnabled = true
end

local function disableSpin()
    if spinConnection then spinConnection:Disconnect(); spinConnection = nil end
    if player.Character then
        restorePose(player.Character)
        local h = player.Character:FindFirstChild("Humanoid")
        if h then
            for _, s in ipairs({Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.Physics, Enum.HumanoidStateType.Ragdoll}) do
                h:SetStateEnabled(s, true)
            end
            h:ChangeState(Enum.HumanoidStateType.Running)
        end
        local rp = player.Character:FindFirstChild("HumanoidRootPart")
        if rp then for _, c in ipairs(rp:GetChildren()) do if c.Name == "SpinAngular" or c.Name == "SpinGyro" then c:Destroy() end end end
    end
    spinEnabled = false
end

local function enableESP()
    espEnabled = true
    espConnection = RunService.Heartbeat:Connect(function()
        for _, op in ipairs(Players:GetPlayers()) do
            if op ~= player and op.Character then
                local highlight = espHighlights[op]
                if not highlight or not highlight.Parent then
                    highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0); highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0); highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = op.Character
                    espHighlights[op] = highlight
                end
            end
        end
    end)
end

local function disableESP()
    if espConnection then espConnection:Disconnect(); espConnection = nil end
    for _, hl in pairs(espHighlights) do if hl then hl:Destroy() end end
    espHighlights = {}
    espEnabled = false
end

local function enablePlayerCollision()
    playerCollisionEnabled = true
    collisionConnection = RunService.Heartbeat:Connect(function()
        if player.Character then
            for _, p in ipairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
        end
        for _, op in ipairs(Players:GetPlayers()) do
            if op ~= player and op.Character then
                for _, p in ipairs(op.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
            end
        end
    end)
end

local function disablePlayerCollision()
    if collisionConnection then collisionConnection:Disconnect(); collisionConnection = nil end
    playerCollisionEnabled = false
end

local function enableAimbot()
    aimbotEnabled = true
    aimbotCircle.Visible = true
    aimbotConnection = RunService.Heartbeat:Connect(function()
        if not aimbotActive then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local ch, cd = nil, aimbotRadius
        for _, op in ipairs(Players:GetPlayers()) do
            if op ~= player and op.Character then
                local head = op.Character:FindFirstChild("Head")
                if head then
                    local sp, on = cam:WorldToViewportPoint(head.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)).Magnitude
                        if d < cd then cd = d; ch = head end
                    end
                end
            end
        end
        if ch then cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, ch.Position), aimStrength) end
    end)
end

local function disableAimbot()
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
    aimbotCircle.Visible = false
    aimbotEnabled = false
    aimbotActive = false
end

local function enableDodge()
    dodgeEnabled = true
    dodgeConnection = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        local myPos = Vector2.new(rootPart.Position.X, rootPart.Position.Z)
        local totalOffset = Vector3.zero
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local otherPos = Vector2.new(otherRoot.Position.X, otherRoot.Position.Z)
                    local distance = (otherPos - myPos).Magnitude
                    if distance < dodgeRadius and distance > 0 then
                        local dir = (myPos - otherPos).Unit
                        totalOffset = totalOffset + Vector3.new(dir.X * (dodgeRadius - distance) / dodgeRadius * 2, 0, dir.Y * (dodgeRadius - distance) / dodgeRadius * 2)
                    end
                end
            end
        end
        if totalOffset.Magnitude > 0 then rootPart.CFrame = CFrame.new(rootPart.Position + totalOffset) end
    end)
end

local function disableDodge()
    if dodgeConnection then dodgeConnection:Disconnect(); dodgeConnection = nil end
    dodgeEnabled = false
end

local function enableOrbit()
    orbitEnabled = true
    orbitConnection = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        local rp = char:FindFirstChild("HumanoidRootPart")
        if not rp then return end
        local ct, cd = nil, orbitRadius
        for _, op in ipairs(Players:GetPlayers()) do
            if op ~= player and op.Character then
                local oRoot = op.Character:FindFirstChild("HumanoidRootPart")
                if oRoot then
                    local d = (rp.Position - oRoot.Position).Magnitude
                    if d < cd then cd = d; ct = oRoot end
                end
            end
        end
        if ct then
            orbitTarget = ct
            local tp = orbitTarget.Position
            local angle = tick() * orbitSpeed
            local offset = Vector3.new(math.cos(angle) * orbitDistance, 0, math.sin(angle) * orbitDistance)
            local np = tp + offset
            local ld = (tp - np).Unit
            rp.CFrame = CFrame.lookAt(np, np + Vector3.new(ld.X, 0, ld.Z))
        else orbitTarget = nil end
    end)
end

local function disableOrbit()
    if orbitConnection then orbitConnection:Disconnect(); orbitConnection = nil end
    orbitTarget = nil; orbitEnabled = false
end

-- 滑块事件
local function setupSlider(sBtn, sBg, setFunc, min, max)
    local dragging = false
    sBtn.MouseButton1Down:Connect(function() dragging = true end)
    sBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local ratio = math.clamp((input.Position.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X, 0, 1)
            setFunc(math.floor(min + ratio * (max - min)))
        end
    end)
end

setupSlider(speedBtn, speedSlider, setSpeed, 16, 1000)
setupSlider(flySpeedBtn, flySpeedSlider, setFlySpeed, 10, 500)
setupSlider(flyPanelSizeBtn, flyPanelSizeSlider, setFlyPanelSize, 80, 200)
setupSlider(aimbotBtn, aimbotSlider, setAimbotRadius, 50, 500)
setupSlider(aimTriggerSizeBtn, aimTriggerSizeSlider, setAimTriggerSize, 80, 400)
setupSlider(spinBtn, spinSlider, setSpinSpeed, 1, 1000)
setupSlider(dodgeBtn, dodgeSlider, setDodgeRadius, 5, 50)
setupSlider(orbitRadiusBtn, orbitRadiusSlider, setOrbitRadius, 5, 50)
setupSlider(orbitDistanceBtn, orbitDistanceSlider, setOrbitDistance, 2, 20)
setupSlider(orbitSpeedBtn, orbitSpeedSlider, setOrbitSpeed, 1, 100)

-- 开关绑定
speedToggle.MouseButton1Down:Connect(toggleSpeed)
climbToggle.MouseButton1Down:Connect(function()
    if climbEnabled then disableClimb() else enableClimb() end
    updateToggle(climbToggle, climbEnabled)
end)
flyToggle.MouseButton1Down:Connect(function()
    if flyEnabled then disableFly() else enableFly() end
    updateToggle(flyToggle, flyEnabled)
end)
spinToggle.MouseButton1Down:Connect(function()
    if spinEnabled then disableSpin() else enableSpin() end
    updateToggle(spinToggle, spinEnabled)
end)
espToggle.MouseButton1Down:Connect(function()
    if espEnabled then disableESP() else enableESP() end
    updateToggle(espToggle, espEnabled)
end)
collisionToggle.MouseButton1Down:Connect(function()
    if playerCollisionEnabled then disablePlayerCollision() else enablePlayerCollision() end
    updateToggle(collisionToggle, playerCollisionEnabled)
end)
aimbotToggle.MouseButton1Down:Connect(function()
    if aimbotEnabled then disableAimbot() else enableAimbot() end
    updateToggle(aimbotToggle, aimbotEnabled)
end)
dodgeToggle.MouseButton1Down:Connect(function()
    if dodgeEnabled then disableDodge() else enableDodge() end
    updateToggle(dodgeToggle, dodgeEnabled)
end)
orbitToggle.MouseButton1Down:Connect(function()
    if orbitEnabled then disableOrbit() else enableOrbit() end
    updateToggle(orbitToggle, orbitEnabled)
end)
teleportToggle.MouseButton1Down:Connect(function()
    if teleportEnabled then disableTeleport() else enableTeleport() end
    updateToggle(teleportToggle, teleportEnabled)
end)

-- 显示触发按钮
aimTriggerToggle.MouseButton1Down:Connect(function()
    aimTriggerVisible = not aimTriggerVisible
    aimTriggerToggle.Text = "显示触发: " .. (aimTriggerVisible and "开" or "关")
    aimTriggerToggle.BackgroundColor3 = aimTriggerVisible and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
    aimTriggerBtn.Visible = aimTriggerVisible
    aimbotActive = false
end)

-- 触发移动按钮
aimTriggerMoveBtn.MouseButton1Down:Connect(function()
    aimTriggerMoving = not aimTriggerMoving
    aimTriggerMoveBtn.Text = "触发移动: " .. (aimTriggerMoving and "开" or "关")
    aimTriggerMoveBtn.BackgroundColor3 = aimTriggerMoving and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
    if aimTriggerMoving then
        aimTriggerBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        aimTriggerBtn.BackgroundTransparency = 0.7
        aimTriggerLabel.Text = "拖动放置"
    else
        aimTriggerPos = aimTriggerBtn.Position
        aimTriggerBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        aimTriggerBtn.BackgroundTransparency = 0.8
        aimTriggerLabel.Text = "按住自瞄"
    end
end)

-- 自瞄触发按钮：按下激活，松开停用（Active = false 确保穿透点击）
aimTriggerBtn.MouseButton1Down:Connect(function()
    if not aimTriggerMoving then aimbotActive = true end
end)
aimTriggerBtn.MouseButton1Up:Connect(function()
    aimbotActive = false
end)

-- 触发按钮拖动
local triggerDragging, triggerDragStartPos, triggerDragStartTouch = false, nil, nil
aimTriggerBtn.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if aimTriggerMoving and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        triggerDragging = true
        triggerDragStartPos = aimTriggerBtn.AbsolutePosition
        triggerDragStartTouch = Vector2.new(input.Position.X, input.Position.Y)
    end
end)
aimTriggerBtn.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if aimTriggerMoving then
        triggerDragging = false
        triggerDragStartPos = nil
        triggerDragStartTouch = nil
    end
end)

-- 悬浮球拖拽和菜单
local ballDragging, ballStartPos, ballStartTouch = false, nil, nil
local menuOpen = false

ball.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ballDragging = true
        ballStartPos = ball.AbsolutePosition
        ballStartTouch = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

ball.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if ballDragging and ballStartTouch then
            if (Vector2.new(input.Position.X, input.Position.Y) - ballStartTouch).Magnitude < 5 then
                menuOpen = not menuOpen
                menu.Visible = menuOpen
            end
        end
        ballDragging = false
        ballStartPos = nil
        ballStartTouch = nil
    end
end)

RunService.Heartbeat:Connect(function()
    if triggerDragging and triggerDragStartPos and triggerDragStartTouch then
        local mp = UserInputService:GetMouseLocation()
        local delta = Vector2.new(mp.X, mp.Y) - triggerDragStartTouch
        local newPos = triggerDragStartPos + delta
        aimTriggerBtn.Position = UDim2.fromOffset(math.clamp(newPos.X, 0, gui.AbsoluteSize.X - aimTriggerSize), math.clamp(newPos.Y, 0, gui.AbsoluteSize.Y - aimTriggerSize))
    end
    if ballDragging and ballStartPos and ballStartTouch then
        local mp = UserInputService:GetMouseLocation()
        local d = Vector2.new(mp.X, mp.Y) - ballStartTouch
        ball.Position = UDim2.fromOffset(math.clamp((ballStartPos + d).X, 0, gui.AbsoluteSize.X - 50), math.clamp((ballStartPos + d).Y, 0, gui.AbsoluteSize.Y - 50))
        if menuOpen then menu.Position = ball.Position + UDim2.new(0, 60, 0, 0) end
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.1)
    if speedEnabled then local h = char:FindFirstChild("Humanoid"); if h then h.WalkSpeed = currentSpeed end end
    if climbEnabled then if climbConnection then climbConnection:Disconnect() end enableClimb() end
    if flyEnabled then disableFly(); task.wait(0.1); enableFly() end
    if spinEnabled then if spinConnection then spinConnection:Disconnect() end enableSpin() end
    if playerCollisionEnabled then if collisionConnection then collisionConnection:Disconnect() end enablePlayerCollision() end
    if dodgeEnabled then if dodgeConnection then dodgeConnection:Disconnect() end enableDodge() end
    if orbitEnabled then if orbitConnection then orbitConnection:Disconnect() end enableOrbit() end
    -- 如果死亡重生时正在跟随，重新开始跟随
    if followEnabled and followTarget then
        stopFollow()
        startFollow(followTarget)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if espHighlights[plr] then espHighlights[plr]:Destroy(); espHighlights[plr] = nil end
    if followEnabled and followTarget == plr then
        stopFollow()
        if teleportWindow then
            -- 更新窗口列表
            for _, child in ipairs(teleportWindow:GetDescendants()) do
                if child:IsA("ScrollingFrame") then
                    -- 触发列表更新
                    local refreshBtn = teleportWindow:FindFirstChildWhichIsA("TextButton")
                end
            end
        end
    end
end)

-- 初始化
for _, t in ipairs({speedToggle, climbToggle, flyToggle, spinToggle, espToggle, collisionToggle, aimbotToggle, dodgeToggle, orbitToggle, teleportToggle}) do
    updateToggle(t, false)
end
setSpeed(50); setFlySpeed(50); setFlyPanelSize(100); setSpinSpeed(50); setDodgeRadius(15)
setOrbitRadius(20); setOrbitDistance(5); setOrbitSpeed(10); setAimbotRadius(200); setAimTriggerSize(200)

print("OK")
