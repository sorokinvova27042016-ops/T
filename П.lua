-- XENO / KRNL / SYNAPSE / FLUXUS
-- UNLOCK ALL WITH BUTTON

local player = game.Players.LocalPlayer

-- ============================================
-- ФУНКЦИЯ РАЗБЛОКИРОВКИ
-- ============================================
local function unlockAll()
    print("⭐ РАЗБЛОКИРОВКА ЗАПУЩЕНА!")
    
    local gui = player.PlayerGui
    if not gui then
        print("❌ GUI НЕ НАЙДЕН!")
        return
    end
    
    local count = 0
    
    for _, obj in ipairs(gui:GetDescendants()) do
        -- КНОПКИ
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            obj.Visible = true
            obj.Active = true
            obj.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            pcall(function() obj:Fire() end)
            count = count + 1
        end
        
        -- СКРЫТЫЕ ФРЕЙМЫ
        if obj:IsA("Frame") and obj.Visible == false then
            obj.Visible = true
            count = count + 1
        end
        
        -- СКРЫТЫЕ НАДПИСИ
        if obj:IsA("TextLabel") and obj.Visible == false then
            obj.Visible = true
            count = count + 1
        end
    end
    
    print("✅ РАЗБЛОКИРОВАНО: " .. count .. " ЭЛЕМЕНТОВ")
end

-- ============================================
-- СОЗДАЁМ КНОПКУ
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.1, 0)
btn.Text = "⭐ UNLOCK ALL"
btn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
btn.TextColor3 = Color3.fromRGB(0, 0, 0)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.Parent = screenGui

-- ============================================
-- НАЖАТИЕ КНОПКИ
-- ============================================
btn.MouseButton1Click:Connect(function()
    btn.Text = "⏳ РАЗБЛОКИРОВКА..."
    btn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    
    unlockAll()
    
    btn.Text = "✅ ГОТОВО!"
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    
    wait(2)
    btn.Text = "⭐ UNLOCK ALL"
    btn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
end)

print("=========================================")
print("⭐ UNLOCK ALL ЗАГРУЖЕН!")
print("=========================================")
print("✅ Нажми жёлтую кнопку в игре")
print("=========================================")
