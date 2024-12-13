local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
--[[{
    ["TowerIndex"] = "",
    ["TypeIndex"] = "",
    ["Ability"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
return function(self, p1)
    local tableinfo = p1--ParametersPatch("Ability",...)
    local Tower = tableinfo["TowerIndex"]
    local Ability = tableinfo["Ability"]
    local Data = tableinfo["Data"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("Ability","Total")
    task.spawn(function()
        if not TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"]) then
            return
        end
        local AbilityCheck
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        task.spawn(function()
            task.wait(2)
            while not (type(AbilityCheck) == "boolean" and AbilityCheck) do
                ConsoleWarn(`Cannot Ability (Name: {Ability} On Tower Index: {Tower}, Type: \"{TowerType}\", (Wave {Wave}, Min: {Min}, Sec: {Sec}, InBetween: {InWave})`)
                task.wait(1)
            end
        end)
        repeat
            if not TowersCheckHandler(Tower) then
                return
            end
            if Ability == "Call Of Arms" and TowersContained[Tower].AutoChain then
                SetActionInfo("Ability")
                ConsoleInfo("Skipped Ability (AutoChain Enabled) On Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
                return
            end
            AbilityCheck = RemoteFunction:InvokeServer("Troops","Abilities","Activate",{
                ["Troop"] = TowersContained[Tower].Instance,
                ["Name"] = Ability,
                ["Data"] = Data,
            })
            task.wait()
        until type(AbilityCheck) == "boolean" and AbilityCheck
        SetActionInfo("Ability")
        ConsoleInfo("Used Ability On Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end