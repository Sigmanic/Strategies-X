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
    local Path = tableinfo["PathTarget"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    local CurrentCount = StratXLibrary.CurrentCount
    SetActionInfo("Upgrade","Total")
    task.spawn(function()
        local TimerCheck = TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"])
        if not TimerCheck then
            return
        end
        --prints(TimerCheck)
        --prints("Upgrade",Wave, Min, Sec, InWave, StratXLibrary.CurrentCount, tableinfo["Debug"])
        local UpgradeCheck, SkipCheck
        task.delay(50, function()
            SkipCheck = true
        end)
        repeat
            if not TowersCheckHandler(Tower) then
                prints("End Upgrade",Wave, Min, Sec, InWave)
                return
            end
            UpgradeCheck = RemoteFunction:InvokeServer("Troops","Upgrade","Set",{
                ["Troop"] = TowersContained[Tower].Instance,
                ["Path"] = Path
            })
            task.wait()
        until UpgradeCheck or SkipCheck
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        if CurrentCount ~= StratXLibrary.RestartCount then
            return
        end
        if SkipCheck and not UpgradeCheck then
            ConsoleError("Failed To Upgrade Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..") UpgradeCheck: "..tostring(UpgradeCheck)..", SkipCheck: "..tostring(SkipCheck))
            return
        end
        SetActionInfo("Upgrade")
        ConsoleInfo("Upgraded Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..") UpgradeCheck: "..tostring(UpgradeCheck)..", SkipCheck: "..tostring(SkipCheck))
    end)
end
