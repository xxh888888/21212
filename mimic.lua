local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = character:WaitForChild("Humanoid")
end)

-- 创建屏幕GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedControl"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- 右下角小按钮
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 1, -50)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Text = "⚡"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 20
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 10
toggleButton.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = toggleButton

-- 速度控制面板
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 420, 0, 200)
panel.Position = UDim2.new(0.5, -210, 0.5, -100)
panel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 5
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

-- 顶部栏
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
topBar.BorderSizePixel = 0
topBar.ZIndex = 6
topBar.Parent = panel

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ 移动速度控制"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 7
title.Parent = topBar

-- 关闭程序按钮
local closeProgramButton = Instance.new("TextButton")
closeProgramButton.Size = UDim2.new(0, 90, 0, 26)
closeProgramButton.Position = UDim2.new(1, -100, 0, 7)
closeProgramButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeProgramButton.Text = "关闭程序"
closeProgramButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeProgramButton.TextSize = 13
closeProgramButton.Font = Enum.Font.GothamBold
closeProgramButton.BorderSizePixel = 0
closeProgramButton.ZIndex = 7
closeProgramButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeProgramButton

-- 速度显示标签
local speedDisplay = Instance.new("TextLabel")
speedDisplay.Size = UDim2.new(1, 0, 0, 30)
speedDisplay.Position = UDim2.new(0, 0, 0, 50)
speedDisplay.BackgroundTransparency = 1
speedDisplay.Text = "16"
speedDisplay.TextColor3 = Color3.fromRGB(0, 170, 255)
speedDisplay.TextSize = 28
speedDisplay.Font = Enum.Font.GothamBold
speedDisplay.ZIndex = 6
speedDisplay.Parent = panel

-- 减100按钮
local minus100Btn = Instance.new("TextButton")
minus100Btn.Size = UDim2.new(0, 42, 0, 42)
minus100Btn.Position = UDim2.new(0, 15, 0, 95)
minus100Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minus100Btn.Text = "-100"
minus100Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
minus100Btn.TextSize = 14
minus100Btn.Font = Enum.Font.GothamBold
minus100Btn.BorderSizePixel = 0
minus100Btn.ZIndex = 6
minus100Btn.Parent = panel

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 6)
minusCorner.Parent = minus100Btn

-- 减10按钮
local minus10Btn = Instance.new("TextButton")
minus10Btn.Size = UDim2.new(0, 42, 0, 42)
minus10Btn.Position = UDim2.new(0, 65, 0, 95)
minus10Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minus10Btn.Text = "-10"
minus10Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
minus10Btn.TextSize = 14
minus10Btn.Font = Enum.Font.GothamBold
minus10Btn.BorderSizePixel = 0
minus10Btn.ZIndex = 6
minus10Btn.Parent = panel

local minus10Corner = Instance.new("UICorner")
minus10Corner.CornerRadius = UDim.new(0, 6)
minus10Corner.Parent = minus10Btn

-- 减1按钮
local minus1Btn = Instance.new("TextButton")
minus1Btn.Size = UDim2.new(0, 42, 0, 42)
minus1Btn.Position = UDim2.new(0, 115, 0, 95)
minus1Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minus1Btn.Text = "-1"
minus1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
minus1Btn.TextSize = 14
minus1Btn.Font = Enum.Font.GothamBold
minus1Btn.BorderSizePixel = 0
minus1Btn.ZIndex = 6
minus1Btn.Parent = panel

local minus1Corner = Instance.new("UICorner")
minus1Corner.CornerRadius = UDim.new(0, 6)
minus1Corner.Parent = minus1Btn

-- 加100按钮
local plus100Btn = Instance.new("TextButton")
plus100Btn.Size = UDim2.new(0, 42, 0, 42)
plus100Btn.Position = UDim2.new(1, -57, 0, 95)
plus100Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
plus100Btn.Text = "+100"
plus100Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
plus100Btn.TextSize = 14
plus100Btn.Font = Enum.Font.GothamBold
plus100Btn.BorderSizePixel = 0
plus100Btn.ZIndex = 6
plus100Btn.Parent = panel

local plus100Corner = Instance.new("UICorner")
plus100Corner.CornerRadius = UDim.new(0, 6)
plus100Corner.Parent = plus100Btn

-- 加10按钮
local plus10Btn = Instance.new("TextButton")
plus10Btn.Size = UDim2.new(0, 42, 0, 42)
plus10Btn.Position = UDim2.new(1, -107, 0, 95)
plus10Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
plus10Btn.Text = "+10"
plus10Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
plus10Btn.TextSize = 14
plus10Btn.Font = Enum.Font.GothamBold
plus10Btn.BorderSizePixel = 0
plus10Btn.ZIndex = 6
plus10Btn.Parent = panel

local plus10Corner = Instance.new("UICorner")
plus10Corner.CornerRadius = UDim.new(0, 6)
plus10Corner.Parent = plus10Btn

-- 加1按钮
local plus1Btn = Instance.new("TextButton")
plus1Btn.Size = UDim2.new(0, 42, 0, 42)
plus1Btn.Position = UDim2.new(1, -157, 0, 95)
plus1Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
plus1Btn.Text = "+1"
plus1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
plus1Btn.TextSize = 14
plus1Btn.Font = Enum.Font.GothamBold
plus1Btn.BorderSizePixel = 0
plus1Btn.ZIndex = 6
plus1Btn.Parent = panel

local plus1Corner = Instance.new("UICorner")
plus1Corner.CornerRadius = UDim.new(0, 6)
plus1Corner.Parent = plus1Btn

-- 输入框
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -30, 0, 40)
inputBox.Position = UDim2.new(0, 15, 0, 150)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.Text = ""
inputBox.PlaceholderText = "输入速度值 (0-10000)"
inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 16
inputBox.Font = Enum.Font.Gotham
inputBox.BorderSizePixel = 0
inputBox.ZIndex = 6
inputBox.Parent = panel

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

-- 变量
local defaultSpeed = 16
local maxSpeed = 10000
local currentSpeed = defaultSpeed

-- 应用速度
local function applySpeed(value)
	currentSpeed = math.clamp(math.floor(value), 0, maxSpeed)
	if humanoid then
		humanoid.WalkSpeed = currentSpeed
	end
	speedDisplay.Text = tostring(currentSpeed)
	inputBox.Text = ""
end

-- 面板开关
toggleButton.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
	if panel.Visible then
		speedDisplay.Text = tostring(currentSpeed)
	end
end)

-- 关闭程序
closeProgramButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- 加减按钮
minus100Btn.MouseButton1Click:Connect(function()
	applySpeed(currentSpeed - 100)
end)

minus10Btn.MouseButton1Click:Connect(function()
	applySpeed(currentSpeed - 10)
end)

minus1Btn.MouseButton1Click:Connect(function()
	applySpeed(currentSpeed - 1)
end)

plus1Btn.MouseButton1Click:Connect(function()
	applySpeed(currentSpeed + 1)
end)

plus10Btn.MouseButton1Click:Connect(function()
	applySpeed(currentSpeed + 10)
end)

plus100Btn.MouseButton1Click:Connect(function()
	applySpeed(currentSpeed + 100)
end)

-- 输入框确认
inputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local num = tonumber(inputBox.Text)
		if num then
			applySpeed(num)
		end
	end
end)

-- 初始化
applySpeed(defaultSpeed)
