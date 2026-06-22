local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiCheatUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ========== 景深模糊效果 ==========
local blurEffect = Instance.new("BlurEffect")
blurEffect.Name = "UIBackgroundBlur"
blurEffect.Size = 0
blurEffect.Enabled = true
blurEffect.Parent = Lighting

-- ========== 顶部纯黑胶囊按钮 ==========
local capsuleWidth = 120
local capsuleHeight = 40
local capsuleExpandedWidth = 200

local topCapsule = Instance.new("TextButton")
topCapsule.Name = "TopCapsule"
topCapsule.Size = UDim2.new(0, capsuleWidth, 0, capsuleHeight)
topCapsule.Position = UDim2.new(0.5, 0, 0, 10)
topCapsule.AnchorPoint = Vector2.new(0.5, 0)
topCapsule.BackgroundColor3 = Color3.new(0, 0, 0)
topCapsule.BackgroundTransparency = 0
topCapsule.Text = ""
topCapsule.BorderSizePixel = 0
topCapsule.ZIndex = 10
topCapsule.Parent = screenGui

local capsuleCorner = Instance.new("UICorner")
capsuleCorner.CornerRadius = UDim.new(0, capsuleHeight / 2)
capsuleCorner.Parent = topCapsule

-- ========== 圆手 ==========
local handSize = 22

local leftHand = Instance.new("Frame")
leftHand.Name = "LeftHand"
leftHand.Size = UDim2.new(0, handSize, 0, handSize)
leftHand.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
leftHand.BorderSizePixel = 0
leftHand.AnchorPoint = Vector2.new(1, 0.5)
leftHand.Position = UDim2.new(0, -5, 0.5, 0)
leftHand.Visible = false
leftHand.ZIndex = 9
leftHand.Parent = topCapsule
Instance.new("UICorner", leftHand).CornerRadius = UDim.new(1, 0)

local rightHand = Instance.new("Frame")
rightHand.Name = "RightHand"
rightHand.Size = UDim2.new(0, handSize, 0, handSize)
rightHand.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
rightHand.BorderSizePixel = 0
rightHand.AnchorPoint = Vector2.new(0, 0.5)
rightHand.Position = UDim2.new(1, 5, 0.5, 0)
rightHand.Visible = false
rightHand.ZIndex = 9
rightHand.Parent = topCapsule
Instance.new("UICorner", rightHand).CornerRadius = UDim.new(1, 0)

-- ========== 面部部件 ==========
local faceContainer = Instance.new("Frame")
faceContainer.Name = "FaceContainer"
faceContainer.Size = UDim2.new(1, -16, 1, -8)
faceContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
faceContainer.AnchorPoint = Vector2.new(0.5, 0.5)
faceContainer.BackgroundTransparency = 1
faceContainer.ZIndex = 11
faceContainer.Parent = topCapsule

local leftEye = Instance.new("Frame")
leftEye.Size = UDim2.new(0, 10, 0, 10)
leftEye.Position = UDim2.new(0.28, -5, 0.38, -5)
leftEye.BackgroundColor3 = Color3.new(1, 1, 1)
leftEye.BorderSizePixel = 0
leftEye.ZIndex = 12
leftEye.Parent = faceContainer
Instance.new("UICorner", leftEye).CornerRadius = UDim.new(1, 0)

local leftPupil = Instance.new("Frame")
leftPupil.Size = UDim2.new(0, 5, 0, 5)
leftPupil.Position = UDim2.new(0.5, -2.5, 0.5, -2.5)
leftPupil.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
leftPupil.BorderSizePixel = 0
leftPupil.ZIndex = 13
leftPupil.Parent = leftEye
Instance.new("UICorner", leftPupil).CornerRadius = UDim.new(1, 0)

local leftHighlight = Instance.new("Frame")
leftHighlight.Size = UDim2.new(0, 3, 0, 3)
leftHighlight.Position = UDim2.new(0.2, 0, 0.15, 0)
leftHighlight.BackgroundColor3 = Color3.new(1, 1, 1)
leftHighlight.BorderSizePixel = 0
leftHighlight.ZIndex = 14
leftHighlight.Parent = leftEye
Instance.new("UICorner", leftHighlight).CornerRadius = UDim.new(1, 0)

local rightEye = Instance.new("Frame")
rightEye.Size = UDim2.new(0, 10, 0, 10)
rightEye.Position = UDim2.new(0.72, -5, 0.38, -5)
rightEye.BackgroundColor3 = Color3.new(1, 1, 1)
rightEye.BorderSizePixel = 0
rightEye.ZIndex = 12
rightEye.Parent = faceContainer
Instance.new("UICorner", rightEye).CornerRadius = UDim.new(1, 0)

local rightPupil = Instance.new("Frame")
rightPupil.Size = UDim2.new(0, 5, 0, 5)
rightPupil.Position = UDim2.new(0.5, -2.5, 0.5, -2.5)
rightPupil.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
rightPupil.BorderSizePixel = 0
rightPupil.ZIndex = 13
rightPupil.Parent = rightEye
Instance.new("UICorner", rightPupil).CornerRadius = UDim.new(1, 0)

local rightHighlight = Instance.new("Frame")
rightHighlight.Size = UDim2.new(0, 3, 0, 3)
rightHighlight.Position = UDim2.new(0.2, 0, 0.15, 0)
rightHighlight.BackgroundColor3 = Color3.new(1, 1, 1)
rightHighlight.BorderSizePixel = 0
rightHighlight.ZIndex = 14
rightHighlight.Parent = rightEye
Instance.new("UICorner", rightHighlight).CornerRadius = UDim.new(1, 0)

local mouth = Instance.new("Frame")
mouth.Size = UDim2.new(0, 14, 0, 3)
mouth.Position = UDim2.new(0.5, -7, 0.72, -1)
mouth.BackgroundColor3 = Color3.new(1, 1, 1)
mouth.BorderSizePixel = 0
mouth.ZIndex = 12
mouth.Parent = faceContainer
local mouthCorner = Instance.new("UICorner")
mouthCorner.CornerRadius = UDim.new(0, 1.5)
mouthCorner.Parent = mouth

local leftBlush = Instance.new("Frame")
leftBlush.Size = UDim2.new(0, 8, 0, 5)
leftBlush.Position = UDim2.new(0.08, 0, 0.58, 0)
leftBlush.BackgroundColor3 = Color3.new(1, 0.5, 0.6)
leftBlush.BackgroundTransparency = 0.6
leftBlush.BorderSizePixel = 0
leftBlush.ZIndex = 11
leftBlush.Parent = faceContainer
Instance.new("UICorner", leftBlush).CornerRadius = UDim.new(1, 0)

local rightBlush = Instance.new("Frame")
rightBlush.Size = UDim2.new(0, 8, 0, 5)
rightBlush.Position = UDim2.new(0.84, 0, 0.58, 0)
rightBlush.BackgroundColor3 = Color3.new(1, 0.5, 0.6)
rightBlush.BackgroundTransparency = 0.6
rightBlush.BorderSizePixel = 0
rightBlush.ZIndex = 11
rightBlush.Parent = faceContainer
Instance.new("UICorner", rightBlush).CornerRadius = UDim.new(1, 0)

local emoteBubble = Instance.new("TextLabel")
emoteBubble.Size = UDim2.new(0, 30, 0, 30)
emoteBubble.Position = UDim2.new(0.5, -15, 0, -35)
emoteBubble.BackgroundTransparency = 1
emoteBubble.Text = ""
emoteBubble.TextColor3 = Color3.new(1, 1, 1)
emoteBubble.Font = Enum.Font.GothamBold
emoteBubble.TextSize = 20
emoteBubble.TextTransparency = 1
emoteBubble.ZIndex = 15
emoteBubble.Parent = topCapsule

local capsuleText = Instance.new("TextLabel")
capsuleText.Size = UDim2.new(1, -10, 1, -4)
capsuleText.Position = UDim2.new(0.5, 0, 0.5, 0)
capsuleText.AnchorPoint = Vector2.new(0.5, 0.5)
capsuleText.BackgroundTransparency = 1
capsuleText.Text = "欢迎使用x辅助"
capsuleText.TextColor3 = Color3.new(1, 1, 1)
capsuleText.Font = Enum.Font.GothamBold
capsuleText.TextSize = 14
capsuleText.TextTransparency = 1
capsuleText.ZIndex = 14
capsuleText.Parent = topCapsule

