-- // Variáveis
local usuario = game.Players.LocalPlayer.Name
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- // Função para criar botão estilizado
function criarBotao(parent, texto, pos, tamanho, func)
    local botao = Instance.new("ImageButton")
    botao.Parent = parent
    botao.Image = "rbxassetid://3570695787" -- Imagem de botão escuro
    botao.ImageColor3 = Color3.fromRGB(45, 45, 45)
    botao.ScaleType = Enum.ScaleType.Slice
    botao.SliceCenter = Rect.new(100, 100, 100, 100)
    botao.Position = pos
    botao.Size = tamanho

    local text = Instance.new("TextLabel")
    text.Parent = botao
    text.BackgroundTransparency = 1
    text.Position = UDim2.new(0, 10, 0, 0)
    text.Size = UDim2.new(1, -20, 1, 0)
    text.Font = Enum.Font.GothamBold
    text.Text = texto
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 14
    text.TextWrapped = true

    botao.MouseButton1Down:Connect(func)
end

-- // Função para criar caixa de texto
function criarTextBox(parent, texto, pos, tamanho)
    local box = Instance.new("TextBox")
    box.Parent = parent
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.BorderColor3 = Color3.fromRGB(0, 0, 0)
    box.BorderSizePixel = 2
    box.Position = pos
    box.Size = tamanho
    box.Font = Enum.Font.GothamBold
    box.PlaceholderText = texto
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 14
    return box
end

-- // Função para criar label
function criarLabel(parent, texto, pos, tamanho)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    label.BorderColor3 = Color3.fromRGB(0, 0, 0)
    label.BorderSizePixel = 2
    label.Position = pos
    label.Size = tamanho
    label.Font = Enum.Font.GothamBold
    label.Text = texto
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    return label
end

-- // Função para criar aba com imagem de fundo
function criarAba(nome, pos)
    local aba = Instance.new("Frame")
    aba.Parent = ScreenGui
    aba.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    aba.BorderColor3 = Color3.fromRGB(0, 0, 0)
    aba.BorderSizePixel = 2
    aba.Position = pos
    aba.Size = UDim2.new(0, 250, 0, 400)
    aba.Active = true
    aba.Draggable = true

    -- Imagem de fundo
    local background = Instance.new("ImageLabel")
    background.Parent = aba
    background.Image = "rbxassetid://2151745514" -- Fundo escuro
    background.ImageColor3 = Color3.fromRGB(25, 25, 25)
    background.BackgroundTransparency = 1
    background.Size = UDim2.new(1, 0, 1, 0)

    -- Título
    local abaTitulo = Instance.new("TextLabel")
    abaTitulo.Parent = aba
    abaTitulo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    abaTitulo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    abaTitulo.BorderSizePixel = 2
    abaTitulo.Size = UDim2.new(1, 0, 0, 30)
    abaTitulo.Font = Enum.Font.GothamBold
    abaTitulo.Text = nome
    abaTitulo.TextColor3 = Color3.fromRGB(255, 255, 255)
    abaTitulo.TextSize = 16
    abaTitulo.TextWrapped = true

    return aba
end

-- // Funções de Teleporte
function teleport(pos)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    end
end

-- // Função para voar
local flying = false
local flyspeed = 10
local bv, bg

function startFly()
    if flying then return end
    flying = true
    local char = LocalPlayer.Character
    if not char then return end

    bv = Instance.new("BodyVelocity")
    bv.Parent = char.HumanoidRootPart
    bv.MaxForce = Vector3.new(4000, 4000, 4000)
    bv.Velocity = Vector3.new()

    bg = Instance.new("BodyGyro")
    bg.Parent = char.HumanoidRootPart
    bg.MaxTorque = Vector3.new(4000, 4000, 4000)
    bg.P = 1000
    bg.D = 100
    bg.I = 0
    bg.ObjectCFrame = char.HumanoidRootPart.CFrame

    RunService.Stepped:Connect(function()
        if flying then
            bv.Velocity = ((UserInputService:IsKeyDown(Enum.KeyCode.W) and Vector3.new(0, 0, -flyspeed)) or
                          (UserInputService:IsKeyDown(Enum.KeyCode.S) and Vector3.new(0, 0, flyspeed)) or Vector3.new(0, 0, 0)) +
                         ((UserInputService:IsKeyDown(Enum.KeyCode.A) and Vector3.new(-flyspeed, 0, 0)) or
                          (UserInputService:IsKeyDown(Enum.KeyCode.D) and Vector3.new(flyspeed, 0, 0)) or Vector3.new(0, 0, 0)) +
                         ((UserInputService:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0, flyspeed, 0)) or
                          (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and Vector3.new(0, -flyspeed, 0)) or Vector3.new(0, 0, 0))

            bg.ObjectCFrame = Mouse.Hit * CFrame.Angles(-math.rad(90), 0, 0)
        end
    end)
end

function stopFly()
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    flying = false
end

