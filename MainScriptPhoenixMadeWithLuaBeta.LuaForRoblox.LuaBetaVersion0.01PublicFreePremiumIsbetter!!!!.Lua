-- Load Orion Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Create the main window
local Window = OrionLib:MakeWindow({Name = "Phoenix Hub Version 0.06 Beta Testing Private", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- Visuals Tab
local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = VisualsTab:AddSection({
    Name = "Visuals Configuration"
})

-- Local Player Tab
local LocalPlayerTab = Window:MakeTab({
    Name = "Local Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LocalPlayerSection = LocalPlayerTab:AddSection({
    Name = "Humanoid"
})

-- FPS Tab
local FpsTab = Window:MakeTab({
    Name = "Fps Configuration",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = FpsTab:AddSection({
    Name = "Fps Boosters"
})

-- Info Tab
local infoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = infoTab:AddSection({
    Name = "Visuals Info"
})

-- ESP Configuration
local espEnabled = false
local chamsEnabled = false
local espCache = {}

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

-- FPS Button
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
                object.Material = Enum.Material.SmoothPlastic
            end
        end
        
        for _, object in pairs(workspace:GetDescendants()) do
            removeTextures(object)
        end
        
        print("All textures removed.")
    end    
})

-- Fly Toggle
local flying = false
local flySpeed = 50
local bodyGyro, bodyVelocity

local function startFlying()
    local character = game.Players.LocalPlayer.Character
    if not character then return end

    local humanoid = character:WaitForChild("Humanoid")
    local torso = character:WaitForChild("HumanoidRootPart")

    -- Create BodyGyro and BodyVelocity instances
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Parent = torso
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.CFrame = torso.CFrame

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Parent = torso
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)

    game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            bodyVelocity.Velocity = (workspace.CurrentCamera.CFrame.LookVector * flySpeed) + (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
    end)
end

local function stopFlying()
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
end

LocalPlayerTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        flying = Value
        if flying then
            startFlying()
        else
            stopFlying()
        end
    end    
})

-- Notifications
OrionLib:MakeNotification({
    Name = "Phoenix Hub Loaded",
    Content = "Welcome to Phoenix Hub! All features have been loaded successfully.",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- End of Script
