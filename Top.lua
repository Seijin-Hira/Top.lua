-- Configurações iniciais
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Variável para armazenar jogadores suspeitos
local suspeitos = {}

-- Função para detectar executores e jogadores suspeitos
local function detectarHackers()
    suspeitos = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local isModified = false
            local isUsingExecutor = false

            -- Exemplo básico de detecção de modificações
            if not isfile or not isfolder or not readfile or not writefile then
                isUsingExecutor = true
            end

            if player.UserId < 0 then
                isModified = true
            end

            if isUsingExecutor or isModified then
                table.insert(suspeitos, player.Name)
            end
        end
    end
end

-- Função para criar UI
local function criarMenu()
    local mainFrame = Instance.new("ScreenGui")
    mainFrame.Name = "AntiHackMenu"
    mainFrame.ResetOnSpawn = false
    mainFrame.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 300)
    frame.Position = UDim2.new(0.8, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = mainFrame

    -- Barra superior para fechar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    topBar.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, -5)
    closeBtn.Text = "✖"
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 20
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = topBar

    closeBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)

    -- Botão para detectar hackers
    local detectBtn = Instance.new("TextButton")
    detectBtn.Size = UDim2.new(0.8, 0, 0, 40)
    detectBtn.Position = UDim2.new(0.1, 0, 0, 40)
    detectBtn.Text = "Detectar Hackers"
    detectBtn.Font = Enum.Font.SourceSansBold
    detectBtn.TextSize = 16
    detectBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    detectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    detectBtn.BorderSizePixel = 0
    detectBtn.Parent = frame

    detectBtn.MouseButton1Click:Connect(function()
        detectarHackers()
        mostrarSuspeitos()
    end)

    -- Dropdown de expulsão
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(0.8, 0, 0, 30)
    dropdownFrame.Position = UDim2.new(0.1, 0, 0, 90)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = frame

    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Size = UDim2.new(1, 0, 0, 20)
    dropdownLabel.Text = "Selecione um Hacker:"
    dropdownLabel.Font = Enum.Font.SourceSansBold
    dropdownLabel.TextSize = 14
    dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Parent = dropdownFrame

    local dropdown = Instance.new("TextBox")
    dropdown.Size = UDim2.new(1, 0, 0, 30)
    dropdown.Position = UDim2.new(0, 0, 0, 25)
    dropdown.PlaceholderText = "Nome do Hacker"
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.BorderSizePixel = 0
    dropdown.Parent = dropdownFrame

    local kickBtn = Instance.new("TextButton")
    kickBtn.Size = UDim2.new(0.8, 0, 0, 40)
    kickBtn.Position = UDim2.new(0.1, 0, 0, 130)
    kickBtn.Text = "Kickar Hacker"
    kickBtn.Font = Enum.Font.SourceSansBold
    kickBtn.TextSize = 16
    kickBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    kickBtn.BorderSizePixel = 0
    kickBtn.Parent = frame

    kickBtn.MouseButton1Click:Connect(function()
        local nome = dropdown.Text
        local jogador = Players:FindFirstChild(nome)
        if jogador then
            game:GetService("Chat"):Chat(workspace.CurrentCamera, jogador.Name .. " está usando hack!", Enum.ChatColor.Red)
            pcall(function()
                jogador:Kick("Você foi expulso por uso de hack.")
            end)
        end
    end)

    -- Botão para mostrar novamente
    local reopenBtn = Instance.new("TextButton")
    reopenBtn.Size = UDim2.new(0, 50, 0, 50)
    reopenBtn.Position = UDim2.new(0.9, -55, 0.9, -55)
    reopenBtn.Text = "📁"
    reopenBtn.Font = Enum.Font.SourceSansBold
    reopenBtn.TextSize = 24
    reopenBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    reopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    reopenBtn.BorderSizePixel = 0
    reopenBtn.Visible = false
    reopenBtn.Parent = mainFrame

    reopenBtn.MouseButton1Click:Connect(function()
        frame.Visible = true
        reopenBtn.Visible = false
    end)

    -- Fechar e reabrir
    frame.Changed:Connect(function()
        if not frame.Visible then
            reopenBtn.Visible = true
        end
    end)
end

-- Função para mostrar jogadores suspeitos em uma janela flutuante
local function mostrarSuspeitos()
    local susFrame = Instance.new("Frame")
    susFrame.Size = UDim2.new(0, 200, 0, 200)
    susFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    susFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    susFrame.BorderSizePixel = 0
    susFrame.Draggable = true
    susFrame.ClipsDescendants = false
    susFrame.Parent = game.CoreGui.AntiHackMenu

    -- Barra superior para fechar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    topBar.Parent = susFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, -5)
    closeBtn.Text = "✖"
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 20
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = topBar

    closeBtn.MouseButton1Click:Connect(function()
        susFrame:Destroy()
    end)

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 20)
    textLabel.Position = UDim2.new(0, 0, 0, 35)
    textLabel.Text = "Jogadores Suspeitos:"
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = susFrame

    local index = 1
    for _, name in pairs(suspeitos) do
        local nameTag = Instance.new("TextLabel")
        nameTag.Size = UDim2.new(1, 0, 0, 20)
        nameTag.Position = UDim2.new(0, 0, 0, 35 + (index * 25))
        nameTag.Text = "• " .. name
        nameTag.Font = Enum.Font.SourceSans
        nameTag.TextSize = 14
        nameTag.TextColor3 = Color3.fromRGB(255, 100, 100)
        nameTag.BackgroundTransparency = 1
        nameTag.Parent = susFrame
        index = index + 1
    end
end

-- Iniciar
criarMenu()
