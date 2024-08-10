-- Load Orion Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Create the main window
local Window = OrionLib:MakeWindow({
    Name = "Phoenix Hub Version 0.17 BETA Private",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

-- Create Tabs
local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LocalPlayerTab = Window:MakeTab({
    Name = "Local Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local FpsTab = Window:MakeTab({
    Name = "Fps Configuration",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local InfoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiTab = Window:MakeTab({
    Name = "MiTab",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- ESP and Chams Implementation
VisualsTab:AddToggle({
    Name = "Box Esp",
    Default = false,
    Callback = function(Value)
        if Value then
            _G.espEnabled = true
            local players = game:GetService("Players")
            local runService = game:GetService("RunService")
            local camera = workspace.CurrentCamera

            local function createEsp(player)
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESP"
                box.Adornee = player.Character:WaitForChild("HumanoidRootPart")
                box.Size = player.Character:WaitForChild("HumanoidRootPart").Size
                box.Color3 = Color3.new(1, 0, 0)
                box.AlwaysOnTop = true
                box.Transparency = 0.8
                box.ZIndex = 5
                box.Parent = player.Character:WaitForChild("HumanoidRootPart")
            end

            local function removeEsp(player)
                if player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("ESP") then
                    player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("ESP"):Destroy()
                end
            end

            for _, player in pairs(players:GetPlayers()) do
                if player ~= players.LocalPlayer then
                    createEsp(player)
                end
            end

            players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    wait(1)
                    createEsp(player)
                end)
            end)

            players.PlayerRemoving:Connect(function(player)
                removeEsp(player)
            end)

        else
            _G.espEnabled = false
            local players = game:GetService("Players")
            for _, player in pairs(players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if player.Character.HumanoidRootPart:FindFirstChild("ESP") then
                        player.Character.HumanoidRootPart.ESP:Destroy()
                    end
                end
            end
        end
    end    
})

VisualsTab:AddToggle({
    Name = "Chams",
    Default = false,
    Callback = function(Value)
        if Value then
            _G.chamsEnabled = true
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game:GetService("Players").LocalPlayer then
                    local character = player.Character
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Material = Enum.Material.ForceField
                            part.Color = Color3.new(0, 0, 1)
                        end
                    end
                end
            end
        else
            _G.chamsEnabled = false
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game:GetService("Players").LocalPlayer then
                    local character = player.Character
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Material = Enum.Material.Plastic
                            part.Color = Color3.new(1, 1, 1)
                        end
                    end
                end
            end
        end
    end    
})

-- Local Player Controls
LocalPlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 0,
    Max = 300,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

LocalPlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 0,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end    
})

-- Flying Implementation
local flying = false
local flySpeed = 50
local bodyGyro, bodyVelocity

local function startFlying()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local hrp = character:WaitForChild("HumanoidRootPart")

    flying = true
    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e5
    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            local direction = Vector3.zero
            local camera = workspace.CurrentCamera

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.E) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Q) then
                direction = direction - Vector3.new(0, 1, 0)
            end

            bodyVelocity.Velocity = direction * flySpeed
            bodyGyro.CFrame = camera.CFrame
        end
    end)
end

local function stopFlying()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local hrp = character:WaitForChild("HumanoidRootPart")

    flying = false
    bodyGyro:Destroy()
    bodyVelocity:Destroy()
end

LocalPlayerTab:AddToggle({
    Name = "Levitate",
    Default = false,
    Callback = function(Value)
        if Value then
            startFlying()
        else
            stopFlying()
        end
    end
})

LocalPlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        flySpeed = Value
    end
})

-- Fps Configuration
FpsTab:AddButton({
    Name = "Remove Textures",
    Callback = function()
        local function removeTextures(object)
            if object:IsA("BasePart") then
                for _, child in pairs(object:GetChildren()) do
                    if child:IsA("Texture") or child:IsA("Decal") then
                        child:Destroy()
                    end
                end
            end
        end

        local function onCharacterAdded(character)
            for _, part in pairs(character:GetDescendants()) do
                removeTextures(part)
            end
        end

        local Players = game:GetService("Players")
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                onCharacterAdded(player.Character)
            end
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(onCharacterAdded)
        end)
    end    
})

-- MiTab: Send User to a Specific Game
MiTab:AddButton({
    Name = "wave key daily!!!! Works + 10000 robux every second!!??!?!",
    Callback = function()
        local gameId = 18860278129
        game:GetService("TeleportService"):Teleport(gameId, game.Players.LocalPlayer)
    end    
})

-- Info Section
InfoTab:AddButton({
    Name = "Join our Discord!",
    Callback = function()
        setclipboard("https://discord.gg/YourServerInvite") -- Replace with your actual Discord invite link
        OrionLib:MakeNotification({
            Name = "Discord Link Copied!",
            Content = "The Discord link has been copied to your clipboard.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

OrionLib:Init()
