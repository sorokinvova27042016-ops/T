-- XENO / KRNL / SYNAPSE / FLUXUS
-- AUTO FARM LEVELS + SPEED CONTROL (ANTI-BAN)

local player = game.Players.LocalPlayer
local isActive = false
local currentWorld = 1
local targetWins = 10
local speed = 1

-- ============================================
-- ФУНКЦИЯ ЗАВЕРШЕНИЯ УРОВНЯ
-- ============================================
local function completeLevel()
    local char = player.Character
    if not char then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    -- Ищем финишную точку
    local finish = workspace:FindFirstChild("Finish") or 
                   workspace:FindFirstChild("End") or 
                   workspace:FindFirstChild("Goal") or
                   workspace:FindFirstChild("WinZone")
    
    if finish then
        -- Телепорт на финиш
        local targetPos = finish:FindFirstChild("Position") or finish:FindFirstChild("CFrame")
        if targetPos then
            hrp.CFrame = CFrame.new(targetPos.Value or targetPos.Position)
        else
            hrp.CFrame = finish.CFrame
        end
        return true
    end
    
    -- Если нет финиша - идём к последнему блоку в уровне
    local parts = workspace:GetDescendants()
    local highestY = -9999
    local targetPart = nil
    
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") and part.Name:lower():match("platform") or part.Name:lower():match("floor") or part.Name:lower():match("ground") then
            if part.Position.Y > highestY then
                highestY = part.Position.Y
                targetPart = part
            end
        end
    end
    
    if targetPart then
        hrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 5, 0))
        return true
    end
    
    return false
end

-- ============================================
-- ПРОВЕРКА ЗАВЕРШЕНИЯ УРОВНЯ
-- ============================================
local function isLevelComplete()
    local gui = player.PlayerGui
    if not gui then return false end
    
    -- Проверяем наличие экрана победы
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local text = obj.Text:lower()
            if text:match("win") or text:match("victory") or text:match("complete") or text:match("passed") then
                return true
            end
        end
    end
    
    -- Проверяем появление кнопки "Next"
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Visible then
            local text = obj.Text:lower()
            if text:match("next") or text:match("continue") or text:match("replay") then
                return true
            end
        end
    end
    
    return false
end

-- ============================================
-- НАЖАТИЕ КНОПКИ "NEXT" / "REPLAY"
-- ============================================
local function clickNextButton()
    local gui = player.PlayerGui
    if not gui then return false end
    
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Visible then
            local text = obj.Text:lower()
            if text:match("next") or text:match("continue") or text:match("replay") or text:match("play") then
                obj:Fire()
                return true
            end
        end
    end
    
    return false
end

-- ============================================
-- ВЫБОР МИРА
-- ============================================
local function selectWorld(worldNum)
    local gui = player.PlayerGui
    if not gui then return false end
    
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Visible then
            local text = obj.Text:lower()
            if text:match("world " .. worldNum) or text:match("мир " .. worldNum) or text:match("level " .. worldNum) then
                obj:Fire()
                return true
            end
        end
    end
    
    return false
end

-- ============================================
-- ОСНОВНОЙ ЦИКЛ ФАРМА
-- ============================================
local function startFarm()
    isActive = true
    local wins = 0
    
    print("🏆 НАЧАЛО ФАРМА!")
    print("🌍 МИР: " .. currentWorld)
    print("🎯 ЦЕЛЬ: " .. targetWins .. " ПОБЕД")
    print("⚡ СКОРОСТЬ: " .. speed .. "x")
    
    -- Выбираем мир
    if currentWorld > 0 then
        selectWorld(currentWorld)
        wait(1 / speed)
    end
    
    while isActive and wins < targetWins do
        -- Завершаем уровень
        local success = completeLevel()
        
        if success then
            wait(0.5 / speed)
        else
            print("⚠️ НЕ УДАЛОСЬ ЗАВЕРШИТЬ УРОВЕНЬ")
            wait(1 / speed)
        end
        
        -- Ждём появления экрана победы
        local timer = 0
        while timer < 5 and not isLevelComplete() do
            wait(0.2 / speed)
            timer = timer + 0.2
        end
        
        if isLevelComplete() then
            wins = wins + 1
            print("✅ ПОБЕДА " .. wins .. "/" .. targetWins)
            
            -- Нажимаем Next / Replay
            clickNextButton()
            wait(0.5 / speed)
        else
            -- Если не появилось - просто перезапускаем
            print("🔄 ПЕРЕЗАПУСК УРОВНЯ")
            clickNextButton()
            wait(0.5 / speed)
        end
        
        -- Небольшая задержка между уровнями (анти-бан)
        wait(0.3 / speed)
    end
    
    if wins >= targetWins then
        print("🎉 ФАРМ ЗАВЕРШЁН! ПОБЕД: " .. wins)
    else
        print("⛔ ФАРМ ОСТАНОВЛЕН")
    end
    
    isActive = false
end

-- ============================================
-- ВКЛЮЧЕНИЕ/ВЫКЛЮЧЕНИЕ
-- ============================================
local function toggleFarm()
    if isActive then
        isActive = false
        print("⛔ ФАРМ ОСТАНОВЛЕН")
        return
    end
    
    spawn(startFarm)
end

-- ============================================
-- СОЗДАЁМ МЕНЮ
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarm"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 320)
mainFrame.Position = UDim2.new(0.5, -175, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Text = "🏆 AUTO FARM"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0.01, 0)
divider.Position = UDim2.new(0.05, 0, 0.12, 0)
divider.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
divider.Parent = mainFrame