-- ========== 主方框（毛玻璃效果） ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
mainFrame.BackgroundTransparency = 0.35
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.new(1, 1, 1)
mainFrame.BorderMode = Enum.BorderMode.Inset
mainFrame.Visible = false
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local glassOverlay = Instance.new("Frame")
glassOverlay.Size = UDim2.new(1, 0, 1, 0)
glassOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
glassOverlay.BackgroundTransparency = 0.85
glassOverlay.BorderSizePixel = 0
glassOverlay.ZIndex = 6
glassOverlay.Parent = mainFrame
Instance.new("UICorner", glassOverlay).CornerRadius = UDim.new(0, 12)

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 180, 1, 0)
leftPanel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
leftPanel.BackgroundTransparency = 0.4
leftPanel.BorderSizePixel = 0
leftPanel.ZIndex = 7
leftPanel.Parent = mainFrame
Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0, 12)

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1, -180, 1, 0)
rightPanel.Position = UDim2.new(0, 180, 0, 0)
rightPanel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
rightPanel.BackgroundTransparency = 0.4
rightPanel.BorderSizePixel = 0
rightPanel.ZIndex = 7
rightPanel.Parent = mainFrame
Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0, 12)

-- 为rightPanel添加裁剪，防止切换动画时内容溢出
local rightClipFrame = Instance.new("Frame")
rightClipFrame.Size = UDim2.new(1, 0, 1, 0)
rightClipFrame.Position = UDim2.new(0, 0, 0, 0)
rightClipFrame.BackgroundTransparency = 1
rightClipFrame.BorderSizePixel = 0
rightClipFrame.ClipsDescendants = true
rightClipFrame.ZIndex = 7
rightClipFrame.Parent = rightPanel

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.new(1, 0.2, 0.2)
closeButton.BackgroundTransparency = 0.2
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.ZIndex = 8
closeButton.Parent = mainFrame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- ========== 确认关闭对话框 ==========
local confirmDialog = Instance.new("Frame")
confirmDialog.Name = "ConfirmDialog"
confirmDialog.Size = UDim2.new(0, 320, 0, 150)
confirmDialog.Position = UDim2.new(0.5, -160, 0, -170)
confirmDialog.BackgroundColor3 = Color3.new(0.1, 0.1, 0.12)
confirmDialog.BackgroundTransparency = 0.15
confirmDialog.BorderSizePixel = 1
confirmDialog.BorderColor3 = Color3.new(0.4, 0.4, 0.5)
confirmDialog.Visible = false
confirmDialog.ZIndex = 20
confirmDialog.Parent = screenGui
local dialogCorner = Instance.new("UICorner")
dialogCorner.CornerRadius = UDim.new(0, 12)
dialogCorner.Parent = confirmDialog

local dialogTitle = Instance.new("TextLabel")
dialogTitle.Size = UDim2.new(1, 0, 0, 40)
dialogTitle.Position = UDim2.new(0, 0, 0, 5)
dialogTitle.BackgroundTransparency = 1
dialogTitle.Text = "⚠ 关闭程序"
dialogTitle.TextColor3 = Color3.new(1, 0.7, 0.3)
dialogTitle.Font = Enum.Font.GothamBold
dialogTitle.TextSize = 20
dialogTitle.ZIndex = 21
dialogTitle.Parent = confirmDialog

local dialogMessage = Instance.new("TextLabel")
dialogMessage.Size = UDim2.new(1, -20, 0, 30)
dialogMessage.Position = UDim2.new(0, 10, 0, 50)
dialogMessage.BackgroundTransparency = 1
dialogMessage.Text = "确定要关闭辅助程序吗？"
dialogMessage.TextColor3 = Color3.new(1, 1, 1)
dialogMessage.Font = Enum.Font.Gotham
dialogMessage.TextSize = 14
dialogMessage.ZIndex = 21
dialogMessage.Parent = confirmDialog

local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0, 110, 0, 36)
cancelBtn.Position = UDim2.new(0.5, -120, 0, 95)
cancelBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.35)
cancelBtn.BackgroundTransparency = 0.2
cancelBtn.Text = "取消"
cancelBtn.TextColor3 = Color3.new(1, 1, 1)
cancelBtn.Font = Enum.Font.GothamBold
cancelBtn.TextSize = 15
cancelBtn.ZIndex = 21
cancelBtn.Parent = confirmDialog
Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 8)

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0, 110, 0, 36)
confirmBtn.Position = UDim2.new(0.5, 10, 0, 95)
confirmBtn.BackgroundColor3 = Color3.new(1, 0.2, 0.2)
confirmBtn.BackgroundTransparency = 0.2
confirmBtn.Text = "确定"
confirmBtn.TextColor3 = Color3.new(1, 1, 1)
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextSize = 15
confirmBtn.ZIndex = 21
confirmBtn.Parent = confirmDialog
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)

local isDialogAnimating = false

local function showConfirmDialog()
	if isDialogAnimating or confirmDialog.Visible then return end
	isDialogAnimating = true
	confirmDialog.Visible = true
	confirmDialog.Position = UDim2.new(0.5, -160, 0, -170)
	
	local ti = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local targetPos = UDim2.new(0.5, -160, 0, 30)
	TweenService:Create(confirmDialog, ti, {Position = targetPos}):Play()
	task.wait(0.5)
	isDialogAnimating = false
end

local function hideConfirmDialog(callback)
	if isDialogAnimating or not confirmDialog.Visible then return end
	isDialogAnimating = true
	
	local ti = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local targetPos = UDim2.new(0.5, -160, 0, -170)
	local tween = TweenService:Create(confirmDialog, ti, {Position = targetPos})
	tween:Play()
	tween.Completed:Connect(function()
		confirmDialog.Visible = false
		isDialogAnimating = false
		if callback then callback() end
	end)
end

cancelBtn.MouseButton1Click:Connect(function()
	hideConfirmDialog()
end)

