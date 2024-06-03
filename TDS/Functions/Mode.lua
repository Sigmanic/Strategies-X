local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
return function(self, p1)
    if not CheckPlace() then
        return
    end
    local DiffTable = {
        ["Easy"] = "Easy",
        ["Molten"] = "Normal",
        ["Fallen"] = "Insane",
    }
    local ModeName = DiffTable[p1.Name] or p1.Name
    task.spawn(function()
        local Mode
        repeat
            Mode = RemoteFunction:InvokeServer("Difficulty", "Vote", ModeName)
            task.wait() 
        until Mode
        if not GetGameSate():GetAttribute("HasDifficultyVoteCompleted") then
            RemoteFunction:InvokeServer("Difficulty", "Ready")
        end
        ConsoleInfo("Mode Selected: "..p1.Name)
    end)
end