local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
return function(self, p1)
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        local Mode
        repeat
            Mode = RemoteFunction:InvokeServer("Difficulty", "Vote", p1.Name)
            task.wait() 
        until Mode
        ConsoleInfo("Mode Selected: "..p1.Name)
    end)
end