confirmBtn.MouseButton1Click:Connect(function()
	hideConfirmDialog(function()
		espEnabled = false
		aimbotEnabled = false
		flyEnabled = false
		speedEnabled = false
		TweenService:Create(blurEffect, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
		task.wait(0.3)
		blurEffect:Destroy()
		screenGui:Destroy()
	end)
end)

closeButton.MouseButton1Click:Connect(function()
	showConfirmDialog()
end)

-- ========== 选项卡 ==========
local tabNames = {"公告", "透视", "功能"}
local contentFrames = {}
local currentTabIndex = 1
local isTabSwitching = false

local optionList = Instance.new("ScrollingFrame")
optionList.Size = UDim2.new(1, -10, 1, -10)
optionList.Position = UDim2.new(0, 5, 0, 5)
optionList.BackgroundTransparency = 1
optionList.BorderSizePixel = 0
optionList.ScrollBarThickness = 4
optionList.CanvasSize = UDim2.new(0, 0, 0, 0)
optionList.ZIndex = 8
optionList.Parent = leftPanel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = optionList

-- ========== 页面切换动画函数 ==========
local function switchToTab(targetIndex, fromDirection)
	if isTabSwitching then return end
	if targetIndex == currentTabIndex then return end
	
	isTabSwitching = true
	
	local oldContent = contentFrames[tabNames[currentTabIndex]]
	local newContent = contentFrames[tabNames[targetIndex]]
	
	if not oldContent or not newContent then
		isTabSwitching = false
		return
	end
	
	-- 判断切换方向：如果没有指定方向，根据索引判断（向下=右，向上=左）
	local direction = fromDirection or (targetIndex > currentTabIndex and "right" or "left")
	
	-- 当前页面滑出动画
	local oldStartPos, oldEndPos
	-- 新页面滑入起始位置
	local newStartPos, newEndPos
	
	if direction == "right" then
		-- 旧页面向左滑出，新页面从右边滑入
		oldStartPos = UDim2.new(0, 0, 0, 0)
		oldEndPos = UDim2.new(0, -rightClipFrame.AbsoluteSize.X, 0, 0)
		newStartPos = UDim2.new(0, rightClipFrame.AbsoluteSize.X, 0, 0)
		newEndPos = UDim2.new(0, 0, 0, 0)
	else
		-- 旧页面向右滑出，新页面从左边滑入
		oldStartPos = UDim2.new(0, 0, 0, 0)
		oldEndPos = UDim2.new(0, rightClipFrame.AbsoluteSize.X, 0, 0)
		newStartPos = UDim2.new(0, -rightClipFrame.AbsoluteSize.X, 0, 0)
		newEndPos = UDim2.new(0, 0, 0, 0)
	end
	
	-- 显示新页面并设置初始位置
	newContent.Visible = true
	newContent.Position = newStartPos
	
	-- 执行动画
	local animDuration = 0.35
	
	local oldTweenInfo = TweenInfo.new(animDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local newTweenInfo = TweenInfo.new(animDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	
	-- 给新页面添加一点弹性效果
	if direction == "right" then
		newTweenInfo = TweenInfo.new(animDuration * 1.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	else
		newTweenInfo = TweenInfo.new(animDuration * 1.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end
	
	-- 同时添加透明度变化
	local fadeOutInfo = TweenInfo.new(animDuration * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local fadeInInfo = TweenInfo.new(animDuration * 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	-- 旧页面淡出+滑出
	for _, child in ipairs(oldContent:GetDescendants()) do
		if child:IsA("TextLabel") or child:IsA("TextButton") then
			TweenService:Create(child, fadeOutInfo, {TextTransparency = 1}):Play()
		elseif child:IsA("Frame") and child.BackgroundTransparency < 1 then
			TweenService:Create(child, fadeOutInfo, {BackgroundTransparency = 1}):Play()
		end
	end
	
	local oldTween = TweenService:Create(oldContent, oldTweenInfo, {Position = oldEndPos})
	oldTween:Play()
	
	-- 新页面滑入
	local newTween = TweenService:Create(newContent, newTweenInfo, {Position = newEndPos})
	newTween:Play()
	
	-- 新页面淡入
	for _, child in ipairs(newContent:GetDescendants()) do
		if child:IsA("TextLabel") then
			child.TextTransparency = 1
			TweenService:Create(child, fadeInInfo, {TextTransparency = child.Name == "TitleGradient" and 0.5 or 0}):Play()
		elseif child:IsA("TextButton") then
			child.TextTransparency = 1
			TweenService:Create(child, fadeInInfo, {TextTransparency = 0}):Play()
		end
	end
	
	newTween.Completed:Connect(function()
		-- 动画完成后清理
		oldContent.Visible = false
		oldContent.Position = UDim2.new(0, 0, 0, 0)
		
		-- 恢复旧页面的透明度
		for _, child in ipairs(oldContent:GetDescendants()) do
			if child:IsA("TextLabel") then
				child.TextTransparency = 0
			elseif child:IsA("TextButton") then
				child.TextTransparency = 0
			elseif child:IsA("Frame") and child.BackgroundTransparency > 0 then
				-- 保持原有透明度
			end
		end
		
		currentTabIndex = targetIndex
		isTabSwitching = false
	end)
end

-- ========== ESP 透视功能 ==========
local espEnabled = false
local espObjects = {}

local espSettings = {
	box = true,
	skeleton = true,
	name = true,
	health = true,
	distance = true
}

local function createESP(playerToTrack)
	local espContainer = Instance.new("Frame")
	espContainer.Name = "ESP_" .. playerToTrack.Name
	espContainer.Size = UDim2.new(0, 0, 0, 0)
	espContainer.BackgroundTransparency = 1
	espContainer.BorderSizePixel = 0
	espContainer.ZIndex = 90
	espContainer.Parent = screenGui
	
	local topLine = Instance.new("Frame")
	topLine.Name = "TopLine"
	topLine.Size = UDim2.new(0, 0, 0, 2)
	topLine.BackgroundColor3 = Color3.new(1, 1, 1)
	topLine.BorderSizePixel = 0
	topLine.ZIndex = 100
	topLine.Parent = espContainer
	
	local bottomLine = Instance.new("Frame")
	bottomLine.Name = "BottomLine"
	bottomLine.Size = UDim2.new(0, 0, 0, 2)
	bottomLine.BackgroundColor3 = Color3.new(1, 1, 1)
	bottomLine.BorderSizePixel = 0
	bottomLine.ZIndex = 100
	bottomLine.Parent = espContainer
	
	local leftLine = Instance.new("Frame")
	leftLine.Name = "LeftLine"
	leftLine.Size = UDim2.new(0, 2, 0, 0)
	leftLine.BackgroundColor3 = Color3.new(1, 1, 1)
	leftLine.BorderSizePixel = 0
	leftLine.ZIndex = 100
	leftLine.Parent = espContainer
	
	local rightLine = Instance.new("Frame")
	rightLine.Name = "RightLine"
	rightLine.Size = UDim2.new(0, 2, 0, 0)
	rightLine.BackgroundColor3 = Color3.new(1, 1, 1)
	rightLine.BorderSizePixel = 0
	rightLine.ZIndex = 100
	rightLine.Parent = espContainer
	
	local function createBoneLine(name)
		local line = Instance.new("Frame")
		line.Name = name
		line.Size = UDim2.new(0, 0, 0, 2)
		line.BackgroundColor3 = Color3.new(1, 1, 1)
		line.BorderSizePixel = 0
		line.ZIndex = 100
		line.Parent = espContainer
		return line
	end
	
	createBoneLine("HeadToBody")
	createBoneLine("BodyToLeftArm")
	createBoneLine("BodyToRightArm")
	createBoneLine("BodyToLeftLeg")
	createBoneLine("BodyToRightLeg")
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = playerToTrack.Name
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 13
	nameLabel.TextStrokeTransparency = 0.7
	nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	nameLabel.ZIndex = 100
	nameLabel.Parent = espContainer
	
	local healthBg = Instance.new("Frame")
	healthBg.Name = "HealthBg"
	healthBg.Size = UDim2.new(0, 3, 0, 0)
	healthBg.BackgroundColor3 = Color3.new(0, 0, 0)
	healthBg.BackgroundTransparency = 0.4
	healthBg.BorderSizePixel = 0
	healthBg.ZIndex = 99
	healthBg.Parent = espContainer
	
	local healthBar = Instance.new("Frame")
	healthBar.Name = "HealthBar"
	healthBar.Size = UDim2.new(1, 0, 1, 0)
	healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
	healthBar.BorderSizePixel = 0
	healthBar.ZIndex = 100
	healthBar.Parent = healthBg
	
	local distanceLabel = Instance.new("TextLabel")
	distanceLabel.Name = "DistanceLabel"
	distanceLabel.BackgroundTransparency = 1
	distanceLabel.Text = ""
	distanceLabel.TextColor3 = Color3.new(1, 1, 1)
	distanceLabel.Font = Enum.Font.Gotham
	distanceLabel.TextSize = 12
	distanceLabel.TextStrokeTransparency = 0.7
	distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	distanceLabel.ZIndex = 100
	distanceLabel.Parent = espContainer
	
	espObjects[playerToTrack] = espContainer
	return espContainer
end

local function removeESP(playerToTrack)
	if espObjects[playerToTrack] then
		espObjects[playerToTrack]:Destroy()
		espObjects[playerToTrack] = nil
	end
end

local function updateESP()
	if not espEnabled then return end
	
	local camera = workspace.CurrentCamera
	if not camera then return end
	
	local myChar = player.Character
	local myRootPart = myChar and myChar:FindFirstChild("HumanoidRootPart")
	
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= player then
			local character = targetPlayer.Character
			if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("Head") then
				local humanoid = character.Humanoid
				local head = character.Head
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				
				if humanoid.Health > 0 and head and humanoidRootPart then
					local espContainer = espObjects[targetPlayer]
					if not espContainer then
						espContainer = createESP(targetPlayer)
					end
					
					local headPos = head.Position
					local rootPos = humanoidRootPart.Position
					local headScreenPos, headOnScreen = camera:WorldToScreenPoint(headPos)
					local rootScreenPos, rootOnScreen = camera:WorldToScreenPoint(rootPos)
					
					if headOnScreen and rootOnScreen then
						local height = math.abs(headScreenPos.Y - rootScreenPos.Y)
						local boxHeight = height * 1.8
						local boxWidth = boxHeight * 0.45
						
						local boxX = headScreenPos.X - boxWidth / 2
						local boxY = headScreenPos.Y - boxHeight * 0.1
						
						if espSettings.box then
							local topLine = espContainer:FindFirstChild("TopLine")
							local bottomLine = espContainer:FindFirstChild("BottomLine")
							local leftLine = espContainer:FindFirstChild("LeftLine")
							local rightLine = espContainer:FindFirstChild("RightLine")
							
							if topLine then
								topLine.Visible = true
								topLine.Size = UDim2.new(0, boxWidth, 0, 2)
								topLine.Position = UDim2.new(0, boxX, 0, boxY)
							end
							if bottomLine then
								bottomLine.Visible = true
								bottomLine.Size = UDim2.new(0, boxWidth, 0, 2)
								bottomLine.Position = UDim2.new(0, boxX, 0, boxY + boxHeight)
							end
							if leftLine then
								leftLine.Visible = true
								leftLine.Size = UDim2.new(0, 2, 0, boxHeight)
								leftLine.Position = UDim2.new(0, boxX, 0, boxY)
							end
							if rightLine then
								rightLine.Visible = true
								rightLine.Size = UDim2.new(0, 2, 0, boxHeight)
								rightLine.Position = UDim2.new(0, boxX + boxWidth, 0, boxY)
							end
						else
							for _, lineName in ipairs({"TopLine", "BottomLine", "LeftLine", "RightLine"}) do
								local line = espContainer:FindFirstChild(lineName)
								if line then line.Visible = false end
							end
						end
						
						if espSettings.skeleton then
							local function getPartScreenPos(partName)
								local part = character:FindFirstChild(partName)
								if part then
									local pos, onScreen = camera:WorldToScreenPoint(part.Position)
									if onScreen then return pos end
								end
								return nil
							end
							
							local function drawLine(lineFrame, startPos, endPos)
								if lineFrame and startPos and endPos then
									local dx = endPos.X - startPos.X
									local dy = endPos.Y - startPos.Y
									local length = math.sqrt(dx * dx + dy * dy)
									if length > 0 then
										local angle = math.deg(math.atan2(dy, dx))
										local midX = (startPos.X + endPos.X) / 2
										local midY = (startPos.Y + endPos.Y) / 2
										
										lineFrame.Visible = true
										lineFrame.Size = UDim2.new(0, length, 0, 2)
										lineFrame.Position = UDim2.new(0, midX - length/2, 0, midY - 1)
										lineFrame.Rotation = angle
									else
										lineFrame.Visible = false
									end
								elseif lineFrame then
									lineFrame.Visible = false
								end
							end
							
							local headSP = getPartScreenPos("Head")
							local upperTorsoSP = getPartScreenPos("UpperTorso") or getPartScreenPos("Torso")
							local leftArmSP = getPartScreenPos("LeftHand") or getPartScreenPos("LeftLowerArm")
							local rightArmSP = getPartScreenPos("RightHand") or getPartScreenPos("RightLowerArm")
							local leftLegSP = getPartScreenPos("LeftFoot") or getPartScreenPos("LeftLowerLeg")
							local rightLegSP = getPartScreenPos("RightFoot") or getPartScreenPos("RightLowerLeg")
							
							drawLine(espContainer:FindFirstChild("HeadToBody"), headSP, upperTorsoSP)
							drawLine(espContainer:FindFirstChild("BodyToLeftArm"), upperTorsoSP, leftArmSP)
							drawLine(espContainer:FindFirstChild("BodyToRightArm"), upperTorsoSP, rightArmSP)
							drawLine(espContainer:FindFirstChild("BodyToLeftLeg"), upperTorsoSP, leftLegSP)
							drawLine(espContainer:FindFirstChild("BodyToRightLeg"), upperTorsoSP, rightLegSP)
						else
							for _, boneName in ipairs({"HeadToBody", "BodyToLeftArm", "BodyToRightArm", "BodyToLeftLeg", "BodyToRightLeg"}) do
								local bone = espContainer:FindFirstChild(boneName)
								if bone then bone.Visible = false end
							end
						end
						
						local nameLabel = espContainer:FindFirstChild("NameLabel")
						if nameLabel then
							if espSettings.name then
								nameLabel.Visible = true
								nameLabel.Text = targetPlayer.Name
								nameLabel.Position = UDim2.new(0, boxX + boxWidth/2, 0, boxY - 18)
								nameLabel.AnchorPoint = Vector2.new(0.5, 1)
							else
								nameLabel.Visible = false
							end
						end
						
						local healthBg = espContainer:FindFirstChild("HealthBg")
						local healthBar = healthBg and healthBg:FindFirstChild("HealthBar")
						if healthBg and healthBar then
							if espSettings.health then
								healthBg.Visible = true
								local healthPercent = humanoid.Health / humanoid.MaxHealth
								healthBg.Size = UDim2.new(0, 3, 0, boxHeight)
								healthBg.Position = UDim2.new(0, boxX - 6, 0, boxY)
								healthBar.Size = UDim2.new(1, 0, healthPercent, 0)
								
								if healthPercent > 0.6 then
									healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
								elseif healthPercent > 0.3 then
									healthBar.BackgroundColor3 = Color3.new(1, 1, 0)
								else
									healthBar.BackgroundColor3 = Color3.new(1, 0, 0)
								end
							else
								healthBg.Visible = false
							end
						end
						
						local distanceLabel = espContainer:FindFirstChild("DistanceLabel")
						if distanceLabel then
							if espSettings.distance then
								distanceLabel.Visible = true
								local dist = 0
								if myRootPart then
									dist = (myRootPart.Position - rootPos).Magnitude
								end
								distanceLabel.Text = string.format("%.1fm", dist)
								distanceLabel.Position = UDim2.new(0, boxX + boxWidth/2, 0, boxY + boxHeight + 3)
								distanceLabel.AnchorPoint = Vector2.new(0.5, 0)
							else
								distanceLabel.Visible = false
							end
						end
					else
						for _, child in ipairs(espContainer:GetChildren()) do
							if child:IsA("GuiObject") then
								child.Visible = false
							end
						end
					end
				else
					removeESP(targetPlayer)
				end
			else
				removeESP(targetPlayer)
			end
		end
	end
end

-- ========== 强锁自瞄 ==========
local aimbotEnabled = false
local aimbotTarget = nil

local function getClosestEnemy()
	local camera = workspace.CurrentCamera
	if not camera then return nil end
	
	local closestPlayer = nil
	local closestDistance = math.huge
	local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
	
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= player then
			local character = targetPlayer.Character
			if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("Head") then
				if character.Humanoid.Health > 0 then
					local headPos, onScreen = camera:WorldToScreenPoint(character.Head.Position)
					if onScreen then
						local distance = (Vector2.new(headPos.X, headPos.Y) - screenCenter).Magnitude
						local worldDist = (character.Head.Position - camera.CFrame.Position).Magnitude
						if distance < closestDistance and worldDist < 500 then
							closestDistance = distance
							closestPlayer = targetPlayer
						end
					end
				end
			end
		end
	end
	
	return closestPlayer
end

local function updateAimbot()
	if not aimbotEnabled then return end
	
	local camera = workspace.CurrentCamera
	if not camera then return end
	
	local target = getClosestEnemy()
	if target and target.Character and target.Character:FindFirstChild("Head") then
		local headPos = target.Character.Head.Position
		camera.CFrame = CFrame.new(camera.CFrame.Position, headPos)
	end
end

-- ========== 飞天功能 ==========
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

local flySpeedBar = Instance.new("Frame")
flySpeedBar.Name = "FlySpeedBar"
flySpeedBar.Size = UDim2.new(0, 220, 0, 30)
flySpeedBar.Position = UDim2.new(0.5, -110, 0, 60)
flySpeedBar.BackgroundColor3 = Color3.new(0, 0, 0)
flySpeedBar.BackgroundTransparency = 0.3
flySpeedBar.BorderSizePixel = 0
flySpeedBar.Visible = false
flySpeedBar.ZIndex = 50
flySpeedBar.Parent = screenGui
Instance.new("UICorner", flySpeedBar).CornerRadius = UDim.new(0, 15)

local flyMinusBtn = Instance.new("TextButton")
flyMinusBtn.Size = UDim2.new(0, 30, 0, 30)
flyMinusBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
flyMinusBtn.Text = "-"
flyMinusBtn.TextColor3 = Color3.new(1, 1, 1)
flyMinusBtn.Font = Enum.Font.GothamBold
flyMinusBtn.TextSize = 20
flyMinusBtn.BorderSizePixel = 0
flyMinusBtn.ZIndex = 51
flyMinusBtn.Parent = flySpeedBar
Instance.new("UICorner", flyMinusBtn).CornerRadius = UDim.new(0, 15)

local flyPlusBtn = Instance.new("TextButton")
flyPlusBtn.Size = UDim2.new(0, 30, 0, 30)
flyPlusBtn.Position = UDim2.new(1, -30, 0, 0)
flyPlusBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
flyPlusBtn.Text = "+"
flyPlusBtn.TextColor3 = Color3.new(1, 1, 1)
flyPlusBtn.Font = Enum.Font.GothamBold
flyPlusBtn.TextSize = 20
flyPlusBtn.BorderSizePixel = 0
flyPlusBtn.ZIndex = 51
flyPlusBtn.Parent = flySpeedBar
Instance.new("UICorner", flyPlusBtn).CornerRadius = UDim.new(0, 15)

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(1, -70, 1, 0)
flySpeedLabel.Position = UDim2.new(0, 35, 0, 0)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "飞行速度: 50"
flySpeedLabel.TextColor3 = Color3.new(1, 1, 1)
flySpeedLabel.Font = Enum.Font.GothamBold
flySpeedLabel.TextSize = 14
flySpeedLabel.ZIndex = 51
flySpeedLabel.Parent = flySpeedBar

local function updateFlySpeedDisplay()
	flySpeedLabel.Text = "飞行速度: " .. flySpeed
	if flyBodyVelocity then
		flyBodyVelocity.MaxForce = Vector3.new(flySpeed * 100, flySpeed * 100, flySpeed * 100)
	end
end

flyMinusBtn.MouseButton1Click:Connect(function()
	if flySpeed > 10 then
		flySpeed = flySpeed - 10
		updateFlySpeedDisplay()
	end
end)

flyPlusBtn.MouseButton1Click:Connect(function()
	flySpeed = flySpeed + 10
	updateFlySpeedDisplay()
end)

local function startFly()
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	
	local rootPart = player.Character.HumanoidRootPart
	local humanoid = player.Character:FindFirstChild("Humanoid")
	
	if humanoid then
		humanoid.PlatformStand = true
	end
	
	flyBodyVelocity = Instance.new("BodyVelocity")
	flyBodyVelocity.Velocity = Vector3.zero
	flyBodyVelocity.MaxForce = Vector3.new(flySpeed * 100, flySpeed * 100, flySpeed * 100)
	flyBodyVelocity.P = 1000
	flyBodyVelocity.Parent = rootPart
	
	flyBodyGyro = Instance.new("BodyGyro")
	flyBodyGyro.CFrame = rootPart.CFrame
	flyBodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 400000
	flyBodyGyro.P = 30000
	flyBodyGyro.Parent = rootPart
	
	local camera = workspace.CurrentCamera
	
	flyConnection = RunService.Heartbeat:Connect(function()
		if not flyEnabled then return end
		if not player.Character or not rootPart or not rootPart.Parent then return end
		if not camera then return end
		
		local camCF = camera.CFrame
		flyBodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camCF.LookVector)
		
		local moveDirection = Vector3.zero
		
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDirection = moveDirection + camCF.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDirection = moveDirection - camCF.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDirection = moveDirection - camCF.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDirection = moveDirection + camCF.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			moveDirection = moveDirection + Vector3.new(0, 1, 0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			moveDirection = moveDirection - Vector3.new(0, 1, 0)
		end
		
		if moveDirection.Magnitude > 0 then
			moveDirection = moveDirection.Unit
		end
		
		flyBodyVelocity.Velocity = moveDirection * flySpeed
	end)
	
	flySpeedBar.Visible = true
end

local function stopFly()
	flyEnabled = false
	
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end
	
	if flyBodyVelocity then
		flyBodyVelocity:Destroy()
		flyBodyVelocity = nil
	end
	
	if flyBodyGyro then
		flyBodyGyro:Destroy()
		flyBodyGyro = nil
	end
	
	if player.Character then
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
		end
	end
	
	flySpeedBar.Visible = false
end

-- ========== 人物奔跑速度修改 ==========
local speedEnabled = false
local walkSpeed = 16
local originalWalkSpeed = 16

local speedBar = Instance.new("Frame")
speedBar.Name = "SpeedBar"
speedBar.Size = UDim2.new(0, 220, 0, 30)
speedBar.Position = UDim2.new(0.5, -110, 0, 100)
speedBar.BackgroundColor3 = Color3.new(0, 0, 0)
speedBar.BackgroundTransparency = 0.3
speedBar.BorderSizePixel = 0
speedBar.Visible = false
speedBar.ZIndex = 50
speedBar.Parent = screenGui
Instance.new("UICorner", speedBar).CornerRadius = UDim.new(0, 15)

local speedMinusBtn = Instance.new("TextButton")
speedMinusBtn.Size = UDim2.new(0, 30, 0, 30)
speedMinusBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
speedMinusBtn.Text = "-"
speedMinusBtn.TextColor3 = Color3.new(1, 1, 1)
speedMinusBtn.Font = Enum.Font.GothamBold
speedMinusBtn.TextSize = 20
speedMinusBtn.BorderSizePixel = 0
speedMinusBtn.ZIndex = 51
speedMinusBtn.Parent = speedBar
Instance.new("UICorner", speedMinusBtn).CornerRadius = UDim.new(0, 15)

local speedPlusBtn = Instance.new("TextButton")
speedPlusBtn.Size = UDim2.new(0, 30, 0, 30)
speedPlusBtn.Position = UDim2.new(1, -30, 0, 0)
speedPlusBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
speedPlusBtn.Text = "+"
speedPlusBtn.TextColor3 = Color3.new(1, 1, 1)
speedPlusBtn.Font = Enum.Font.GothamBold
speedPlusBtn.TextSize = 20
speedPlusBtn.BorderSizePixel = 0
speedPlusBtn.ZIndex = 51
speedPlusBtn.Parent = speedBar
Instance.new("UICorner", speedPlusBtn).CornerRadius = UDim.new(0, 15)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -70, 1, 0)
speedLabel.Position = UDim2.new(0, 35, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "奔跑速度: 16"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.ZIndex = 51
speedLabel.Parent = speedBar

local function updateSpeedDisplay()
	speedLabel.Text = "奔跑速度: " .. walkSpeed
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = walkSpeed
	end
end

speedMinusBtn.MouseButton1Click:Connect(function()
	if walkSpeed > 1 then
		walkSpeed = walkSpeed - 1
		updateSpeedDisplay()
	end
end)

speedPlusBtn.MouseButton1Click:Connect(function()
	walkSpeed = walkSpeed + 1
	updateSpeedDisplay()
end)

local function startSpeed()
	speedEnabled = true
	speedBar.Visible = true
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = walkSpeed
	end
	player.CharacterAdded:Connect(function(character)
		if speedEnabled then
			local humanoid = character:WaitForChild("Humanoid")
			humanoid.WalkSpeed = walkSpeed
		end
	end)
end

local function stopSpeed()
	speedEnabled = false
	speedBar.Visible = false
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = originalWalkSpeed
	end
end

if player.Character and player.Character:FindFirstChild("Humanoid") then
	originalWalkSpeed = player.Character.Humanoid.WalkSpeed
end

-- ========== 主循环 ==========
RunService.RenderStepped:Connect(function()
	updateESP()
	updateAimbot()
end)

Players.PlayerRemoving:Connect(function(leftPlayer)
	removeESP(leftPlayer)
end)

for i, name in ipairs(tabNames) do
	local tabBtn = Instance.new("TextButton")
	tabBtn.Name = name .. "Tab"
	tabBtn.Size = UDim2.new(1, -10, 0, 36)
	tabBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	tabBtn.BackgroundTransparency = 0.3
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.new(1, 1, 1)
	tabBtn.Font = Enum.Font.Gotham
	tabBtn.TextSize = 16
	tabBtn.ZIndex = 8
	tabBtn.Parent = optionList
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, 0, 1, 0)
	contentFrame.Position = UDim2.new(0, 0, 0, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Visible = false
	contentFrame.ZIndex = 8
	contentFrame.Parent = rightClipFrame  -- 改为放在rightClipFrame下
	
	-- 内容区域加内边距
	local contentInner = Instance.new("Frame")
	contentInner.Size = UDim2.new(1, -20, 1, -20)
	contentInner.Position = UDim2.new(0, 10, 0, 10)
	contentInner.BackgroundTransparency = 1
	contentInner.ZIndex = 8
	contentInner.Parent = contentFrame

	if name == "公告" then
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.Position = UDim2.new(0, 0, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "本辅助暂时公益\n反馈可延长公益时长"
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextSize = 20
		textLabel.TextWrapped = true
		textLabel.TextYAlignment = Enum.TextYAlignment.Center
		textLabel.ZIndex = 8
		textLabel.Parent = contentInner
	
	elseif name == "透视" then
		local espToggle = Instance.new("TextButton")
		espToggle.Name = "ESPToggle"
		espToggle.Size = UDim2.new(1, 0, 0, 40)
		espToggle.Position = UDim2.new(0, 0, 0, 5)
		espToggle.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
		espToggle.BackgroundTransparency = 0.2
		espToggle.Text = "透视总开关: 关闭"
		espToggle.TextColor3 = Color3.new(1, 1, 1)
		espToggle.Font = Enum.Font.GothamBold
		espToggle.TextSize = 15
		espToggle.ZIndex = 8
		espToggle.Parent = contentInner
		Instance.new("UICorner", espToggle).CornerRadius = UDim.new(0, 8)
		
		espToggle.MouseButton1Click:Connect(function()
			espEnabled = not espEnabled
			if espEnabled then
				espToggle.Text = "透视总开关: 开启"
				espToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.3)
			else
				espToggle.Text = "透视总开关: 关闭"
				espToggle.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
				for targetPlayer, container in pairs(espObjects) do
					container:Destroy()
				end
				espObjects = {}
			end
		end)
		
		local subOptionList = Instance.new("ScrollingFrame")
		subOptionList.Size = UDim2.new(1, 0, 1, -55)
		subOptionList.Position = UDim2.new(0, 0, 0, 55)
		subOptionList.BackgroundTransparency = 1
		subOptionList.BorderSizePixel = 0
		subOptionList.ScrollBarThickness = 4
		subOptionList.CanvasSize = UDim2.new(0, 0, 0, 0)
		subOptionList.ZIndex = 8
		subOptionList.Parent = contentInner
		
		local subLayout = Instance.new("UIListLayout")
		subLayout.Padding = UDim.new(0, 6)
		subLayout.Parent = subOptionList
		
		local subOptions = {
			{name = "人物方框", key = "box"},
			{name = "人物骨骼", key = "skeleton"},
			{name = "人物名字", key = "name"},
			{name = "人物血量", key = "health"},
			{name = "人物距离", key = "distance"}
		}
		
		for _, opt in ipairs(subOptions) do
			local subToggle = Instance.new("TextButton")
			subToggle.Name = opt.key .. "Toggle"
			subToggle.Size = UDim2.new(1, -5, 0, 36)
			subToggle.BackgroundColor3 = Color3.new(0.15, 0.2, 0.15)
			subToggle.BackgroundTransparency = 0.2
			subToggle.Text = opt.name .. ": 开启"
			subToggle.TextColor3 = Color3.new(1, 1, 1)
			subToggle.Font = Enum.Font.Gotham
			subToggle.TextSize = 14
			subToggle.ZIndex = 8
			subToggle.Parent = subOptionList
			Instance.new("UICorner", subToggle).CornerRadius = UDim.new(0, 6)
			
			subToggle.MouseButton1Click:Connect(function()
				espSettings[opt.key] = not espSettings[opt.key]
				if espSettings[opt.key] then
					subToggle.Text = opt.name .. ": 开启"
					subToggle.BackgroundColor3 = Color3.new(0.15, 0.2, 0.15)
				else
					subToggle.Text = opt.name .. ": 关闭"
					subToggle.BackgroundColor3 = Color3.new(0.2, 0.15, 0.15)
				end
			end)
		end
		
		subOptionList.CanvasSize = UDim2.new(0, 0, 0, subLayout.AbsoluteContentSize.Y + 10)
		subLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			subOptionList.CanvasSize = UDim2.new(0, 0, 0, subLayout.AbsoluteContentSize.Y + 10)
		end)
	
	elseif name == "功能" then
		local funcScrollingFrame = Instance.new("ScrollingFrame")
		funcScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
		funcScrollingFrame.BackgroundTransparency = 1
		funcScrollingFrame.BorderSizePixel = 0
		funcScrollingFrame.ScrollBarThickness = 4
		funcScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		funcScrollingFrame.ZIndex = 8
		funcScrollingFrame.Parent = contentInner
		
		local funcLayout = Instance.new("UIListLayout")
		funcLayout.Padding = UDim.new(0, 8)
		funcLayout.Parent = funcScrollingFrame
		
		-- 强锁自瞄
		local aimbotToggle = Instance.new("TextButton")
		aimbotToggle.Name = "AimbotToggle"
		aimbotToggle.Size = UDim2.new(1, -5, 0, 40)
		aimbotToggle.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
		aimbotToggle.BackgroundTransparency = 0.2
		aimbotToggle.Text = "强锁自瞄: 关闭"
		aimbotToggle.TextColor3 = Color3.new(1, 1, 1)
		aimbotToggle.Font = Enum.Font.GothamBold
		aimbotToggle.TextSize = 15
		aimbotToggle.ZIndex = 8
		aimbotToggle.Parent = funcScrollingFrame
		Instance.new("UICorner", aimbotToggle).CornerRadius = UDim.new(0, 8)
		
		aimbotToggle.MouseButton1Click:Connect(function()
			aimbotEnabled = not aimbotEnabled
			if aimbotEnabled then
				aimbotToggle.Text = "强锁自瞄: 开启"
				aimbotToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.3)
			else
				aimbotToggle.Text = "强锁自瞄: 关闭"
				aimbotToggle.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
			end
		end)
		
		-- 飞天
		local flyToggle = Instance.new("TextButton")
		flyToggle.Name = "FlyToggle"
		flyToggle.Size = UDim2.new(1, -5, 0, 40)
		flyToggle.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
		flyToggle.BackgroundTransparency = 0.2
		flyToggle.Text = "飞天: 关闭"
		flyToggle.TextColor3 = Color3.new(1, 1, 1)
		flyToggle.Font = Enum.Font.GothamBold
		flyToggle.TextSize = 15
		flyToggle.ZIndex = 8
		flyToggle.Parent = funcScrollingFrame
		Instance.new("UICorner", flyToggle).CornerRadius = UDim.new(0, 8)
		
		flyToggle.MouseButton1Click:Connect(function()
			flyEnabled = not flyEnabled
			if flyEnabled then
				flyToggle.Text = "飞天: 开启"
				flyToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.3)
				startFly()
			else
				flyToggle.Text = "飞天: 关闭"
				flyToggle.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
				stopFly()
			end
		end)
		
		-- 人物奔跑速度修改
		local speedToggle = Instance.new("TextButton")
		speedToggle.Name = "SpeedToggle"
		speedToggle.Size = UDim2.new(1, -5, 0, 40)
		speedToggle.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
		speedToggle.BackgroundTransparency = 0.2
		speedToggle.Text = "奔跑速度修改: 关闭"
		speedToggle.TextColor3 = Color3.new(1, 1, 1)
		speedToggle.Font = Enum.Font.GothamBold
		speedToggle.TextSize = 15
		speedToggle.ZIndex = 8
		speedToggle.Parent = funcScrollingFrame
		Instance.new("UICorner", speedToggle).CornerRadius = UDim.new(0, 8)
		
		speedToggle.MouseButton1Click:Connect(function()
			speedEnabled = not speedEnabled
			if speedEnabled then
				speedToggle.Text = "奔跑速度修改: 开启"
				speedToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.3)
				startSpeed()
			else
				speedToggle.Text = "奔跑速度修改: 关闭"
				speedToggle.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
				stopSpeed()
			end
		end)
		
		funcScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, funcLayout.AbsoluteContentSize.Y + 10)
		funcLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			funcScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, funcLayout.AbsoluteContentSize.Y + 10)
		end)
	end

	contentFrames[name] = contentFrame

	tabBtn.MouseButton1Click:Connect(function()
		-- 高亮当前按钮
		for _, btn in ipairs(optionList:GetChildren()) do
			if btn:IsA("TextButton") then
				btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			end
		end
		tabBtn.BackgroundColor3 = Color3.new(0.35, 0.5, 0.9)
		
		-- 使用切换动画
		local targetIndex = i
		switchToTab(targetIndex)
	end)