-- // Função para matar jogador
function killPlayer(nome)
    if nome == "all" then
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then
                local char = v.Character
                if char and char:FindFirstChild("Head") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, char.Head, 0)
                    wait(0.1)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, char.Head, 1)
                end
            end
        end
    else
        local v = Players:FindFirstChild(nome)
        if v then
            local char = v.Character
            if char and char:FindFirstChild("Head") then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, char.Head, 0)
                wait(0.1)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, char.Head, 1)
            end
        end
    end
end

-- // Função para puxar arma
function pullWeapon(nome)
    local player = LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    if not character or not backpack then return end

    local tool = game.ReplicatedStorage.Items:FindFirstChild(nome)
    if tool then
        tool:Clone().Parent = backpack
    end
end

-- // Função para puxar carro
function pullCar()
    local car = game.ReplicatedStorage.Vehicles["Offroad Car"]:Clone()
    car.Parent = workspace
    car:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
end

-- // Função para criar NPC
function spawnNPC(npcType)
    local npc = game.ReplicatedStorage.NPCs:FindFirstChild(npcType)
    if npc then
        local clone = npc:Clone()
        clone.Parent = workspace
        clone:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
    end
end

-- // Carregar aba comum
if usuario ~= "feernando01ap" then
    local aba = criarAba("Menu Comum", UDim2.new(0, 10, 0, 10))

    criarBotao(aba, "Puxar Espingarda", UDim2.new(0, 20, 0, 50), UDim2.new(0, 210, 0, 40), function()
        pullWeapon("Shotgun")
    end)

    criarBotao(aba, "Puxar AK47", UDim2.new(0, 20, 0, 100), UDim2.new(0, 210, 0, 40), function()
        pullWeapon("AK47")
    end)

    criarBotao(aba, "TP Cela", UDim2.new(0, 20, 0, 150), UDim2.new(0, 210, 0, 40), function()
        teleport(workspace.Cells[LocalPlayer.Name].CFrame)
    end)

    criarBotao(aba, "TP Fora da Prisão", UDim2.new(0, 20, 0, 200), UDim2.new(0, 210, 0, 40), function()
        teleport(workspace["Prison_Free"].CFrame)
    end)

-- // Carregar aba VIP
else
    local aba = criarAba("Menu VIP", UDim2.new(0, 10, 0, 10))

    -- Teleportes
    criarBotao(aba, "TP Cela", UDim2.new(0, 20, 0, 50), UDim2.new(0, 210, 0, 40), function()
        teleport(workspace.Cells[LocalPlayer.Name].CFrame)
    end)

    criarBotao(aba, "TP Topo da Prisão", UDim2.new(0, 20, 0, 100), UDim2.new(0, 210, 0, 40), function()
        teleport(workspace.Prison_Main.CFrame * CFrame.new(0, 50, 0))
    end)

    criarBotao(aba, "TP Fora da Prisão", UDim2.new(0, 20, 0, 150), UDim2.new(0, 210, 0, 40), function()
        teleport(workspace["Prison_Free"].CFrame)
    end)

    criarBotao(aba, "TP Base Bandidos", UDim2.new(0, 20, 0, 200), UDim2.new(0, 210, 0, 40), function()
        teleport(workspace["Criminal Base"].CFrame)
    end)

    -- Voar
    criarBotao(aba, "Voar (Ativar)", UDim2.new(0, 20, 0, 250), UDim2.new(0, 210, 0, 40), function()
        startFly()
    end)

    criarBotao(aba, "Voar (Desativar)", UDim2.new(0, 20, 0, 300), UDim2.new(0, 210, 0, 40), function()
        stopFly()
    end)

    -- Armas
    criarBotao(aba, "Puxar Espingarda", UDim2.new(0, 20, 0, 50), UDim2.new(0, 210, 0, 40), function()
        pullWeapon("Shotgun")
    end)

    criarBotao(aba, "Puxar AK47", UDim2.new(0, 20, 0, 100), UDim2.new(0, 210, 0, 40), function()
        pullWeapon("AK47")
    end)

    criarBotao(aba, "Puxar Carro", UDim2.new(0, 20, 0, 150), UDim2.new(0, 210, 0, 40), function()
        pullCar()
    end)

    -- Matar
    local killBox = criarTextBox(aba, "Nome ou 'all'", UDim2.new(0, 20, 0, 200), UDim2.new(0, 210, 0, 30))
    criarBotao(aba, "Matar", UDim2.new(0, 20, 0, 240), UDim2.new(0, 210, 0, 40), function()
        killPlayer(killBox.Text)
    end)

    -- Criar NPCs
    criarBotao(aba, "Criar Guarda", UDim2.new(0, 20, 0, 290), UDim2.new(0, 210, 0, 40), function()
        spawnNPC("Guard")
    end)

    criarBotao(aba, "Criar Bandido", UDim2.new(0, 20, 0, 340), UDim2.new(0, 210, 0, 40), function()
        spawnNPC("Mobster")
    end)

    criarBotao(aba, "Criar Prisioneiro", UDim2.new(0, 20, 0, 390), UDim2.new(0, 210, 0, 40), function()
        spawnNPC("Inmate")
    end)
end
