local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
local TeleportService = game:GetService("TeleportService")

local SpecialGameMode = {
    ["Pizza Party"] = {mode = "halloween", challenge = "PizzaParty"},
    ["Badlands II"] = {mode = "badlands", challenge = "Badlands"},
    ["Polluted Wastelands II"] = {mode = "polluted", challenge = "PollutedWasteland"},
    --Current Special Maps ^^^^^^
    ["Failed Gateway"] = {mode = "halloween2024", difficulty = "Act1", night = 1},
    ["The Nightmare Realm"] = {mode = "halloween2024", difficulty = "Act2", night = 2},
    ["Containment"] = {mode = "halloween2024", difficulty = "Act3", night = 3},
    ["Pls Donate"] = {mode = "plsDonate", difficulty = "PlsDonateHard"},
    ["Outpost 32"] = {mode = "frostInvasion", difficulty = "Hard" },
    --Temporary Special Maps ^^^^^^
    ["Classic Candy Cane Lane"] = {mode = "Event", part = "ClassicRobloxPart1"},
    ["Classic Winter"] = {mode = "Event", part = "ClassicRobloxPart2"},
    ["Classic Forest Camp"] = {mode = "Event", part = "ClassicRobloxPart3"},
    ["Classic Island Chaos"] = {mode = "Event", part = "ClassicRobloxPart4"},
    ["Classic Castle"] = {mode = "Event", part = "ClassicRobloxPart5"},
    --The Classic Event Maps ^^^^^^ [STILL EXIST IN GAME FILES]
    ["Huevous Hunt"] = {""},
    --The Hunt Event Maps [NO LONGER EXIST IN GAME FILES]
}
local ElevatorSettings = {
    ["Survival"] = {Enabled = false, ChangeMap = true, JoinMap = true, WaitTimeToChange = .1, WaitTimeToJoin = .25},
    ["Hardcore"] = {Enabled = false, ChangeMap = true, JoinMap = true, WaitTimeToChange = 4.2, WaitTimeToJoin = 1.7},
    ["Tutorial"] = {Enabled = false},
    ["Halloween2024"] = {Enabled = false},
    ["PlsDonate"] = {Enabled = false},
    ["Event"] = {Enabled = false},
    ["FrostInvasion"] = {Enabled = false}
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
    ElevatorSettings[Mode].Enabled = true
    MapGlobal[NameTable] = tableinfo
    if MapGlobal.Active then
        print("One-time Execution")
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
            local RSMode = ReplicatedStorage:WaitForChild("State"):WaitForChild("Mode") -- Survival or Hardcore check
            local RSMap = ReplicatedStorage:WaitForChild("State"):WaitForChild("Map") --map's Name
            repeat task.wait() until RSMap.Value and typeof(RSMap.Value) == "string" and RSMode.Value --#ReplicatedStorage.State.Map.Value > 1
            local GameMapName = RSMap.Value
            local GameMode = RSMode.Value
            local MapTable = MapGlobal[GameMapName..":"..GameMode]
            if not MapTable then --or not StratXLibrary.Strat[MapTable.Index].Loadout.AllowTeleport then
                print(MapGlobal[GameMapName..":"..GameMode],GameMode)
                ConsoleError("Wrong Map Selected: "..GameMapName..", ".."Mode: "..GameMode)
                task.wait(3)
                TeleportHandler(3260590327,2,7)
                --TeleportService:Teleport(3260590327, LocalPlayer)
                return
            end
            ConsoleInfo("Map Selected: "..GameMapName..", ".."Mode: "..Mode..", ".."Solo Only: "..tostring(Solo))
            return
        end
        local Elevators = {
            ["Survival"] = {},
            ["Hardcore"] = {},
        }
        if MapName == "Tutorial" then
            prints("Teleporting To Tutorial Mode ")
            RemoteEvent:FireServer("Tutorial", "Start")
            return
        end
        for i,v in next, Workspace.Elevators:GetChildren() do
            if SpecialGameMode[MapName] then
                local SpecialTable = SpecialGameMode[MapName]
                UI.JoiningStatus.Text = `Special Gamemode Found. Checking Loadout`
                local Strat = StratXLibrary.Strat[self.Index]
                if Strat.Loadout and not Strat.Loadout.AllowTeleport then
                    prints("Waiting Loadout Allowed")
                    repeat task.wait() until Strat.Loadout.AllowTeleport
                end
                local LoadoutInfo = Strat.Loadout.Lists[#Strat.Loadout.Lists]
                LoadoutInfo.AllowEquip = true
                LoadoutInfo.SkipCheck = true
                prints("Loadout Selecting")
                Functions.Loadout(Strat,LoadoutInfo)
                task.wait(2)
                UI.JoiningStatus.Text = `Teleporting to Special Gamemode`
                RemoteFunction:InvokeServer("Multiplayer","single_create")
                if SpecialTable.mode == "halloween2024" then
                    RemoteFunction:InvokeServer("Multiplayer","v2:start",{
                        ["difficulty"] = SpecialTable.difficulty,
                        ["night"] = SpecialTable.night,
                        ["count"] = 1,
                        ["mode"] = SpecialTable.mode,
                    })
                elseif SpecialTable.mode == "frostInvasion" then
                    RemoteFunction:InvokeServer("Multiplayer","v2:start",{
                        ["difficulty"] = SpecialTable.difficulty,
                        ["mode"] = SpecialTable.mode,
                        ["count"] = 1,
                    })
                elseif SpecialTable.mode == "plsDonate" then
                    RemoteFunction:InvokeServer("Multiplayer","v2:start",{
                    ["difficulty"] = SpecialTable.difficulty,
                    ["count"] = 1,
                    ["mode"] = SpecialTable.mode,
                    })
                elseif SpecialTable.mode == "Event" then
                    RemoteFunction:InvokeServer("EventMissions","Start", SpecialTable.part)
                else
                    RemoteFunction:InvokeServer("Multiplayer","v2:start",{
                        ["count"] = 1,
                        ["mode"] = SpecialTable.mode,
                        ["challenge"] = SpecialTable.challenge,
                    })
                end
                prints(`Using MatchMaking To Teleport To Special GameMode: {SpecialTable.mode}`)
                return
            elseif UtilitiesConfig.PreferMatchmaking or Workspace:GetAttribute("IsPrivateServer") or game:GetService("MarketplaceService"):UserOwnsGamePassAsync(LocalPlayer.UserId, 10518590) then
                UI.JoiningStatus.Text = `Matchmaking Enabled. Checking Loadout`
                prints("Waiting Loadout Allowed")
                local Strat = StratXLibrary.Strat
                local MapProps
                repeat
                    task.wait()
                    for i,v in next, Strat do
                        if v.Loadout and v.Loadout.AllowTeleport then
                            MapProps = v.Map.Lists[1]
                            break
                        end
                    end
                until MapProps
                local DiffTable = {
                    ["Easy"] = "Easy",
                    ["Normal"] = "Molten",
                    ["Intermediate"] = "Intermediate",
                    ["Fallen"] = "Fallen",
                }
                local Strat = Strat[MapProps.Index]
                local DifficultyName = Strat.Mode.Lists[1] and DiffTable[Strat.Mode.Lists[1].Name]
                local LoadoutInfo = Strat.Loadout.Lists[1]
                LoadoutInfo.AllowEquip = true
                LoadoutInfo.SkipCheck = true
                prints("Loadout Selecting")
                Functions.Loadout(Strat,LoadoutInfo)
                task.wait(2)
                UI.JoiningStatus.Text = `Teleporting to Matchmaking Place`
                RemoteFunction:InvokeServer("Multiplayer","single_create")
                RemoteFunction:InvokeServer("Multiplayer","v2:start",{
                    ["count"] = 1,
                    ["mode"] = string.lower(MapProps.Mode),
                    ["difficulty"] = DifficultyName,
                })
                prints("Teleporting To Matchmaking Place")
                return
            end
            --[[local Passed, ElevatorType = pcall(function()
				return require(v.Settings).Type
			end)
			if not Passed then
				ElevatorType = if v:GetAttribute("Level") == 50 then "Hardcore" else "Survival"
			end
			if not Elevators[ElevatorType] then
				Elevators[ElevatorType] = {}
			end
			table.insert(Elevators[ElevatorType],{
				["Object"] = v,
				["MapName"] = v:GetAttribute("Map"),
				["Time"] = v:GetAttribute("Timer"),
				["Playing"] = v:GetAttribute("Players"),
				["Mode"] = ElevatorType,
			})]]
            local ElevatorType = v:GetAttribute("Type")
            if not Elevators[ElevatorType] then
                Elevators[ElevatorType] = {}
            end
            table.insert(Elevators[ElevatorType],{
				["Object"] = v,
				["Map"] = v:GetAttribute("Map"),
				["Timer"] = v:GetAttribute("Timer"),
				["Players"] = v:GetAttribute("Players"),
				["Mode"] = ElevatorType,
            })
        end
        --prints("Found",#Elevators,"Elevators")
        for i,v in next, Elevators do
            prints("Found",#v, i.." Elevators")
        end
        while true do
            task.wait(.3)
            for Name, Check in next, ElevatorSettings do
                if not Check.Enabled then
                    continue
                end
                local ElevatorEnter = ReplicatedStorage:WaitForChild("Network"):WaitForChild("Elevators"):WaitForChild("Enter")
                local ElevatorLeave = ReplicatedStorage:WaitForChild("Network"):WaitForChild("Elevators"):WaitForChild("Leave")
                --Changing Map [[NO LONGER EXIST]]
                --[[if Check.ChangeMap then
                    ElevatorSettings[Name].ChangeMap = false
                    task.wait()
                    task.spawn(function()
                        for i,v in ipairs(Elevators[Name]) do
                            task.wait(ElevatorSettings[Name].WaitTimeToChange)
                            if MapGlobal.JoiningCheck then
                                repeat task.wait() until MapGlobal.JoiningCheck == false
                            end
                            local ModeElevator = v["Object"]:GetAttribute("Type")
                            local MapElevator = v["Object"]:GetAttribute("Map")
                            local PlayersElevator = v["Object"]:GetAttribute("Players")
                            local TimerElevator = v["Object"]:GetAttribute("Timer")
                            local MapTableName = MapElevator..":"..ModeElevator
                            if not MapGlobal[MapTableName] and PlayersElevator == 0 and not MapGlobal.JoiningCheck then
                                MapGlobal.ChangeCheck = true
                                prints("Changing Elevator",i)
                                ElevatorEnter:InvokeServer(v["Object"])
                                task.wait(.8)
                                ElevatorLeave:InvokeServer()
                                task.wait(.1)
                                MapGlobal.ChangeCheck = false
                            end
                        end
                        task.wait()
                        ElevatorSettings[Name].ChangeMap = true
                    end)
                end]]
                --Joining Map
                if Check.JoinMap then
                    ElevatorSettings[Name].JoinMap = false
                    task.wait()
                    task.spawn(function()
                        for i,v in ipairs(Elevators[Name]) do
                            task.wait(ElevatorSettings[Name].WaitTimeToJoin)
                            UI.JoiningStatus.Text = "Trying Elevator: " ..tostring(i)
                            local ModeElevator = v["Object"]:GetAttribute("Type")
                            local MapElevator = v["Object"]:GetAttribute("Map")
                            local PlayersElevator = v["Object"]:GetAttribute("Players")
                            local TimerElevator = v["Object"]:GetAttribute("Timer")
                            UI.MapFind.Text = "Map: "..MapElevator
                            UI.CurrentPlayer.Text = "Player Joined: "..PlayersElevator
                            prints("Checking Elevator",i,"Info [ Map:","\""..MapElevator.."\"",", Player Joined:",PlayersElevator,"]")
                            local MapTableName = MapElevator..":"..ModeElevator
                            local MapTable = MapGlobal[MapTableName]
                            if MapTable and TimerElevator > 5 and PlayersElevator < 4 then
                                if MapTable.Solo and PlayersElevator ~= 0 then
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

                                ElevatorEnter:InvokeServer(v["Object"])
                                UI.JoiningStatus.Text = "Joined Elevator: " ..tostring(i)
                                prints("Joined Elevator",i)

                                local LoadoutInfo = StratXLibrary.Strat[MapIndex].Loadout.Lists[#StratXLibrary.Strat[MapIndex].Loadout.Lists]
                                LoadoutInfo.AllowEquip = true
                                LoadoutInfo.SkipCheck = true
                                print("Loadout Selecting")
                                Functions.Loadout(StratXLibrary.Strat[MapIndex],LoadoutInfo)

                                MapGlobal.ConnectionEvent = v:GetAttribute("Timer").Changed:Connect(function()
                                    local MapTableName = MapElevator..":"..ModeElevator
                                    UI.MapFind.Text = "Map: "..MapElevator
                                    UI.CurrentPlayer.Text = "Player Joined: "..PlayersElevator
                                    UI.TimerLeft.Text = "Time Left: "..tostring(TimerElevator)
                                    prints("Time Left: ",TimerElevator)
                                    --Scenario: Player Died
                                    if not (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")) then
                                        print("Event Disconnected 3")
                                        MapGlobal.ConnectionEvent:Disconnect()
                                        UI.JoiningStatus.Text = "Player Died. Rejoining Elevator"
                                        prints("Player Died. Rejoining Elevator")
                                        ElevatorLeave:InvokeServer()
                                        UI.TimerLeft.Text = "Time Left: NaN"
                                        repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
                                        MapGlobal.JoiningCheck = false
                                        return
                                    end
                                    if TimerElevator > 0 and (not MapGlobal[MapTableName] or (MapGlobal[MapTableName].Solo and PlayersElevator > 1)) then
                                        print("Event Disconnected 1")
                                        MapGlobal.ConnectionEvent:Disconnect()
                                        local Text = (not MapGlobal[MapTableName] and "Map Has Been Changed") or ((MapGlobal[MapTableName].Solo and PlayersElevator > 1) and "Someone Has Joined") or "Error"
                                        ElevatorLeave:InvokeServer()
                                        UI.JoiningStatus.Text = Text..", Leaving Elevator "..tostring(i)
                                        prints(Text..", Leaving Elevator",i,"Map:","\""..MapElevator.."\"",", Player Joined:",PlayersElevator)
                                        UI.TimerLeft.Text = "Time Left: NaN"
                                        MapGlobal.JoiningCheck = false
                                        return
                                    end
                                    if TimerElevator == 0 then
                                        print("Event Disconnected 2")
                                        MapGlobal.ConnectionEvent:Disconnect()
                                        UI.JoiningStatus.Text = "Teleporting To Match"
                                        task.wait(60)
                                        UI.JoiningStatus.Text = "Rejoining Elevator"
                                        prints("Rejoining Elevator")
                                        ElevatorLeave:InvokeServer()
                                        UI.TimerLeft.Text = "Time Left: NaN"
                                        MapGlobal.JoiningCheck = false
                                        return
                                    end
                                    ElevatorEnter:InvokeServer(v["Object"])
                                end)
                                repeat task.wait() until MapGlobal.JoiningCheck == false
                            end
                            task.wait(.2)
                        end
                        ElevatorSettings[Name].JoinMap = true
                    end)
                end
                task.wait()
            end
        end
    end)
end