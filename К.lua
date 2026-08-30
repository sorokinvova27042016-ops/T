-- XENO / KRNL / SYNAPSE / FLUXUS
-- FPS ONE TAP - WALLHACK ONLY (FIXED)

local player = game.Players.LocalPlayer
local espActive = false

-- ============================================
-- WALLHACK (ESP) - РАБОЧАЯ ВЕРСИЯ
-- ============================================
local function toggleESP()
    espActive = not espActive
    
    if espActive then
        print("🔦 ESP ВКЛЮЧЁН")
        
        while espActive do
            wait(0.3)
            
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr == player then continue end
                
                local char = plr.Character
                if not char then continue end
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end
                
                -- СОЗДАЁМ ПОДСВЕТКУ
                local highlight = char:FindFirstChild("ESP_Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight"
                    highlight.FillTransparency = 0.3
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
            
            -- УДАЛЯЕМ ПОДСВЕТКУ У ВЫШЕДШИХ ИГРОКОВ
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "ESP_Highlight" and obj.Parent then
                    local owner = game.Players:GetPlayerFromCharacter(obj.Parent)
                    if not owner then
                        obj:Destroy()
                    end
                end
            end
        end
        
    else
        print("🔦 ESP ВЫКЛЮЧЕН")
        
        -- УДАЛЯЕМ ВСЕ ПОДСВЕТКИ
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "ESP_Highlight" then
                obj:Destroy()
            end
        end
    end
end

-- ============================================
-- СОЗДАЁМ МЕНЮ
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Wallhack"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 140)
mainFrame.Position = UDim2.new(0.5, -125, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Text = "🔦 WALLHACK"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0.01, 0)
divider.Position = UDim2.new(0.05, 0, 0.18, 0)
divider.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
divider.Parent = mainFrame

-- BUTTON
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0.3, 0)
btn.Position = UDim2.new(0.1, 0, 0.22, 0)
btn.Text = "ESP: OFF"
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.Parent = mainFrame

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0.15, 0)
status.Position = UDim2.new(0.05, 0, 0.6, 0)
status.Text = "СТАТУС: ВЫКЛ"
status.TextColor3 = Color3.fromRGB(255, 0, 0)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.Parent = mainFrame

-- HOTKEY
local hotkey = Instance.new("TextLabel")
hotkey.Size = UDim2.new(0.9, 0, 0.1, 0)
hotkey.Position = UDim2.new(0.05, 0, 0.82, 0)
hotkey.Text = "F1 - ВКЛ/ВЫКЛ"
hotkey.TextColor3 = Color3.fromRGB(150, 150, 200)
hotkey.BackgroundTransparency = 1
hotkey.Font = Enum.Font.Gotham
hotkey.TextScaled = true
hotkey.Parent = mainFrame

-- ============================================
-- КНОПКИ
-- ============================================
btn.MouseButton1Click:Connect(function()
    toggleESP()
    
    if espActive then
        btn.Text = "ESP: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        status.Text = "СТАТУС: ВКЛ"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        btn.Text = "ESP: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "СТАТУС: ВЫКЛ"
        status.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- HOTKEY F1
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        btn.MouseButton1Click:Fire()
    end
end)

print("=========================================")
print("🔦 WALLHACK ЗАГРУЖЕН!")
print("=========================================")
print("✅ F1 - Включить/Выключить")
print("✅ Подсвечивает игроков сквозь стены")
print("=========================================")
