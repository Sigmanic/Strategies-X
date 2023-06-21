if getgenv().StratXLibrary and getgenv().StratXLibrary.Executed then return getgenv().StratXLibrary end
getgenv().IsPlayerInGroup = getgenv().IsPlayerInGroup
local Success
task.spawn(function()
    if IsPlayerInGroup then
        return
    end
    repeat task.wait() until game:GetService("Players").LocalPlayer
    local Success = pcall(function()
        IsPlayerInGroup = game:GetService("Players").LocalPlayer:IsInGroup(4914494)
    end)
end)
if not game:IsLoaded() then
    game['Loaded']:Wait()
end
writefile("StratLoader/UserLogs/PrintLog.txt", "")
getgenv().StratXLibrary = {}

if not StratXLibrary.UtilitiesConfig then
    StratXLibrary.UtilitiesConfig = {
        Camera = tonumber(getgenv().DefaultCam) or 2,
        LowGraphics = getgenv().PotatoPC or false,
        BypassGroup = false,
        Webhook = {
            Enabled = false,
            Link = (isfile("TDS_AutoStrat/Webhook (Logs).txt") and readfile("TDS_AutoStrat/Webhook (Logs).txt")) or "",
            HideUser = false,
            PlayerInfo = true,
            GameInfo = true,
            TroopsInfo = true,
            DisableCustomLog = true,
        },
    }
end

local Version = "Version: 0.2.4 [Alpha]"
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunction")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
local Lighting = game:GetService("Lighting")
local UILibrary = getgenv().UILibrary or loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/ROBLOX/main/ModificationWallyUi", true))()
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
local UI = StratXLibrary.UI
local UtilitiesConfig = StratXLibrary.UtilitiesConfig

--loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/ConvertFunc.lua", true))()
local Patcher = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/ConvertFunc.lua", true))()
function ParametersPatch(name,...)
    if type(...) == "table" and select("#",...) == 1 then
        return ...
    end
    return Patcher[name](...)
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/ConsoleLibrary.lua", true))()

function prints(...)
    local TableText = {...}
    for i,v in next, TableText do
        if type(v) ~= "string" then
            TableText[i] = tostring(v)
        end
    end
    local Text = table.concat(TableText, " ")
    appendfile("StratLoader/UserLogs/PrintLog.txt", Text.."\n")
    print(Text)
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

getgenv().MinimizeClient = getgenv().MinimizeClient or function(boolean)
    local boolean = boolean or (boolean == nil and true)
    if not getgenv().FirstTime then
        getgenv().FirstTime = {
            GlobalShadow = Lighting.GlobalShadows,
            PhysicsThrottle = settings().Physics.PhysicsEnvironmentalThrottle,
            OldQuality = settings():GetService("RenderSettings").QualityLevel,
            TechLight = gethiddenproperty(Lighting, "Technology"),
        }
    end
    if boolean then
        pcall(function()
            setfpscap(10)
        end)
        settings():GetService("RenderSettings").QualityLevel = Enum.QualityLevel.Level01
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
        if sethiddenproperty then
            sethiddenproperty(Lighting, "Technology",Enum.Technology.Compatibility)
        end
        Lighting.GlobalShadows = boolean
    else
        pcall(function()
            setfpscap(60)
        end)
        settings():GetService("RenderSettings").QualityLevel = getgenv().FirstTime.OldQuality
        settings().Physics.PhysicsEnvironmentalThrottle = getgenv().FirstTime.PhysicsThrottle
        if sethiddenproperty then
            sethiddenproperty(Lighting, "Technology", getgenv().FirstTime.TechLight)
        end
        Lighting.GlobalShadows = getgenv().FirstTime.GlobalShadow
    end
    game:GetService("RunService"):Set3dRenderingEnabled(not boolean)
    for i,v in next, Lighting:GetChildren() do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") and v.Enabled ~= not boolean then
            v.Enabled = not boolean
        end
    end
end

function CheckPlace()
    return (game.PlaceId == 5591597781)
end

