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
local namesEnabled = false
local namesScript = nil

VisualsTab:AddToggle({
    Name = "Box Esp",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            if not espScript then
                espScript = loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkWareV2/Phoenix-Hub/main/Esp.lua'))()
                espScript()  -- Execute the ESP script
            end
        else
            if espScript then
                -- Execute code to disable the ESP script if it is running
                loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkWareV2/Phoenix-Hub/main/StopEsp.lua'))()
                espScript = nil
            end
        end
    end    
})

VisualsTab:AddToggle({
    Name = "Names",
    Default = false,
    Callback = function(Value)
        namesEnabled = Value
        if namesEnabled then
            if not namesScript then
                namesScript = loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkWareV2/Phoenix-Hub/main/Names.Lua'))()
                namesScript()  -- Execute the Names script
            end
        else
            if namesScript then
                -- Execute code to disable or cleanup the Names script if it is running
                -- Implement a similar cleanup mechanism for the Names script if necessary
                namesScript = nil
            end
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

VisualsTab:AddToggle({
    Name = "Names",
    Default = false,
    Callback = function(Value)
        namesEnabled = Value
        if namesEnabled then
            if not namesScript then
                namesScript = loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkWareV2/Phoenix-Hub/main/Names.Lua'))()
                namesScript()  -- Execute the Names script
            end
        else
            if namesScript then
                -- Execute code to disable or cleanup the Names script if it is running
                -- Implement a similar cleanup mechanism for the Names script if necessary
                namesScript = nil
            end
        end
    end    
})
