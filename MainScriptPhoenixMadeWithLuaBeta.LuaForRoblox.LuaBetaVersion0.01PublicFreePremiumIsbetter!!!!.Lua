-- Load Orion Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Create the main window
local Window = OrionLib:MakeWindow({
    Name = "Phoenix Hub Version 0.08 Beta Testing Private", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "OrionTest"
})

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

                        esp.box.Size = UDim2.new(0, width, 0, height)
                        esp.box.Position = UDim2.new(0, position.X - width / 2, 0, position.Y - height / 2)

                        esp.boxoutline.Size = UDim2.new(0, width + 2, 0, height + 2)
                        esp.boxoutline.Position = UDim2.new(0, position.X - (width + 2) / 2, 0, position.Y - (height + 2) / 2)
                    end
                end
            end

            runService.RenderStepped:Connect(function()
                for _, player in next, players:GetPlayers() do
                    if player ~= localPlayer and player.Character then
                        local esp = espCache[player]
                        if esp then
                            updateEsp(player, esp)
                        end
                    end
                end
            end)

            players.PlayerAdded:Connect(function(player)
                if espEnabled then
                    createEsp(player)
                end
            end)

            players.PlayerRemoving:Connect(function(player)
                removeEsp(player)
            end)
        else
            for player, esp in next, espCache do
                removeEsp(player)
            end
        end
    end
})

-- Fly Script (Updated to include toggle and version)
local flying = false
local flySpeed = 50

local function fly()
    local character = game.Players.LocalPlayer.Character
    local humanoid = character:WaitForChild("Humanoid")
    local torso = character:WaitForChild("HumanoidRootPart")

    local gyro = Instance.new("BodyGyro")
    gyro.P = 9e4
    gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    gyro.Parent = torso

    local velocity = Instance.new("BodyVelocity")
    velocity.velocity = Vector3.new(0, 0, 0)
    velocity.P = 9e4
    velocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    velocity.Parent = torso

    while flying do
        velocity.velocity = (torso.CFrame.LookVector * flySpeed)
        wait()
    end

    gyro:Destroy()
    velocity:Destroy()
end

local UserInputService = game:GetService("UserInputService")
local toggle = false

UserInputService.InputBegan:Connect(function(inputObject)
    if inputObject.KeyCode == Enum.KeyCode.RightShift then
        if toggle then
            flying = false
            toggle = false
        else
            flying = true
            toggle = true
            fly()
        end
    end
end)

-- Add a label to indicate "1% of the time fly bugs"
infoTab:AddLabel("1% of the time fly bugs")

OrionLib:Init()