local Folder = Instance.new("Folder")
Folder.Parent = ReplicatedStorage
Folder.Name = "Map"
StratXLibrary.LowGraphics = function(bool)
    if bool then
        repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
        LocalPlayer.Character.Humanoid.PlatformStand = true
        LocalPlayer.Character.HumanoidRootPart.Anchored = true
        if CheckPlace() then
            for i,v in next, Workspace.Map:GetChildren() do
                if v.Name ~= "Paths" then
                    v.Parent = Folder
                end
            end
        else
            for i,v in next, Workspace.Lobby:GetChildren() do
                v.Parent = Folder
            end
        end
    else
        if not (CheckPlace() and getgenv().DefaultCam ~= 1) then
            repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
            LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
        for i,v in next, Folder:GetChildren() do
            v.Parent = Workspace[CheckPlace() and "Map" or "Lobby"]
        end
    end
    MinimizeClient(bool)
    prints((bool and "Enabled" or "Disabled").." Low Graphics Mode")
end

function SaveUtilitiesConfig()
    local UtilitiesTab = UI.UtilitiesTab
    local WebSetting = UI.WebSetting
    StratXLibrary.UtilitiesConfig = {
        Camera = tonumber(getgenv().DefaultCam) or 2,
        LowGraphics = UtilitiesTab.flags.LowGraphics,
        BypassGroup = UtilitiesTab.flags.BypassGroup,
        Webhook = {
            Enabled = WebSetting.flags.Enabled or false,
            Link = (isfile("TDS_AutoStrat/Webhook (Logs).txt") and readfile("TDS_AutoStrat/Webhook (Logs).txt")) or "",
            HideUser = WebSetting.flags.HideUser or false,
            PlayerInfo = WebSetting.flags.PlayerInfo or true,
            GameInfo = WebSetting.flags.GameInfo or true,
            TroopsInfo = WebSetting.flags.TroopsInfo or true,
            DisableCustomLog = WebSetting.flags.DisableCustomLog or true,
        },
    }
    UtilitiesConfig = StratXLibrary.UtilitiesConfig
    writefile("StratLoader/UserConfig/UtilitiesConfig.txt",cloneref(game:GetService("HttpService")):JSONEncode(StratXLibrary.UtilitiesConfig))
end

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
local TimerCheck,TimerConnection = false
function CheckTimer(bool)
    return (bool and TimerCheck) or true
end
function TimePrecise(Number)
    --return math.round((math.ceil(Number) - Number)*1000)/1000
    return Number - math.floor(Number)
end
function TotalSec(Minute,Second)
    return (Minute*60) + math.ceil(Second)
end
function TowersCheckHandler(...)
    for i,v in next, {...} do
        local Id = tonumber(v) or 0
        local SkipTowerCheck
        if not (TowersContained[Id] and typeof(TowersContained[Id].Instance) == "Instance") then
            task.spawn(function()
                task.wait(15)
                SkipTowerCheck = true
            end)
            if not TowersContained[Id] then
                ConsoleWarn("Tower Index: "..Id.." Hasn't Created Yet")
                repeat task.wait() until TowersContained[Id] or SkipTowerCheck
            end
            if TowersContained[Id].Placed == false and not SkipTowerCheck then
                ConsoleWarn("Tower Index: "..Id.." Hasn't Been Placed Yet. Waiting It To Be Placed")
                repeat task.wait() until (TowersContained[Id].Instance and TowersContained[Id].Placed) or SkipTowerCheck
            end
            if SkipTowerCheck then
                ConsoleWarn("Can't Find Tower Index: "..Id)
            end
        --[[else
            ConsoleInfo("Tower Index: "..Id.." Existed")]]
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
    if Debug then
        return
    end
    repeat 
        task.wait() 
    until tonumber(GetGameInfo():GetAttribute("Wave")) == Wave and CheckTimer(InWave)
    repeat 
        task.wait()
    until (ReplicatedStorage.State.Timer.Time.Value + 1 == TotalSec(Min,Sec) or ReplicatedStorage.State.Timer.Time.Value == TotalSec(Min,Sec)) --CheckTimer will return true when in wave and false when not in wave
    task.wait(TimePrecise(Sec))
end

local maintab = UILibrary:CreateWindow("Strategies X")
prints("Checking Group")
getgenv().BypassGroup = false
if not ((IsPlayerInGroup and CheckPlace()) or UtilitiesConfig.BypassGroup) then
    if IsPlayerInGroup == nil then
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
        repeat task.wait() until IsPlayerInGroup ~= nil or getgenv().BypassGroup or UtilitiesConfig.BypassGroup
        if getgenv().BypassGroup or UtilitiesConfig.BypassGroup then
            return
        end
    end
    if not IsPlayerInGroup then
        maintab:Section("You Need To Join")
        maintab:Section("Paradoxum Games Group")
        local JoinButton = maintab:DropSection("Join The Group")
        JoinButton:Button("Copy Link Group", function()
            setclipboard("https://www.roblox.com/groups/4914494/Paradoxum-Games")
        end)
        JoinButton:Button("Yes, I Just Joined It", function()
            getgenv().BypassGroup = true
        end)
        repeat task.wait() until getgenv().BypassGroup or UtilitiesConfig.BypassGroup
    end
