local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local isEnabled = true
local isLocked = false -- Переменная для блокировки движения
local currentColor = Color3.fromRGB(0, 0, 255)

-- Создание графического интерфейса
local screenGui = Instance.new("ScreenGui")
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Главная панель (высота увеличена до 145)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 145)
mainFrame.Position = UDim2.new(0, 20, 0, 40)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Кнопка включения / выключения ESP
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -20, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "ESP: ON"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleButton

-- Текст над слайдером
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 0, 20)
label.Position = UDim2.new(0, 10, 0, 50)
label.Text = "Выберите цвет RGB:"
label.Font = Enum.Font.GothamSemibold
label.TextSize = 12
label.TextColor3 = Color3.fromRGB(200, 200, 200)
label.BackgroundTransparency = 1
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = mainFrame

-- Радужный RGB Слайдер
local colorSlider = Instance.new("Frame")
colorSlider.Size = UDim2.new(1, -20, 0, 12)
colorSlider.Position = UDim2.new(0, 10, 0, 75)
colorSlider.BorderSizePixel = 0
colorSlider.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 6)
sliderCorner.Parent = colorSlider

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})
gradient.Parent = colorSlider

-- Ползунок слайдера
local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 6, 1, 4)
sliderKnob.Position = UDim2.new(0.667, -3, 0, -2)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = colorSlider

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(0, 3)
knobCorner.Parent = sliderKnob

-- Индикатор текущего цвета
local colorPreview = Instance.new("Frame")
colorPreview.Size = UDim2.new(0, 10, 0, 10)
colorPreview.Position = UDim2.new(1, -20, 0, 55)
colorPreview.BackgroundColor3 = currentColor
colorPreview.Parent = mainFrame

local previewCorner = Instance.new("UICorner")
previewCorner.CornerRadius = UDim.new(1, 0)
previewCorner.Parent = colorPreview

-- Кнопка-галочка для закрепления окна
local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.new(1, -20, 0, 30)
lockButton.Position = UDim2.new(0, 10, 0, 105)
lockButton.Text = "[ ] Закрепить окно"
lockButton.Font = Enum.Font.GothamSemibold
lockButton.TextSize = 12
lockButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
lockButton.TextColor3 = Color3.fromRGB(180, 180, 180)
lockButton.BorderSizePixel = 0
lockButton.Parent = mainFrame

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 6)
lockCorner.Parent = lockButton

lockButton.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    if isLocked then
        lockButton.Text = "[X] Окно закреплено"
        lockButton.TextColor3 = Color3.fromRGB(46, 204, 113) -- Текст становится зеленым
        lockButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    else
        lockButton.Text = "[ ] Закрепить окно"
        lockButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        lockButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end
end)

-- Логика кнопки ESP
local function clearHighlights()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local hl = player.Character:FindFirstChildOfClass("Highlight")
            if hl then hl:Destroy() end
        end
    end
end

toggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        toggleButton.Text = "ESP: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        toggleButton.Text = "ESP: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        clearHighlights()
    end
end)

-- Логика RGB слайдера
local isSliding = false
local function updateColor(input)
    local mouseX = input.Position.X
    local barX = colorSlider.AbsolutePosition.X
    local barWidth = colorSlider.AbsoluteSize.X
    local percentage = math.clamp((mouseX - barX) / barWidth, 0, 1)
    
    sliderKnob.Position = UDim2.new(percentage, -3, 0, -2)
    currentColor = Color3.fromHSV(percentage, 1, 1)
    colorPreview.BackgroundColor3 = currentColor
end

colorSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
        updateColor(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateColor(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = false
    end
end)

-- Логика перетаскивания (модифицирована проверкой на isLocked)
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if isLocked then return end -- Если закреплено, игнорируем нажатие для переноса
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        if isLocked then dragging = false return end
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Основной цикл работы ESP
RunService.Heartbeat:Connect(function()
    if not isEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                local highlight = char:FindFirstChildOfClass("Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Parent = char
                end
                
                highlight.FillColor = currentColor
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                highlight.OutlineTransparency = 0
            end
        end
    end
end)
