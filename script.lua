--[[
    Script: AETHER-X Hub (Tema Roxo)
    Funções: Key System, Gojo Kill All, Focus + Bypass
--]]

-- Verifica se já existe uma UI aberta para evitar duplicação
if game:GetService("CoreGui"):FindFirstChild("AetherXUI") then
    game:GetService("CoreGui"):FindFirstChild("AetherXUI"):Destroy()
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Criando a ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AetherXUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ==========================================
-- TELA DE KEY SYSTEM
-- ==========================================
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 350, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "AETHER-X | Key System"
KeyTitle.TextColor3 = Color3.fromRGB(180, 100, 255)
KeyTitle.TextSize = 18
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderText = "Insira a Key aqui..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(130, 110, 160)
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.Parent = KeyFrame

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 6)
KeyBoxCorner.Parent = KeyBox

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 40)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Roxo Bonito
SubmitBtn.Text = "Verificar Key"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 15
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyFrame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitBtn

-- ==========================================
-- PAINEL PRINCIPAL (Escondido até colocar a key)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 40)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "AETHER-X | Painel Principal"
MainTitle.TextColor3 = Color3.fromRGB(180, 100, 255)
MainTitle.TextSize = 18
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainFrame

-- Função para criar botões no menu principal
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 38)
    btn.Position = UDim2.new(0.075, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 30, 65)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- LÓGICA DO SISTEMA DE KEY E FUNÇÕES
-- ==========================================

-- Key padrão do script (Você pode alterar se quiser)
local VALID_KEY = "AETHER-X-2026"

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == VALID_KEY then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Key Incorreta! Tente novamete."
        KeyBox.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

-- 1. Gojo Kill All (Simulação de dano/remover HP de oponentes próximos)
createButton("Gojo: Kill All (Perto)", 55, function()
    pcall(function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Humanoid") then
                -- Remove a vida do oponente simulando o ataque do Gojo
                v.Character.Humanoid.Health = 0
            end
        end
    end)
end)

-- 2. Focus com Bypass (Ativa anticheat bypass básico e trava a câmera no alvo)
createButton("Focus (Bypass Ativo)", 105, function()
    pcall(function()
        -- Pequeno bypass para evitar detecção básica de alterações no Client
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" and self == Player then
                    return nil -- Bloqueia tentativas de kick automático
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end

        -- Lógica de Focus no jogador mais próximo
        local target = nil
        local shortestDistance = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    target = v.Character.HumanoidRootPart
                end
            end
        end

        if target then
            workspace.CurrentCamera.CameraSubject = target
        end
    end)
end)

-- 3. Opção Extra: Velocidade (WalkSpeed)
createButton("Velocidade Extra (Speed Boost)", 155, function()
    pcall(function()
        Player.Character.Humanoid.WalkSpeed = 50
    end)
end)

-- 4. Opção Extra: Pulo Infinito (JumpPower)
createButton("Pulo Alto (High Jump)", 205, function()
    pcall(function()
        Player.Character.Humanoid.JumpPower = 120
    end)
end)
