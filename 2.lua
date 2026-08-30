-- XENO / KRNL / SYNAPSE / FLUXUS
-- MM2 MEGA HACK v2.0

local player = game.Players.LocalPlayer
local wallhackActive = false
local invisibleActive = false
local autoCoinActive = false

-- ============================================
-- ПОЛУЧЕНИЕ РОЛИ
-- ============================================
local function getRole(plr)
    if not plr then return "unknown" end
    
    local char = plr.Character
    if not char then return "unknown" end
    
    -- Проверяем разные места
    local role = plr:FindFirstChild("Role") or plr:FindFirstChild("Team") or plr:FindFirstChild("PlayerRole")
    if role then
        return tostring(role.Value or role.Name):lower()
    end
    
    role = char:FindFirstChild("Role") or char:FindFirstChild("Team")
    if role then
        return tostring(role.Value or role.Name):lower()
    end
    
    -- Проверяем GUI
    local gui = plr.PlayerGui
    if gui then
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local text = obj.Text:lower()
                if text:match("sheriff") or text:match("detective") then
                    return "sheriff"
                elseif text:match("murderer") or text:match("killer") then
                    return "murderer"
                elseif text:match("innocent") then
                    return "innocent"
                end
            end
        end
    end
    
    return "unknown"
end

-- ============================================
-- WALLHACK
-- ============================================
local function toggleWallhack()
    wallhackActive = not wallhackActive
    
    if wallhackActive then
        while wallhackActive do
            wait(0.3)
            
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr == player then continue end
                
                local char = plr.Character
                if not char then continue end
                
                local role = getRole(plr)
                
                local hl = char:FindFirstChild("WallhackHL")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "WallhackHL"
                    hl.FillTransparency = 0.3
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = char
                end
                
                -- ЦВЕТА
                if role:match("sheriff") or role:match("detective") then
                    hl.FillColor = Color3.fromRGB(0, 100, 255) -- СИНИЙ
                    hl.OutlineColor = Color3.fromRGB(0, 100, 255)
                elseif role:match("murderer") or role:match("killer") then
                    hl.FillColor = Color3.fromRGB(255, 0, 0) -- КРАСНЫЙ
                    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                elseif role:match("innocent") then
                    hl.FillColor = Color3.fromRGB(0, 255, 0) -- ЗЕЛЁНЫЙ
                    hl.OutlineColor = Color3.fromRGB(0, 255, 0)
                else
                    hl.FillColor = Color3.fromRGB(255, 255, 0) -- ЖЁЛТЫЙ
                    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                end
            end
        end
    end
    
    -- Очистка
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "WallhackHL" then
            obj:Destroy()
        end
    end
end

-- ============================================
-- НЕВИДИМОСТЬ
-- ============================================
local function toggleInvisible()
    invisibleActive = not invisibleActive
    
    local char = player.Character
    if not char then return end
    
    if invisibleActive then
        -- Делаем прозрачным
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        
        -- Скрываем имя
        player.Name = " "
        player.DisplayName = " "
        
        -- Скрываем HealthBar
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.HealthDisplayDistance = 0
        end
    else
        -- Возвращаем видимость
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        
        player.Name = player.Name
        player.DisplayName = player.DisplayName
        
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.HealthDisplayDistance = 50
        end
    end
end

-- ============================================
-- ОТОБРАТЬ ОРУЖИЕ У ШЕРИФА
-- ============================================
local function stealGun()
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr == player then continue end
        
        local char = plr.Character
        if not char then continue end
        
        -- Проверяем, шериф ли это
        local role = getRole(plr)
        if not role:match("sheriff") and not role:match("detective") then
            continue
        end
        
        -- Ищем оружие в руках
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then continue end
        
        -- Проверяем, что это пистолет
        if tool.Name:lower():match("gun") or tool.Name:lower():match("pistol") or tool.Name:lower():match("revolver") then
            -- Крадём
            tool.Parent = player:FindFirstChild("Backpack") or player.Character
            print("🔫 Пистолет украден у " .. plr.Name)
            
            -- Если оружие в руках — забираем
            if char:FindFirstChild("Humanoid") then
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum:FindFirstChild("EquipTool") then
                    hum:FindFirstChild("EquipTool"):FireServer()
                end
            end
        end
    end
end

