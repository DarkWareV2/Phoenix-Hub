-- Script to remove all Drawing objects from CoreGui, Players, and Workspace

local function removeAllDrawings()
    local function removeDrawingsFrom(container)
        for _, obj in pairs(container:GetChildren()) do
            if obj:IsA("Drawing") then
                obj:Destroy()
            elseif obj:IsA("Model") or obj:IsA("Folder") then
                removeDrawingsFrom(obj)
            end
        end
    end

    local coreGui = game:GetService("CoreGui")
    removeDrawingsFrom(coreGui)

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            removeDrawingsFrom(playerGui)
        end
    end

    removeDrawingsFrom(workspace)
end

removeAllDrawings()

_G.espCache = nil

local runService = game:GetService("RunService")
runService:UnbindFromRenderStep("esp")

print("Cleanup complete. All Drawing objects should be removed.")
