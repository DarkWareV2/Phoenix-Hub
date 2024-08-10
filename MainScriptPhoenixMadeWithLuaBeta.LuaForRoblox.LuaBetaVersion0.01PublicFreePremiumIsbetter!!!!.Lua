-- Load Orion Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Create the main window
local Window = OrionLib:MakeWindow({
    Name = "Phoenix Hub Version 0.15 Beta Private",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = true
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

-- Variables for ESP
local espEnabled = false
local chamsEnabled = false
local espCache = {}

-- Variables for Flying
local flying = false
local flySpeed = 50 -- Adjust speed as needed
local bodyGyro, bodyVelocity

-- ESP Configuration
VisualsTab:AddToggle({
    Name = "Box Esp",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        _G.espEnabled = Value

        if espEnabled then
            local settings = {
                defaultcolor = Color3.fromRGB(255, 0, 0),
                teamcheck = false,
                teamcolor = true
            }

            local runService = game:GetService("RunService")
            local players = game:GetService("Players")

            local localPlayer = players.LocalPlayer
            local camera = workspace.CurrentCamera

            local newVector2, newColor3, newDrawing = Vector2.new, Color3.new, Drawing.new
            local tan, rad = math.tan, math.rad
            local round = function(...) local a = {}; for i,v in next, table.pack(...) do a[i] = math.round(v); end return unpack(a); end
            local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return newVector2(a.X, a.Y), b, a.Z end

            local function createEsp(player)
                local drawings = {}
                
                drawings.box = newDrawing("Square")
                drawings.box.Thickness = 1
                drawings.box.Filled = false
                drawings.box.Color = settings.defaultcolor
                drawings.box.Visible = false
                drawings.box.ZIndex = 2

                drawings.boxoutline = newDrawing("Square")
                drawings.boxoutline.Thickness = 3
                drawings.boxoutline.Filled = false
                drawings.boxoutline.Color = newColor3()
                drawings.boxoutline.Visible = false
                drawings.boxoutline.ZIndex = 1

                espCache[player] = drawings
            end

            local function removeEsp(player)
                if rawget(espCache, player) then
                    for _, drawing in next, espCache[player] do
                        drawing:Remove()
                    end
                    espCache[player] = nil
                end
            end

            local function updateEsp(player, esp)
                if not _G.espEnabled then return end

                local character = player and player.Character
                if character then
                    local cframe = character:GetModelCFrame()
                    local position, visible, depth = wtvp(cframe.Position)
                    esp.box.Visible = visible
                    esp.boxoutline.Visible = visible

                    if cframe and visible then
                        local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000
                        local width, height = round(4 * scaleFactor, 5 * scaleFactor)
                        local x, y = round(position.X, position.Y)

                        esp.box.Size = newVector2(width, height)
                        esp.box.Position = newVector2(round(x - width / 2, y - height / 2))
                        esp.box.Color = settings.teamcolor and player.TeamColor.Color or settings.defaultcolor

                        esp.boxoutline.Size = esp.box.Size
                        esp.boxoutline.Position = esp.box.Position
                    end
                else
                    esp.box.Visible = false
                    esp.boxoutline.Visible = false
                end
            end

            for _, player in next, players:GetPlayers() do
                if player ~= localPlayer then
                    createEsp(player)
                end
            end

            players.PlayerAdded:Connect(function(player)
                createEsp(player)
            end)

            players.PlayerRemoving:Connect(function(player)
                removeEsp(player)
            end)

            runService:BindToRenderStep("esp", Enum.RenderPriority.Camera.Value, function()
                if not _G.espEnabled then return end

                for player, drawings in next, espCache do
                    if settings.teamcheck and player.Team == localPlayer.Team then
                        continue
                    end

                    if drawings and player ~= localPlayer then
                        updateEsp(player, drawings)
                    end
                end
            end)
        else
            game:GetService("RunService"):UnbindFromRenderStep("esp")
            for player, drawings in next, espCache do
                for _, drawing in next, drawings do
                    drawing:Remove()
                end
            end
            espCache = {}
        end
    end
})

-- Chams Configuration
VisualsTab:AddToggle({
    Name = "Chams",
    Default = false,
    Callback = function(Value)
        chamsEnabled = Value
        if chamsEnabled then
            local color = BrickColor.new(50, 0, 250)
            local transparency = 0.8

            local Players = game:GetService("Players")

            local function applyChams(character)
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and not part:FindFirstChild("ChamAdornment") then
                        local adornment = Instance.new("BoxHandleAdornment")
                        adornment.Name = "ChamAdornment"
                        adornment.Size = part.Size
                        adornment.Color = color
                        adornment.Transparency = transparency
                        adornment.AlwaysOnTop = true
                        adornment.Adornee = part
                        adornment.Parent = part
                    end
                end
            end

            local function onCharacterAdded(character)
                if character ~= Players.LocalPlayer.Character then
                    applyChams(character)
                end
            end

            local function onPlayerAdded(player)
                if player.Character then
                    onCharacterAdded(player.Character)
                end
                player.CharacterAdded:Connect(onCharacterAdded)
            end

            for _, player in pairs(Players:GetPlayers()) do
                onPlayerAdded(player)
            end

            Players.PlayerAdded:Connect(onPlayerAdded)
        else
            local Players = game:GetService("Players")

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

            local function onCharacterAdded(character)
                removeChams(character)
            end

            local function onPlayerAdded(player)
                if player.Character then
                    onCharacterAdded(player.Character)
                end
                player.CharacterAdded:Connect(onCharacterAdded)
            end

            for _, player in pairs(Players:GetPlayers()) do
                onPlayerAdded(player)
            end

            Players.PlayerAdded:Connect(onPlayerAdded)
        end
    end    
})

-- Slider for Walk Speed
LocalPlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 0,
    Max = 300,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end    
})

-- Slider for Jump Power
LocalPlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 0,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value
        end
    end    
})

-- Remove Textures Button
FpsTab:AddButton({
    Name = "Remove Textures",
    Callback = function()
        print("button pressed")

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

-- Function to Start Flying
local function startFlying()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.PlatformStand = true
    flying = true

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e5
    bodyGyro.Parent = hrp

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = hrp

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
                direction = direction + Vector3.new(0, 1, 0) -- Move Up
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Q) then
                direction = direction - Vector3.new(0, 1, 0) -- Move Down
            end

            bodyVelocity.Velocity = direction * flySpeed
            bodyGyro.CFrame = camera.CFrame
        end
    end)
end

-- Function to Stop Flying
local function stopFlying()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.PlatformStand = false
    flying = false

    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
end

-- Fly Toggle Button
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

-- Speed Slider
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

-- Info Button
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
