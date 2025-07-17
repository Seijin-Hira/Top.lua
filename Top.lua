-- Serviços necessários
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Variáveis globais
local suspeitos = {}

-- Função para detectar jogadores suspeitos
local function detectarHackers()
    suspeitos = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local isModified = false
            local isUsingExecutor = false

            -- Detecção básica de executores
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

-- Função para criar o menu principal
local function criarMenu()
    local mainFrame = Instance.new("ScreenGui")
    mainFrame.Name = "AntiHackMenu"
    mainFrame.ResetOnSpawn = false
    mainFrame.Parent = CoreGui

    -- Frame principal do menu (centralizado)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 350)
    frame.Position = UDim2.new(0.5, -125, 0.5, -175) -- Centralizado
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = false -- Permitir arrastar
    frame.Draggable = true -- Arrastável
    frame.Parent = mainFrame

    -- Barra superior para fechar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
        mainFrame.ReopenButton.Visible = true
    end)

    -- Texto principal
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 40)
    title.Text = "Anti-Hack Menu"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Parent = frame

    -- Botão Detectar Hackers
    local detectBtn = Instance.new("TextButton")
    detectBtn.Size = UDim2.new(0.8, 0, 0, 40)
    detectBtn.Position = UDim2.new(0.1, 0, 0, 80)
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
    local dropdown = Instance.new("TextBox")
    dropdown.Size = UDim2.new(0.8, 0, 0, 30)
    dropdown.Position = UDim2.new(0.1, 0, 0, 140)
    dropdown.PlaceholderText = "Nome do Hacker"
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.BorderSizePixel = 0
    dropdown.Parent = frame

    -- Botão Kickar
    local kickBtn = Instance.new("TextButton")
    kickBtn.Size = UDim2.new(0.8, 0, 0, 40)
    kickBtn.Position = UDim2.new(0.1, 0, 0, 180)
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

    -- Botão Reabrir (Mobile)
    local reopenBtn = Instance.new("TextButton")
    reopenBtn.Name = "ReopenButton"
    reopenBtn.Size = UDim2.new(0, 60, 0, 60)
    reopenBtn.Position = UDim2.new(0.9, -65, 0.9, -65)
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

    -- Evento para esconder/mostrar botão de reabrir
    frame.Changed:Connect(function(prop)
        if prop == "Visible" then
            if not frame.Visible then
                reopenBtn.Visible = true
            end
        end
    end)
end

-- Função para exibir jogadores suspeitos em janela flutuante e arrastável
local function mostrarSuspeitos()
    local susFrame = Instance.new("Frame")
    susFrame.Size = UDim2.new(0, 220, 0, 250)
    susFrame.Position = UDim2.new(0.5, -110, 0.5, -125) -- Centralizado
    susFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    susFrame.BorderSizePixel = 0
    susFrame.ClipsDescendants = false
    susFrame.Draggable = true
    susFrame.Parent = game.CoreGui.AntiHackMenu

    -- Barra superior para fechar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 0, 35)
    title.Text = "Jogadores Suspeitos:"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Parent = susFrame

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

-- Iniciar o menu
criarMenu()
