-- XENO / KRNL / SYNAPSE / FLUXUS
-- UNLOCK ALL TRACKS / LEVELS (ADMIN, CANDY, GOLD)

local player = game.Players.LocalPlayer

-- ============================================
-- РАЗБЛОКИРОВКА ВСЕХ КНОПОК
-- ============================================
local function unlockAll()
    print("🔓 НАЧАЛО РАЗБЛОКИРОВКИ...")
    
    local gui = player.PlayerGui
    if not gui then
        print("❌ GUI НЕ НАЙДЕН!")
        return
    end
    
    local found = 0
    local unlocked = 0
    
    -- Проходим по всем объектам в GUI
    for _, obj in ipairs(gui:GetDescendants()) do
        -- Ищем кнопки
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            local text = obj.Text or ""
            local name = obj.Name:lower()
            
            -- Проверяем, является ли кнопка заблокированной
            local isLocked = false
            
            -- Проверяем по тексту
            if text:lower():match("lock") or text:lower():match("заблок") or text:lower():match("closed") then
                isLocked = true
            end
            
            -- Проверяем по цвету (если серая - заблокирована)
            if obj.BackgroundColor3 and obj.BackgroundColor3.R == 0.3 and obj.BackgroundColor3.G == 0.3 and obj.BackgroundColor3.B == 0.3 then
                isLocked = true
            end
            
            -- Проверяем по свойству Visible
            if not obj.Visible then
                isLocked = true
            end
            
            if isLocked then
                -- Пытаемся разблокировать
                found = found + 1
                obj.Visible = true
                obj.Active = true
                obj.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                obj.TextColor3 = Color3.fromRGB(255, 255, 255)
                
                -- Пытаемся нажать
                pcall(function()
                    obj:Fire()
                end)
                
                unlocked = unlocked + 1
                print("✅ РАЗБЛОКИРОВАНО: " .. (text or name))
            end
        end
        
        -- Ищем замки (Frame с замком)
        if obj:IsA("Frame") and obj.Visible == false then
            obj.Visible = true
            print("✅ ПОКАЗАН ФРЕЙМ: " .. obj.Name)
        end
    end
    
    print("=========================================")
    print("🔓 РАЗБЛОКИРОВКА ЗАВЕРШЕНА!")
    print("📊 НАЙДЕНО ЗАБЛОКИРОВАННЫХ: " .. found)
    print("✅ РАЗБЛОКИРОВАНО: " .. unlocked)
    print("=========================================")
end

-- ============================================
-- ПОИСК И АКТИВАЦИЯ СПЕЦИАЛЬНЫХ ДОРОЖЕК
-- ============================================
local function unlockSpecialTracks()
    local gui = player.PlayerGui
    if not gui then return end
    
    -- Список ключевых слов для дорожек
    local tracks = {
        "admin", "канди", "candy", "gold", "золот", 
        "premium", "vip", "legendary", "элит", "ultra"
    }
    
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            local text = obj.Text:lower()
            local name = obj.Name:lower()
            
            for _, track in ipairs(tracks) do
                if text:match(track) or name:match(track) then
                    -- Делаем видимым и активным
                    obj.Visible = true
                    obj.Active = true
                    obj.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                    obj.TextColor3 = Color3.fromRGB(0, 0, 0)
                    
                    -- Нажимаем
                    pcall(function()
                        obj:Fire()
                    end)
                    
                    print("⭐ РАЗБЛОКИРОВАНА ДОРОЖКА: " .. obj.Text)
                    break
                end
            end
        end
    end
end

-- ============================================
-- АКТИВАЦИЯ ВСЕХ ДОСТУПНЫХ УРОВНЕЙ
-- ============================================
local function activateAllLevels()
    local gui = player.PlayerGui
    if not gui then return end
    
    -- Ищем папки с уровнями
    local levelFolders = {}
    
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("Folder") or obj:IsA("Frame") then
            local name = obj.Name:lower()
            if name:match("level") or name:match("world") or name:match("track") or name:match("stage") then
                table.insert(levelFolders, obj)
            end
        end
    end
    
    for _, folder in ipairs(levelFolders) do
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("ImageButton") then
                child.Visible = true
                child.Active = true
                pcall(function()
                    child:Fire()
                end)
                print("🎯 АКТИВИРОВАН УРОВЕНЬ: " .. child.Name)
            end
        end
    end
end

-- ============================================
-- ОСНОВНАЯ ФУНКЦИЯ
-- ============================================
local function unlockEverything()
    print("=========================================")
    print("🔓 РАЗБЛОКИРОВКА ВСЕХ ДОРОЖЕК")
    print("=========================================")
    
    -- Ждём загрузки GUI
    wait(1)
    
    -- Разблокируем всё
    unlockAll()
    unlockSpecialTracks()
    activateAllLevels()
    
    -- Повторная попытка через 2 секунды
    wait(2)
    unlockAll()
    unlockSpecialTracks()
    
    print("✅ ГОТОВО! Все дорожки разблокированы!")
end

-- ============================================
-- СОЗДАЁМ МЕНЮ
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UnlockAll"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Text = "⭐ UNLOCK ALL"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0.01, 0)
divider.Position = UDim2.new(0.05, 0, 0.18, 0)
divider.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
divider.Parent = mainFrame

-- BUTTON
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0.25, 0)
btn.Position = UDim2.new(0.1, 0, 0.22, 0)
btn.Text = "⭐ UNLOCK ALL"
btn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
btn.TextColor3 = Color3.fromRGB(0, 0, 0)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.Parent = mainFrame

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0.15, 0)
status.Position = UDim2.new(0.05, 0, 0.55, 0)
status.Text = "СТАТУС: ГОТОВ"
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.Parent = mainFrame

-- INFO
local info = Instance.new("TextLabel")
info.Size = UDim2.new(0.9, 0, 0.12, 0)
info.Position = UDim2.new(0.05, 0, 0.75, 0)
info.Text = "АДМИН | КАНДИ | ЗОЛОТАЯ"
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.TextScaled = true
info.Parent = mainFrame

-- HOTKEY
local hotkey = Instance.new("TextLabel")
hotkey.Size = UDim2.new(0.9, 0, 0.08, 0)
hotkey.Position = UDim2.new(0.05, 0, 0.88, 0)
hotkey.Text = "F1 - РАЗБЛОКИРОВАТЬ ВСЁ"
hotkey.TextColor3 = Color3.fromRGB(150, 150, 200)
hotkey.BackgroundTransparency = 1
hotkey.Font = Enum.Font.Gotham
hotkey.TextScaled = true
hotkey.Parent = mainFrame

-- ============================================
-- КНОПКИ
-- ============================================
btn.MouseButton1Click:Connect(function()
    status.Text = "СТАТУС: РАЗБЛОКИРОВКА..."
    status.TextColor3 = Color3.fromRGB(255, 200, 0)
    btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    
    spawn(unlockEverything)
    
    wait(3)
    status.Text = "СТАТУС: ГОТОВО!"
    status.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
end)

-- F1 HOTKEY
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        btn.MouseButton1Click:Fire()
    end
end)

print("=========================================")
print("⭐ UNLOCK ALL ЗАГРУЖЕН!")
print("=========================================")
print("✅ Нажми кнопку или F1")
print("✅ Разблокирует: Админ, Канди, Золотую")
print("=========================================")
