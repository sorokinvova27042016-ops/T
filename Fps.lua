-- XENO / KRNL / SYNAPSE / FLUXUS
-- FPS ONE TAP - WALLHACK + AIMBOT (CUSTOM)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local aimbotActive = false
local espActive = false

-- ============================================
-- WALLHACK (ESP)
-- ============================================
local function toggleESP()
    espActive = not espActive
    
    while espActive do
        wait(0.1)
        
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr == player then continue end
            
            local char = plr.Character
            if not char then continue end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            local highlight = char:FindFirstChild("ESP_Highlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillTransparency = 0.4
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = char
            end
            
            -- ЦВЕТ ПО КОМАНДЕ
            local team = plr.Team
            if team then
                highlight.FillColor = team.TeamColor.Color
                highlight.OutlineColor = team.TeamColor.Color
            else
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
    
    -- Очистка при выключении
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "ESP_Highlight" then
            obj:Destroy()
        end
    end
end

-- ============================================
-- AIMBOT
-- ============================================
local function getClosestPlayer()
    local char = player.Character
    if not char then return nil end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local myPos = hrp.Position
    local closest = nil
    local closestDist = math.huge
    
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr == player then continue end
        
        local targetChar = plr.Character
        if not targetChar then continue end
        
        local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetHrp then continue end
        
        local dist = (targetHrp.Position - myPos).Magnitude
        if dist < closestDist and dist < 100 then -- Макс дистанция 100 блоков
            closest = plr
            closestDist = dist
        end
    end
    
    return closest
end

local function aimbotLoop()
    while aimbotActive do
        wait(0.05)
        
        local target = getClosestPlayer()
        if not target then continue end
        
        local char = target.Character
        if not char then continue end
        
        local head = char:FindFirstChild("Head")
        if not head then continue end
        
        -- Наводим прицел на голову
        local headPos = head.Position
        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(headPos)
        
        if onScreen then
            mouse.MoveTo(Vector2.new(screenPos.X, screenPos.Y))
        end
    end
end

-- ============================================
-- СОЗДАЁМ МЕНЮ
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSHack"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Text = "🎯 FPS ONE TAP"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

-- DIVIDER
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0.01, 0)
divider.Position = UDim2.new(0.05, 0, 0.18, 0)
divider.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
divider.Parent = mainFrame

-- ESP BUTTON
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.8, 0, 0.22, 0)
espBtn.Position = UDim2.new(0.1, 0, 0.22, 0)
espBtn.Text = "ESP: OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextScaled = true
espBtn.Parent = mainFrame

-- AIMBOT BUTTON
local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(0.8, 0, 0.22, 0)
aimBtn.Position = UDim2.new(0.1, 0, 0.48, 0)
aimBtn.Text = "AIMBOT: OFF"
aimBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
aimBtn.Font = Enum.Font.GothamBold
aimBtn.TextScaled = true
aimBtn.Parent = mainFrame

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0.12, 0)
status.Position = UDim2.new(0.05, 0, 0.75, 0)
status.Text = "СТАТУС: ГОТОВ"
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.Parent = mainFrame

-- HOTKEYS
local hotkey = Instance.new("TextLabel")
hotkey.Size = UDim2.new(0.9, 0, 0.08, 0)
hotkey.Position = UDim2.new(0.05, 0, 0.88, 0)
hotkey.Text = "F1 - ESP | F2 - AIMBOT"
hotkey.TextColor3 = Color3.fromRGB(150, 150, 200)
hotkey.BackgroundTransparency = 1
hotkey.Font = Enum.Font.Gotham
hotkey.TextScaled = true
hotkey.Parent = mainFrame

-- ============================================
-- КНОПКИ
-- ============================================
espBtn.MouseButton1Click:Connect(function()
    if espActive then
        espActive = false
        espBtn.Text = "ESP: OFF"
        espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "СТАТУС: ESP ВЫКЛ"
        status.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        espBtn.Text = "ESP: ON"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        status.Text = "СТАТУС: ESP ВКЛ"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
        spawn(toggleESP)
    end
end)

aimBtn.MouseButton1Click:Connect(function()
    if aimbotActive then
        aimbotActive = false
        aimBtn.Text = "AIMBOT: OFF"
        aimBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "СТАТУС: AIMBOT ВЫКЛ"
        status.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        aimbotActive = true
        aimBtn.Text = "AIMBOT: ON"
        aimBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        status.Text = "СТАТУС: AIMBOT ВКЛ"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
        spawn(aimbotLoop)
    end
end)

-- HOTKEYS
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        espBtn.MouseButton1Click:Fire()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        aimBtn.MouseButton1Click:Fire()
    end
end)

print("=========================================")
print("🎯 FPS ONE TAP - CUSTOM SCRIPT")
print("=========================================")
print("✅ F1 - ESP (подсветка)")
print("✅ F2 - AIMBOT (автоприцел)")
print("=========================================")
