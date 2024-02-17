local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
--[[{
    ["TowerIndex"] = ""
    ["TypeIndex"] = "",
    ["UpgradeTo"] = number,
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
return function(self, p1)
    local tableinfo = p1--ParametersPatch("Upgrade",...)
    local Tower = tableinfo["TowerIndex"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("Upgrade","Total")
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"])
        local SkipCheck = false
        task.spawn(function()
            task.wait(15)
            SkipCheck = true
        end)
        local CheckUpgraded
        TowersCheckHandler(Tower)
        repeat
            --pcall(function()
            CheckUpgraded = RemoteFunction:InvokeServer("Troops","Upgrade","Set",{
                ["Troop"] = TowersContained[Tower].Instance
            })
            task.wait()
            --end)
        until CheckUpgraded or SkipCheck
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        if SkipCheck and not CheckUpgraded then
            ConsoleError("Failed To Upgrade Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..") CheckUpgraded: "..tostring(CheckUpgraded)..", SkipCheck: "..tostring(SkipCheck))
            return
        end
        SetActionInfo("Upgrade")
        ConsoleInfo("Upgraded Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..") CheckUpgraded: "..tostring(CheckUpgraded)..", SkipCheck: "..tostring(SkipCheck))
    end)
end