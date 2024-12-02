local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
--[[{
    ["TowerIndex1"] = "",
    ["TowerIndex2"] = "",
    ["TowerIndex3"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
function Chain(Tower)
    local Tower = TowersContained[Tower].Instance
    if Tower and Tower:FindFirstChild("Replicator") and Tower:FindFirstChild("Replicator"):GetAttribute("Upgrade") >= 2 then
        if Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") ~= false then
            repeat task.wait() 
            until not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false or not Tower
            if not Tower then
                return
            end
        end
        RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"] = Tower ,["Name"] = "Call Of Arms"})
        task.wait(10)
    end
end
return function(self, p1)
    local tableinfo = p1--ParametersPatch("AutoChain",...)
    local Tower1,Tower2,Tower3 = tableinfo["TowerIndex1"], tableinfo["TowerIndex2"], tableinfo["TowerIndex3"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("AutoChain","Total")
    task.spawn(function()
        if not TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"]) then
            return
        end
        if not TowersCheckHandler(Tower1,Tower2,Tower3) then
            return
        end
        TowersContained[Tower1].AutoChain = true
        TowersContained[Tower2].AutoChain = true
        TowersContained[Tower3].AutoChain = true
        local TowerType = {
            [Tower1] = TowersContained[Tower1].TypeIndex,
            [Tower2] = TowersContained[Tower2].TypeIndex,
            [Tower3] = TowersContained[Tower3].TypeIndex,
        }
        for i,v in next, TowerType do
            if not v:match("Commander") then
                ConsoleError("Troop Index: "..v.." Is Not A Commander!")
                return
            end
        end
        SetActionInfo("AutoChain")
        ConsoleInfo("Enabled AutoChain For Towers Index: "..Tower1..", "..Tower2..", "..Tower3..", Types: \""..TowerType[Tower1].."\",  \""..TowerType[Tower2].."\", \""..TowerType[Tower3]..
        "\" (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
        while true do
            if not TowersContained[Tower1].Instance then
                TowersContained[Tower1].AutoChain = false
                ConsoleInfo("Disbaled AutoChain For Towers Index: "..Tower1..", "..Tower2..", "..Tower3)
                break
            end
            Chain(Tower1)
            if not TowersContained[Tower2].Instance then
                TowersContained[Tower2].AutoChain = false
                ConsoleInfo("Disbaled AutoChain For Towers Index: "..Tower1..", "..Tower2..", "..Tower3)
                break
            end
            Chain(Tower2)
            if not TowersContained[Tower3].Instance then
                TowersContained[Tower3].AutoChain = false
                ConsoleInfo("Disbaled AutoChain For Towers Index: "..Tower1..", "..Tower2..", "..Tower3)
                break
            end
            Chain(Tower3)
            task.wait()
        end
    end)
end