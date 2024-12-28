local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function(self, p1)
    local tableinfo = p1
    local GameSetLoadoutName = tableinfo["GameSetLoadout"]
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        ReplicatedStorage.Network.PlayerManager.SelectLoadout:FireServer(GameSetLoadoutName)
        ConsoleInfo("Choosen Loadout: "..GameSetLoadoutName)
    end)
end