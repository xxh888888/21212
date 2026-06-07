local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- 模仿相关变量
local mimickingPlayer = nil
local mimicConnections = {}  -- 存储所有连接
local originalWalkSpeed = 16
local originalJumpPower = 50
local relativeOffset = nil  -- 保存相对偏移
local rightOffset = 5  -- 右边距离

local gui = Instance.new("ScreenGui")
gui.Name = "PlayerListUI"
gui.Parent = pgui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999

-- 屏幕中间的小球
local ball = Instance.new("TextButton")
ball.Parent = gui
ball.Size = UDim2.new(0, 60, 0, 60)
ball.Position = UDim2.new(0.5, -30, 0.5, -30)
ball.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ball.BackgroundTransparency = 0.1
ball.AutoButtonColor = false
ball.Text = "👥"
ball.TextColor3 = Color3.new(1, 1, 1)
ball.TextSize = 26
ball.Font = Enum.Font.GothamBold
ball.ZIndex = 10000
Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)

-- 玩家列表面板
local panel = Instance.new("Frame")
panel.Parent = gui
panel.Size = UDim2.new(0, 240, 0, 0)
panel.Position = UDim2.new(0.5, 50, 0.5, -30)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
panel.BackgroundTransparency = 0.15
panel.BorderSizePixel = 0
panel.Visible = false
panel.ClipsDescendants = true
panel.ZIndex = 9999

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

local panelStroke = Instance.new("UIStroke")
panelStroke.Parent = panel
panelStroke.Color = Color3.fromRGB(255, 255, 255)
panelStroke.Transparency = 0.6
panelStroke.Thickness = 1

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = panel
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 10000

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "玩家列表"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 10001

-- 取消模仿按钮
local stopMimicBtn = Instance.new("TextButton")
stopMimicBtn.Parent = titleBar
stopMimicBtn.Size = UDim2.new(0, 50, 0, 30)
stopMimicBtn.Position = UDim2.new(1, -115, 0, 5)
stopMimicBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
stopMimicBtn.BackgroundTransparency = 0.3
stopMimicBtn.AutoButtonColor = false
stopMimicBtn.Text = "停止"
stopMimicBtn.TextColor3 = Color3.new(1, 1, 1)
stopMimicBtn.TextSize = 12
stopMimicBtn.Font = Enum.Font.GothamBold
stopMimicBtn.ZIndex = 10001
stopMimicBtn.Visible = false
Instance.new("UICorner", stopMimicBtn).CornerRadius = UDim.new(0, 8)

-- 刷新按钮
local refreshBtn = Instance.new("TextButton")
refreshBtn.Parent = titleBar
refreshBtn.Size = UDim2.new(0, 50, 0, 30)
refreshBtn.Position = UDim2.new(1, -55, 0, 5)
refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
refreshBtn.BackgroundTransparency = 0.2
refreshBtn.AutoButtonColor = false
refreshBtn.Text = "刷新"
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.TextSize = 14
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.ZIndex = 10001
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 8)

