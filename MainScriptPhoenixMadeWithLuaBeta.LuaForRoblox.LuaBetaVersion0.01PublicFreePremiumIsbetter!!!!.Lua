local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Phoenix Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = VisualsTab:AddSection({
    Name = "Visuals"
})

local infoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = infoTab:AddSection({
    Name = "Visuals Info"
})

local LocalPlayerTab = Window:MakeTab({
    Name = "Local Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local LocalPlayerSection = LocalPlayerTab:AddSection({
    Name = "Humanoid"
})

local espEnabled = false
local espScript = nil

VisualsTab:AddToggle({
    Name = "Box Esp",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            if not espScript then
                espScript = loadstring(game:HttpGet(('https://raw.githubusercontent.com/DarkWareV2/Phoenix-Hub/main/Esp.lua')))()
                espScript()
            end
        else
            loadstring(game:HttpGet(('https://raw.githubusercontent.com/DarkWareV2/Phoenix-Hub/main/StopEsp.lua')))()
            espScript = nil
        end
    end    
})

infoTab:AddLabel("Esp Toggle Of Bugs A Little Fix Soon")

-- Helper function to get the player's Humanoid
local function getHumanoid()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    return character:FindFirstChildOfClass("Humanoid")
end

LocalPlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 0,
    Max = 300,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end    
})

LocalPlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 0,
    Max = 300,
    Default = getHumanoid() and getHumanoid().JumpPower or 50,  -- Default to current jump power or 50 if humanoid is not yet loaded
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.JumpPower = Value
        end
    end    
})