end

-- 初始化显示第一个选项卡
if tabNames[1] then
	local firstContent = contentFrames[tabNames[1]]
	if firstContent then
		firstContent.Visible = true
		firstContent.Position = UDim2.new(0, 0, 0, 0)
	end
	local firstBtn = optionList:FindFirstChild(tabNames[1] .. "Tab")
	if firstBtn then
		firstBtn.BackgroundColor3 = Color3.new(0.35, 0.5, 0.9)
	end
end

optionList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	optionList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- ========== 面部动画系统 ==========
local faceState = "idle"
local isPanelOpen = false
local currentLookConnection = nil
local lastInteraction = tick()
local handBusy = false
local globalCooldown = 0

-- ========== 调度系统：每分钟平均分配6个动画 ==========
local ANIMATIONS_PER_MINUTE = 6
local MINUTE_LENGTH = 60
local minuteTimer = 0
local animationsThisMinute = {}
local animationSlots = {}

local availableAnimations = {"sleepy", "wander", "giggle", "sneeze", "coverMouth", "scratchHead", "emote"}

local function redistributeAnimations()
	animationsThisMinute = {}
	animationSlots = {}
	
	local slotSize = MINUTE_LENGTH / ANIMATIONS_PER_MINUTE
	
	for i = 1, ANIMATIONS_PER_MINUTE do
		local slotStart = (i - 1) * slotSize
		local slotEnd = i * slotSize
		local triggerTime = slotStart + math.random(slotSize * 0.2, slotSize * 0.8)
		
		local anim = availableAnimations[math.random(#availableAnimations)]
		
		table.insert(animationSlots, {
			time = triggerTime,
			animation = anim,
			triggered = false
		})
	end
	
	table.sort(animationSlots, function(a, b) return a.time < b.time end)
end

redistributeAnimations()

local function resetPupils()
	if currentLookConnection then currentLookConnection:Disconnect(); currentLookConnection = nil end
	local info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(leftPupil, info, {Position = UDim2.new(0.5, -2.5, 0.5, -2.5)}):Play()
	TweenService:Create(rightPupil, info, {Position = UDim2.new(0.5, -2.5, 0.5, -2.5)}):Play()
end

local function lookAt(worldPos)
	if not worldPos then resetPupils(); return end
	if currentLookConnection then currentLookConnection:Disconnect() end
	local function updateLook()
		local eyeCenter = leftEye.AbsolutePosition + leftEye.AbsoluteSize / 2
		local dir = worldPos - eyeCenter
		local offset = dir.Unit * math.min(dir.Magnitude / 150, 1) * 2.5
		local info = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(leftPupil, info, {Position = UDim2.new(0.5, offset.X - 2.5, 0.5, offset.Y - 2.5)}):Play()
		TweenService:Create(rightPupil, info, {Position = UDim2.new(0.5, offset.X - 2.5, 0.5, offset.Y - 2.5)}):Play()
	end
	updateLook()
	currentLookConnection = RunService.Heartbeat:Connect(updateLook)
end

local function setEyeOpenness(level)
	local baseSize = 10
	local newHeight = baseSize * level
	local info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(leftEye, info, {Size = UDim2.new(0, baseSize, 0, newHeight)}):Play()
	TweenService:Create(rightEye, info, {Size = UDim2.new(0, baseSize, 0, newHeight)}):Play()
	local hs = level >= 0.8 and 3 or (level >= 0.3 and 2 or 1)
	TweenService:Create(leftHighlight, info, {Size = UDim2.new(0, hs, 0, hs)}):Play()
	TweenService:Create(rightHighlight, info, {Size = UDim2.new(0, hs, 0, hs)}):Play()
end

local function setMouth(type)
	local info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	if type == "neutral" then
		TweenService:Create(mouth, info, {Size = UDim2.new(0, 14, 0, 3), Position = UDim2.new(0.5, -7, 0.72, -1)}):Play()
		TweenService:Create(mouthCorner, info, {CornerRadius = UDim.new(0, 1.5)}):Play()
	elseif type == "surprised" then
		TweenService:Create(mouth, info, {Size = UDim2.new(0, 7, 0, 7), Position = UDim2.new(0.5, -3.5, 0.65, -3.5)}):Play()
		TweenService:Create(mouthCorner, info, {CornerRadius = UDim.new(1, 0)}):Play()
	elseif type == "question" then
		TweenService:Create(mouth, info, {Size = UDim2.new(0, 9, 0, 4), Position = UDim2.new(0.5, -4.5, 0.73, -2)}):Play()
		TweenService:Create(mouthCorner, info, {CornerRadius = UDim.new(0, 2)}):Play()
	elseif type == "sleepy" then
		TweenService:Create(mouth, info, {Size = UDim2.new(0, 7, 0, 1.5), Position = UDim2.new(0.5, -3.5, 0.74, -0.5)}):Play()
		TweenService:Create(mouthCorner, info, {CornerRadius = UDim.new(0, 0.5)}):Play()
	elseif type == "smile" then
		TweenService:Create(mouth, info, {Size = UDim2.new(0, 12, 0, 4), Position = UDim2.new(0.5, -6, 0.7, -2)}):Play()
		TweenService:Create(mouthCorner, info, {CornerRadius = UDim.new(0, 2)}):Play()
	elseif type == "sneeze" then
		TweenService:Create(mouth, info, {Size = UDim2.new(0, 10, 0, 8), Position = UDim2.new(0.5, -5, 0.63, -4)}):Play()
		TweenService:Create(mouthCorner, info, {CornerRadius = UDim.new(0, 3)}):Play()
	end
end

local function setBlush(intensity)
	local info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(leftBlush, info, {BackgroundTransparency = 1 - intensity * 0.4}):Play()
	TweenService:Create(rightBlush, info, {BackgroundTransparency = 1 - intensity * 0.4}):Play()
end

local function showEmote(emote, duration)
	emoteBubble.Text = emote
	TweenService:Create(emoteBubble, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0, TextSize = 20}):Play()
	task.delay(duration or 1.5, function()
		TweenService:Create(emoteBubble, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1, TextSize = 14}):Play()
	end)