-- 滚动框架
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = panel
scrollFrame.Size = UDim2.new(1, -12, 1, -50)
scrollFrame.Position = UDim2.new(0, 6, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
scrollFrame.ScrollBarImageTransparency = 0.4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.BorderSizePixel = 0
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.ZIndex = 10000

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Parent = scrollFrame
playerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
playerListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
playerListLayout.Padding = UDim.new(0, 5)
playerListLayout.SortOrder = Enum.SortOrder.Name

-- 辅助函数：获取 Humanoid
local function getHumanoid(character)
    if not character then return nil end
    return character:FindFirstChild("Humanoid")
end

-- 辅助函数：获取 HumanoidRootPart
local function getRootPart(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

-- 停止模仿函数
local function stopMimicking()
    -- 断开所有连接
    for _, conn in ipairs(mimicConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    mimicConnections = {}
    
    -- 恢复角色的原始状态
    local myChar = player.Character
    if myChar then
        local myHumanoid = getHumanoid(myChar)
        if myHumanoid then
            myHumanoid.WalkSpeed = originalWalkSpeed
            myHumanoid.JumpPower = originalJumpPower
            myHumanoid:Move(Vector3.zero, true)
            myHumanoid.Jump = false
            myHumanoid.Sit = false
            myHumanoid.PlatformStand = false
        end
    end
    
    mimickingPlayer = nil
    relativeOffset = nil
    stopMimicBtn.Visible = false
    
    -- 重置按钮文字
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            local btn = child:FindFirstChild("MimicBtn")
            if btn and btn:IsA("TextButton") then
                btn.Text = "模仿"
                btn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
            end
        end
    end
end

stopMimicBtn.MouseButton1Down:Connect(stopMimicking)

-- 同步所有动作的核心函数
local function startFullMimic(targetPlayer)
    -- 停止之前的模仿
    if mimickingPlayer then
        stopMimicking()
    end
    
    local targetChar = targetPlayer.Character
    if not targetChar then
        return false
    end
    
    local targetHumanoid = getHumanoid(targetChar)
    local targetRoot = getRootPart(targetChar)
    
    if not targetHumanoid or not targetRoot then
        return false
    end
    
    local myChar = player.Character
    if not myChar then
        return false
    end
    
    local myHumanoid = getHumanoid(myChar)
    local myRoot = getRootPart(myChar)
    
    if not myHumanoid or not myRoot then
        return false
    end
    
    -- 保存原始属性
    originalWalkSpeed = myHumanoid.WalkSpeed
    originalJumpPower = myHumanoid.JumpPower
    
    -- 先传送到目标的右边
    local targetPosition = targetRoot.CFrame
    local rightPosition = targetPosition * CFrame.new(rightOffset, 0, 0)  -- 目标右边5格
    
    -- 设置平台站立模式
    myHumanoid.PlatformStand = true
    
    -- 传送角色
    myRoot.CFrame = rightPosition
    myHumanoid.Jump = false
    
    -- 保存相对位置偏移（相对于目标）
    relativeOffset = myRoot.CFrame:ToObjectSpace(targetRoot.CFrame)
    
    -- 开始模仿
    mimickingPlayer = targetPlayer
    stopMimicBtn.Visible = true
    
    -- 1. 同步移动和位置
    local moveConnection = RunService.Heartbeat:Connect(function()
        if not mimickingPlayer or not mimickingPlayer.Parent then
            stopMimicking()
            return
        end
        
        local tChar = mimickingPlayer.Character
        if not tChar then return end
        
        local tHumanoid = getHumanoid(tChar)
        local tRoot = getRootPart(tChar)
        local mChar = player.Character
        if not mChar then return end
        
        local mHumanoid = getHumanoid(mChar)
        local mRoot = getRootPart(mChar)
        
        if not tHumanoid or not tRoot or not mHumanoid or not mRoot then
            return
        end
        
        -- 同步速度属性
        mHumanoid.WalkSpeed = tHumanoid.WalkSpeed
        mHumanoid.JumpPower = tHumanoid.JumpPower
        
        -- 复制移动方向
        local moveDirection = tHumanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            -- 获取目标的世界移动方向
            local targetLookVector = tRoot.CFrame.LookVector
            local targetRightVector = tRoot.CFrame.RightVector
            local targetUpVector = tRoot.CFrame.UpVector
            
            -- 转换移动方向到世界坐标系
            local worldMoveDir = (targetLookVector * moveDirection.Z) + 
                                 (targetRightVector * moveDirection.X) + 
                                 (targetUpVector * moveDirection.Y)
            
            -- 应用到自己的角色，保持右边偏移
            mHumanoid:Move(worldMoveDir, true)
        else
            mHumanoid:Move(Vector3.zero, true)
        end
        
        -- 同步位置（保持在目标的右边）
        if relativeOffset then
            mRoot.CFrame = tRoot.CFrame * relativeOffset
        end
    end)
    table.insert(mimicConnections, moveConnection)
    
    -- 2. 同步跳跃状态
    local jumpConnection = RunService.Stepped:Connect(function()
        if not mimickingPlayer or not mimickingPlayer.Parent then
            return
        end
        
        local tChar = mimickingPlayer.Character
        if not tChar then return end
        
        local tHumanoid = getHumanoid(tChar)
        local mChar = player.Character
        if not mChar then return end
        
        local mHumanoid = getHumanoid(mChar)
        
        if tHumanoid and mHumanoid then
            local tState = tHumanoid:GetState()
            local mState = mHumanoid:GetState()
            
            -- 目标正在跳跃
            if tState == Enum.HumanoidStateType.Jumping then
                if mState ~= Enum.HumanoidStateType.Jumping and mState ~= Enum.HumanoidStateType.Freefall then
                    mHumanoid.Jump = true
                end
            end
            
            -- 目标正在掉落
            if tState == Enum.HumanoidStateType.Freefall then
                if mState ~= Enum.HumanoidStateType.Freefall then
                    mHumanoid.Jump = false
                end
            end
        end
    end)
    table.insert(mimicConnections, jumpConnection)
    
    -- 3. 同步蹲下/坐下状态
    local crouchConnection = RunService.Heartbeat:Connect(function()
        if not mimickingPlayer or not mimickingPlayer.Parent then
            return
        end
        
        local tChar = mimickingPlayer.Character
        if not tChar then return end
        
        local tHumanoid = getHumanoid(tChar)
        local mChar = player.Character
        if not mChar then return end
        
        local mHumanoid = getHumanoid(mChar)
        
        if tHumanoid and mHumanoid then
            local tState = tHumanoid:GetState()
            
            -- 检测蹲下状态
            local isCrouching = (tState == Enum.HumanoidStateType.StrafingNoPhysics or
                                 tState == Enum.HumanoidStateType.Landed or
                                 tState == Enum.HumanoidStateType.RunningNoPhysics)
            
            local tRoot = getRootPart(tChar)
            local mRoot = getRootPart(mChar)
            
            if tRoot and mRoot then
                -- 如果目标 Y 位置明显不同，可能是蹲下或爬下
                local heightDiff = math.abs(tRoot.Position.Y - mRoot.Position.Y)
                if heightDiff > 2 then
                    mHumanoid.Sit = true
                elseif isCrouching and tHumanoid.MoveDirection.Magnitude < 1 then
                    mHumanoid.Sit = true
                else
                    mHumanoid.Sit = false
                end
            end
        end
    end)
    table.insert(mimicConnections, crouchConnection)
    
    -- 4. 同步动画和表情
    local animConnection = RunService.RenderStepped:Connect(function()
        if not mimickingPlayer or not mimickingPlayer.Parent then
            return
        end
        
        local tChar = mimickingPlayer.Character
        if not tChar then return end
        
        local tHumanoid = getHumanoid(tChar)
        local mChar = player.Character
        if not mChar then return end
        
        local mHumanoid = getHumanoid(mChar)
        
        if tHumanoid and tHumanoid.Animator and mHumanoid and mHumanoid.Animator then
            local tAnimator = tHumanoid.Animator
            local mAnimator = mHumanoid.Animator
            
            -- 获取目标正在播放的动画
            local tPlaying = tAnimator:GetPlayingAnimationTracks()
            
            -- 清除当前不在目标播放列表中的动画
            local mPlaying = mAnimator:GetPlayingAnimationTracks()
            for _, mTrack in ipairs(mPlaying) do
                local shouldKeep = false
                for _, tTrack in ipairs(tPlaying) do
                    if tTrack.Animation.AnimationId == mTrack.Animation.AnimationId then
                        shouldKeep = true
                        -- 同步播放进度
                        mTrack.TimePosition = tTrack.TimePosition
                        break
                    end
                end
                if not shouldKeep then
                    mTrack:Stop()
                end
            end
            
            -- 播放目标正在播放但自己没播放的动画
            for _, tTrack in ipairs(tPlaying) do
                local alreadyPlaying = false
                for _, mTrack in ipairs(mPlaying) do
                    if mTrack.Animation.AnimationId == tTrack.Animation.AnimationId then
                        alreadyPlaying = true
                        break
                    end
                end
                
                if not alreadyPlaying then
                    local newAnim = Instance.new("Animation")
                    newAnim.AnimationId = tTrack.Animation.AnimationId
                    local newTrack = mAnimator:LoadAnimation(newAnim)
                    newTrack:Play()
                    newTrack.TimePosition = tTrack.TimePosition
                end
            end
        end
    end)
    table.insert(mimicConnections, animConnection)
    
    -- 5. 同步角色朝向（保持右边相对位置）
    local orientationConnection = RunService.Heartbeat:Connect(function()
        if not mimickingPlayer or not mimickingPlayer.Parent then
            return
        end
        
        local tChar = mimickingPlayer.Character
        if not tChar then return end
        
        local tRoot = getRootPart(tChar)
        local mChar = player.Character
        if not mChar then return end
        
        local mRoot = getRootPart(mChar)
        
        if tRoot and mRoot then
            -- 同步朝向，保持右边相对位置
            local relativeCF = mRoot.CFrame:ToObjectSpace(tRoot.CFrame)
            local newCF = tRoot.CFrame * relativeCF
            mRoot.CFrame = newCF
        end
    end)
    table.insert(mimicConnections, orientationConnection)
    
    print("✅ 开始完全模仿: " .. targetPlayer.Name .. " (右边距离: " .. rightOffset .. ")")
    return true
end

-- 创建玩家条目
local function createPlayerEntry(plr, parent)
    local entry = Instance.new("Frame")
    entry.Parent = parent
    entry.Size = UDim2.new(1, -5, 0, 45)
    entry.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    entry.BackgroundTransparency = 0.3
    entry.BorderSizePixel = 0
    entry.ZIndex = 10001
    Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 8)

    local displayName = Instance.new("TextLabel")
    displayName.Parent = entry
    displayName.Size = UDim2.new(1, -70, 1, 0)
    displayName.Position = UDim2.new(0, 15, 0, 0)
    displayName.BackgroundTransparency = 1
    displayName.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
    displayName.TextColor3 = Color3.new(1, 1, 1)
    displayName.TextSize = 13
    displayName.Font = Enum.Font.Gotham
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.ZIndex = 10002

    local statusDot = Instance.new("Frame")
    statusDot.Parent = entry
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(0, 4, 0.5, -4)
    statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 10003
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local mimicBtn = Instance.new("TextButton")
    mimicBtn.Name = "MimicBtn"
    mimicBtn.Parent = entry
    mimicBtn.Size = UDim2.new(0, 60, 0, 30)
    mimicBtn.Position = UDim2.new(1, -65, 0.5, -15)
    mimicBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    mimicBtn.BackgroundTransparency = 0.2
    mimicBtn.AutoButtonColor = false
    mimicBtn.Text = "模仿"
    mimicBtn.TextColor3 = Color3.new(1, 1, 1)
    mimicBtn.TextSize = 12
    mimicBtn.Font = Enum.Font.GothamBold
    mimicBtn.ZIndex = 10002
    Instance.new("UICorner", mimicBtn).CornerRadius = UDim.new(0, 6)

    mimicBtn.MouseButton1Down:Connect(function()
        if mimickingPlayer == plr then
            stopMimicking()
        else
            startFullMimic(plr)
            mimicBtn.Text = "模仿中"
            mimicBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            
            -- 更新其他按钮状态
            for _, child in ipairs(scrollFrame:GetChildren()) do
                if child:IsA("Frame") and child ~= entry then
                    local btn = child:FindFirstChild("MimicBtn")
                    if btn and btn:IsA("TextButton") then
                        btn.Text = "模仿"
                        btn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
                    end
                end
            end
        end
    end)

    return entry
end

-- 更新玩家列表
local function updatePlayerList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local playerCount = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            createPlayerEntry(plr, scrollFrame)
            playerCount = playerCount + 1
        end
    end

    if playerCount == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Parent = scrollFrame
        emptyLabel.Size = UDim2.new(1, 0, 0, 40)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "没有其他玩家"
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.TextSize = 14
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.ZIndex = 10001
    end
end

refreshBtn.MouseButton1Down:Connect(function()
    updatePlayerList()
    refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(0.15)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
end)

-- 拖拽系统
local isDragging = false
local dragStartMouse = nil
local dragStartBall = nil
local panelOpen = false
local panelTween = nil

local function updatePanelPosition()
    if not panelOpen then return end
    
    local ballPos = ball.AbsolutePosition
    local ballSize = ball.AbsoluteSize
    local panelX = ballPos.X + ballSize.X + 10
    local panelY = ballPos.Y
    
    if panelX + 240 > gui.AbsoluteSize.X then
        panelX = ballPos.X - 250
    end
    
    if panelY + 300 > gui.AbsoluteSize.Y then
        panelY = gui.AbsoluteSize.Y - 310
    end
    if panelY < 0 then
        panelY = 10
    end
    
    panel.Position = UDim2.fromOffset(panelX, panelY)
end

local function togglePanel()
    panelOpen = not panelOpen
    panel.Visible = true

    if panelTween then
        panelTween:Cancel()
    end

    if panelOpen then
        updatePlayerList()
        updatePanelPosition()
        panelTween = TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 240, 0, 300)
        })
    else
        panelTween = TweenService:Create(panel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 240, 0, 0)
        })
    end

    panelTween:Play()
    panelTween.Completed:Connect(function()
        if not panelOpen then
            panel.Visible = false
        end
    end)
