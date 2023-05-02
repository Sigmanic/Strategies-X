getgenv().ASLibrary = {}
if getgenv().Executed then return getgenv().ASLibrary end
local IsPlayerInGroup = IsPlayerInGroup
task.spawn(function()
    if IsPlayerInGroup then
        return
    end
    repeat task.wait() until game:GetService("Players").LocalPlayer
    IsPlayerInGroup = game:GetService("Players").LocalPlayer:IsInGroup(4914494)
end)
if not game:IsLoaded() then
    game['Loaded']:Wait()
end
writefile("StratLoader/UserLogs/PrintLog.txt", "")
getgenv().UtilitiesConfig = {
    Camera = tonumber(getgenv().DefaultCam) or 2,
    LowGraphics = getgenv().PotatoPC or false,
    Webhook = {
        Enabled = false,
        Link = readfile("TDS_AutoStrat/Webhook (Logs).txt") or "",
        HideUser = false,
        PlayerInfo = true,
        GameInfo = true,
        TroopsInfo = true,
        DisableCustomLog = true,
    },
}

local Version = "Version: 0.1.5 [Alpha]"
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunction")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

local UILibrary
if getgenv().UILibrary and type(getgenv().UILibrary) == "table" then
    UILibrary = getgenv().UILibrary
else
    UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/ROBLOX/main/ModificationWallyUi", true))()
end
--loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/ConvertFunc.lua", true))()
local Patcher = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/ConvertFunc.lua", true))()
function ParametersPatch(name,...)
    if type(...) == "table" then
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

getgenv().output = function(...)
    prints(...)
end
if isfile("StratLoader/UserConfig/UtilitiesConfig.txt") then
    getgenv().UtilitiesConfig = cloneref(game:GetService("HttpService")):JSONDecode(readfile("StratLoader/UserConfig/UtilitiesConfig.txt"))
    if tonumber(getgenv().DefaultCam) and tonumber(getgenv().DefaultCam) <= 3 and tonumber(getgenv().DefaultCam) ~= getgenv().UtilitiesConfig.Camera then
        getgenv().UtilitiesConfig.Camera = tonumber(getgenv().DefaultCam)
    end
else
    writefile("StratLoader/UserConfig/UtilitiesConfig.txt",cloneref(game:GetService("HttpService")):JSONEncode(getgenv().UtilitiesConfig))
end
ConsolePrint("WHITE","Table",UtilitiesConfig)

getgenv().MinimizeClient = getgenv().MinimizeClient or function(boolean)
    local boolean = boolean or (boolean == nil and true)
    if not getgenv().FirstTime then
        getgenv().FirstTime = {
            GlobalShadow = game:GetService("Lighting").GlobalShadows,
            PhysicsThrottle = settings().Physics.PhysicsEnvironmentalThrottle,
            OldQuality = settings():GetService("RenderSettings").QualityLevel,
            TechLight = gethiddenproperty(game:GetService("Lighting"), "Technology"),
        }
    end
    if boolean then
        pcall(function()
            setfpscap(10)
        end)
        settings():GetService("RenderSettings").QualityLevel = Enum.QualityLevel.Level01
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
        if sethiddenproperty then
            sethiddenproperty(game:GetService("Lighting"), "Technology",Enum.Technology.Compatibility)
        end
        game:GetService("Lighting").GlobalShadows = boolean
    else
        pcall(function()
            setfpscap(60)
        end)
        settings():GetService("RenderSettings").QualityLevel = getgenv().FirstTime.OldQuality
        settings().Physics.PhysicsEnvironmentalThrottle = getgenv().FirstTime.PhysicsThrottle
        if sethiddenproperty then
            sethiddenproperty(game:GetService("Lighting"), "Technology", getgenv().FirstTime.TechLight)
        end
        game:GetService("Lighting").GlobalShadows = getgenv().FirstTime.GlobalShadow
    end
    game:GetService("RunService"):Set3dRenderingEnabled(not boolean)
    for i,v in next, game:GetService("Lighting"):GetChildren() do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") and v.Enabled ~= not boolean then
            v.Enabled = not boolean
        end
    end
