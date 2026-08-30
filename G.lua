-- XENO / KRNL / SYNAPSE / FLUXUS
-- NATURAL DISASTER SURVIVAL - SPACE TARAN (RADIUS 1)

local player = game.Players.LocalPlayer
local isActive = false
local pushForce = 99999999
local radius = 1 -- РАДИУС 1 БЛОК

-- ============================================
-- ОТПРАВКА В КОСМОС
-- ============================================
local function sendToSpace(target)
    if not target or not target.Character then return end
    
    local char = target.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if not hrp then return end
    
    if humanoid then
        humanoid.PlatformStand = true
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    end
    
    for _, v in ipairs(char:GetDescendants()) do
        local name = v.Name:lower()
        if name:match("anticheat") or name:match("antifly") or name:match("speedcheck") or name:match("gravity") then
            v:Destroy()
        end
        if v:IsA("JointInstance") or v:IsA("Motor6D") then
            v:Destroy()
        end
    end
    
    hrp.CFrame = CFrame.new(0, pushForce, 0)
    hrp.Velocity = Vector3.new(0, pushForce * 2, 0)
    hrp:ApplyImpulse(Vector3.new(0, pushForce * 3, 0))
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.Velocity = Vector3.new(0, pushForce * 10, 0)
    bv.Parent = hrp
    game:GetService("Debris"):AddItem(bv, 3)
    
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(0, math.huge, 0)
    bp.Position = Vector3.new(0, pushForce, 0)
    bp.Parent = hrp
    game:GetService("Debris"):AddItem(bp, 3)
    
    print("🚀 " .. target.Name .. " улетел в космос!")
end

-- ============================================
-- ОСНОВНОЙ ЦИКЛ (РАДИУС 1)
-- ============================================
local function startTaran()
    isActive = true
    
    while isActive do
        wait(0.1)
        
        local char = player.Character
        if not char then 
            wait(0.5)
            continue 
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then 
            wait(0.5)
            continue 
        end
        
        local myPos = hrp.Position
        
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr == player then continue end
            
            local targetChar = plr.Character
            if not targetChar then continue end
            
            local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
            if not targetHrp then continue end
            
            local dist = (targetHrp.Position - myPos).Magnitude
            
            if dist < radius then -- РАДИУС 1 БЛОК
                sendToSpace(plr)
                wait(0.05)
            end
        end
    end
end

-- ============================================
-- ВКЛЮЧЕНИЕ/ВЫКЛЮЧЕНИЕ
-- ============================================
local function toggleTaran()
    isActive = not isActive
    
    if isActive then
        print("🚀 Taran ВКЛЮЧЁН (радиус 1 блок)")
        spawn(startTaran)
    else
        print("🚀 Taran ВЫКЛЮЧЕН")
    end
end

-- ============================================
-- СОЗДАЁМ МЕНЮ
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpaceTaran"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(0.5, -140, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(200, 50, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.12, 0)
title.Text = "🚀 SPACE TARAN"
title.TextColor3 = Color3.fromRGB(200, 50, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0.01, 0)
divider.Position = UDim2.new(0.05, 0, 0.15, 0)
divider.BackgroundColor3 = Color3.fromRGB(200, 50, 255)
divider.Parent = mainFrame

-- TOGGLE
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
toggleBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
toggleBtn.Text = "ENABLE TARAN"
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.Parent = mainFrame

-- RADIUS INFO
local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(0.9, 0, 0.12, 0)
radiusLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
radiusLabel.Text = "RADIUS: 1 BLOCK"
radiusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Font = Enum.Font.Gotham
radiusLabel.TextScaled = true
radiusLabel.Parent = mainFrame

-- STATUS
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0.12, 0)
statusLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
statusLabel.Text = "STATUS: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true
statusLabel.Parent = mainFrame

-- HOTKEY
local hotkeyLabel = Instance.new("TextLabel")
hotkeyLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
hotkeyLabel.Position = UDim2.new(0.05, 0, 0.82, 0)
hotkeyLabel.Text = "F1 - TOGGLE"
hotkeyLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
hotkeyLabel.BackgroundTransparency = 1
hotkeyLabel.Font = Enum.Font.Gotham
hotkeyLabel.TextScaled = true
hotkeyLabel.Parent = mainFrame

-- INFO
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
infoLabel.Position = UDim2.new(0.05, 0, 0.92, 0)
infoLabel.Text = "ONLY PLAYERS IN 1 BLOCK"
infoLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextScaled = true
infoLabel.Parent = mainFrame

-- ============================================
-- КНОПКИ
-- ============================================
toggleBtn.MouseButton1Click:Connect(function()
    toggleTaran()
    
    if isActive then
        toggleBtn.Text = "DISABLE TARAN"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        statusLabel.Text = "STATUS: ON"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        toggleBtn.Text = "ENABLE TARAN"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        statusLabel.Text = "STATUS: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- HOTKEY F1
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleBtn.MouseButton1Click:Fire()
    end
end)

print("=========================================")
print("🚀 SPACE TARAN LOADED!")
print("=========================================")
print("✅ F1 - Включить/Выключить")
print("✅ Радиус: 1 блок")
print("✅ Только игроки вплотную улетают")
print("=========================================")