end

local function setFaceTransparency(transparency)
	local info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	for _, part in ipairs({leftEye, rightEye, leftPupil, rightPupil, leftHighlight, rightHighlight, mouth}) do
		TweenService:Create(part, info, {BackgroundTransparency = transparency}):Play()
	end
	TweenService:Create(leftBlush, info, {BackgroundTransparency = 1 - (1 - transparency) * 0.4}):Play()
	TweenService:Create(rightBlush, info, {BackgroundTransparency = 1 - (1 - transparency) * 0.4}):Play()
end

-- ========== 手部动画 ==========
local function retractHand(hand)
	TweenService:Create(hand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, handSize, 0, handSize)}):Play()
	task.wait(0.2)
	hand.Visible = false
	handBusy = false
end

local function coverMouth(hand)
	handBusy = true
	hand.Visible = true
	TweenService:Create(hand, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, handSize * 1.3, 0, handSize * 1.3)}):Play()
	task.wait(0.25)
	TweenService:Create(hand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -handSize * 1.3 / 2, 0.72, -handSize * 1.3 / 2)}):Play()
	task.wait(1.5)
	retractHand(hand)
	hand.Position = (hand == leftHand) and UDim2.new(0, -5, 0.5, 0) or UDim2.new(1, 5, 0.5, 0)
