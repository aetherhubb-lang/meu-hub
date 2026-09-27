-- =========================================================
--                     AETHER HUB v1.0
-- =========================================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Proteção contra múltiplas execuções
if game:GetService("CoreGui"):FindFirstChild("AetherHubUI") then
    game:GetService("CoreGui").AetherHubUI:Destroy()
end

-- ScreenGui Principal
local AetherHubUI = Instance.new("ScreenGui")
AetherHubUI.Name = "AetherHubUI"
AetherHubUI.Parent = game:GetService("CoreGui")
AetherHubUI.ResetOnSpawn = false

-- Variáveis de Estado
local isDraggable = false
local gojoActive = false
local flyActive = false
local gojoThread = nil

-- =========================================================
--                   INTERFACE DO HUB
-- =========================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = AetherHubUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Bar (Cabeçalho)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(32, 26, 45)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 14)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.Text = "AETHER HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Botão Cadeado (Drag Toggle)
local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0, 30, 0, 25)
LockBtn.Position = UDim2.new(1, -35, 0, 5)
LockBtn.Text = "🔒"
LockBtn.TextSize = 14
LockBtn.BackgroundColor3 = Color3.fromRGB(45, 38, 60)
LockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.BorderSizePixel = 0
LockBtn.Parent = TopBar

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 6)
LockCorner.Parent = LockBtn

-- Botão Minimizar (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
MinimizeBtn.Position = UDim2.new(0, 5, 0, 5)
MinimizeBtn.Text = "-"
MinimizeBtn.TextSize = 18
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 38, 60)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- Botão Reabrir (+ Flutuante)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.Text = "+"
OpenBtn.TextSize = 24
OpenBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.Parent = AetherHubUI

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

-- Container dos Botões
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = Container

-- =========================================================
--                     SISTEMA DE DRAG
-- =========================================================

local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if isDraggable and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if isDraggable and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging and isDraggable then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

LockBtn.MouseButton1Click:Connect(function()
    isDraggable = not isDraggable
    LockBtn.Text = isDraggable and "🔓" or "🔒"
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- =========================================================
--               CRIADOR DE BOTÕES ESTILIZADOS
-- =========================================================

local function CreateHubButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 38, 60)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(75, 60, 100)
    stroke.Thickness = 1
    stroke.Parent = btn
    
    return btn
end

local GojoBtn = CreateHubButton("Gojo 0.2")
local FlyBtn = CreateHubButton("Fly")

-- =========================================================
--                     LÓGICA: GOJO 0.2
-- =========================================================

GojoBtn.MouseButton1Click:Connect(function()
    gojoActive = not gojoActive
    
    if gojoActive then
        GojoBtn.Text = "Gojo 0.2: ON"
        GojoBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        
        gojoThread = task.spawn(function()
            while gojoActive do
                for _, player in ipairs(Players:GetPlayers()) do
                    if not gojoActive then break end
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        end
                        task.wait(0.08) -- Velocidade máxima de alternância
                    end
                end
                task.wait(0.01)
            end
        end)
    else
        GojoBtn.Text = "Gojo 0.2: OFF"
        GojoBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        if gojoThread then task.cancel(gojoThread) end
    end
end)

-- =========================================================
--                  LÓGICA: FLY COM SETAS
-- =========================================================

local FlyGui = Instance.new("ScreenGui")
FlyGui.Name = "FlyGui"
FlyGui.Parent = game:GetService("CoreGui")
FlyGui.Enabled = false

local function CreateArrow(name, pos, size, text, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Position = pos
    btn.Size = size
    btn.Text = text
    btn.TextSize = 20
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    
    return btn
end

-- D-Pad Esquerdo (Esquerda, Direita, Frente, Trás)
local LeftFrame = Instance.new("Frame")
LeftFrame.Size = UDim2.new(0, 150, 0, 150)
LeftFrame.Position = UDim2.new(0, 20, 1, -170)
LeftFrame.BackgroundTransparency = 1
LeftFrame.Parent = FlyGui

local UpBtn = CreateArrow("Up", UDim2.new(0, 50, 0, 0), UDim2.new(0, 50, 0, 50), "▲", LeftFrame)
local DownBtn = CreateArrow("Down", UDim2.new(0, 50, 0, 100), UDim2.new(0, 50, 0, 50), "▼", LeftFrame)
local LeftBtn = CreateArrow("Left", UDim2.new(0, 0, 0, 50), UDim2.new(0, 50, 0, 50), "◄", LeftFrame)
local RightBtn = CreateArrow("Right", UDim2.new(0, 100, 0, 50), UDim2.new(0, 50, 0, 50), "►", LeftFrame)

-- Controls Direitos (Subir / Descer)
local RightFrame = Instance.new("Frame")
RightFrame.Size = UDim2.new(0, 60, 0, 130)
RightFrame.Position = UDim2.new(1, -80, 1, -160)
RightFrame.BackgroundTransparency = 1
RightFrame.Parent = FlyGui

local AscendBtn = CreateArrow("Ascend", UDim2.new(0, 0, 0, 0), UDim2.new(0, 60, 0, 55), "▲\nSubir", RightFrame)
local DescendBtn = CreateArrow("Descend", UDim2.new(0, 0, 0, 65), UDim2.new(0, 60, 0, 55), "▼\nDescer", RightFrame)

-- Lógica de Movimento do Fly
local moveState = {F = 0, B = 0, L = 0, R = 0, U = 0, D = 0}

local function BindHold(button, stateKey)
    button.MouseButton1Down:Connect(function() moveState[stateKey] = 1 end)
    button.MouseButton1Up:Connect(function() moveState[stateKey] = 0 end)
end

BindHold(UpBtn, "F")
BindHold(DownBtn, "B")
BindHold(LeftBtn, "L")
BindHold(RightBtn, "R")
BindHold(AscendBtn, "U")
BindHold(DescendBtn, "D")

local flySpeed = 60
local flyConnection

FlyBtn.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    FlyGui.Enabled = flyActive
    
    if flyActive then
        FlyBtn.Text = "Fly: ON"
        FlyBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        
        flyConnection = RunService.RenderStepped:Connect(function(delta)
            if not flyActive then return end
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local cam = workspace.CurrentCamera
                
                local moveDir = Vector3.zero
                if moveState.F == 1 then moveDir = moveDir + (cam.CFrame.LookVector) end
                if moveState.B == 1 then moveDir = moveDir - (cam.CFrame.LookVector) end
                if moveState.R == 1 then moveDir = moveDir + (cam.CFrame.RightVector) end
                if moveState.L == 1 then moveDir = moveDir - (cam.CFrame.RightVector) end
                if moveState.U == 1 then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if moveState.D == 1 then moveDir = moveDir - Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (moveDir.Unit * flySpeed * delta)
                    hrp.Velocity = Vector3.zero
                end
            end
        end)
    else
        FlyBtn.Text = "Fly: OFF"
        FlyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        for k in pairs(moveState) do moveState[k] = 0 end
        if flyConnection then flyConnection:Disconnect() end
    end
end)
