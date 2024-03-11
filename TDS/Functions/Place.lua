local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
local TowerProps = {}

local PreviewHolder = Instance.new("Folder")
PreviewHolder.Parent = ReplicatedStorage
PreviewHolder.Name = "PreviewHolder"
local AssetsHologram = Instance.new("Folder")
AssetsHologram.Parent = PreviewHolder
AssetsHologram.Name = "AssetsHologram"
local AssetsError = Instance.new("Folder")
AssetsError.Parent = PreviewHolder
AssetsError.Name = "AssetsError"

local PreviewFolder = Instance.new("Folder")
PreviewFolder.Parent = Workspace
PreviewFolder.Name = "PreviewFolder"
--[[local PreviewHightLight = Instance.new("Highlight")
PreviewHightLight.Parent = PreviewFolder
PreviewHightLight.FillColor = Color3.fromRGB(255, 255, 255)]]

local PrewviewErrorFolder = Instance.new("Folder")
PrewviewErrorFolder.Parent = Workspace
PrewviewErrorFolder.Name = "PrewviewErrorFolder"
--[[local NotGoodHightLight = Instance.new("Highlight")
NotGoodHightLight.Parent = PrewviewErrorFolder
NotGoodHightLight.FillColor = Color3.fromRGB(255, 0, 0)
NotGoodHightLight.FillTransparency = 0.3]]

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

function DebugTower(Object, Color) --Rework in Future
    repeat task.wait() until tonumber(Object.Name) and Object:FindFirstChild("HumanoidRootPart")
    local Color = Color or Color3.new(1, 0, 0)
    local HumanoidRootPart = Object:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart:FindFirstChild("BillboardGui") then
        HumanoidRootPart:FindFirstChild("BillboardGui"):Destroy()
    end
    local GuiInstance = Instance.new("BillboardGui")
    GuiInstance.Parent = HumanoidRootPart
    GuiInstance.Adornee = HumanoidRootPart
    GuiInstance.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
    GuiInstance.Size = UDim2.new(0, 250, 0, 50)
    GuiInstance.AlwaysOnTop = true
    local Text = Instance.new("TextLabel")
    Text.Parent = GuiInstance
    Text.BackgroundTransparency = 1
    Text.Text = Object.Name
    Text.Font = "Legacy"
    Text.Size = UDim2.new(1, 0, 0, 70)
    Text.TextSize = 22
    Text.TextScaled = false
    Text.TextColor3 = Color
    Text.TextStrokeColor3 = Color3.new(0, 0, 0)
    Text.TextStrokeTransparency = 0.5
end

function PreviewInitial()
    for i,v in next, RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops") do
        if v.Equipped then
            TowerProps[i] = v.Skin
            local Tower = ReplicatedStorage.Assets.Troops[i].Skins[v.Skin]:Clone()
            Tower.Parent = AssetsHologram
            Tower.Name = i
            for i2,v2 in next, Tower:GetDescendants() do
                if v2:IsA("BasePart") then
                    v2.Material = Enum.Material.ForceField
                    if v2.CanCollide then
                        v2.CanCollide = false
                    end
                end
            end
            local Tower = Tower:Clone()
            for i2,v2 in next, Tower:GetDescendants() do
                if v2:IsA("BasePart") then
                    v2.Color = Color3.new(1, 0, 0)
                end
            end
            Tower.Parent = AssetsError
            --[[for i2,v2 in next, Tower:GetDescendants() do
                if v2:IsA("BasePart") then
                    v2.Material = Enum.Material.ForceField
                end
            end]]
        end
    end
end

function AddFakeTower(Name,Type)
    if not TowerProps[Name] then
        PreviewInitial()
    end
    local Type = Type or "Normal"
    --local SkinName = SkinName or TowerProps[Name]
    local Tower = if Type == "Normal" then AssetsHologram[Name] else AssetsError[Name] --ReplicatedStorage.Assets.Troops[Name].Skins[SkinName]
    if Tower then
        Tower = Tower:Clone()
        Tower.Parent = PreviewHolder --if Type == "Normal" then PreviewFolder else PrewviewErrorFolder
        if Tower:FindFirstChild("AnimationController") then
            task.spawn(function()
                local Success
                repeat task.wait(.7)
                    Success = pcall(function()
                        Tower:FindFirstChild("AnimationController"):LoadAnimation(Tower.Animations.Idle["0"]):Play()
                    end)
                until Success
            end)
        end
        return Tower
    end
end

if CheckPlace() then
    PreviewInitial()
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

    local CurrentCount = StratXLibrary.CurrentCount
    local TowerTable = TowersContained[TempNum]
    local TowerModel = AddFakeTower(TowerTable.TowerName)
    --TowerModel.PrimaryPart.CFrame = CFrame.new(TowerTable.Position) + Vector3.new(0,math.abs(TowerModel.PrimaryPart.HeightOffset.CFrame.Y),0)
    TowerModel:PivotTo(CFrame.new(TowerTable.Position + Vector3.new(0,math.abs(TowerModel.PrimaryPart.HeightOffset.CFrame.Y),0)) * TowerTable.Rotation)
    TowerModel.Name = TempNum
    DebugTower(TowerModel,Color3.new(0.35, 0.7, 0.3))
    TowerTable.TowerModel = TowerModel
    if UtilitiesTab.flags.TowersPreview then
        TowerModel.Parent = PreviewFolder
    end

    task.spawn(function()
        if not TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"]) then
            return
        end
        TowerTable.PassedTimer = true
        local CheckPlaced, ErrorModel
        task.delay(45, function()
            if typeof(CheckPlaced) ~= "Instance" then
                ConsoleError("Tower Index: "..TempNum..", Type: \""..Tower.."\" Hasn't Been Placed In The Last 45 Seconds. Check Again Its Arguments Or Order.")
                ConsoleError(`Returned CheckPlaced Value: {CheckPlaced}`)
            end
        end)
        repeat
            if type(CheckPlaced) == "string" and CheckPlaced == "You cannot place here!" and not ErrorModel then
                ErrorModel = AddFakeTower(TowerTable.TowerName,"Error")
                ErrorModel:PivotTo(CFrame.new(TowerTable.Position + Vector3.new(0,math.abs(TowerModel.PrimaryPart.HeightOffset.CFrame.Y),0)) * TowerTable.Rotation)
                ErrorModel.Name = TempNum
                DebugTower(ErrorModel,Color3.new(1, 0, 0))
                TowerTable.ErrorModel = ErrorModel 
                TowerModel.Parent = PreviewHolder
                --[[local NotGoodHightLight = NotGoodHightLight:Clone()
                NotGoodHightLight.Parent = ErrorModel]]
                if UtilitiesTab.flags.TowersPreview then
                    ErrorModel.Parent = PrewviewErrorFolder
                end
            end
            if CurrentCount ~= StratXLibrary.RestartCount then
                return
            end
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
        TowerModel.Parent = PreviewHolder
        if ErrorModel then
            ErrorModel.Parent = PreviewHolder
        end
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