end

function CheckPlace()
    return (game.PlaceId == 5591597781)
end

--repeat wait() until game:IsLoaded()

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
    return math.round((math.ceil(Number) - Number)*1000)/1000
end
function TotalSec(Minute,Second)
    return (Minute*60) + math.ceil(Second)
end

function GetTypeIndex(string,Tower)
    if (type(string) ~= "string" or (type(string) == "string" and #string == 0)) then
        if typeof(Tower) == "Instance" and type(Tower:GetAttribute("TypeIndex")) == "string" then
            return Tower:GetAttribute("TypeIndex")
        elseif type(Workspace.Towers:WaitForChild(Tower):GetAttribute("TypeIndex")) == "string" then
            return Workspace.Towers:WaitForChild(Tower):GetAttribute("TypeIndex")
        end
    end
    return string
end

function TimeWaveWait(Wave,Min,Sec,InWave)
    repeat 
        task.wait()
    until tonumber(GetGameInfo():GetAttribute("Wave")) == Wave and 
    (ReplicatedStorage.State.Timer.Time.Value + 1 == TotalSec(Min,Sec) or ReplicatedStorage.State.Timer.Time.Value == TotalSec(Min,Sec)) and CheckTimer(InWave) --CheckTimer will return true when in wave and false when not in wave
    task.wait(TimePrecise(Sec))
end
local CountNum = 0
local maintab = UILibrary:CreateWindow("Strategies X")
--maintab:Section("==Modded Version==")
prints("Checking Group")
getgenv().BypassGroup = false
if not IsPlayerInGroup and not CheckPlace() then
    if IsPlayerInGroup  == nil then
        repeat task.wait() until IsPlayerInGroup ~= nil
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
        repeat task.wait() until getgenv().BypassGroup
    end
end
prints("Checking Group Completed")
maintab:Section(Version)
maintab:Section("Current Place: "..(CheckPlace() and "Ingame" or "Lobby"))

if CheckPlace() then
    if #Players:GetChildren() > 1 and getgenv().Multiplayer["Enabled"] == false then
        game:GetService("TeleportService"):Teleport(3260590327, LocalPlayer)
    end
    Workspace.Towers.ChildAdded:Connect(function(tower)
        if not tower:FindFirstChild("Replicator") then
            repeat task.wait() until tower:FindFirstChild("Replicator")
        end
        if tower:FindFirstChild("Owner").Value and tower:FindFirstChild("Owner").Value == LocalPlayer.UserId then
            task.spawn(function()
                CountNum += 1
                getgenv().TowerInfo[tower.Replicator:GetAttribute("Type")][2] += 1
                tower.Name = CountNum
                tower:SetAttribute("TypeIndex", tower.Replicator:GetAttribute("Type").." "..tostring(getgenv().TowerInfo[tower.Replicator:GetAttribute("Type")][2]))
                getgenv().TowerInfo[tower.Replicator:GetAttribute("Type")][1].Text = tower.Replicator:GetAttribute("Type").." : "..tostring(getgenv().TowerInfo[tower.Replicator:GetAttribute("Type")][2])
                if getgenv().Debug then
                    task.spawn(DebugTower,tower)
                end
            end)
        end
    end)
    TimerConnection = ReplicatedStorage.StateReplicators.ChildAdded:Connect(function(object)
        if object:GetAttribute("Duration") and object:GetAttribute("Duration") == 5 then
            TimerCheck = true
        elseif object:GetAttribute("Duration") and object:GetAttribute("Duration") > 5 then
            TimerCheck = false
        end
    end)

    local utilitiestab = UILibrary:CreateWindow("Utilities")
    utilitiestab:Toggle("Rejoin Lobby After Match",{default = true, location = getgenv(), flag = "RejoinLobby"})

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
                    if InputTyped.UserInputType == Enum.UserInputType.MouseButton2 and getgenv().UtilitiesConfig.Camera == 3 then
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
            if getgenv().UtilitiesConfig.Camera == 3 then
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

        utilitiestab:Button("Teleport Back To Platform",function()
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Part.CFrame +  Vector3.new(0, 3.5, 0)
        end)
        local WebSetting = utilitiestab:DropSection("Webhook Settings")
        WebSetting:Toggle("Enabled",{default = getgenv().UtilitiesConfig.Webhook.Enabled or false, flag = "Enabled"})
        if getgenv().FeatureConfig and getgenv().FeatureConfig.CustomLog then
            WebSetting:Toggle("Disable SL's Custom Log",{default = getgenv().UtilitiesConfig.Webhook.DisableCustomLog or false, flag = "DisableCustomLog"})
        end
        WebSetting:Toggle("Hide Username",{default = getgenv().UtilitiesConfig.Webhook.HideUser or false ,flag = "HideUser"})
        WebSetting:Toggle("Player Info",{default = getgenv().UtilitiesConfig.Webhook.PlayerInfo or false, flag = "PlayerInfo"})
        WebSetting:Toggle("Game Info",{default = getgenv().UtilitiesConfig.Webhook.GameInfo or false, flag = "GameInfo"})
        WebSetting:Toggle("Troops Info",{default = getgenv().UtilitiesConfig.Webhook.TroopsInfo or false, flag = "TroopsInfo"})

        local modesection = maintab:Section("Mode: Voting")
        task.spawn(function()
            repeat task.wait() until GetGameInfo():GetAttribute("Difficulty")
            modesection.Text = "Mode: "..GetGameInfo():GetAttribute("Difficulty")
        end)
        maintab:Section("Map: "..ReplicatedStorage.State.Map.Value)
        maintab:Section("Tower Info:")
        getgenv().TowerInfo = {}
        for i,v in next, RemoteFunction:InvokeServer("Session","Search","Inventory.Troops") do
            if v.Equipped then
                TowerInfo[i] = {maintab:Section(i.." : 0"), 0, i}
            end
        end
        local OldCameraOcclusionMode = LocalPlayer.DevCameraOcclusionMode
        if getgenv().UtilitiesConfig.Camera == 1 then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
            Camera.CameraType = "Follow"
        elseif getgenv().UtilitiesConfig.Camera == 2 then
            LocalPlayer.Character.Humanoid.PlatformStand = true
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
            LocalPlayer.DevCameraOcclusionMode = "Invisicam"
            Camera.CameraType = "Follow"
        end
        
        local CamSetting = utilitiestab:DropSection("Camera Settings")
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
        local Folder = Instance.new("Folder")
        Folder.Parent = ReplicatedStorage
        Folder.Name = "Map"
        utilitiestab:Toggle("Low Graphics Mode",{default = getgenv().UtilitiesConfig.LowGraphics or false ,flag = "LowGraphics"}, function(bool)
            if bool then
                repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
                LocalPlayer.Character.Humanoid.PlatformStand = true
                LocalPlayer.Character.HumanoidRootPart.Anchored = true
                for i,v in next, Workspace.Map:GetChildren() do
                    if v.Name ~= "Paths" then
                        v.Parent = Folder
                    end
                end
            else
                for i,v in next, Folder:GetChildren() do
                    v.Parent = Workspace.Map
                end
            end
            MinimizeClient(bool)
        end)
        if getgenv().PotatoPC or getgenv().UtilitiesConfig.LowGraphics then
            repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
            LocalPlayer.Character.Humanoid.PlatformStand = true
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
            for i,v in next, Workspace.Map:GetChildren() do
                if v.Name ~= "Paths" then
                    v.Parent = Folder
                end
            end
            MinimizeClient(bool)
        end

        task.spawn(function()
            repeat task.wait(.3)
            until getgenv().StratCreditsAuthor ~= nil
            if (type(getgenv().StratCreditsAuthor) == "string" and #getgenv().StratCreditsAuthor > 0) or type(getgenv().StratCreditsAuthor) == "number" then
                utilitiestab:Section("==Strat Creators==")
                utilitiestab:Section(tostring(getgenv().StratCreditsAuthor))
            elseif type(getgenv().StratCreditsAuthor) == "table" then
                for i,v in next, getgenv().StratCreditsAuthor do
                    if (type(v) == "string" and #v > 0) or type(v) == "number" then
                        utilitiestab:Section(tostring(v))
                    end
                end
            end
        end)

        function SaveUtilitiesConfig()
            getgenv().UtilitiesConfig = {
                Camera = tonumber(getgenv().DefaultCam) or 2,
                LowGraphics = utilitiestab.flags.LowGraphics,
                Webhook = {
                    Enabled = WebSetting.flags.Enabled or false,
                    Link = readfile("TDS_AutoStrat/Webhook (Logs).txt") or "",
                    HideUser = WebSetting.flags.HideUser or false,
                    PlayerInfo = WebSetting.flags.PlayerInfo or true,
                    GameInfo = WebSetting.flags.GameInfo or true,
                    TroopsInfo = WebSetting.flags.TroopsInfo or true,
                    DisableCustomLog = WebSetting.flags.DisableCustomLog or true,
                },
            }
            writefile("StratLoader/UserConfig/UtilitiesConfig.txt",cloneref(game:GetService("HttpService")):JSONEncode(getgenv().UtilitiesConfig))
        end
        task.spawn(function()
            while true do
                SaveUtilitiesConfig()
                task.wait(1)
            end
        end)

        repeat wait() until Workspace:FindFirstChild("NPCs")
        task.spawn(function()
            while true do
                for i,v in next, Workspace.NPCs:GetChildren() do
                    if getgenv().UtilitiesConfig.Camera ~= 2 then
                        repeat wait() until getgenv().UtilitiesConfig.Camera == 2
                    end
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("HumanoidRootPart").CFrame.Y > -5 then
                        repeat
                            if getgenv().UtilitiesConfig.Camera == 2 then
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

        for i,v in next, game:GetService("Lighting"):GetChildren() do
            if v.Name ~= "Sky" then
                v:Destroy()
            end
        end
        local GameGui = LocalPlayer.PlayerGui.GameGui
        GameGui.Results:GetPropertyChangedSignal("Visible"):Connect(function()
            prints("Match Ended")
            task.wait(1)
            if getgenv().UtilitiesConfig.Webhook.Enabled then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/Webhook.lua", true))()
                prints("Sent Webhook Log")
            end
            if not getgenv().RejoinLobby then
                repeat task.wait() until getgenv().RejoinLobby
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
        wait(1)
        repeat wait() until tonumber(Object.Name)
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

    getgenv().EquipStatus = maintab:DropSection("Troops Loadout: Loading")
    getgenv().TowersStatus = {
        [1] = EquipStatus:Section("Empty"),
        [2] = EquipStatus:Section("Empty"),
        [3] = EquipStatus:Section("Empty"),
        [4] = EquipStatus:Section("Empty"),
        [5] = EquipStatus:Section("Empty"),
    }
    maintab:Section("Elevator Status:")
    getgenv().JoiningStatus = maintab:Section("Trying Elevator: 0")
    getgenv().TimerLeft = maintab:Section("Time Left: 20")
    getgenv().MapFind = maintab:Section("Map: ")
    getgenv().CurrentPlayer = maintab:Section("Player Joined: 0")

    local utilitiestab = UILibrary:CreateWindow("Utilities")
    local WebSetting = utilitiestab:DropSection("Webhook Settings")
    WebSetting:Toggle("Enabled",{default = getgenv().UtilitiesConfig.Webhook.Enabled or false, flag = "Enabled"})
    if getgenv().FeatureConfig and getgenv().FeatureConfig.CustomLog then
        WebSetting:Toggle("Disable SL's Custom Log",{default = getgenv().UtilitiesConfig.Webhook.DisableCustomLog or false, flag = "DisableCustomLog"})
    end
    WebSetting:Toggle("Hide Username",{default = getgenv().UtilitiesConfig.Webhook.HideUser or false ,flag = "HideUser"})
    WebSetting:Toggle("Player Info",{default = getgenv().UtilitiesConfig.Webhook.PlayerInfo or false, flag = "PlayerInfo"})
    WebSetting:Toggle("Game Info",{default = getgenv().UtilitiesConfig.Webhook.GameInfo or false, flag = "GameInfo"})
    WebSetting:Toggle("Troops Info",{default = getgenv().UtilitiesConfig.Webhook.TroopsInfo or false, flag = "TroopsInfo"})

    local Folder = Instance.new("Folder")
    Folder.Parent = ReplicatedStorage
    Folder.Name = "Lobby"
    utilitiestab:Toggle("Low Graphics Mode",{default = getgenv().UtilitiesConfig.LowGraphics or false ,flag = "LowGraphics"}, function(bool)
        if bool then
            repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
            LocalPlayer.Character.Humanoid.PlatformStand = true
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
            for i,v in next, Workspace.Lobby:GetChildren() do
                v.Parent = Folder
            end
        else
            for i,v in next, Folder:GetChildren() do
                v.Parent = Workspace.Lobby
            end
        end
        MinimizeClient(bool)
    end)
    if getgenv().PotatoPC or getgenv().UtilitiesConfig.LowGraphics then
        repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
        LocalPlayer.Character.Humanoid.PlatformStand = true
        LocalPlayer.Character.HumanoidRootPart.Anchored = true
        for i,v in next, Workspace.Lobby:GetChildren() do
            v.Parent = Folder
        end
        MinimizeClient(bool)
    end
    function SaveUtilitiesConfig()
        getgenv().UtilitiesConfig = {
            Camera = tonumber(getgenv().DefaultCam) or 2,
            LowGraphics = utilitiestab.flags.LowGraphics,
            Webhook = {
                Enabled = WebSetting.flags.Enabled or false,
                Link = readfile("TDS_AutoStrat/Webhook (Logs).txt") or "",
                HideUser = WebSetting.flags.HideUser or false,
                PlayerInfo = WebSetting.flags.PlayerInfo or true,
                GameInfo = WebSetting.flags.GameInfo or true,
                TroopsInfo = WebSetting.flags.TroopsInfo or true,
                DisableCustomLog = WebSetting.flags.DisableCustomLog or true,
            },
        }
        writefile("StratLoader/UserConfig/UtilitiesConfig.txt",cloneref(game:GetService("HttpService")):JSONEncode(getgenv().UtilitiesConfig))
    end
    task.spawn(function()
        while true do
            SaveUtilitiesConfig()
            task.wait(1)
        end
    end)
    task.spawn(function()
        repeat task.wait(.3)
        until getgenv().StratCreditsAuthor ~= nil
        local multitab = utilitiestab:DropSection("Multiplayer: Off")
        if getgenv().Mulitplayer.Enabled then
            multitab:SetText("Multiplayer: On")
            multitab:Section("Host:"..Players:GetNameFromUserIdAsync(getgenv().Mulitplayer.Host))
            for i =1, getgenv().Mulitplayer.Players do
                getgenv().PlayersSection[v] = multitab:Section("")
            end
        end
        if (type(getgenv().StratCreditsAuthor) == "string" and #getgenv().StratCreditsAuthor > 0) or type(getgenv().StratCreditsAuthor) == "number" then
            utilitiestab:Section("==Strat Creators==")
            utilitiestab:Section(tostring(getgenv().StratCreditsAuthor))
        elseif type(getgenv().StratCreditsAuthor) == "table" then
            for i,v in next, getgenv().StratCreditsAuthor do
                if (type(v) == "string" and #v > 0) or type(v) == "number" then
                    utilitiestab:Section(tostring(v))
                end
            end
        end
    end)
end

function ASLibrary:Map(...)
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
            if not table.find(Map,ReplicatedStorage.State.Map.Value) then
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
                        prints("Changing Elavator",i)
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
                getgenv().JoiningStatus.Text = "Trying Elevator: " ..tostring(i)
                getgenv().MapFind.Text = "Map: "..v["MapName"].Value
                getgenv().CurrentPlayer.Text = "Player Joined: "..v["Playing"].Value
                prints("Trying elavator",i,"Map:","\""..v["MapName"].Value.."\"",", Player Joined:",v["Playing"].Value)
                if table.find(Map,v["MapName"].Value) and v["Time"].Value > 5 and v["Playing"].Value < 4 then
                    if Solo and v["Playing"].Value ~= 0 then
                        continue
                    end
                    if JoiningCheck or ChangeCheck then
                        repeat task.wait() until JoiningCheck == false and ChangeCheck == false
                    end
                    JoiningCheck = true
                    getgenv().JoiningStatus.Text = "Joined Elevator: " ..tostring(i)
                    prints("Joined Elavator",i)
                    RemoteFunction:InvokeServer("Elevators", "Enter", v["Object"])
                    ConnectionEvent = v["Time"].Changed:Connect(function(numbertime)
                        getgenv().MapFind.Text = "Map: "..v["MapName"].Value
                        getgenv().CurrentPlayer.Text = "Player Joined: "..v["Playing"].Value
                        getgenv().TimerLeft.Text = "Time Left: "..tostring(numbertime)
                        prints("Time Left: ",numbertime)
                        if numbertime > 0 and (not table.find(Map,v["MapName"].Value) or (Solo and v["Playing"].Value > 1)) then
                            print("Event Disconnected 1")
                            ConnectionEvent:Disconnect()
                            local Text = (not table.find(Map,v["MapName"].Value) and "Map Has Been Changed") or ((Solo and v["Playing"].Value > 1) and "Someone Has Joined") or "Error"
                            RemoteFunction:InvokeServer("Elevators", "Leave")

                            getgenv().JoiningStatus.Text = Text..", Leaving Elevator "..tostring(i)
                            prints(Text..", Leaving Elevator",i,"Map:","\""..v["MapName"].Value.."\"",", Player Joined:",v["Playing"].Value)
                            getgenv().TimerLeft.Text = "Time Left: 20"
                            JoiningCheck = false
                            return
                        end
                        if numbertime == 0 then
                            print("Event Disconnected 2")
                            ConnectionEvent:Disconnect()
                            getgenv().JoiningStatus.Text = "Teleporting To A Match"
                            wait(60)
                            getgenv().JoiningStatus.Text = "Rejoining Elevator"
                            prints("Rejoining Elevator")
                            RemoteFunction:InvokeServer("Elevators", "Leave")
                            getgenv().TimerLeft.Text = "Time Left: 20"
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

function ASLibrary:Loadout(...)
    if getgenv().IsMultiStrat then 
        return 
    end
    local tableinfo = ParametersPatch("Loadout",...)
    local TotalTowers = tableinfo["TotalTowers"]
    getgenv().TroopsOwned = RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops")
    if CheckPlace() then
        task.spawn(function()
            if #TroopsOwned ~= #tableinfo then
                game:GetService("TeleportService"):Teleport(3260590327, LocalPlayer)
                return
            end
            for i, v in next, TroopsOwned do
                if v.Equipped and not tableinfo[i] then
                    game:GetService("TeleportService"):Teleport(3260590327, LocalPlayer)
                    return
                end
            end
        end)
        ConsoleInfo("Loadout Selected: \""..table.concat(TotalTowers, "\", \"").."\"")
        return
    end
    getgenv().EquipStatus:SetText("Troops Loadout: Equipping")

    local Text = ""
    for i,v in next, TotalTowers do
        if not TroopsOwned[v] then
            Text = Text..v..", "
        end
    end
    if #Text ~= 0 then
        repeat
            local BoughtCheck = true
            getgenv().TroopsOwned = RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops")
            for i,v in next, string.split(Text,", ") do
                if #v > 0 and not TroopsOwned[v] then
                    BoughtCheck = false
                    TowersStatus[i].Text = v..": Missing"
                end
            end
            task.wait(5)
        until BoughtCheck
        --LocalPlayer:Kick("Missing Tower: "..Text)
    end

    for i,v in next, TroopsOwned do
        if v.Equipped then
            RemoteEvent:FireServer("Inventory","Unequip","Tower",i)
        end
    end

    for i,v in next, TotalTowers do
        RemoteEvent:FireServer("Inventory", "Equip", "tower",v)
        TowersStatus[i].Text = tableinfo[v][1] and "[Golden] "..v or ""..v
        if TroopsOwned[v].GoldenPerks and tableinfo[v][1] == false then
            RemoteEvent:FireServer("Inventory", "Unequip", "Golden", v)
        elseif tableinfo[v][1]  then
            RemoteEvent:FireServer("Inventory", "Equip", "Golden", v)
        end
    end
    getgenv().EquipStatus:SetText("Troops Loadout: Equipped")
    ConsoleInfo("Loadout Selected: "..table.concat(TotalTowers, "\", \"").."\"")
end

function ASLibrary:Mode(Name)
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
getgenv().Placing = false
getgenv().Upgrading = false
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

function ASLibrary:Place(...)
    local tableinfo = ParametersPatch("Place",...)
    local Tower = tableinfo["Type"]
    local Position = tableinfo["Position"] or Vector3.new(0,0,0)
    local Rotation = tableinfo["Rotation"] or CFrame.new(0,0,0)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        local CheckPlaced
        repeat
            CheckPlaced = RemoteFunction:InvokeServer("Troops","Place",Tower,{
                ["Position"] = Position,
                ["Rotation"] = Rotation
            })
            wait()
        until typeof(CheckPlaced) == "Instance" --return instance
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],CheckPlaced)
        --prints(Tower,CheckPlaced.Name,TowerType,Wave, Min, Sec, tostring(InWave))
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
function ASLibrary:Upgrade(...)
    local tableinfo = ParametersPatch("Upgrade",...)
    local Tower = tableinfo["TowerIndex"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        --[[if not Workspace.Towers:FindFirstChild(Tower) then
            local SkipCheck
            task.spawn(function()
                task.wait(10)
                SkipCheck = true
            end)
            ConsoleWarn("Can't Find Tower Index: "..Tower)
            repeat 
                task.wait() 
            until Workspace.Towers:FindFirstChild(Tower) or SkipCheck
            if SkipCheck and not Workspace.Towers:FindFirstChild(Tower) then
                ConsoleError("Tower Index: "..Tower.." Doesn't Existed")
                return
            end
        end]]
        local SkipCheck
        task.spawn(function()
            task.wait(15)
            SkipCheck = true
        end)
        local CheckUpgraded
        repeat
            CheckUpgraded = RemoteFunction:InvokeServer("Troops","Upgrade","Set",{
                ["Troop"] = Workspace.Towers:WaitForChild(Tower)
            })
            wait()
        until CheckUpgraded or SkipCheck
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        if SkipCheck and not CheckUpgraded then
            ConsoleError("Failed To Upgrade Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
            return
        end
        ConsoleInfo("Upgraded Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end

--[[{
    ["TowerIndex"] = "",
    ["TypeIndex"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
function ASLibrary:Sell(...)
    local tableinfo = ParametersPatch("Sell",...)
    local Tower = tostring(tableinfo["TowerIndex"])
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        local CheckUpgraded
        repeat
            CheckUpgraded = RemoteFunction:InvokeServer("Troops","Sell",{
                ["Troop"] = Workspace.Towers:WaitForChild(Tower)
            })
            wait()
        until CheckUpgraded
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        ConsoleInfo("Sold Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end

--[[{
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
function ASLibrary:Skip(...)
    local tableinfo = ParametersPatch("Skip",...)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        RemoteFunction:InvokeServer("Waves", "Skip")
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
function ASLibrary:Ability(...)
    local tableinfo = ParametersPatch("Ability",...)
    local Tower = tostring(tableinfo["TowerIndex"])
    local AbilityName = tableinfo["Ability"]
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        RemoteFunction:InvokeServer("Troops","Abilities","Activate",{
            ["Troop"] = Workspace.Towers:WaitForChild(Tower), 
            ["Name"] = AbilityName
        })
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        ConsoleInfo("Used Ability On Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end

--[[{
    ["TowerIndex"] = "",
    ["TypeIndex"] = "",
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
function ASLibrary:Target(...)
    local tableinfo = ParametersPatch("Target",...)
    local Tower = tostring(tableinfo["TowerIndex"])
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        RemoteFunction:InvokeServer("Troops","Target","Set",{
            ["Troop"] = Workspace.Towers:WaitForChild(Tower)
        })
        local TowerType = GetTypeIndex(tableinfo["TypeIndex"],Tower)
        ConsoleInfo("Changed Target Tower Index: "..Tower..", Type: \""..TowerType.."\", (Wave "..Wave..", Min: "..Min..", Sec: "..Sec..", InBetween: "..tostring(InWave)..")")
    end)
end

local function Chain(Tower)
    local Tower = Workspace.Towers[tostring(Tower)]
    if Tower then
        if Tower.Replicator:GetAttribute("Upgrade") >= 2 then
            if Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") ~= false then
                repeat wait() 
                until not Tower.Replicator.Stuns:GetAttribute("1") or Tower.Replicator.Stuns:GetAttribute("1") == false
            end
            RemoteFunction:InvokeServer("Troops","Abilities","Activate",{["Troop"] = Tower ,["Name"] = "Call Of Arms"})
            task.wait(10.01)
        end
    else
        task.wait(10.01)
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
function ASLibrary:AutoChain(...)
    local tableinfo = ParametersPatch("AutoChain",...)
    local Tower1,Tower2,Tower3 = tostring(tableinfo["TowerIndex1"]), tostring(tableinfo["TowerIndex2"]), tostring(tableinfo["TowerIndex3"])
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    local TowerType = {
        [Tower1] = Workspace.Towers:WaitForChild(Tower1):GetAttribute("TypeIndex"),
        [Tower2] = Workspace.Towers:WaitForChild(Tower2):GetAttribute("TypeIndex"),
        [Tower3] = Workspace.Towers:WaitForChild(Tower3):GetAttribute("TypeIndex"),
    }
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        for i,v in next, TowerType do
            if not v:match("Commander") then
                ConsoleError("Troop Index: "..v.." Is Not A Commander!")
                return
            end
        end
        while task.wait() do
            Chain(Tower1)
            Chain(Tower2)
            Chain(Tower3)
        end
    end)
end

function ASLibrary:SellAllFarms(...)
    local tableinfo = ParametersPatch("SellAllFarms",...)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false 
    if not CheckPlace() then
        return
    end
    task.spawn(function()
        TimeWaveWait(Wave, Min, Sec, InWave)
        for i,v in next, Workspace.Towers:GetChildren() do
            if v:FindFirstChild("Owner").Value == LocalPlayer.UserId and v.Replicator:GetAttribute("Type") == "Farm" then 
                RemoteFunction:InvokeServer("Troops","Sell",{
                    ["Troop"] = v
                })
            end
        end
    end)
end
ConsoleInfo("Loaded Library")
getgenv().Executed = true
return ASLibrary