end

local function scratchHead(hand)
	handBusy = true
	hand.Visible = true
	TweenService:Create(hand, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, handSize * 1.3, 0, handSize * 1.3)}):Play()
	task.wait(0.25)
	local topPos = UDim2.new(0.5, -handSize * 1.3 / 2, 0, -handSize * 1.3)
	TweenService:Create(hand, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = topPos}):Play()
	task.wait(0.2)
	for i = 1, 3 do
		TweenService:Create(hand, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = topPos + UDim2.new(0, 0, 0, -3)}):Play()
		task.wait(0.1)
		TweenService:Create(hand, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = topPos}):Play()
		task.wait(0.1)
	end
	retractHand(hand)
	hand.Position = (hand == leftHand) and UDim2.new(0, -5, 0.5, 0) or UDim2.new(1, 5, 0.5, 0)
end

local function sneeze()
	if handBusy or faceState == "sneezing" then return end
	faceState = "sneezing"
	globalCooldown = 2.5
	local op = topCapsule.Position
	TweenService:Create(topCapsule, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = op - UDim2.new(0, 0, 0, 4)}):Play()
	setEyeOpenness(0.1)
	setMouth("sneeze")
	task.wait(0.3)
	TweenService:Create(topCapsule, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = op + UDim2.new(0, 0, 0, 8)}):Play()
	showEmote("🤧", 1.5)
	task.wait(0.1)
	TweenService:Create(topCapsule, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = op}):Play()
	setEyeOpenness(1)
	setMouth("neutral")
	task.wait(0.5)
	faceState = "idle"
