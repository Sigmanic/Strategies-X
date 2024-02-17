local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
--[[{
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
return function(self, p1)
    local tableinfo = p1--ParametersPatch("Skip",...)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("Skip","Total")
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"])
        RemoteFunction:InvokeServer("Voting", "Skip")
        SetActionInfo("Skip")
        ConsoleInfo("Skipped Wave "..Wave.." (Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end