local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
--[[{
    ["TowerIndex"] = "",
    ["TypeIndex"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
    ["Target"] = string,
}]]
return function(self, p1)
    local tableinfo = p1--ParametersPatch("Target",...)
    local Tower = tableinfo["TowerIndex"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    local Target = tableinfo["Target"]
    if not CheckPlace() then
        return
    end
    SetActionInfo("Target","Total")
    task.spawn(function()
        if not TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"]) then
            return
        end
        if not TowersCheckHandler(Tower) then
            return
        end
        RemoteFunction:InvokeServer("Troops","Target","Set",{
            ["Troop"] = TowersContained[Tower].Instance,
            ["Target"] = Target,
        })
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        SetActionInfo("Target")
        ConsoleInfo("Changed Target To: "..Target..", Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end