end

local function giggle()
	if faceState == "giggling" then return end
	local prev = faceState
	faceState = "giggling"
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(leftEye, info, {Size = UDim2.new(0, 10, 0, 3)}):Play()
	TweenService:Create(rightEye, info, {Size = UDim2.new(0, 10, 0, 3)}):Play()
	setMouth("smile")
	setBlush(1)
	local op = topCapsule.Position
	for i = 1, 3 do
		TweenService:Create(topCapsule, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = op + UDim2.new(0, 0, 0, -1)}):Play()
		task.wait(0.1)
		TweenService:Create(topCapsule, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = op}):Play()
		task.wait(0.1)
	end
	showEmote("😏", 1.5)
	task.wait(1)
	setEyeOpenness(1)
	setMouth("neutral")
	setBlush(0.3)
	faceState = prev
end

-- ========== 待机行为循环 ==========
local function idleBehaviorLoop()
	setEyeOpenness(1)
	setMouth("neutral")
	setBlush(0.3)
	faceState = "idle"

	while true do
		task.wait(0.5)
		if isPanelOpen or isAnimating then continue end

		if globalCooldown > 0 then
			globalCooldown = globalCooldown - 0.5
		end

		minuteTimer = minuteTimer + 0.5
		if minuteTimer >= MINUTE_LENGTH then
			minuteTimer = 0
			redistributeAnimations()
		end

		if not handBusy and math.random() < 0.08 then
			setEyeOpenness(0)
			task.wait(0.12)
			setEyeOpenness(1)
		end

		if not handBusy and globalCooldown <= 0 then
			for _, slot in ipairs(animationSlots) do
				if not slot.triggered and minuteTimer >= slot.time then
					slot.triggered = true
					
					if slot.animation == "sleepy" and faceState == "idle" then
						faceState = "sleepy"
						setEyeOpenness(0.25)
						setMouth("sleepy")
						setBlush(0.5)
						showEmote("💤", 2)
						task.wait(5)
						setEyeOpenness(1)
						setMouth("neutral")
						setBlush(0.3)
						faceState = "idle"
						
					elseif slot.animation == "wander" and faceState == "idle" then
						faceState = "wandering"
						local sw = screenGui.AbsoluteSize.X
						local sh = screenGui.AbsoluteSize.Y
						for i = 1, 3 do
							lookAt(Vector2.new(math.random(sw * 0.2, sw * 0.8), math.random(sh * 0.2, sh * 0.8)))
							task.wait(2)
						end
						resetPupils()
						faceState = "idle"
						
					elseif slot.animation == "giggle" and (faceState == "idle" or faceState == "sleepy") then
						giggle()
						
					elseif slot.animation == "sneeze" and (faceState == "idle" or faceState == "sleepy") then
						sneeze()
						
					elseif slot.animation == "coverMouth" and (faceState == "idle" or faceState == "sleepy") then
						local hand = math.random() < 0.5 and leftHand or rightHand
						faceState = "giggling"
						setBlush(0.8)
						coverMouth(hand)
						setBlush(0.3)
						faceState = "idle"
						
					elseif slot.animation == "scratchHead" and (faceState == "idle" or faceState == "sleepy") then
						local hand = math.random() < 0.5 and leftHand or rightHand
						scratchHead(hand)
						
					elseif slot.animation == "emote" and (faceState == "idle" or faceState == "sleepy") then
						local emotes = {"✨", "🌟", "💫", "🎮", "👀", "😊", "💪", "👍"}
						showEmote(emotes[math.random(#emotes)], 1.5)
					end
					
					break
				end
			end
		end

		local timeSinceInteraction = tick() - lastInteraction
		if timeSinceInteraction > 20 and faceState == "idle" and not handBusy and globalCooldown <= 0 then
			faceState = "questioning"
			setEyeOpenness(0.7)
			setMouth("question")
			showEmote("❓", 2)
			lookAt(UserInputService:GetMouseLocation())
			task.wait(2)
			resetPupils()
			setEyeOpenness(1)
			setMouth("neutral")
			faceState = "idle"
			lastInteraction = tick()
		end
	end
end

coroutine.wrap(idleBehaviorLoop)()

-- ========== 鼠标点击监听 ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if isPanelOpen or isAnimating then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mousePos = Vector2.new(input.Position.X, input.Position.Y)
		local capPos = topCapsule.AbsolutePosition
		local capSize = topCapsule.AbsoluteSize
		if mousePos.X >= capPos.X and mousePos.X <= capPos.X + capSize.X and
		   mousePos.Y >= capPos.Y and mousePos.Y <= capPos.Y + capSize.Y then
			return
		end
		lastInteraction = tick()
		if faceState == "sleepy" then
			faceState = "idle"
			setEyeOpenness(1)
			setMouth("neutral")
			setBlush(0.3)
		end
		if not handBusy then
			faceState = "looking"
			setEyeOpenness(0.8)
			setMouth("smile")
			lookAt(mousePos)
			showEmote("👀", 1.5)
			task.wait(1.5)
			resetPupils()
			setMouth("neutral")
			faceState = "idle"
		end
	end
end)

-- ========== 面板动画系统 ==========
local isAnimating = false

local function getCapsuleCenter()
	local pos = topCapsule.AbsolutePosition
	local size = topCapsule.AbsoluteSize
	return Vector2.new(pos.X + size.X / 2, pos.Y + size.Y / 2)
end

local function bezierPoint(p0, p1, p2, t)
	return (1 - t) ^ 2 * p0 + 2 * (1 - t) * t * p1 + t ^ 2 * p2
end

local function moveAlongCurve(ball, p0, p1, p2, duration)
	local startTime = tick()
	local connection
	connection = RunService.Heartbeat:Connect(function()
		local elapsed = tick() - startTime
		if elapsed >= duration then
			ball.Position = UDim2.new(0, p2.X, 0, p2.Y)
			connection:Disconnect()
		else
			local t = elapsed / duration
			local pos = bezierPoint(p0, p1, p2, t)
			ball.Position = UDim2.new(0, pos.X, 0, pos.Y)
		end
	end)
	return connection
end

local function enableBlur()
	TweenService:Create(blurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 24}):Play()
end

local function disableBlur()
	TweenService:Create(blurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
end

local function expandCapsule()
	local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(topCapsule, ti, {Size = UDim2.new(0, capsuleExpandedWidth, 0, capsuleHeight)}):Play()
	TweenService:Create(capsuleText, ti, {TextTransparency = 0}):Play()
	setFaceTransparency(1)
	TweenService:Create(emoteBubble, ti, {TextTransparency = 1}):Play()
	isPanelOpen = true
	enableBlur()
end

local function collapseCapsule()
	local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(topCapsule, ti, {Size = UDim2.new(0, capsuleWidth, 0, capsuleHeight)}):Play()
	TweenService:Create(capsuleText, ti, {TextTransparency = 1}):Play()
	setFaceTransparency(0)
	disableBlur()
	isPanelOpen = false
	faceState = "idle"
	setEyeOpenness(1)
	setMouth("neutral")
	setBlush(0.3)
	resetPupils()
	lastInteraction = tick()
end

local function bounceCapsule()
	local op = topCapsule.Position
	TweenService:Create(topCapsule, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = op + UDim2.new(0, 0, 0, 6)}):Play()
	task.wait(0.1)
	TweenService:Create(topCapsule, TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Position = op}):Play()
