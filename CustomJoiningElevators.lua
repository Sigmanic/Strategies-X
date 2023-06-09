if game.PlaceId ~= 3260590327 then return end
if not game:IsLoaded() then
    game['Loaded']:Wait()
end
if not (StratXLibrary and StratXLibrary.Executed) then
    repeat task.wait() until StratXLibrary and StratXLibrary.Executed
end
if not getgenv().IsPlayerInGroup then
    repeat task.wait() until getgenv().IsPlayerInGroup or getgenv().BypassGroup or (StratXLibrary.UtilitiesConfig and StratXLibrary.UtilitiesConfig.BypassGroup)
end
StratXLibrary:LoadMultiStrat()
--[[function prints(...)
    local TableText = {...}
    for i,v in next, TableText do
        if type(v) ~= "string" then
            TableText[i] = tostring(v)
        end
    end
    local Text = table.concat(TableText, " ")
    appendfile("StratLoader/UserLogs/PrintLog.txt", Text.."\n")
    print(Text)
    getgenv().ConsoleInfo(Text)
end
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:WaitForChild("ReplicatedStorage")
local RemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunction")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
local TroopsOwned = RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops")
if not (StratXLibrary and StratXLibrary.Executed) then
    repeat task.wait() until StratXLibrary and StratXLibrary.Executed
end
local UI = StratXLibrary.UI

if not getgenv().IsPlayerInGroup then
    repeat task.wait() until getgenv().BypassGroup or (StratXLibrary.UtilitiesConfig and StratXLibrary.UtilitiesConfig.BypassGroup)
end

--loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/AutoStratModded/main/ConvertFunc.lua", true))()
local Patcher = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/AutoStratModded/main/ConvertFunc.lua", true))()
function ParametersPatch(name,...)
    if type(...) == "table" then
        return ...
    end
    return Patcher[name](...)
end

function CheckTroop(towerequip)
    if not (type(towerequip) == "table" and type(TroopsOwned) == "table") then
        return prints("Cant Find Any Information About Towers To Equip Or Towers Owned")
    end
    local Text = ""
    for i,v in next, towerequip do
        if v ~= "nil" and not TroopsOwned[v] then
            Text = Text..v..", "
        end
    end
    if #Text ~= 0 then
        UI.EquipStatus:SetText("Troops Loadout: Missing")
        repeat
            local BoughtCheck = true
            TroopsOwned = RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops")
            for i,v in next, string.split(Text,", ") do
                if #v > 0 and v ~= "nil" and not TroopsOwned[v] then
                    BoughtCheck = false
                    UI.TowersStatus[i].Text = v..": Missing"
                end
            end
            task.wait(5)
        until BoughtCheck
    end
end
function EquipTroop(towerequip)
    if not type(towerequip) == "table" then
        prints("Cant Find Any Information About Towers To Equip")
        return
    end
    local tableinfo = ParametersPatch("Loadout",unpack(towerequip))
    local TotalTowers = tableinfo["TotalTowers"]
    UI.EquipStatus:SetText("Troops Loadout: Equipping")
    for i,v in next, TroopsOwned do
        if v.Equipped then
            RemoteEvent:FireServer("Inventory","Unequip","Tower",i)
        end
    end

    for i,v in next, TotalTowers do
        RemoteEvent:FireServer("Inventory", "Equip", "tower",v)
        UI.TowersStatus[i].Text = (tableinfo[v][1] and "[Golden] " or "")..v
        if TroopsOwned[v].GoldenPerks and tableinfo[v][1] == false then
            RemoteEvent:FireServer("Inventory", "Unequip", "Golden", v)
        elseif tableinfo[v][1] then
            RemoteEvent:FireServer("Inventory", "Equip", "Golden", v)
        end
    end
    UI.EquipStatus:SetText("Troops Loadout: Equipped")
    ConsoleInfo("Loadout Selected: \""..table.concat(TotalTowers, "\", \"").."\"")
end
--function Map(name, solo, mode)
function Map(tableinfo)
    local Map = {}
    for i,v in next, tableinfo do
        table.insert(Map,i)
    end
    local Solo = tableinfo["Solo"] or true
    local Mode = tableinfo["Mode"] or "Survival"
    repeat task.wait() until LocalPlayer:FindFirstChild("Level")
    if Mode == "Hardcore" and LocalPlayer.Level.Value < 50 then
        LocalPlayer:Kick("This User Doesn't Have Require Level > 50")
    end
    task.spawn(function()
        local Elevators = {}
        for i,v in next,Workspace.Elevators:GetChildren() do
            if require(v.Settings).Type == Mode then
                table.insert(Elevators,{
                    ["Object"] = v,
                    ["MapName"] = v.State.Map.Title,
                    ["Time"] = v.State.Timer,
                    ["Playing"] = v.State.Players
                })
            end
        end
        prints("Found",#Elevators,"Elevators")
        local JoiningCheck, ChangeCheck = false, false
        local ConnectionEvent
        local WaitTime = (#Elevators > 6 and 1) or 5.5
        task.spawn(function()
            while true do
                for i,v in next, Elevators do
                    task.wait()
                    if JoiningCheck then
                        repeat task.wait() until JoiningCheck == false
                    end
                    if not table.find(Map,v["MapName"].Value) and v["Playing"].Value == 0 and not JoiningCheck then
                        ChangeCheck = true
                        prints("Changing Elevator",i)
                        RemoteFunction:InvokeServer("Elevators", "Enter", v["Object"])
                        task.wait(.9)
                        RemoteFunction:InvokeServer("Elevators", "Leave")
                        ChangeCheck = false
                    end
                end
                task.wait(WaitTime)
            end
        end)
        while true do
            for i,v in next, Elevators do
                UI.JoiningStatus.Text = "Trying Elevator: " ..tostring(i)
                UI.MapFind.Text = "Map: "..v["MapName"].Value
                UI.CurrentPlayer.Text = "Player Joined: "..v["Playing"].Value
                UI.EquipStatus:SetText("Troops Loadout: Loading")
                prints("Trying elevator",i,"Map:","\""..v["MapName"].Value.."\"",", Player Joined:",v["Playing"].Value)
                if table.find(Map,v["MapName"].Value) and v["Time"].Value > 5 and v["Playing"].Value < 4 then
                    if Solo and v["Playing"].Value ~= 0 then
                        continue
                    end
                    if JoiningCheck or ChangeCheck then
                        repeat task.wait() until JoiningCheck == false and ChangeCheck == false
                    end
                    JoiningCheck = true
                    UI.JoiningStatus.Text = "Joined Elevator: " ..tostring(i)
                    prints("Joined Elevator",i)
                    RemoteFunction:InvokeServer("Elevators", "Enter", v["Object"])
                    EquipTroop(tableinfo[v["MapName"].Value])
                    ConnectionEvent = v["Time"].Changed:Connect(function(numbertime)
                        UI.MapFind.Text = "Map: "..v["MapName"].Value
                        UI.CurrentPlayer.Text = "Player Joined: "..v["Playing"].Value
                        UI.TimerLeft.Text = "Time Left: "..tostring(numbertime)
                        prints("Time Left: ",numbertime)
                        if not (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")) then
                            print("Event Disconnected 3")
                            ConnectionEvent:Disconnect()
                            UI.JoiningStatus.Text = "Player Died. Rejoining Elevator"
                            prints("Player Died. Rejoining Elevator")
                            RemoteFunction:InvokeServer("Elevators", "Leave")
                            UI.TimerLeft.Text = "Time Left: 20"
                            repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
                            JoiningCheck = false
                        end
                        if numbertime > 0 and (not table.find(Map,v["MapName"].Value) or (Solo and v["Playing"].Value > 1)) then
                            print("Event Disconnected 1")
                            ConnectionEvent:Disconnect()
                            local Text = (not table.find(Map,v["MapName"].Value) and "Map Has Been Changed") or ((Solo and v["Playing"].Value > 1) and "Someone Has Joined") or "Error"
                            RemoteFunction:InvokeServer("Elevators", "Leave")
                            
                            UI.JoiningStatus.Text = Text..", Leaving Elevator "..tostring(i)
                            prints(Text..", Leaving Elevator",i,"Map:","\""..v["MapName"].Value.."\"",", Player Joined:",v["Playing"].Value)
                            UI.TimerLeft.Text = "Time Left: 20"
                            JoiningCheck = false
                            return
                        end
                        if numbertime == 0 then
                            print("Event Disconnected 2")
                            ConnectionEvent:Disconnect()
                            UI.JoiningStatus.Text = "Teleporting To A Match"
                            task.wait(60)
                            UI.JoiningStatus.Text = "Rejoining Elevator"
                            prints("Rejoining Elevator")
                            RemoteFunction:InvokeServer("Elevators", "Leave")
                            UI.TimerLeft.Text = "Time Left: 20"
                            JoiningCheck = false
                            return
                        end
                    end)
                    repeat task.wait() until JoiningCheck == false
                end
                task.wait(.2)
            end
        end
    end)
end]]

--[[for i, v in next, RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops") do
    table.insert(TroopsOwned, i)
end]]

--[[for i,v in next, getgenv().Maps do
    if type(v) == "table" then
        CheckTroop(v)
    else
        prints(i,"Doesn't Contained Any Information About Towers")
        ConsoleError(i.."Doesn't Contained Any Information About Towers")
    end
end
getgenv().Maps["Mode"] = getgenv().MultiStratType or "Survival"
Map(getgenv().Maps)]]
