if getgenv().StratXLibrary and getgenv().StratXLibrary.Executed then
    if StratXLibrary.Strat[#StratXLibrary.Strat].Active then
        return Strat.new()
    else
        return StratXLibrary.Strat[#StratXLibrary.Strat]
    end
end
getgenv().IsPlayerInGroup = IsPlayerInGroup --From StratLoader
local Success
task.spawn(function()
    if IsPlayerInGroup then
        return
    end
    repeat task.wait() until game:GetService("Players").LocalPlayer
    Success = pcall(function()
        getgenv().IsPlayerInGroup = game:GetService("Players").LocalPlayer:IsInGroup(4914494)
    end)
end)
writefile("StratLoader/UserLogs/PrintLog.txt", "")

local LoadLocal = false
local MainLink = LoadLocal and "" or "https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/"

getgenv().StratXLibrary = {Functions = {}}
getgenv().StratXLibrary.ExecutedCount = 0
getgenv().Functions = StratXLibrary.Functions
StratXLibrary["TowersContained"] = {}
getgenv().TowersContained = StratXLibrary["TowersContained"]
StratXLibrary["ActionInfo"] = {
    ["Place"] = {0,0},
    ["Upgrade"] = {0,0},
    ["Sell"] = {0,0},
    ["Skip"] = {0,0},
    ["Ability"] = {0,0},
    ["Target"] = {0,0},
    ["AutoChain"] = {0,0},
    ["SellAllFarms"] = {0,0}, 
}
StratXLibrary.UI = {}
--StratXLibrary.MultiStratEnabled = getgenv().IsMultiStrat or false
--[[StratXLibrary.MultiStratEnabled = true
getgenv().GameSpoof = "Lobby"
StratXLibrary.Strat = {}]]

if not StratXLibrary.UtilitiesConfig then
    StratXLibrary.UtilitiesConfig = {  
        Camera = tonumber(getgenv().DefaultCam) or 2,
        LowGraphics = getgenv().PotatoPC or false,
        BypassGroup = false,
        AutoBuyMissing = false,
        AutoPickups = false,
        RestartMatch = true,
        Webhook = {
            Enabled = false,
            Link = (isfile("TDS_AutoStrat/Webhook (Logs).txt") and readfile("TDS_AutoStrat/Webhook (Logs).txt")) or "",
            HideUser = false,
            UseNewFormat = false,
            PlayerInfo = true,
            GameInfo = true,
            TroopsInfo = true,
            DisableCustomLog = true,
        },
    }
end

if not game:IsLoaded() then
    game["Loaded"]:Wait()
end
local SpoofEvent = {}
if GameSpoof then
    function SpoofEvent:InvokeServer(...)
        print("InvokeServer",...)
    end
    function SpoofEvent:FireServer(...)
        print("FireServer",...)
    end
end
local Version = "Version: 0.3.1 [Alpha]"
local Items = {
    Enabled = false,
    Name = "Cookie"
}
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = Workspace.CurrentCamera
local OldCameraOcclusionMode = LocalPlayer.DevCameraOcclusionMode
local UILibrary = getgenv().UILibrary or loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/ROBLOX/main/ModificationWallyUi", true))()
UILibrary.options.toggledisplay = 'Fill'
UI = StratXLibrary.UI
UtilitiesConfig = StratXLibrary.UtilitiesConfig
local Patcher = loadstring(game:HttpGet(MainLink.."TDS/ConvertFunc.lua", true))()--loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/ConvertFunc.lua", true))()

function ParametersPatch(FuncsName,...)
    if type(...) == "table" and #{...} == 1 then --select("#",...)
        return ...
    end
    local GetFuncName = FuncsName --debug.getinfo(4,"n").name
    if StratXLibrary.Functions[GetFuncName] and Patcher[GetFuncName] then
        return Patcher[GetFuncName](...)
    else
        return {...}
    end
end

loadstring(game:HttpGet(MainLink.."ConsoleLibrary.lua", true))()
loadstring(game:HttpGet(MainLink.."TDS/JoinLessServer.lua", true))()

function prints(...)
    local TableText = {...}
    for i,v in next, TableText do
        if type(v) ~= "string" then
            TableText[i] = tostring(v)
        end
    end
    local Text = table.concat(TableText, " ")
    --appendfile("StratLoader/UserLogs/PrintLog.txt", Text.."\n")
    --print(Text)
    ConsoleInfo(Text)
end
getgenv().output = function(Text,Color)
    ConsolePrint(Color,"Info",Text)
end

if isfile("StratLoader/UserConfig/UtilitiesConfig.txt") then
    UtilitiesConfig = cloneref(game:GetService("HttpService")):JSONDecode(readfile("StratLoader/UserConfig/UtilitiesConfig.txt"))
    if tonumber(getgenv().DefaultCam) and tonumber(getgenv().DefaultCam) <= 3 and tonumber(getgenv().DefaultCam) ~= UtilitiesConfig.Camera then
        UtilitiesConfig.Camera = tonumber(getgenv().DefaultCam)
    end
    if getgenv().PotatoPC then
        UtilitiesConfig.LowGraphics = true
    end
else
    writefile("StratLoader/UserConfig/UtilitiesConfig.txt",cloneref(game:GetService("HttpService")):JSONEncode(UtilitiesConfig))
end
ConsolePrint("WHITE","Table",UtilitiesConfig)

function SaveUtilitiesConfig()
    local UtilitiesTab = UI.UtilitiesTab
    local WebSetting = UI.WebSetting
    StratXLibrary.UtilitiesConfig = {
        Camera = tonumber(getgenv().DefaultCam) or 2,
        LowGraphics = UtilitiesTab.flags.LowGraphics,
        BypassGroup = UtilitiesTab.flags.BypassGroup,
        AutoBuyMissing = UtilitiesTab.flags.AutoBuyMissing,
        AutoPickups = UtilitiesConfig.AutoPickups or UtilitiesTab.flags.AutoPickups,
        RestartMatch = UtilitiesTab.flags.RestartMatch,
        Webhook = {
            Enabled = WebSetting.flags.Enabled or false,
            UseNewFormat = WebSetting.flags.UseNewFormat or false,
            Link = (#WebSetting.flags.Link ~= 0 and WebSetting.flags.Link) or (isfile("TDS_AutoStrat/Webhook (Logs).txt") and readfile("TDS_AutoStrat/Webhook (Logs).txt")) or "",
            HideUser = WebSetting.flags.HideUser or false,
            PlayerInfo = WebSetting.flags.PlayerInfo or true,
            GameInfo = WebSetting.flags.GameInfo or true,
            TroopsInfo = WebSetting.flags.TroopsInfo or true,
            DisableCustomLog = WebSetting.flags.DisableCustomLog or true,
        },
    }
    UtilitiesConfig = StratXLibrary.UtilitiesConfig
    writefile("StratLoader/UserConfig/UtilitiesConfig.txt",cloneref(game:GetService("HttpService")):JSONEncode(UtilitiesConfig))
end

function CheckPlace()
    return if not GameSpoof then (game.PlaceId == 5591597781) else if GameSpoof == "Ingame" then true else false
end

loadstring(game:HttpGet(MainLink.."TDS/LowGraphics.lua", true))()

local GameInfo
getgenv().GetGameInfo = function()
    if not CheckPlace() then
        return
    end
    if GameInfo then
        return GameInfo
    end
    repeat
        for i,v in next, ReplicatedStorage.StateReplicators:GetChildren() do
            if v:GetAttribute("TimeScale") then
                GameInfo = v
                return v
            end
        end
        task.wait()
    until GameInfo
end
local VoteState
getgenv().GetVoteState = function()
    if not CheckPlace() then
        return
    end
    if VoteState then
        return VoteState
    end
    repeat
        for i,v in next, ReplicatedStorage.StateReplicators:GetChildren() do
            if v:GetAttribute("MaxVotes") then
                VoteState = v
                return v
            end
        end
        task.wait()
    until VoteState
end
local TimerCheck = false
function CheckTimer(bool)
    return (bool and TimerCheck) or true
end
function TimePrecise(Number)
    --return math.round((math.ceil(Number) - Number)*1000)/1000 --more the decimal, long wait
    return Number - math.floor(Number) - 0.13 --more the decimal, less wait, wtf is this mathematic
end
function TotalSec(Minute,Second)
    return (Minute*60) + math.ceil(Second)
end
function TowersCheckHandler(...)
    for i,v in next, {...} do
        local Id = tonumber(v) or 0
        local SkipTowerCheck
        if not (TowersContained[Id] and typeof(TowersContained[Id].Instance) == "Instance") then
            task.delay(25,function() --game has wave 0 now so increase it to make it works
                SkipTowerCheck = true
            end)
            if not TowersContained[Id] then
                ConsoleWarn(`Tower Index: {Id} Hasn't Created Yet`)
                repeat task.wait() until TowersContained[Id] or SkipTowerCheck
            end
            if TowersContained[Id].Placed == false and not SkipTowerCheck then
                ConsoleWarn(`Tower Index: {Id}, Type: \"{TowersContained[Id].TowerName}\" Hasn't Been Placed Yet. Waiting It To Be Placed`)
                repeat task.wait() until (TowersContained[Id].Instance and TowersContained[Id].Placed) or SkipTowerCheck
            end
            if SkipTowerCheck then
                ConsoleWarn(`Can't Find Tower Index: {Id}. Maybe Its Arguments Have Been Wrong?`)
            end
        end
    end
end

function GetTypeIndex(string,Id)
    if (type(string) ~= "string" or (type(string) == "string" and #string == 0)) then
        return TowersContained[Id].TypeIndex
    end
    return string
end

function TimeWaveWait(Wave,Min,Sec,InWave,Debug)
    if Debug or GetGameInfo():GetAttribute("Wave") > Wave then
        return
    end
    repeat 
        task.wait() 
    until tonumber(GetGameInfo():GetAttribute("Wave")) == Wave and CheckTimer(InWave)
    if ReplicatedStorage.State.Timer.Time.Value - TotalSec(Min,Sec) < -1 then
        return
    end
    local Timer = 0
    repeat 
        task.wait()
        Timer = math.abs(ReplicatedStorage.State.Timer.Time.Value - TotalSec(Min,Sec))
    until Timer <= 1
    --until (ReplicatedStorage.State.Timer.Time.Value + 1 == TotalSec(Min,Sec) or ReplicatedStorage.State.Timer.Time.Value == TotalSec(Min,Sec)) --CheckTimer will return true when in wave and false when not in wave
    task.wait(TimePrecise(Sec))
end

function SetActionInfo(String,Type)
    task.spawn(function()
        local ActionInfoTable = StratXLibrary["ActionInfo"]
        local Current = ActionInfoTable[String][1]
        local Total = ActionInfoTable[String][2]
        local Type = Type or "Current"
        if Type == "Total" then
            Total += 1
            ActionInfoTable[String][2] = Total
        else
            Current += 1
            ActionInfoTable[String][1] = Current
        end
        if Total == 1 then
            if not UI.ActInfo then
                repeat task.wait() until UI.ActInfo
            end
            if not ActionInfoTable[String][3] then
                ActionInfoTable[String][3] = UI.ActInfo:Section(`{String} : 0 / 1`)
            end
        elseif Total > 1 and not ActionInfoTable[String][3] then
            repeat task.wait() until ActionInfoTable[String][3]
        end
        ActionInfoTable[String][3].Text = `{String} : {Current}/{Total}`
    end)
end

--Main Ui Setup
local maintab = UILibrary:CreateWindow("Strategies X")
prints("Checking Group")
getgenv().BypassGroup = false
if not (UtilitiesConfig.BypassGroup or IsPlayerInGroup) then
    repeat task.wait() until Success ~= nil
    if not Success then
        maintab:Section("Checking Group Failed")
        prints("Checking Group Failed")
        maintab:Button("I Already Joined It", function()
            getgenv().BypassGroup = true
        end)
    end
    --[[if IsPlayerInGroup == nil then
        task.spawn(function()
            repeat task.wait() until Success ~= nil
            if not Success then
                maintab:Section("Checking Group Failed")
                prints("Checking Group Failed")
                maintab:Button("I Already Joined It", function()
                    getgenv().BypassGroup = true
                end)
            end
        end)
    end]]
    if not IsPlayerInGroup then
        if CheckPlace() then
            maintab:Section("WARN Extra Money Not Actived")
            maintab:Section("Strat May Broken Due To This")
        else
            maintab:Section("You Need To Join")
            maintab:Section("Paradoxum Games Group")
            local JoinButton = maintab:DropSection("Join The Group")
            JoinButton:Button("Copy Link Group", function()
                setclipboard("https://www.roblox.com/groups/4914494/Paradoxum-Games")
            end)
            JoinButton:Button("Yes, I Just Joined It", function()
                getgenv().BypassGroup = true
            end)
        end
        task.spawn(function()
            repeat
                task.wait()
                Success = pcall(function()
                    IsPlayerInGroup = game:GetService("Players").LocalPlayer:IsInGroup(4914494)
                end)
            until IsPlayerInGroup ~= nil or getgenv().BypassGroup or UtilitiesConfig.BypassGroup
        end)
        repeat 
            task.wait()
        until IsPlayerInGroup ~= nil or getgenv().BypassGroup or UtilitiesConfig.BypassGroup
    end
end
if UtilitiesConfig.BypassGroup then
    prints("Bypassed Group Checking")
else
    prints("Checking Group Completed")
end
maintab:Section(Version)
maintab:Section(`Current Place: {CheckPlace() and "Ingame" or "Lobby"}`)

UI.UtilitiesTab = UILibrary:CreateWindow("Utilities")
local UtilitiesTab = UI.UtilitiesTab

--InGame Core
if CheckPlace() then
    if #Players:GetChildren() > 1 and getgenv().Multiplayer["Enabled"] == false then
        TeleportService:Teleport(3260590327, LocalPlayer)
    end
    --Disable Auto Skip Feature
    local AutoSkipCheck = (LocalPlayer.PlayerGui.RoactUniversal.Settings.window.scrollingFrame.Unknown["Auto Skip"].button.toggle.content.textLabel.Text == "Enabled")
    if AutoSkipCheck then
        RemoteFunction:InvokeServer("Settings","Update","Auto Skip",false)
    end
    --Check if InWave or not
    StratXLibrary.TimerConnection = ReplicatedStorage.StateReplicators.ChildAdded:Connect(function(object)
        if object:GetAttribute("Duration") and object:GetAttribute("Duration") == 5 then
            TimerCheck = true
        elseif object:GetAttribute("Duration") and object:GetAttribute("Duration") > 5 then
            TimerCheck = false
        end
    end)
    
    task.spawn(function()
        --repeat task.wait() until Workspace.Map:FindFirstChild("Environment"):FindFirstChild("SpawnLocation")
        local Part = Instance.new("Part")
        Part.Size = Vector3.new(10, 2, 10)
        Part.CFrame = CFrame.new(0, 30, 0) --Workspace.Map.Environment:FindFirstChild("SpawnLocation").CFrame + Vector3.new(0, 30, 0)
        Part.Anchored = true
        Part.CanCollide = true
        Part.Transparency = 1
        Part.Parent = Workspace
        Part.Name = "PlatformPart"
        StratXLibrary.PlatformPart = Part

        local OutlineBox = Instance.new("SelectionBox")
        OutlineBox.Parent = Part
        OutlineBox.Adornee = Part
        OutlineBox.LineThickness = 0.05

        repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
        LocalPlayer.Character.Humanoid.PlatformStand = true
        LocalPlayer.Character.HumanoidRootPart.Anchored = true
        LocalPlayer.Character.HumanoidRootPart.CFrame = Part.CFrame + Vector3.new(0, 3.5, 0)
    end)
    task.spawn(function()
        loadstring(game:HttpGet(MainLink.."TDS/FreeCam.lua", true))()

        local ModeSection = maintab:Section("Mode: Voting")
        task.spawn(function()
            repeat task.wait() until GetGameInfo():GetAttribute("Difficulty")
            ModeSection.Text = `Mode: {GetGameInfo():GetAttribute("Difficulty")}`
        end)
        maintab:Section(`Map: {ReplicatedStorage.State.Map.Value}`)
        maintab:Section("Tower Info:")
        StratXLibrary.TowerInfo = {}
        for i,v in next, RemoteFunction:InvokeServer("Session","Search","Inventory.Troops") do
            if v.Equipped then
                StratXLibrary.TowerInfo[i] = {maintab:Section(i.." : 0"), 0, i}
            end
        end
        UI.ActInfo = maintab:DropSection("Actions Info")

        if UtilitiesConfig.Camera == 1 then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
            CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            CurrentCamera.CameraType = "Follow"
        elseif UtilitiesConfig.Camera == 2 then
            LocalPlayer.Character.Humanoid.PlatformStand = true
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
            LocalPlayer.DevCameraOcclusionMode = "Invisicam"
            CurrentCamera.CameraType = "Follow"
        end

        repeat task.wait() until Workspace:FindFirstChild("NPCs")
        task.spawn(function()
            while true do
                for i,v in next, Workspace.NPCs:GetChildren() do
                    if UtilitiesConfig.Camera ~= 2 then
                        repeat wait() until UtilitiesConfig.Camera == 2
                    end
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("HumanoidRootPart").CFrame.Y > -5 then
                        if not v.RootPointer.Value.Parent then  --Clean model that's no longer used by game
                            v:Destroy()
                            continue
                        end
                        repeat
                            if UtilitiesConfig.Camera == 2 then
                                CurrentCamera.CameraSubject = v:FindFirstChild("HumanoidRootPart")
                            end
                            task.wait() 
                        until not (v:FindFirstChild("HumanoidRootPart") and v.RootPointer.Value.Parent)
                    end
                    --CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
                end
                task.wait(.5)
            end
        end) 
        --End Of Match
        --StratXLibrary.RestartCount = 1
        StratXLibrary.SignalEndMatch = GetGameInfo():GetAttributeChangedSignal("GameOver"):Connect(function()
            prints("Match Ended")
            task.wait(.5)
            if not GetGameInfo():GetAttribute("GameOver") then --true/false like Value,but not check this Attribute exists
                return
            end
            if not type(GetGameInfo():GetAttribute("Won")) == "boolean" then
                repeat task.wait() until type(GetGameInfo():GetAttribute("Won")) == "boolean"
                task.wait(1.3)
            end
            if UtilitiesConfig.RestartMatch and GetGameInfo():GetAttribute("Won") == false then --StratXLibrary.RestartCount <= UtilitiesConfig.RestartTimes
            prints("Match Lose And Restart")
                ReplicatedStorage.RemoteFunction:InvokeServer("Voting", "Skip")
                StratXLibrary["TowersContained"] = {}
                StratXLibrary["ActionInfo"] = {
                    ["Place"] = {0,0},
                    ["Upgrade"] = {0,0},
                    ["Sell"] = {0,0},
                    ["Skip"] = {0,0},
                    ["Ability"] = {0,0},
                    ["Target"] = {0,0},
                    ["AutoChain"] = {0,0},
                    ["SellAllFarms"] = {0,0}, 
                }
                for i,v in next, StratXLibrary.TowerInfo do
                    v[2] = 0
                end
                for i,v in next, StratXLibrary.Strat[StratXLibrary.Strat.ChosenID] do
                    if type(v) == "table" and v.ListNum and type(v.ListNum) == "number" then
                        task.delay(3, function()
                            v.ListNum = 1 
                        end)
                    end
                end
                --prints("RestartCount",StratXLibrary.RestartCount)
            else
                --prints("Stopped Restart Match After",StratXLibrary.RestartCount)
                prints("Match Won")
                if AutoSkipCheck then
                    RemoteFunction:InvokeServer("Settings","Update","Auto Skip",true)
                end
                task.wait(1)
                if UtilitiesConfig.Webhook.Enabled then
                    task.wait(1.3)
                    loadstring(game:HttpGet(MainLink.."TDS/Webhook.lua", true))()--loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/Webhook.lua", true))()
                    prints("Sent Webhook Log")
                end
                if not StratXLibrary.RejoinLobby then
                    repeat task.wait() until StratXLibrary.RejoinLobby
                end
                task.wait(.5)
                if type(FeatureConfig) == "table" and FeatureConfig["JoinLessFeature"].Enabled then
                    return
                end
                prints("Rejoining To Lobby")
                TeleportHandler(3260590327,2,7)
                --TeleportService:Teleport(3260590327)
                --StratXLibrary.SignalEndMatch:Disconnect()
            end
            --StratXLibrary.RestartCount += 1
        end)
    end)
    function DebugTower(Object) --Rework in Future
        repeat task.wait() until tonumber(Object.Name)
        local GuiInstance = Instance.new("BillboardGui")
        GuiInstance.Parent = Object:WaitForChild("HumanoidRootPart")
        GuiInstance.Adornee = Object:WaitForChild("HumanoidRootPart")
        GuiInstance.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
        GuiInstance.Size = UDim2.new(0, 250, 0, 50)
        GuiInstance.AlwaysOnTop = true
        local Text1 = Instance.new("TextLabel")
        Text1.Parent = GuiInstance
        Text1.BackgroundTransparency = 1
        Text1.Text = Object.Name
        Text1.Font = "Legacy"
        Text1.Size = UDim2.new(1, 0, 0, 70)
        Text1.TextSize = 32
        Text1.TextScaled = false
        Text1.TextColor3 = Color3.new(0, 0, 0)
        Text1.TextStrokeColor3 = Color3.new(0, 0, 0)
        Text1.TextStrokeTransparency = 0.5
        local Text2 = Instance.new("TextLabel")
        Text2.Parent = GuiInstance
        Text2.BackgroundTransparency = 1
        Text2.Text = Object.Name
        Text2.Font = "Legacy"
        Text2.Size = UDim2.new(1, 0, 0, 70)
        Text2.TextSize = 30
        Text2.TextScaled = false
        Text2.TextColor3 = Color3.new(1, 0, 0)
        Text2.TextStrokeColor3 = Color3.new(0, 0, 0)
        Text2.TextStrokeTransparency = 0.5
    end
end

--UI Setup
--getgenv().PlayersSection = {}
if not CheckPlace() then
    RemoteFunction:InvokeServer("Login", "Claim")
    RemoteFunction:InvokeServer("Session", "Search", "Login")

    UI.EquipStatus = maintab:DropSection("Troops Loadout: Broken")
    UI.TowersStatus = {
        [1] = UI.EquipStatus:Section("Empty"),
        [2] = UI.EquipStatus:Section("Empty"),
        [3] = UI.EquipStatus:Section("Empty"),
        [4] = UI.EquipStatus:Section("Empty"),
        [5] = UI.EquipStatus:Section("Empty"),
    }
    maintab:Section("Elevator Status:")
    UI.JoiningStatus = maintab:Section("Trying Elevator: 0")
    UI.TimerLeft = maintab:Section("Time Left: NaN")
    UI.MapFind = maintab:Section("Map: ")
    UI.CurrentPlayer = maintab:Section("Player Joined: 0")

    --[[task.spawn(function()
        repeat task.wait(.3)
        until getgenv().StratCreditsAuthor ~= nil
        local multitab = UtilitiesTab:DropSection("Multiplayer: Off")
        if getgenv().Mulitplayer.Enabled then
            multitab:SetText("Multiplayer: On")
            multitab:Section("Host:"..Players:GetNameFromUserIdAsync(getgenv().Mulitplayer.Host))
            for i =1, getgenv().Mulitplayer.Players do
                getgenv().PlayersSection[v] = multitab:Section("")
            end
        end
    end)]]
end

if CheckPlace() then
    UtilitiesTab:Section("Game Settings")
    UtilitiesTab:Toggle("Rejoin Lobby After Match",{default = true, location = StratXLibrary, flag = "RejoinLobby"})
    UtilitiesTab:Button("Teleport Back To Platform",function()
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = StratXLibrary.PlatformPart.CFrame +  Vector3.new(0, 3.3, 0)
    end)
    if Items.Enabled then
        UtilitiesTab:Toggle("Auto Pick Items[EVENT]",{default = UtilitiesConfig.AutoPickups or false, flag = "AutoPickups"})
    end
    local CamSetting = UtilitiesTab:DropSection("Camera Settings")
    CamSetting:Button("Normal Camera",function()
        getgenv().DefaultCam = 1
        SaveUtilitiesConfig()
        LocalPlayer.Character.Humanoid.PlatformStand = false
        LocalPlayer.Character.HumanoidRootPart.Anchored = false
        CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        CurrentCamera.CameraType = "Follow"
        LocalPlayer.DevCameraOcclusionMode = OldCameraOcclusionMode
    end)
    CamSetting:Button("Follow Enemies",function()
        getgenv().DefaultCam = 2
        SaveUtilitiesConfig()
        LocalPlayer.Character.Humanoid.PlatformStand = true
        LocalPlayer.Character.HumanoidRootPart.Anchored = true
        LocalPlayer.DevCameraOcclusionMode = "Invisicam"
        CurrentCamera.CameraType = "Follow"
    end)
    CamSetting:Button("Free Camera",function()
        getgenv().DefaultCam = 3
        SaveUtilitiesConfig()
        LocalPlayer.Character.HumanoidRootPart.Anchored = true
        LocalPlayer.Character.Humanoid.PlatformStand = true
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        LocalPlayer.DevCameraOcclusionMode = OldCameraOcclusionMode
    end)
    if Items.Enabled then
        task.spawn(function()
            local Pickups = Workspace.Pickups
            while true do            
                for Index, Object in next, Pickups:GetChildren() do
                    if UtilitiesConfig.AutoPickups and Object:IsA("MeshPart") and string.find(Object.Name:lower(),Items.Name:lower()) and Object.CFrame.Y < 200 then
                        if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        end
                        repeat
                            game:GetService("TweenService"):Create(LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(.5, Enum.EasingStyle.Linear), {CFrame = Object.CFrame}):Play() 
                            task.wait(.5)
                        until Object.CFrame.Y >= 200 or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    end
                end
                if getgenv().DefaultCam ~= 1 then
                    game:GetService("TweenService"):Create(LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(0, Enum.EasingStyle.Linear), {CFrame = StratXLibrary.PlatformPart.CFrame +  Vector3.new(0, 3.3, 0)}):Play()
                    task.wait(.1)
                end
                task.wait()
            end
        end)
    end
end

UI.WebSetting = UtilitiesTab:DropSection("Webhook Settings")
local WebSetting = UI.WebSetting
WebSetting:Toggle("Enabled",{default = UtilitiesConfig.Webhook.Enabled or false, flag = "Enabled"})
WebSetting:Toggle("Use New Format",{default = UtilitiesConfig.Webhook.UseNewFormat or false, flag = "UseNewFormat"})
WebSetting:Section("Webhook Link:                             ")
WebSetting:TypeBox("Webhook Link",{default = UtilitiesConfig.Webhook.Link, cleartext = false, flag = "Link"})
if getgenv().FeatureConfig and getgenv().FeatureConfig.CustomLog then
    WebSetting:Toggle("Disable SL's Custom Log",{default = UtilitiesConfig.Webhook.DisableCustomLog or false, flag = "DisableCustomLog"})
end
WebSetting:Toggle("Hide Username",{default = UtilitiesConfig.Webhook.HideUser or false, flag = "HideUser"})
WebSetting:Toggle("Player Info",{default = UtilitiesConfig.Webhook.PlayerInfo or false, flag = "PlayerInfo"})
WebSetting:Toggle("Game Info",{default = UtilitiesConfig.Webhook.GameInfo or false, flag = "GameInfo"})
WebSetting:Toggle("Troops Info",{default = UtilitiesConfig.Webhook.TroopsInfo or false, flag = "TroopsInfo"})

UtilitiesTab:Section("Universal Settings")
UtilitiesTab:Toggle("Low Graphics Mode",{default = UtilitiesConfig.LowGraphics or false ,flag = "LowGraphics"}, function(bool) 
    StratXLibrary.LowGraphics(bool)
end)
UtilitiesTab:Toggle("Bypass Group Checking",{default = UtilitiesConfig.BypassGroup or false, flag = "BypassGroup"})
UtilitiesTab:Toggle("Auto Buy Missing Tower",{default = UtilitiesConfig.AutoBuyMissing or false, flag = "AutoBuyMissing"})
UtilitiesTab:Toggle("Auto Restart When Lose", {flag = "RestartMatch", default = UtilitiesConfig.RestartMatch})
UtilitiesTab:Button("Rejoin To Lobby",function()
    task.wait()
    TeleportHandler(3260590327,2,7)
    --TeleportService:Teleport(3260590327)
end)
task.spawn(function()
    repeat task.wait(.3)
    until getgenv().StratCreditsAuthor ~= nil
    local multitab = UtilitiesTab:DropSection("Multiplayer: Off")
    if getgenv().Mulitplayer.Enabled then
        multitab:SetText("Multiplayer: On")
        multitab:Section("Host:"..Players:GetNameFromUserIdAsync(getgenv().Mulitplayer.Host))
        for i =1, getgenv().Mulitplayer.Players do
            getgenv().PlayersSection[v] = multitab:Section("")
        end
    end
    if (type(getgenv().StratCreditsAuthor) == "string" and #getgenv().StratCreditsAuthor > 0) or type(getgenv().StratCreditsAuthor) == "number" then
        UtilitiesTab:Section("==Strat Creators==")
        UtilitiesTab:Section(tostring(getgenv().StratCreditsAuthor))
    elseif type(getgenv().StratCreditsAuthor) == "table" then
        for i,v in next, getgenv().StratCreditsAuthor do
            if (type(v) == "string" and #v > 0) or type(v) == "number" then
                UtilitiesTab:Section(tostring(v))
            end
        end
    end
end)


Functions.Map = loadstring(game:HttpGet(MainLink.."TDS/Functions/Map.lua", true))()
Functions.Loadout = loadstring(game:HttpGet(MainLink.."TDS/Functions/Loadout.lua", true))()
Functions.Mode = loadstring(game:HttpGet(MainLink.."TDS/Functions/Mode.lua", true))()
Functions.Place = loadstring(game:HttpGet(MainLink.."TDS/Functions/Place.lua", true))()
Functions.Upgrade = loadstring(game:HttpGet(MainLink.."TDS/Functions/Upgrade.lua", true))()
Functions.Sell = loadstring(game:HttpGet(MainLink.."TDS/Functions/Sell.lua", true))()
Functions.Skip = loadstring(game:HttpGet(MainLink.."TDS/Functions/Skip.lua", true))()
Functions.Ability = loadstring(game:HttpGet(MainLink.."TDS/Functions/Ability.lua", true))()
Functions.Target = loadstring(game:HttpGet(MainLink.."TDS/Functions/Target.lua", true))()
Functions.AutoChain = loadstring(game:HttpGet(MainLink.."TDS/Functions/AutoChain.lua", true))()
Functions.SellAllFarms = loadstring(game:HttpGet(MainLink.."TDS/Functions/SellAllFarms.lua", true))()

Functions.MatchMaking = function()
    local MapProps,Index
    repeat
        task.wait()
        for i,v in ipairs(StratXLibrary.Strat) do
            if v.Map.Lists[#v.Map.Lists] and v.Map.Lists[#v.Map.Lists].Mode == "Survival" and not MapProps then-- string.find(i:lower(),"survival")
                MapProps = v.Map.Lists[#v.Map.Lists]
                Index = i
            end
        end
    until MapProps
    RemoteFunction:InvokeServer("LobbyVoting", "Override", MapProps.Map)
    RemoteEvent:FireServer("LobbyVoting", "Vote", MapProps.Map, LocalPlayer.Character.HumanoidRootPart.Position)
    RemoteEvent:FireServer("LobbyVoting","Ready")
    task.wait(6)
    ConsoleInfo(`Map Selected: {ReplicatedStorage.State.Map.Value}, Mode: {MapProps.Mode}, Solo Only: {MapProps.Solo}`)
    StratXLibrary.Strat.ChosenID = Index
end

local GetConnects = getconnections or get_signal_cons
if GetConnects then
    for i,v in next, GetConnects(LocalPlayer.Idled) do
        if v["Disable"] then
            v["Disable"](v)
        elseif v["Disconnect"] then
            v["Disconnect"](v)
        end
    end
end
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(object)
    if object.Name == "ErrorPrompt" and object:FindFirstChild("MessageArea") and object.MessageArea:FindFirstChild("ErrorFrame") then
        TeleportService:Teleport(3260590327, LocalPlayer)
    end
end)

task.spawn(function()
    while true do
        SaveUtilitiesConfig()
        task.wait(1)
    end
end)

StratXLibrary.Strat = {}
StratXLibrary.Executed = true
StratXLibrary.Global = {Map = {}}
StratXLibrary.__index = StratXLibrary

getgenv().Strat = {Lib = StratXLibrary}
Strat.__index = Strat;

function Strat.new()
    local t = setmetatable({}, Strat)
    for Funcname, Functable in next, StratXLibrary.Functions do
        t[Funcname] = {
            name = Funcname,
            --InQueue = {},
            --Loaded = {},
            Lists = {}
        }
        setmetatable(t[Funcname], {
            __call = function(self,...) --self is Functions, ...[1] is parent of self
                local tableinfo = (select(1,...) == t) and (select(2,...) == StratXLibrary and {select(3,...)} or {select(2,...)}) or {...}
                table.insert(t[Funcname].Lists, ParametersPatch(Funcname,unpack(tableinfo)))
                t.Active = true
                --print(t[Funcname].Lists,#t[Funcname].Lists)
            end
        })
    end
    table.insert(StratXLibrary.Strat, t)
    t.Index = #StratXLibrary.Strat
    return t
end
task.spawn(function()
    local StratsListNum = 1
    while not CheckPlace() do
        task.wait()
        if not StratXLibrary.Strat[StratsListNum] then
            continue
        end
        local Strat = StratXLibrary.Strat[StratsListNum]
        for i,v in next, Functions do
            task.spawn(function()
                if not Strat[i] then
                    repeat task.wait() until Strat[i]
                end
                local ListNum = 1
                while true do
                    if ListNum > #Strat[i].Lists then
                        repeat task.wait() until ListNum <= #Strat[i].Lists
                    end
                    if not Strat[i].Lists[ListNum] then 
                        ListNum += 1 
                        continue
                    end
                    Functions[i](Strat,Strat[i].Lists[ListNum])
                    ListNum += 1
                    task.wait()
                end
            end)
        end
        StratsListNum += 1
    end
    if Matchmaking then
        Functions.MatchMaking()
    end
    --print("ID1",StratXLibrary.Strat.ChosenID)
    if not StratXLibrary.Strat.ChosenID then
        repeat
            task.wait()
            for i,v in ipairs(StratXLibrary.Strat) do
                if v.Map.Lists[#v.Map.Lists] and v.Map.Lists[#v.Map.Lists].Map == ReplicatedStorage.State.Map.Value and not StratXLibrary.Strat.ChosenID then -- not apply same map dfferent mode
                    StratXLibrary.Strat.ChosenID = i
                end
            end
        until StratXLibrary.Strat.ChosenID
    end
    prints("Strat ID",StratXLibrary.Strat.ChosenID)
    local Strat = StratXLibrary.Strat[StratXLibrary.Strat.ChosenID]
    for i,v in next, Functions do
        task.spawn(function()
            if not Strat[i] then
                repeat task.wait() until Strat[i]
            end
            Strat[i].ListNum = 1
            while true do
                if Strat[i].ListNum > #Strat[i].Lists then
                    repeat task.wait() until Strat[i].ListNum <= #Strat[i].Lists
                end
                if not Strat[i].Lists[Strat[i].ListNum] then 
                    Strat[i].ListNum += 1 
                    continue
                end
                Functions[i](Strat,Strat[i].Lists[Strat[i].ListNum])
                Strat[i].ListNum += 1
                task.wait()
            end
        end)
    end
    while true do
        task.wait()
        if GetVoteState():GetAttribute("Title") == "Ready?" then --Hardcore/Event Solo
            RemoteFunction:InvokeServer("Voting", "Skip")
            break
        end
    end
end)
prints("Loaded Library")
return Strat.new()