end

local function playExpandAnimation(direction)
	if isAnimating or mainFrame.Visible then return end
	isAnimating = true
	setEyeOpenness(1.3)
	setMouth("surprised")
	setBlush(0.2)
	showEmote("❗", 1)
	bounceCapsule()

	local bs = capsuleHeight
	local ball = Instance.new("Frame")
	ball.Name = "ExpandBall"
	ball.Size = UDim2.new(0, bs, 0, bs)
	ball.BackgroundColor3 = Color3.new(0, 0, 0)
	ball.BorderSizePixel = 0
	ball.AnchorPoint = Vector2.new(0.5, 0.5)
	ball.ZIndex = 15
	ball.Parent = screenGui
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, bs / 2)
	bc.Parent = ball

	local cc = getCapsuleCenter()
	ball.Position = UDim2.new(0, cc.X, 0, cc.Y)
	local tc = Vector2.new(screenGui.AbsoluteSize.X / 2, screenGui.AbsoluteSize.Y / 2)
	local md = 0.35

	if direction == "center" then
		TweenService:Create(ball, TweenInfo.new(md, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
		task.delay(md * 0.5, expandCapsule)
		task.delay(md * 0.5, function()
			local ei = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
			local st = TweenService:Create(ball, ei, {Size = UDim2.new(0, 600, 0, 400)})
			local ct = TweenService:Create(bc, ei, {CornerRadius = UDim.new(0, 8)})
			local clt = TweenService:Create(ball, ei, {BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)})
			st:Play(); ct:Play(); clt:Play()
			st.Completed:Connect(function() ball:Destroy(); mainFrame.Visible = true; isAnimating = false end)
		end)
	else
		local dir = tc - cc
		local perp = Vector2.new(dir.Y, -dir.X).Unit
		local sign = (direction == "left") and -1 or 1
		local mid = (cc + tc) / 2
		local cp = mid + perp * 150 * sign
		local curve = moveAlongCurve(ball, cc, cp, tc, md)
		task.delay(md * 0.5, expandCapsule)
		task.delay(md * 0.5, function()
			local ei = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
			local st = TweenService:Create(ball, ei, {Size = UDim2.new(0, 600, 0, 400)})
			local ct = TweenService:Create(bc, ei, {CornerRadius = UDim.new(0, 8)})
			local clt = TweenService:Create(ball, ei, {BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)})
			st:Play(); ct:Play(); clt:Play()
			st.Completed:Connect(function()
				if curve.Connected then curve:Disconnect() end
				ball:Destroy(); mainFrame.Visible = true; isAnimating = false
			end)
		end)
	end
end

local function playCollapseAnimation(direction)
	if isAnimating or not mainFrame.Visible then return end
	isAnimating = true
	bounceCapsule()
	mainFrame.Visible = false

	local ball = Instance.new("Frame")
	ball.Size = UDim2.new(0, 600, 0, 400)
	ball.Position = UDim2.new(0.5, 0, 0.5, 0)
	ball.AnchorPoint = Vector2.new(0.5, 0.5)
	ball.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
	ball.BorderSizePixel = 0
	ball.ZIndex = 15
	ball.Parent = screenGui
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 8)
	bc.Parent = ball

	local cc = getCapsuleCenter()
	local sc = Vector2.new(screenGui.AbsoluteSize.X / 2, screenGui.AbsoluteSize.Y / 2)
	local ci = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	TweenService:Create(ball, ci, {Size = UDim2.new(0, capsuleHeight, 0, capsuleHeight)}):Play()
	TweenService:Create(bc, ci, {CornerRadius = UDim.new(0, capsuleHeight / 2)}):Play()
	TweenService:Create(ball, ci, {BackgroundColor3 = Color3.new(0, 0, 0)}):Play()

	task.delay(0.225, function()
		if direction == "center" then
			local mt = TweenService:Create(ball, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0, cc.X, 0, cc.Y)})
			mt:Play()
			mt.Completed:Connect(function() ball:Destroy(); collapseCapsule(); isAnimating = false end)
		else
			local dir = cc - sc
			local perp = Vector2.new(dir.Y, -dir.X).Unit
			local sign = (direction == "left") and 1 or -1
			local mid = (sc + cc) / 2
			local cp = mid + perp * 150 * sign
			local curve = moveAlongCurve(ball, sc, cp, cc, 0.35)
			while curve.Connected do task.wait() end
			ball:Destroy(); collapseCapsule(); isAnimating = false
		end
	end)
end

-- ========== 胶囊点击 ==========
topCapsule.MouseButton1Click:Connect(function()
	if isAnimating then return end
	local capSize = topCapsule.AbsoluteSize
	local capPos = topCapsule.AbsolutePosition
	local capLeft = capPos.X
	local capRight = capLeft + capSize.X
	local mousePos = UserInputService:GetMouseLocation()
	local clickX = mousePos.X
	local threshold = capSize.X * 0.1
	local centerX = capLeft + capSize.X / 2
	local dist = math.abs(clickX - centerX)

	local direction
	if dist <= threshold then direction = "center"
	elseif clickX < centerX then direction = "left"
	else direction = "right" end

	if mainFrame.Visible then playCollapseAnimation(direction)
	else playExpandAnimation(direction) end
end)
