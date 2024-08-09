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

local visualsSection = VisualsTab:AddSection({
    Name = "Visuals Configuration"
})

-- Chams (Player ESP)
local chamsEnabled = false
local chamsCache = {}

VisualsTab:AddToggle({
    Name = "Chams",
    Default = false,
    Callback = function(Value)
        chamsEnabled = Value

        if chamsEnabled then
            local players = game:GetService("Players")
            local runService = game:GetService("RunService")

            local function createCham(player)
                if player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            local cham = Instance.new("Highlight")
                            cham.Name = "Cham"
                            cham.OutlineColor = Color3.fromRGB(255, 0, 0)
                            cham.FillColor = Color3.fromRGB(255, 0, 0)
                            cham.Parent = part
                            chamsCache[player] = cham
                        end
                    end
                end
            end

            local function removeCham(player)
                if chamsCache[player] then
                    chamsCache[player]:Destroy()
                    chamsCache[player] = nil
                end
            end

            runService.RenderStepped:Connect(function()
                for _, player in next, players:GetPlayers() do
                    if player ~= game.Players.LocalPlayer then
                        if chamsCache[player] then
                            if not player.Character or not player.Character:FindFirstChildOfClass("Humanoid") then
                                removeCham(player)
                            end
                        else
                            createCham(player)
                        end
                    end
                end
            end)

            players.PlayerAdded:Connect(function(player)
                if chamsEnabled then
                    createCham(player)
                end
            end)

            players.PlayerRemoving:Connect(function(player)
                removeCham(player)
            end)
        else
            for player, cham in next, chamsCache do
                cham:Destroy()
            end
            chamsCache = {}
        end
    end
})

-- FPS Booster
local fpsBoostEnabled = false

local FpsTab = Window:MakeTab({
    Name = "Fps Configuration",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local fpsSection = FpsTab:AddSection({
    Name = "Fps Boosters"
})

fpsSection:AddToggle({
    Name = "FPS Booster",
    Default = false,
    Callback = function(Value)
        fpsBoostEnabled = Value

        if fpsBoostEnabled then
            -- Implement FPS Booster settings
            game:GetService("RunService"):Set3dRenderingEnabled(true)
        else
            game:GetService("RunService"):Set3dRenderingEnabled(false)
        end
    end
})

-- Texture Removal
local textureRemovalEnabled = false

local texturesSection = VisualsTab:AddSection({
    Name = "Texture Removal"
})

texturesSection:AddToggle({
    Name = "Remove Textures",
    Default = false,
    Callback = function(Value)
        textureRemovalEnabled = Value

        if textureRemovalEnabled then
            for _, part in pairs(workspace:FindFirstChildOfClass("Model"):GetDescendants()) do
                if part:IsA("BasePart") and part:FindFirstChild("Texture") then
                    part.Texture:Destroy()
                end
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
local infoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local infoSection = infoTab:AddSection({
    Name = "Visuals Info"
})

infoSection:AddLabel("1% of the time fly bugs")

OrionLib:Init()
