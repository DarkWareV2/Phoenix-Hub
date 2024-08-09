local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({Name = "Phoenix Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = VisualsTab:AddSection({
    Name = "Visuals Configuration"
})

local LocalPlayerTab = Window:MakeTab({
    Name = "Local Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LocalPlayerSection = LocalPlayerTab:AddSection({
    Name = "Humanoid"
})

local FpsTab = Window:MakeTab({
    Name = "Fps Configuration",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = FpsTab:AddSection({
    Name = "Fps Boosters"
})

local infoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = infoTab:AddSection({
    Name = "Visuals Info"
})

local espEnabled = false
local espScript = nil
local chamsEnabled = false

VisualsTab:AddToggle({
    Name = "Box Esp",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            if not espScript then
                espScript = loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkWareV2/Phoenix-Hub/main/Esp.lua'))()
                espScript()
            end
        else
            if espScript then
                loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkWareV2/Phoenix-Hub/main/StopEsp.lua'))()
                espScript = nil
            end
        end
    end    
})

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

            -- Apply chams to all current players
            for _, player in pairs(Players:GetPlayers()) do
                onPlayerAdded(player)
            end

            -- Connect player added event
            Players.PlayerAdded:Connect(onPlayerAdded)
        else
            -- Stop the Chams
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

            -- Remove chams from all current players
            for _, player in pairs(Players:GetPlayers()) do
                onPlayerAdded(player)
            end

            -- Connect player added event
            Players.PlayerAdded:Connect(onPlayerAdded)
        end
    end    
})

infoTab:AddLabel("Esp Toggle Of Bugs A Little Fix Soon")

LocalPlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 0,
    Max = 300,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
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

LocalPlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 0,
    Max = 300,
    Default = (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower) or 50,
    Color = Color3.fromRGB(255,255,255),
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