end
if UtilitiesConfig.BypassGroup then
    prints("Bypassed Group Checking")
else
    prints("Checking Group Completed")
end
maintab:Section(Version)
maintab:Section("Current Place: "..(CheckPlace() and "Ingame" or "Lobby"))

local CountNum = 0
if CheckPlace() then
    if #Players:GetChildren() > 1 and getgenv().Multiplayer["Enabled"] == false then
        game:GetService("TeleportService"):Teleport(3260590327, LocalPlayer)
    end
    --[[Workspace.Towers.ChildAdded:Connect(function(Tower)
        if not Tower:FindFirstChild("Replicator") then
            repeat task.wait() until Tower:FindFirstChild("Replicator")
        end
        if Tower:FindFirstChild("Owner").Value and Tower:FindFirstChild("Owner").Value == LocalPlayer.UserId then
            task.spawn(function()
                CountNum += 1
                getgenv().TowerInfo[Tower.Replicator:GetAttribute("Type")][2] += 1
                Tower.Name = CountNum
                Tower:SetAttribute("TypeIndex", Tower.Replicator:GetAttribute("Type").." "..tostring(getgenv().TowerInfo[Tower.Replicator:GetAttribute("Type")][2]))
                getgenv().TowerInfo[Tower.Replicator:GetAttribute("Type")][1].Text = Tower.Replicator:GetAttribute("Type").." : "..tostring(getgenv().TowerInfo[Tower.Replicator:GetAttribute("Type")][2])
                TowersContained[CountNum] = {
                    ["Instance"] = Tower,
                    ["TypeIndex"] = Tower:GetAttribute("TypeIndex"),
                    ["Target"] = "First",
                    ["Upgrade"] = 0,
                }
                if getgenv().Debug then
                    task.spawn(DebugTower,Tower)
                end
            end)
        end
    end)]]
    TimerConnection = ReplicatedStorage.StateReplicators.ChildAdded:Connect(function(object)
        if object:GetAttribute("Duration") and object:GetAttribute("Duration") == 5 then
            TimerCheck = true
        elseif object:GetAttribute("Duration") and object:GetAttribute("Duration") > 5 then
            TimerCheck = false
        end
    end)

    UI.UtilitiesTab = UILibrary:CreateWindow("Utilities")
    local UtilitiesTab = UI.UtilitiesTab
    UtilitiesTab:Toggle("Rejoin Lobby After Match",{default = true, location = StratXLibrary, flag = "RejoinLobby"})

    task.spawn(function()
        repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")

        local Part = Instance.new("Part")
        Part.Size = Vector3.new(10, 2, 10)
        Part.CFrame = LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame + Vector3.new(0, 30, 0)
        Part.Anchored = true
        Part.CanCollide = true
        Part.Transparency = 1
        Part.Parent = Workspace

        local OutlineBox = Instance.new("SelectionBox")
        OutlineBox.Parent = Part
        OutlineBox.Adornee = Part
        OutlineBox.LineThickness = 0.05

        LocalPlayer.Character.Humanoid.PlatformStand = true
        LocalPlayer.Character.HumanoidRootPart.Anchored = true
        LocalPlayer.Character.HumanoidRootPart.CFrame = Part.CFrame + Vector3.new(0, 3.5, 0)
        local UserInputService = game:GetService("UserInputService")
        local Mouse = LocalPlayer:GetMouse()
        local Camera = Workspace.CurrentCamera
        Camera.CameraType = Enum.CameraType.Scriptable
        local FOV = Camera.FieldOfView
        local movePosition = Vector2.new(0, 0)
        local moveDirection = Vector3.new(0, 0, 0)
        local targetMovePosition = movePosition
        local lastRightButtonDown = Vector2.new(0, 0)
        local rightMouseButtonDown,sprinting = false,false
        local keysDown,moveKeys = {}, {
            [Enum.KeyCode.D] = Vector3.new(1, 0, 0),
            [Enum.KeyCode.A] = Vector3.new(-1, 0, 0),
            [Enum.KeyCode.S] = Vector3.new(0, 0, 1),
            [Enum.KeyCode.W] = Vector3.new(0, 0, -1),
            [Enum.KeyCode.E] = Vector3.new(0, 1, 0),
            [Enum.KeyCode.Q] = Vector3.new(0, -1, 0)
        }
        function Tween(Value,Time)
            pcall(function()
                if Value == Camera.FieldOfView then
                    return
                end
                game:GetService("TweenService"):Create(Camera, TweenInfo.new(Time, Enum.EasingStyle.Linear), {FieldOfView = Value}):Play() 
                task.wait(Time)
            end)
        end
        UserInputService.InputChanged:connect(function(Y)
            if Y.UserInputType == Enum.UserInputType.MouseMovement then
                movePosition = movePosition + Vector2.new(Y.Delta.x, Y.Delta.y)
            end
        end)
        function CalculateMovement()
            local Z = Vector3.new(0, 0, 0)
            for h, b in pairs(keysDown) do
                Z = Z + (moveKeys[h] or Vector3.new(0, 0, 0))
            end
            return Z
        end
        function Input(InputTyped)
            if moveKeys[InputTyped.KeyCode] then
                if InputTyped.UserInputState == Enum.UserInputState.Begin then
                    keysDown[InputTyped.KeyCode] = true
                elseif InputTyped.UserInputState == Enum.UserInputState.End then
                    keysDown[InputTyped.KeyCode] = nil
                end
            else
                if InputTyped.UserInputState == Enum.UserInputState.Begin then
                    if InputTyped.UserInputType == Enum.UserInputType.MouseButton2 and UtilitiesConfig.Camera == 3 then
                        rightMouseButtonDown = true
                        lastRightButtonDown = Vector2.new(Mouse.X, Mouse.Y)
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                    elseif InputTyped.KeyCode == Enum.KeyCode.Z then
                        FOV = 20
                    elseif InputTyped.KeyCode == Enum.KeyCode.LeftShift then
                        sprinting = true
                    end
                else
                    if InputTyped.UserInputType == Enum.UserInputType.MouseButton2 then
                        rightMouseButtonDown = false
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    elseif InputTyped.KeyCode == Enum.KeyCode.Z then
                        FOV = 70
                    elseif InputTyped.KeyCode == Enum.KeyCode.LeftShift then
                        sprinting = false
                    end
                end
            end
        end
        Mouse.WheelForward:connect(function()
            Camera.CoordinateFrame = Camera.CoordinateFrame * CFrame.new(0, 0, -5)
        end)
        Mouse.WheelBackward:connect(function()
            Camera.CoordinateFrame = Camera.CoordinateFrame * CFrame.new(-0, 0, 5)
        end)
        UserInputService.InputBegan:connect(Input)
        UserInputService.InputEnded:connect(Input)
        game:GetService("RunService").RenderStepped:Connect(function()
            if UtilitiesConfig.Camera == 3 then
                targetMovePosition = movePosition
                Camera.CoordinateFrame =CFrame.new(Camera.CoordinateFrame.p) *CFrame.fromEulerAnglesYXZ(-targetMovePosition.Y / 300,-targetMovePosition.X / 300,0) *CFrame.new(CalculateMovement() * (({[true] = 3})[sprinting] or .5))
                Tween(FOV,.1)
                if rightMouseButtonDown then
                    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                    movePosition = movePosition - (lastRightButtonDown - Vector2.new(Mouse.X, Mouse.Y))
                    lastRightButtonDown = Vector2.new(Mouse.X, Mouse.Y)
                end
            end
        end)

        UtilitiesTab:Button("Teleport Back To Platform",function()
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Part.CFrame +  Vector3.new(0, 3.5, 0)
        end)
        
        UI.WebSetting = UtilitiesTab:DropSection("Webhook Settings")
        local WebSetting = UI.WebSetting
        WebSetting:Toggle("Enabled",{default = UtilitiesConfig.Webhook.Enabled or false, flag = "Enabled"})
        if getgenv().FeatureConfig and getgenv().FeatureConfig.CustomLog then
            WebSetting:Toggle("Disable SL's Custom Log",{default = UtilitiesConfig.Webhook.DisableCustomLog or false, flag = "DisableCustomLog"})
        end
        WebSetting:Toggle("Hide Username",{default = UtilitiesConfig.Webhook.HideUser or false, flag = "HideUser"})
        WebSetting:Toggle("Player Info",{default = UtilitiesConfig.Webhook.PlayerInfo or false, flag = "PlayerInfo"})
        WebSetting:Toggle("Game Info",{default = UtilitiesConfig.Webhook.GameInfo or false, flag = "GameInfo"})
        WebSetting:Toggle("Troops Info",{default = UtilitiesConfig.Webhook.TroopsInfo or false, flag = "TroopsInfo"})

        local ModeSection = maintab:Section("Mode: Voting")
        task.spawn(function()
            repeat task.wait() until GetGameInfo():GetAttribute("Difficulty")
            ModeSection.Text = "Mode: "..GetGameInfo():GetAttribute("Difficulty")
        end)
        maintab:Section("Map: "..ReplicatedStorage.State.Map.Value)
        maintab:Section("Tower Info:")
        StratXLibrary.TowerInfo = {}
        for i,v in next, RemoteFunction:InvokeServer("Session","Search","Inventory.Troops") do
            if v.Equipped then
                StratXLibrary.TowerInfo[i] = {maintab:Section(i.." : 0"), 0, i}
            end
        end
        UI.ActInfo = maintab:DropSection("Actions Info")

        local OldCameraOcclusionMode = LocalPlayer.DevCameraOcclusionMode
        if UtilitiesConfig.Camera == 1 then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
            Camera.CameraType = "Follow"
        elseif UtilitiesConfig.Camera == 2 then
            LocalPlayer.Character.Humanoid.PlatformStand = true
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
            LocalPlayer.DevCameraOcclusionMode = "Invisicam"
            Camera.CameraType = "Follow"
        end
        
        local CamSetting = UtilitiesTab:DropSection("Camera Settings")
        CamSetting:Button("Normal Camera",function()
            getgenv().DefaultCam = 1
            SaveUtilitiesConfig()
            LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
            Camera.CameraType = "Follow"
            LocalPlayer.DevCameraOcclusionMode = OldCameraOcclusionMode
        end)
        CamSetting:Button("Follow Enemies",function()
            getgenv().DefaultCam = 2
            SaveUtilitiesConfig()
            LocalPlayer.Character.Humanoid.PlatformStand = true
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
            LocalPlayer.DevCameraOcclusionMode = "Invisicam"
            Camera.CameraType = "Follow"
        end)
        CamSetting:Button("Free Camera",function()
            getgenv().DefaultCam = 3
            SaveUtilitiesConfig()
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
            LocalPlayer.Character.Humanoid.PlatformStand = true
            Camera.CameraType = Enum.CameraType.Scriptable
            LocalPlayer.DevCameraOcclusionMode = OldCameraOcclusionMode
        end)

        UtilitiesTab:Toggle("Low Graphics Mode",{default = UtilitiesConfig.LowGraphics or false ,flag = "LowGraphics"}, function(bool) 
            StratXLibrary.LowGraphics(bool)
        end)

        UtilitiesTab:Toggle("Bypass Group Checking",{default = UtilitiesConfig.BypassGroup or false, flag = "BypassGroup"})
        UtilitiesTab:Button("Teleport Back To Lobby",function()
            task.wait(.5)
            game:GetService("TeleportService"):Teleport(3260590327)
        end)
        task.spawn(function()
            while true do
                SaveUtilitiesConfig()
                task.wait(1)
            end
        end)

        task.spawn(function()
            repeat task.wait(.3)
            until getgenv().StratCreditsAuthor ~= nil
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

        repeat wait() until Workspace:FindFirstChild("NPCs")
        task.spawn(function()
            while true do
                for i,v in next, Workspace.NPCs:GetChildren() do
                    if UtilitiesConfig.Camera ~= 2 then
                        repeat wait() until UtilitiesConfig.Camera == 2
                    end
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("HumanoidRootPart").CFrame.Y > -5 then
                        repeat
                            if UtilitiesConfig.Camera == 2 then
                                Camera.CameraSubject = v:FindFirstChild("HumanoidRootPart")
                            end
                            task.wait() 
                        until not v:FindFirstChild("HumanoidRootPart")
                    --[[else
                        Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")]]
                    end
                end
                task.wait(.5)
            end
        end) 

        local MatchGui = LocalPlayer.PlayerGui.RoactGame.Rewards.content.gameOver
        MatchGui:GetPropertyChangedSignal("Visible"):Connect(function()
            prints("Match Ended")
            task.wait(1)
            if UtilitiesConfig.Webhook.Enabled then
                task.wait(1.3)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/Webhook.lua", true))()
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
            game:GetService("TeleportService"):Teleport(3260590327)
        end)
    end)
    function DebugTower(Object)
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
        Text1.TextSize = 52
        Text1.TextScaled = fals
        Text1.TextColor3 = Color3.new(0, 0, 0)
        Text1.TextStrokeColor3 = Color3.new(0, 0, 0)
        Text1.TextStrokeTransparency = 0.5
        local Text2 = Instance.new("TextLabel")
        Text2.Parent = GuiInstance
        Text2.BackgroundTransparency = 1
        Text2.Text = Object.Name
        Text2.Font = "Legacy"
        Text2.Size = UDim2.new(1, 0, 0, 70)
        Text2.TextSize = 50
        Text2.TextScaled = false
        Text2.TextColor3 = Color3.new(1, 0, 0)
        Text2.TextStrokeColor3 = Color3.new(0, 0, 0)
        Text2.TextStrokeTransparency = 0.5
    end
end
getgenv().PlayersSection = {}
if not CheckPlace() then
    RemoteFunction:InvokeServer("Login", "Claim")
    RemoteFunction:InvokeServer("Session", "Search", "Login")

    UI.EquipStatus = maintab:DropSection("Troops Loadout: Loading")
    UI.TowersStatus = {
        [1] = UI.EquipStatus:Section("Empty"),
        [2] = UI.EquipStatus:Section("Empty"),
        [3] = UI.EquipStatus:Section("Empty"),
        [4] = UI.EquipStatus:Section("Empty"),
        [5] = UI.EquipStatus:Section("Empty"),
    }
    maintab:Section("Elevator Status:")
    UI.JoiningStatus = maintab:Section("Trying Elevator: 0")
    UI.TimerLeft = maintab:Section("Time Left: 20")
    UI.MapFind = maintab:Section("Map: ")
    UI.CurrentPlayer = maintab:Section("Player Joined: 0")

    UI.UtilitiesTab = UILibrary:CreateWindow("Utilities")
    local UtilitiesTab = UI.UtilitiesTab
    UI.WebSetting = UtilitiesTab:DropSection("Webhook Settings")
    local WebSetting = UI.WebSetting
    WebSetting:Toggle("Enabled",{default = UtilitiesConfig.Webhook.Enabled or false, flag = "Enabled"})
    if getgenv().FeatureConfig and getgenv().FeatureConfig.CustomLog then
        WebSetting:Toggle("Disable SL's Custom Log",{default = UtilitiesConfig.Webhook.DisableCustomLog or false, flag = "DisableCustomLog"})
    end
    WebSetting:Toggle("Hide Username",{default = UtilitiesConfig.Webhook.HideUser or false, flag = "HideUser"})
    WebSetting:Toggle("Player Info",{default = UtilitiesConfig.Webhook.PlayerInfo or false, flag = "PlayerInfo"})
    WebSetting:Toggle("Game Info",{default = UtilitiesConfig.Webhook.GameInfo or false, flag = "GameInfo"})
    WebSetting:Toggle("Troops Info",{default = UtilitiesConfig.Webhook.TroopsInfo or false, flag = "TroopsInfo"})

    UtilitiesTab:Toggle("Low Graphics Mode",{default = UtilitiesConfig.LowGraphics or false ,flag = "LowGraphics"}, function(bool) 
        StratXLibrary.LowGraphics(bool)
    end)

    UtilitiesTab:Toggle("Bypass Group Checking",{default = UtilitiesConfig.BypassGroup or false, flag = "BypassGroup"})

    task.spawn(function()
        while true do
            SaveUtilitiesConfig()
            task.wait(1)
        end
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
end

function StratXLibrary:Map(...)
    local tableinfo = ParametersPatch("Map",...)
    local Map = tableinfo["Map"]
    local Solo = tableinfo["Solo"]
    local Mode = tableinfo["Mode"]
    repeat task.wait() until LocalPlayer:FindFirstChild("Level")
    if Mode == "Hardcore" and LocalPlayer.Level.Value < 50 then
        LocalPlayer:Kick("This User Doesn't Have Require Level > 50")
    end
    task.spawn(function()
        if CheckPlace() then
            if not table.find(Map, ReplicatedStorage.State.Map.Value) then
                game:GetService("TeleportService"):Teleport(3260590327, LocalPlayer)
                return
            end
            ConsoleInfo("Map Selected: "..ReplicatedStorage.State.Map.Value..", ".."Mode: "..Mode..", ".."Solo Only: "..tostring(Solo))
            return
        end
        if getgenv().IsMultiStrat then
            return
        end
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
            --[[for i,v in next, Elevators do
                if v["MapName"].Value ~= name and v["Playing"].Value == 0 and not JoiningCheck then
                    prints("Changing Elavator",i)
                    RemoteFunction:InvokeServer("Elevators", "Enter", v["Object"])
                    task.wait(.9)
                    RemoteFunction:InvokeServer("Elevators", "Leave")
                end
            end
            task.wait(WaitTime)]]
        end
    end)
end

function StratXLibrary:Loadout(...)
    if getgenv().IsMultiStrat then 
        return 
    end
    local tableinfo = ParametersPatch("Loadout",...)
    local TotalTowers = tableinfo["TotalTowers"]
    local TroopsOwned = RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops")
    if CheckPlace() then
        for i,v in next, TroopsOwned do
            if v.Equipped and not table.find(TotalTowers, i) then
                game:GetService("TeleportService"):Teleport(3260590327, LocalPlayer)
                return
            end
        end
        ConsoleInfo("Loadout Selected: \""..table.concat(TotalTowers, "\", \"").."\"")
        return
    end
    UI.EquipStatus:SetText("Troops Loadout: Equipping")

    local Text = ""
    for i,v in next, TotalTowers do
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

function StratXLibrary:Mode(Name)
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        local Mode
        repeat
            Mode = RemoteFunction:InvokeServer("Difficulty", "Vote", Name)
            wait() 
        until Mode
        ConsoleInfo("Mode Selected: "..Name)
    end)
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
                ActionInfoTable[String][3] = UI.ActInfo:Section(String.." : 0 / 1")
            end
        elseif Total > 1 and not ActionInfoTable[String][3] then
            repeat task.wait() until ActionInfoTable[String][3]
        end
        ActionInfoTable[String][3].Text = String.." : "..tostring(Current).." / "..tostring(Total)
    end)
end

function StratXLibrary:Place(...)
    local tableinfo = ParametersPatch("Place",...)
    local Tower = tableinfo["Type"]
    local Position = tableinfo["Position"] or Vector3.new(0,0,0)
    local Rotation = tableinfo["Rotation"] or CFrame.new(0,0,0)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("Place","Total")
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        CountNum += 1
        local TempNum = CountNum
        TowersContained[TempNum] = {
            ["Placed"] = false,
        }
        local CheckPlaced
        repeat
            CheckPlaced = RemoteFunction:InvokeServer("Troops","Place",Tower,{
                ["Position"] = Position,
                ["Rotation"] = Rotation
            })
            wait()
        until typeof(CheckPlaced) == "Instance" --return instance
        CheckPlaced.Name = TempNum
        local TowerTable = StratXLibrary.TowerInfo[Tower]
        TowerTable[2] += 1
        CheckPlaced:SetAttribute("TypeIndex", Tower.." "..tostring(TowerTable[2]))
        TowerTable[1].Text = Tower.." : "..tostring(TowerTable[2])
        TowersContained[TempNum] = {
            ["Instance"] = CheckPlaced,
            ["TypeIndex"] = CheckPlaced:GetAttribute("TypeIndex"),
            ["Target"] = "First",
            ["Upgrade"] = 0,
            ["Placed"] = true,
        }
        if getgenv().Debug then
            task.spawn(DebugTower,TowersContained[TempNum].Instance)
        end
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],TempNum)
        SetActionInfo("Place")
        ConsoleInfo("Placed "..Tower.." Index: "..CheckPlaced.Name..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end
--[[{
    ["TowerIndex"] = ""
    ["TypeIndex"] = "",
    ["UpgradeTo"] = number,
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
function StratXLibrary:Upgrade(...)
    local tableinfo = ParametersPatch("Upgrade",...)
    local Tower = tableinfo["TowerIndex"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("Upgrade","Total")
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        local SkipCheck = false
        task.spawn(function()
            task.wait(15)
            SkipCheck = true
        end)
        local CheckUpgraded
        TowersCheckHandler(Tower)
        repeat
            pcall(function()
                CheckUpgraded = RemoteFunction:InvokeServer("Troops","Upgrade","Set",{
                    ["Troop"] = TowersContained[Tower].Instance
                })
                wait()
            end)
        until CheckUpgraded or SkipCheck
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        if SkipCheck and not CheckUpgraded then
            ConsoleError("Failed To Upgrade Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..") CheckUpgraded: "..tostring(CheckUpgraded)..", CheckUpgraded: "..tostring(SkipCheck))
            return
        end
        SetActionInfo("Upgrade")
        ConsoleInfo("Upgraded Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..") CheckUpgraded: "..tostring(CheckUpgraded)..", CheckUpgraded: "..tostring(SkipCheck))
    end)
end

--[[{
    ["TowerIndex"] = "",
    ["TypeIndex"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
function StratXLibrary:Sell(...)
    local tableinfo = ParametersPatch("Sell",...)
    local Tower = tableinfo["TowerIndex"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    for i = 1, #Tower do
        SetActionInfo("Sell","Total")
    end
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"])
        TowersCheckHandler(unpack(Tower))
        for i,v in next, Tower do
            task.spawn(function()
                local CheckSold
                repeat
                    CheckSold = RemoteFunction:InvokeServer("Troops","Sell",{
                        ["Troop"] = TowersContained[v].Instance
                    })
                    wait()
                until CheckSold
                local TowerType = GetTypeIndex(tableinfo["TypeIndex"],v)
                SetActionInfo("Sell")
                ConsoleInfo("Sold Tower Index: "..v..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
            end)
        end
    end)
end

--[[{
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
function StratXLibrary:Skip(...)
    local tableinfo = ParametersPatch("Skip",...)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("Skip","Total")
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        RemoteFunction:InvokeServer("Waves", "Skip")
        SetActionInfo("Skip")
        ConsoleInfo("Skipped Wave "..Wave.." (Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end

--[[{
    ["TowerIndex"] = "",
    ["TypeIndex"] = "",
    ["Ability"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
function StratXLibrary:Ability(...)
    local tableinfo = ParametersPatch("Ability",...)
    local Tower = tableinfo["TowerIndex"]
    local Ability = tableinfo["Ability"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("Ability","Total")
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        TowersCheckHandler(Tower)
        RemoteFunction:InvokeServer("Troops","Abilities","Activate",{
            ["Troop"] = TowersContained[Tower].Instance, 
            ["Name"] = Ability
        })
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        SetActionInfo("Ability")
        ConsoleInfo("Used Ability On Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end

--[[{
    ["TowerIndex"] = "",
    ["TypeIndex"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
    ["Target"] = string,
}]]
function StratXLibrary:Target(...)
    local tableinfo = ParametersPatch("Target",...)
    local Tower = tableinfo["TowerIndex"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    local Target = tableinfo["Target"]
    if not CheckPlace() then
        return
    end
    SetActionInfo("Target","Total")
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        TowersCheckHandler(Tower)
        RemoteFunction:InvokeServer("Troops","Target","Set",{
            ["Troop"] = TowersContained[Tower].Instance,
            ["Target"] = Target,
        })
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        SetActionInfo("Target")
        ConsoleInfo("Changed Target To: "..Target..", Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end

local function Chain(Tower)
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

--[[{
    ["TowerIndex1"] = "",
    ["TowerIndex2"] = "",
    ["TowerIndex3"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
function StratXLibrary:AutoChain(...)
    local tableinfo = ParametersPatch("AutoChain",...)
    local Tower1,Tower2,Tower3 = tableinfo["TowerIndex1"], tableinfo["TowerIndex2"], tableinfo["TowerIndex3"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("AutoChain","Total")
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        TowersCheckHandler(Tower1,Tower2,Tower3)
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
                ConsoleInfo("Disbaled AutoChain For Towers Index: "..Tower1..", "..Tower2..", "..Tower3)
                break
            end
            Chain(Tower1)
            if not TowersContained[Tower2].Instance then
                ConsoleInfo("Disbaled AutoChain For Towers Index: "..Tower1..", "..Tower2..", "..Tower3)
                break
            end
            Chain(Tower2)
            if not TowersContained[Tower3].Instance then
                ConsoleInfo("Disbaled AutoChain For Towers Index: "..Tower1..", "..Tower2..", "..Tower3)
                break
            end
            Chain(Tower3)
            task.wait()
        end
    end)
end

function StratXLibrary:SellAllFarms(...)
    local tableinfo = ParametersPatch("SellAllFarms",...)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    SetActionInfo("SellAllFarms","Total")
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        for i,v in next, Workspace.Towers:GetChildren() do
            if v:FindFirstChild("Owner").Value == LocalPlayer.UserId and v.Replicator:GetAttribute("Type") == "Farm" then 
                RemoteFunction:InvokeServer("Troops","Sell",{
                    ["Troop"] = v
                })
            end
        end
        SetActionInfo("SellAllFarms")
    end)
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
        game:GetService("TeleportService"):Teleport(3260590327, LocalPlayer)
    end
end)
prints("Loaded Library")
getgenv().StratXLibrary.Executed = true
return StratXLibrary
