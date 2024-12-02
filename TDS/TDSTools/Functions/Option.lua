local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
--[[{
    ["TowerIndex"] = "",
    ["TypeIndex"] = "",
    ["Name"] = "",
    ["Value"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
return function(self, p1)
    local tableinfo = p1
    local Tower = tableinfo["TowerIndex"]
    local OptName = tableinfo["Name"]
    local OptValue = tableinfo["Value"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("Option","Total")
    task.spawn(function()
        if not TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"]) then
            return
        end
        local RemoteCheck
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        task.spawn(function()
            task.wait(2)
            while not (type(RemoteCheck) == "boolean" and RemoteCheck) do
                ConsoleWarn(`Cannot Set Option (Name: {OptName}, Value: {OptValue}) On Tower Index: {Tower}, Type: \"{TowerType}\", (Wave {Wave}, Min: {Min}, Sec: {Sec}, InBetween: {InWave})`)
                task.wait(1)
            end
        end)
        repeat
            if not TowersCheckHandler(Tower) then
                return
            end
            RemoteCheck = RemoteFunction:InvokeServer("Troops","Option","Set",{
                ["Troop"] = TowersContained[Tower].Instance, 
                ["Name"] = OptName,
                ["Value"] = OptValue,
            })
            task.wait()
        until type(RemoteCheck) == "boolean" and RemoteCheck
        SetActionInfo("Option")
        ConsoleInfo(`Set Option (Name: {OptName}, Value: {OptValue}) On Tower Index: {Tower}, Type: \"{TowerType}\", (Wave {Wave}, Min: {Min}, Sec: {Sec}, InBetween: {InWave})`)
    end)
end