-- ============================================
-- АВТО-КОИН (ПОИСК И СБОР)
-- ============================================
local function autoCoin()
    autoCoinActive = not autoCoinActive
    
    if autoCoinActive then
        while autoCoinActive do
            wait(0.1)
            
            local char = player.Character
            if not char then continue end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            -- Ищем монеты
            local coins = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():match("coin") then
                    table.insert(coins, obj)
                end
            end
            
            -- Находим ближайшую монету
            local closest = nil
            local closestDist = math.huge
            
            for _, coin in ipairs(coins) do
                local dist = (coin.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closest = coin
                    closestDist = dist
                end
            end
            
            -- Летим к монете
            if closest then
                local targetPos = closest.Position
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                
                -- Кликаем по монете
                local clickDetector = closest:FindFirstChildOfClass("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                end
                
                -- Если не ClickDetector — используем другие методы
                if not clickDetector then
                    local remote = closest:FindFirstChild("Collect") or closest:FindFirstChild("Pickup")
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer()
                    end
                end
                
                print("🪙 Собрана монета!")
            end
        end
    end
end

-- ============================================
-- СОЗДАЁМ МЕНЮ
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2Mega"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 320)
mainFrame.Position = UDim2.new(0.5, -160, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(200, 50, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Text = "🔪 MM2 MEGA HACK"
title.TextColor3 = Color3.fromRGB(200, 50, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0.01, 0)
divider.Position = UDim2.new(0.05, 0, 0.12, 0)
divider.BackgroundColor3 = Color3.fromRGB(200, 50, 255)
divider.Parent = mainFrame

-- WALLHACK
local wallBtn = Instance.new("TextButton")
wallBtn.Size = UDim2.new(0.8, 0, 0.12, 0)
wallBtn.Position = UDim2.new(0.1, 0, 0.15, 0)
wallBtn.Text = "WALLHACK: OFF"
wallBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
wallBtn.Font = Enum.Font.GothamBold
wallBtn.TextScaled = true
wallBtn.Parent = mainFrame

-- INVISIBLE
local invisBtn = Instance.new("TextButton")
invisBtn.Size = UDim2.new(0.8, 0, 0.12, 0)
invisBtn.Position = UDim2.new(0.1, 0, 0.30, 0)
invisBtn.Text = "INVISIBLE: OFF"
invisBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
invisBtn.Font = Enum.Font.GothamBold
invisBtn.TextScaled = true
invisBtn.Parent = mainFrame

-- STEAL GUN
local stealBtn = Instance.new("TextButton")
stealBtn.Size = UDim2.new(0.8, 0, 0.12, 0)
stealBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
stealBtn.Text = "🔫 STEAL GUN"
stealBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
stealBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
stealBtn.Font = Enum.Font.GothamBold
stealBtn.TextScaled = true
stealBtn.Parent = mainFrame

-- AUTO COIN
local coinBtn = Instance.new("TextButton")
coinBtn.Size = UDim2.new(0.8, 0, 0.12, 0)
coinBtn.Position = UDim2.new(0.1, 0, 0.60, 0)
coinBtn.Text = "🪙 AUTO COIN: OFF"
coinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
coinBtn.Font = Enum.Font.GothamBold
coinBtn.TextScaled = true
coinBtn.Parent = mainFrame

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0.08, 0)
status.Position = UDim2.new(0.05, 0, 0.76, 0)
status.Text = "СТАТУС: ГОТОВ"
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.Parent = mainFrame

-- HOTKEYS
local hotkey = Instance.new("TextLabel")
hotkey.Size = UDim2.new(0.9, 0, 0.06, 0)
hotkey.Position = UDim2.new(0.05, 0, 0.86, 0)
hotkey.Text = "F1 | F2 | F3 | F4"
hotkey.TextColor3 = Color3.fromRGB(150, 150, 200)
hotkey.BackgroundTransparency = 1
hotkey.Font = Enum.Font.Gotham
hotkey.TextScaled = true
hotkey.Parent = mainFrame

-- INFO
local info = Instance.new("TextLabel")
info.Size = UDim2.new(0.9, 0, 0.06, 0)
info.Position = UDim2.new(0.05, 0, 0.93, 0)
info.Text = "🔵 Шериф | 🔴 Мардер | 🟢 Невинный"
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.TextScaled = true
info.Parent = mainFrame

-- ============================================
-- КНОПКИ
-- ============================================
wallBtn.MouseButton1Click:Connect(function()
    toggleWallhack()
    wallBtn.Text = wallhackActive and "WALLHACK: ON" or "WALLHACK: OFF"
    wallBtn.BackgroundColor3 = wallhackActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    status.Text = wallhackActive and "WALLHACK ВКЛ" or "ГОТОВ"
end)

invisBtn.MouseButton1Click:Connect(function()
    toggleInvisible()
    invisBtn.Text = invisibleActive and "INVISIBLE: ON" or "INVISIBLE: OFF"
    invisBtn.BackgroundColor3 = invisibleActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    status.Text = invisibleActive and "НЕВИДИМОСТЬ ВКЛ" or "ГОТОВ"
end)

stealBtn.MouseButton1Click:Connect(function()
    stealGun()
    status.Text = "🔫 ПИСТОЛЕТ УКРАДЕН!"
    status.TextColor3 = Color3.fromRGB(255, 200, 0)
    wait(1)
    status.Text = "ГОТОВ"
    status.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

coinBtn.MouseButton1Click:Connect(function()
    autoCoin()
    coinBtn.Text = autoCoinActive and "🪙 AUTO COIN: ON" or "🪙 AUTO COIN: OFF"
    coinBtn.BackgroundColor3 = autoCoinActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    status.Text = autoCoinActive and "AUTO COIN ВКЛ" or "ГОТОВ"
end)

-- HOTKEYS
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        wallBtn.MouseButton1Click:Fire()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        invisBtn.MouseButton1Click:Fire()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        stealBtn.MouseButton1Click:Fire()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        coinBtn.MouseButton1Click:Fire()
    end
end)

print("=========================================")
print("🔪 MM2 MEGA HACK ЗАГРУЖЕН!")
print("=========================================")
print("✅ F1 - Wallhack (подсветка ролей)")
print("✅ F2 - Невидимость")
print("✅ F3 - Украсть пистолет у шерифа")
print("✅ F4 - Авто-сбор монет")
print("=========================================")
