local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
return function(self, p1)
    if not CheckPlace() then
        return
    end
    local DiffTable = {
        ["Easy"] = "Easy",
        ["Casual"] = "Casual",
        ["Intermediate"] = "Intermediate",
        ["Molten"] = "Molten",
        ["Fallen"] = "Fallen"
    }
    local ModeName = DiffTable[p1.Name] or p1.Name
    task.spawn(function()
        local Mode
        local HasDifficultyVotedGUIPath = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("ReactGameDifficulty"):WaitForChild("Frame"):WaitForChild("buttons")
        repeat
            Mode = RemoteFunction:InvokeServer("Difficulty", "Vote", ModeName)
            task.wait()
        until Mode
        local ModeNameFormatted = string.sub(ModeName, 1, 1):lower() .. string.sub(ModeName, 2)
        if HasDifficultyVotedGUIPath:WaitForChild(ModeNameFormatted.."Button"):WaitForChild("button"):WaitForChild("content"):WaitForChild("count"):WaitForChild("textLabel").Text ~= 0 then
            RemoteFunction:InvokeServer("Difficulty", "Ready")
        end
        ConsoleInfo("Mode Selected: "..p1.Name)
    end)
end
