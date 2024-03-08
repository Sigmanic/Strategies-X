local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent

return function(self, p1)
    local tableinfo = p1--ParametersPatch("SellAllFarms",...)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("SellAllFarms","Total")
    task.spawn(function()
        if not TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"]) then
            return
        end
        for i,v in next, TowersContained do
            if v.TowerName == "Farm" and v.Instance then
                RemoteFunction:InvokeServer("Troops","Sell",{
                    ["Troop"] = v.Instance
                })
            end
        end
        --[[for i,v in next, Workspace.Towers:GetChildren() do
            if v:FindFirstChild("Owner").Value == LocalPlayer.UserId and v.Replicator:GetAttribute("Type") == "Farm" then 
                RemoteFunction:InvokeServer("Troops","Sell",{
                    ["Troop"] = v
                })
            end
        end]]
        SetActionInfo("SellAllFarms")
    end)
end