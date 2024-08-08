local function removeSnaplineGui()
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local snaplineGui = playerGui:FindFirstChild("SnaplineGui")
        if snaplineGui then
            snaplineGui:Destroy()
        end
    end
end

local runService = game:GetService("RunService")
runService:UnbindFromRenderStep("SnaplineScript")

TargetPartName = nil
DrawTeammates = false
FindHumanoids = false

removeSnaplineGui()

print("Snapline script disabled and cleaned up.")
