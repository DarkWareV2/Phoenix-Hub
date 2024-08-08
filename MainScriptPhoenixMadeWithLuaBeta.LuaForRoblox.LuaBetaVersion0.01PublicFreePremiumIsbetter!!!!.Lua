local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Phoenix Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local VisualsTab = Window:MakeTab({
	Name = "Local Player",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = VisualsTab:AddSection({
	Name = "Visuals"
})

local infoTab = Window:MakeTab({
	Name = "info",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = infoTab:AddSection({
	Name = "Visuals info"
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
