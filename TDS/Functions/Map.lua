local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
local TeleportService = game:GetService("TeleportService")

local SpecialGameMode = {
    ["Pizza Party"] = "halloween",
    ["Badlands II"] = "badlands",
    ["Polluted Wastelands II"] = "polluted", 
    ["Huevous Hunt"] = {"egg_hunt"},
}

return function(self, p1)
    local tableinfo = p1
    local MapName = tableinfo["Map"]
    local Solo = tableinfo["Solo"]
    local Mode = tableinfo["Mode"]
    local Difficulty = tableinfo["Difficulty"]
    --local MapProps = self.Map
    local MapGlobal = StratXLibrary.Global.Map --Not use self.Map since this function acts like global so if using self in each strat, it will duplicate the value and conflicts
    tableinfo.Index = self.Index
    local NameTable = MapName..":"..Mode
    MapGlobal[NameTable] = tableinfo
    if MapGlobal.Active then
        print("Execute One Actived")
        return
    end
    MapGlobal.Active = true
    for i,v in next, MapGlobal do
        if string.find(typeof(v):lower(),"thread") then
            task.cancel(v)
        elseif string.find(typeof(v):lower(),"rbxscript") then
            v:Disconnect()
            RemoteFunction:InvokeServer("Elevators", "Leave")
        end
    end
    MapGlobal.JoiningCheck = false
    MapGlobal.ChangeCheck = false
    task.spawn(function()
        if CheckPlace() then
            if not MapGlobal[ReplicatedStorage.State.Map.Value..":"..GetGameInfo():GetAttribute("GameMode")] then
                print(MapGlobal[ReplicatedStorage.State.Map.Value..":"..GetGameInfo():GetAttribute("GameMode")],GetGameInfo():GetAttribute("GameMode"))
                ConsoleError("Wrong Map Selected: "..ReplicatedStorage.State.Map.Value..", ".."Mode: "..GetGameInfo():GetAttribute("GameMode"))
                task.wait(3)
                TeleportHandler(3260590327,2,7)
                --TeleportService:Teleport(3260590327, LocalPlayer)
                return
            end
            ConsoleInfo("Map Selected: "..ReplicatedStorage.State.Map.Value..", ".."Mode: "..Mode..", ".."Solo Only: "..tostring(Solo))
            return
        end
        local Elevators = {}
        for i,v in next,Workspace.Elevators:GetChildren() do
            if (Mode == "Survival" and v.State.Difficulty.Value == "Private Server") or Matchmaking then
                UI.JoiningStatus.Text = "Teleporting To Matchmaking"
                if SpecialGameMode[MapName] then
                    local Strat = StratXLibrary.Strat[self.Index]
                    if Strat.Loadout and not Strat.Loadout.AllowTeleport then
                        prints("Waiting Loadout Allowed")
                        repeat task.wait() until Strat.Loadout.AllowTeleport
                    end
                    local LoadoutInfo = Strat.Loadout.Lists[#Strat.Loadout.Lists]
                    LoadoutInfo.AllowEquip = true
                    LoadoutInfo.SkipCheck = true
                    print("Loadout Selecting")
                    Functions.Loadout(Strat,LoadoutInfo)
                    task.wait(2)
                end
                RemoteFunction:InvokeServer("Multiplayer","single_create")       
                RemoteFunction:InvokeServer("Multiplayer","single_start",{
                    ["count"] = 1,
                    ["mode"] = if SpecialGameMode[MapName] then SpecialGameMode[MapName] else "survival",
                    ["difficulty"] = Difficulty,
                })
                prints(if SpecialGameMode[MapName] then `Using MatchMaking To Teleport To Special GameMode: {SpecialGameMode[MapName]}` else "Teleport To Matchmaking Place")
                return
            end
            table.insert(Elevators,{
                ["Object"] = v,
                ["MapName"] = v.State.Map.Title,
                ["Time"] = v.State.Timer,
                ["Playing"] = v.State.Players,
                ["Mode"] = require(v.Settings).Type,
            })
        end
        prints("Found",#Elevators,"Elevators")
        --local WaitTime = (#Elevators > 6 and 1) or 5.5
        MapGlobal.ReMap = task.spawn(function()
            while true do
                for i,v in ipairs(Elevators) do
                    task.wait()
                    if MapGlobal.JoiningCheck then
                        repeat task.wait() until MapGlobal.JoiningCheck == false
                    end
                    local MapTableName = v["MapName"].Value..":"..v["Mode"]
                    if not MapGlobal[MapTableName] and v["Playing"].Value == 0 and not MapGlobal.JoiningCheck then
                        MapGlobal.ChangeCheck = true
                        prints("Changing Elevator",i)
                        RemoteFunction:InvokeServer("Elevators", "Enter", v["Object"])
                        task.wait(.9)
                        RemoteFunction:InvokeServer("Elevators", "Leave")
                        MapGlobal.ChangeCheck = false
                    end
                end
                task.wait(.3)
            end
        end)
        MapGlobal.JoinMap = task.spawn(function()
            while true do
                for i,v in ipairs(Elevators) do
                    UI.JoiningStatus.Text = "Trying Elevator: " ..tostring(i)
                    UI.MapFind.Text = "Map: "..v["MapName"].Value
                    UI.CurrentPlayer.Text = "Player Joined: "..v["Playing"].Value
                    prints("Trying elevator",i,"Map:","\""..v["MapName"].Value.."\"",", Player Joined:",v["Playing"].Value)
                    local MapTableName = v["MapName"].Value..":"..v["Mode"]
                    local MapTable = MapGlobal[MapTableName]
                    if MapTable and v["Time"].Value > 5 and v["Playing"].Value < 4 then
                        if MapTable.Solo and v["Playing"].Value ~= 0 then
                            continue
                        end
                        local MapIndex = MapTable.Index
                        if StratXLibrary.Strat[MapIndex].Loadout and not StratXLibrary.Strat[MapIndex].Loadout.AllowTeleport then
                            prints("Waiting Loadout Allowed")
                            repeat task.wait() until StratXLibrary.Strat[MapIndex].Loadout.AllowTeleport
                        end
                        if MapGlobal.JoiningCheck or MapGlobal.ChangeCheck then -- or not self.Loadout.AllowTeleport then
                            repeat task.wait() 
                            until MapGlobal.JoiningCheck == false and MapGlobal.ChangeCheck == false --and self.Loadout.AllowTeleport
                        end
                        MapGlobal.JoiningCheck = true

                        RemoteFunction:InvokeServer("Elevators", "Enter", v["Object"])
                        UI.JoiningStatus.Text = "Joined Elevator: " ..tostring(i)
                        prints("Joined Elevator",i)

                        local LoadoutInfo = StratXLibrary.Strat[MapIndex].Loadout.Lists[#StratXLibrary.Strat[MapIndex].Loadout.Lists]
                        LoadoutInfo.AllowEquip = true
                        LoadoutInfo.SkipCheck = true
                        print("Loadout Selecting")
                        Functions.Loadout(StratXLibrary.Strat[MapIndex],LoadoutInfo)

                        MapGlobal.ConnectionEvent = v["Time"].Changed:Connect(function(numbertime)
                            local MapTableName = v["MapName"].Value..":"..v["Mode"]
                            UI.MapFind.Text = "Map: "..v["MapName"].Value
                            UI.CurrentPlayer.Text = "Player Joined: "..v["Playing"].Value
                            UI.TimerLeft.Text = "Time Left: "..tostring(numbertime)
                            prints("Time Left: ",numbertime)
                            --Scenario: Player Died
                            if not (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")) then
                                print("Event Disconnected 3")
                                MapGlobal.ConnectionEvent:Disconnect()
                                UI.JoiningStatus.Text = "Player Died. Rejoining Elevator"
                                prints("Player Died. Rejoining Elevator")
                                RemoteFunction:InvokeServer("Elevators", "Leave")
                                UI.TimerLeft.Text = "Time Left: NaN"
                                repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
                                MapGlobal.JoiningCheck = false
                                return
                            end
                            if numbertime > 0 and (not MapGlobal[MapTableName] or (MapGlobal[MapTableName].Solo and v["Playing"].Value > 1)) then
                                print("Event Disconnected 1")
                                MapGlobal.ConnectionEvent:Disconnect()
                                local Text = (not MapGlobal[MapTableName] and "Map Has Been Changed") or ((MapGlobal[MapTableName].Solo and v["Playing"].Value > 1) and "Someone Has Joined") or "Error"
                                RemoteFunction:InvokeServer("Elevators", "Leave")
                                UI.JoiningStatus.Text = Text..", Leaving Elevator "..tostring(i)
                                prints(Text..", Leaving Elevator",i,"Map:","\""..v["MapName"].Value.."\"",", Player Joined:",v["Playing"].Value)
                                UI.TimerLeft.Text = "Time Left: NaN"
                                MapGlobal.JoiningCheck = false
                                return
                            end
                            if numbertime == 0 then
                                print("Event Disconnected 2")
                                MapGlobal.ConnectionEvent:Disconnect()
                                UI.JoiningStatus.Text = "Teleporting To Match"
                                task.wait(60)
                                UI.JoiningStatus.Text = "Rejoining Elevator"
                                prints("Rejoining Elevator")
                                RemoteFunction:InvokeServer("Elevators", "Leave")
                                UI.TimerLeft.Text = "Time Left: NaN"
                                MapGlobal.JoiningCheck = false
                                return
                            end
                            RemoteFunction:InvokeServer("Elevators", "Enter", v["Object"])
                        end)
                        repeat task.wait() until MapGlobal.JoiningCheck == false
                    end
                    task.wait(.2)
                end
            end
        end)
    end)
end