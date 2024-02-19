local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent

function StackPosition(Position,SkipCheck)
    local Position = if typeof(Position) == "Vector3" then Position else Vector3.new(0,0,0)
    local PositionY = Position.Y
    for i,v in next, TowersContained do
        --if v.Position and v.Placed and (math.floor(v.Position.X) == math.floor(Position.X) and math.floor(v.Position.Z) == math.floor(Position.Z)) and (v.Position - Position).magnitude < 5 then (math.abs(v.Position.X - Position.X) < 1 and math.abs(v.Position.Z - Position.Z) < 1)
        if not (v.Position) then -- and v.Placed
            continue
        end
        if (v.Position * Vector3.new(1,0,1) - Position * Vector3.new(1,0,1)).magnitude < 1 and (v.Position - Position).magnitude < 5 then
            Position = Vector3.new(Position.X,v.Position.Y + 5, Position.Z)
        end
    end
    return Vector3.new(0,Position.Y - PositionY,0)
end

--[[{
    ["Type"] = "",
    ["TypeIndex"] = ""
    ["Position"] = Vector3.new(),
    ["Rotation"] = CFrame.new(),
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
    ["InBetween"] = boolean,
}]]
return function(self, p1)
    local tableinfo = p1--ParametersPatch("Place",...)
    local Tower = tableinfo["Type"]
    local Position = tableinfo["Position"] or Vector3.new(0,0,0)
    local Rotation = tableinfo["Rotation"] or CFrame.new(0,0,0)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("Place","Total")
    local TempNum = #TowersContained + 1
    TowersContained[TempNum] = {
        ["TowerName"] = Tower,
        ["Placed"] = false,
        ["TypeIndex"] = "Nil",
        ["Position"] = Position + StackPosition(Position),
        ["Rotation"] = Rotation,
        ["OldPosition"] = Position,
        ["PassedTimer"] = false,
    }
    local TowerTable = TowersContained[TempNum]
    task.spawn(function()

        TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"])
        TowerTable.PassedTimer = true
        local CheckPlaced
        task.delay(25, function()
            if typeof(CheckPlaced) ~= "Instance" then
                ConsoleError("Tower Index: "..TempNum..", Type: \""..Tower.."\" Hasn't Been Placed In The Last 25 Seconds. Check Again Its Arguments Or Order.")
            end
        end)
        repeat
            --[[if type(CheckPlaced) == "string" and CheckPlaced == "You cannot place here!" then
                TowerTable.Position +=  StackPosition(TowerTable.Position)
            end]]
            CheckPlaced = RemoteFunction:InvokeServer("Troops","Place",Tower,{
                ["Position"] = TowerTable.Position,
                ["Rotation"] = TowerTable.Rotation
            })
            task.wait()
        until typeof(CheckPlaced) == "Instance" --return instance
        CheckPlaced.Name = TempNum
        local TowerInfo = StratXLibrary.TowerInfo[Tower]
        TowerInfo[2] += 1
        CheckPlaced:SetAttribute("TypeIndex", Tower.." "..tostring(TowerInfo[2]))
        TowerInfo[1].Text = Tower.." : "..tostring(TowerInfo[2])
        TowerTable.Instance = CheckPlaced
        TowerTable.TypeIndex = CheckPlaced:GetAttribute("TypeIndex")
        TowerTable.Placed = true
        TowerTable.Target = "First"
        TowerTable.Upgrade = 0
        if getgenv().Debug then
            task.spawn(DebugTower,TowerTable.Instance)
        end
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],TempNum)
        SetActionInfo("Place")
        local StackingCheck = (TowerTable.Position - TowerTable.OldPosition).magnitude > 1
        ConsoleInfo("Placed "..Tower.." Index: "..CheckPlaced.Name..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")"..
        if StackingCheck then ", Stacked Position" else ", Original Position")
    end)
end