end

ball.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
        dragStartMouse = Vector2.new(input.Position.X, input.Position.Y)
        dragStartBall = ball.AbsolutePosition
    end
end)

ball.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not isDragging then
            togglePanel()
        else
            updatePanelPosition()
        end
        isDragging = false
        dragStartMouse = nil
        dragStartBall = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragStartMouse and dragStartBall and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentMouse = Vector2.new(input.Position.X, input.Position.Y)
        local delta = currentMouse - dragStartMouse
        
        if delta.Magnitude > 2 then
            isDragging = true
            
            local newPos = dragStartBall + delta
            local maxX = gui.AbsoluteSize.X - ball.AbsoluteSize.X
            local maxY = gui.AbsoluteSize.Y - ball.AbsoluteSize.Y
            newPos = Vector2.new(math.clamp(newPos.X, 0, maxX), math.clamp(newPos.Y, 0, maxY))
            
            ball.Position = UDim2.fromOffset(newPos.X, newPos.Y)
            updatePanelPosition()
        end
    end
end)

-- 玩家事件监听
Players.PlayerRemoving:Connect(function(plr)
    if mimickingPlayer == plr then
        stopMimicking()
    end
    if panelOpen then
        updatePlayerList()
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if panelOpen then
        updatePlayerList()
    end
end)

player.CharacterAdded:Connect(function(char)
    if mimickingPlayer then
        local target = mimickingPlayer
        task.wait(0.5)  -- 等待角色完全加载
        startFullMimic(target)
    end
end)

-- 定期更新玩家列表（可选）
task.spawn(function()
    while true do
        task.wait(5)
        if panelOpen then
            updatePlayerList()
        end
    end
end)

print("✅ 完全模仿系统已加载 - 点击球体打开玩家列表")
print("📍 模仿时会自动传送到目标右边5格的位置")