-- WORLD SELECT
local worldLabel = Instance.new("TextLabel")
worldLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
worldLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
worldLabel.Text = "🌍 WORLD:"
worldLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
worldLabel.BackgroundTransparency = 1
worldLabel.Font = Enum.Font.Gotham
worldLabel.TextScaled = true
worldLabel.TextXAlignment = Enum.TextXAlignment.Left
worldLabel.Parent = mainFrame

local worldBtns = {}
local worldValues = {1, 2, 3}
local worldPositions = {0.05, 0.35, 0.65}

for i, val in ipairs(worldValues) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, 0, 0.08, 0)
    btn.Position = UDim2.new(worldPositions[i], 0, 0.15, 0)
    btn.Text = tostring(val)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = mainFrame
    
    btn.MouseButton1Click:Connect(function()
        currentWorld = val
        for _, b in ipairs(worldBtns) do
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end)
    
    table.insert(worldBtns, btn)
end
worldBtns[1].BackgroundColor3 = Color3.fromRGB(0, 200, 0)

-- WINS INPUT
local winsLabel = Instance.new("TextLabel")
winsLabel.Size = UDim2.new(0.4, 0, 0.08, 0)
winsLabel.Position = UDim2.new(0.05, 0, 0.27, 0)
winsLabel.Text = "🎯 WINS:"
winsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
winsLabel.BackgroundTransparency = 1
winsLabel.Font = Enum.Font.Gotham
winsLabel.TextScaled = true
winsLabel.TextXAlignment = Enum.TextXAlignment.Left
winsLabel.Parent = mainFrame

local winsInput = Instance.new("TextBox")
winsInput.Size = UDim2.new(0.4, 0, 0.08, 0)
winsInput.Position = UDim2.new(0.5, 0, 0.27, 0)
winsInput.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
winsInput.TextColor3 = Color3.fromRGB(255, 255, 255)
winsInput.Text = "10"
winsInput.Font = Enum.Font.GothamBold
winsInput.TextScaled = true
winsInput.ClearTextOnFocus = false
winsInput.Parent = mainFrame

winsInput.FocusLost:Connect(function()
    local val = tonumber(winsInput.Text)
    if val and val > 0 then
        targetWins = val
    else
        winsInput.Text = tostring(targetWins)
    end
end)

-- SPEED CONTROL
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 0.08, 0)
speedLabel.Position = UDim2.new(0.05, 0, 0.39, 0)
speedLabel.Text = "⚡ SPEED: 1x"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextScaled = true
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

local speedBtns = {}
local speedValues = {0.5, 1, 2, 3}
local speedPositions = {0.05, 0.25, 0.45, 0.65}

for i, val in ipairs(speedValues) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.15, 0, 0.08, 0)
    btn.Position = UDim2.new(speedPositions[i], 0, 0.39, 0)
    btn.Text = tostring(val) .. "x"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Parent = mainFrame
    
    btn.MouseButton1Click:Connect(function()
        speed = val
        speedLabel.Text = "⚡ SPEED: " .. tostring(val) .. "x"
        for _, b in ipairs(speedBtns) do
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end)
    
    table.insert(speedBtns, btn)
end
speedBtns[2].BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- 1x по умолчанию

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0.12, 0)
toggleBtn.Position = UDim2.new(0.1, 0, 0.52, 0)
toggleBtn.Text = "▶️ START FARM"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.Parent = mainFrame

-- STATUS
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
statusLabel.Position = UDim2.new(0.05, 0, 0.67, 0)
statusLabel.Text = "СТАТУС: ОСТАНОВЛЕН"
statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true
statusLabel.Parent = mainFrame

-- PROGRESS
local progressLabel = Instance.new("TextLabel")
progressLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
progressLabel.Position = UDim2.new(0.05, 0, 0.77, 0)
progressLabel.Text = "ПРОГРЕСС: 0 / " .. targetWins
progressLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
progressLabel.BackgroundTransparency = 1
progressLabel.Font = Enum.Font.Gotham
progressLabel.TextScaled = true
progressLabel.Parent = mainFrame

-- HOTKEY
local hotkeyLabel = Instance.new("TextLabel")
hotkeyLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
hotkeyLabel.Position = UDim2.new(0.05, 0, 0.88, 0)
hotkeyLabel.Text = "F1 - СТАРТ/СТОП"
hotkeyLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
hotkeyLabel.BackgroundTransparency = 1
hotkeyLabel.Font = Enum.Font.Gotham
hotkeyLabel.TextScaled = true
hotkeyLabel.Parent = mainFrame

-- ============================================
-- КНОПКИ
-- ============================================
toggleBtn.MouseButton1Click:Connect(function()
    if isActive then
        isActive = false
        toggleBtn.Text = "▶️ START FARM"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        statusLabel.Text = "СТАТУС: ОСТАНОВЛЕН"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        targetWins = tonumber(winsInput.Text) or 10
        progressLabel.Text = "ПРОГРЕСС: 0 / " .. targetWins
        toggleBtn.Text = "⏹️ STOP FARM"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        statusLabel.Text = "СТАТУС: ФАРМИМ..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        spawn(startFarm)
        
        -- Обновление прогресса
        spawn(function()
            while isActive do
                wait(1)
                -- Здесь можно добавить отслеживание прогресса
            end
        end)
    end
end)

-- F1 HOTKEY
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleBtn.MouseButton1Click:Fire()
    end
end)

print("=========================================")
print("🏆 AUTO FARM ЗАГРУЖЕН!")
print("=========================================")
print("✅ Выбери мир (1, 2, 3)")
print("✅ Введи количество побед")
print("✅ Выбери скорость (0.5x, 1x, 2x, 3x)")
print("✅ Нажми START FARM или F1")
print("=========================================")
