-- Load Orion Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Create the main window
local Window = OrionLib:MakeWindow({
    Name = "Phoenix Hub Version 0.18",
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

-- Box ESP
local espEnabled = false
local espCache = {}

local function createEsp(player)
    local drawings = {}
    
    drawings.box = Drawing.new("Square")
    drawings.box.Thickness = 1
    drawings.box.Filled = false
    drawings.box.Color = Color3.fromRGB(255, 0, 0)
    drawings.box.Visible = false
    drawings.box.ZIndex = 2

    drawings.boxoutline = Drawing.new("Square")
    drawings.boxoutline.Thickness = 3
    drawings.boxoutline.Filled = false
    drawings.boxoutline.Color = Color3.fromRGB(0, 0, 0)
    drawings.boxoutline.Visible = false
    drawings.boxoutline.ZIndex = 1

    espCache[player] = drawings
end

local function removeEsp(player)
    if espCache[player] then
        for _, drawing in pairs(espCache[player]) do
            drawing:Remove()
        end
        espCache[player] = nil
    end
end

local function updateEsp(player, esp)
    if not espEnabled then return end

    local character = player.Character
    if character then
        local cframe = character:GetModelCFrame()
        local position, visible, depth = workspace.CurrentCamera:WorldToViewportPoint(cframe.Position)
        esp.box.Visible = visible
        esp.boxoutline.Visible = visible

        if cframe and visible then
            local scaleFactor = 1 / (depth * math.tan(math.rad(workspace.CurrentCamera.FieldOfView / 2)) * 2) * 1000
            local width, height = math.round(4 * scaleFactor), math.round(5 * scaleFactor)
            local x, y = math.round(position.X), math.round(position.Y)

            esp.box.Size = Vector2.new(width, height)
            esp.box.Position = Vector2.new(x - width / 2, y - height / 2)
            esp.box.Color = player.TeamColor.Color

            esp.boxoutline.Size = esp.box.Size
            esp.boxoutline.Position = esp.box.Position
        end
    else
        esp.box.Visible = false
        esp.boxoutline.Visible = false
    end
end

VisualsTab:AddToggle({
    Name = "Box ESP",
    Default = false,
    Callback = function(Value)
        espEnabled = Value

        if espEnabled then
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    createEsp(player)
                end
            end

            game:GetService("Players").PlayerAdded:Connect(function(player)
                createEsp(player)
            end)

            game:GetService("Players").PlayerRemoving:Connect(function(player)
                removeEsp(player)
            end)

            game:GetService("RunService").RenderStepped:Connect(function()
                if espEnabled then
                    for player, drawings in pairs(espCache) do
                        updateEsp(player, drawings)
                    end
                end
            end)
        else
            game:GetService("RunService"):UnbindFromRenderStep("esp")
            for player, drawings in pairs(espCache) do
                removeEsp(player)
            end
        end
    end
})

-- Chams
local chamsEnabled = false

local function applyChams(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and not part:FindFirstChild("ChamAdornment") then
            local adornment = Instance.new("BoxHandleAdornment")
            adornment.Name = "ChamAdornment"
            adornment.Size = part.Size
            adornment.Color = BrickColor.new(50, 0, 250).Color
            adornment.Transparency = 0.8
            adornment.AlwaysOnTop = true
            adornment.Adornee = part
            adornment.Parent = part
        end
    end
end

local function removeChams(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local adornment = part:FindFirstChild("ChamAdornment")
            if adornment then
                adornment:Destroy()
            end
        end
    end
end

VisualsTab:AddToggle({
    Name = "Chams",
    Default = false,
    Callback = function(Value)
        chamsEnabled = Value
        local players = game:GetService("Players")

        if chamsEnabled then
            for _, player in pairs(players:GetPlayers()) do
                if player.Character then
                    applyChams(player.Character)
                end
                player.CharacterAdded:Connect(applyChams)
            end
        else
            for _, player in pairs(players:GetPlayers()) do
                if player.Character then
                    removeChams(player.Character)
                end
                player.CharacterAdded:Connect(removeChams)
            end
        end
    end    
})

-- Remove Textures
local function removeTextures()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then
            v:Destroy()
        end
    end
    print("All textures removed.")
end

VisualsTab:AddButton({
    Name = "Remove Textures",
    Callback = removeTextures
})

-- Walk Speed
LocalPlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 0,
    Max = 300,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end    
})

-- Jump Power
LocalPlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 0,
    Max = 300,
    Default = (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower) or 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value
        end
    end    
})

-- Fly Speed
local flySpeed = 50
LocalPlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 0,
    Max = 300,
    Default = flySpeed,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        flySpeed = Value
    end    
})

-- Fly Feature
local flying = false
local bodyVelocity = Instance.new("BodyVelocity")
local bodyGyro = Instance.new("BodyGyro")

local function startFlying()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    local userInputService = game:GetService("UserInputService")

    bodyVelocity.Parent = humanoidRootPart
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)

    bodyGyro.Parent = humanoidRootPart
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)

    local function updateFlying()
        if flying then
            local direction = Vector3.zero
            if userInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction - Vector3.new(0, 1, 0)
            end

            bodyVelocity.Velocity = direction.Unit * flySpeed
            bodyGyro.CFrame = CFrame.new(humanoidRootPart.Position, camera.CFrame.Position)
        end
    end

    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            updateFlying()
        else
            connection:Disconnect()
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
        end
    end)
end

LocalPlayerTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        flying = Value
        if flying then
            startFlying()
        else
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
        end
    end    
})

-- Info Tab
InfoTab:AddLabel("Phoenix Hub Version 0.18")
InfoTab:AddLabel("Developed by YourName")

-- MiTab
MiTab:AddButton({
    Name = "Sample Button",
    Callback = function()
        print("Sample button pressed")
    end
})

-- Save and Load Config
OrionLib:MakeNotification({
    Name = "Config",
    Content = "Config saved!",
    Time = 5
})
