if game.PlaceId ~= 3260590327 and game.PlaceId ~= 5591597781 then return end
task.wait(.9)
local OldTime = os.clock()

getgenv().ExecDis = true --Don't remove this. It's necessary since the "Built In Auto Exec" can break the strat.

--Below here is the library of Strat Loader
local Version = "Version: 0.6 Build 3 Dev-Test"
local Changelog = {"!+[Alpha] Strategies X","!!Require hookfunction()","Improved API","Improved JLS","Fixed File Had Special Char"}

local gethiddenproperty = gethiddenproperty or gethiddenprop or get_hidden_property or get_hidden_prop or getpropvalue
local sethiddenproperty = sethiddenproperty or sethiddenprop or set_hidden_property or set_hidden_prop or setpropvalue
assert(readfile, 'Exploit is missing readfile function')
assert(listfiles, 'Exploit is missing listfiles function')
assert(isfile, 'Exploit is missing isfile function')
assert(hookmetamethod, 'Exploit is missing hookmetamethod function')
assert(hookfunction, 'Exploit is missing hookfunction function')

local IsPlayerInGroup
task.spawn(function()
    repeat task.wait() until game:GetService("Players").LocalPlayer
    IsPlayerInGroup = game:GetService("Players").LocalPlayer:IsInGroup(4914494)
end)

getgenv().Config = {}
getgenv().FeatureConfig = {
    ["JoinLessFeature"] = {
        Enabled = false;
        ActiveWhen = 12;
        MinPlr = 1;
        MaxPlr = 3;
    },
    ["GPULimit"] = false,
    ["CustomLog"] = false,
    ["StrategiesX"] = false
}

if not isfolder("StratLoader") then
    makefolder("StratLoader/UserConfig/Source")
    makefolder("StratLoader/UserLogs")
end
if not isfolder("StratLoader/UserConfig/Source") then
    makefolder("StratLoader/UserConfig/Source")
end
if not isfolder("StratLoader/UserLogs") then
    makefolder("StratLoader/UserLogs")
end
if isfile("StratLoader/UserConfig/Config.txt") then
    getgenv().Config = cloneref(game:GetService("HttpService")):JSONDecode(readfile("StratLoader/UserConfig/Config.txt"))
else
    writefile("StratLoader/UserConfig/Config.txt",cloneref(game:GetService("HttpService")):JSONEncode(Config))
end
if isfile("StratLoader/UserConfig/FeatureConfig.txt") then
    getgenv().FeatureConfig = cloneref(game:GetService("HttpService")):JSONDecode(readfile("StratLoader/UserConfig/FeatureConfig.txt"))
else
    writefile("StratLoader/UserConfig/FeatureConfig.txt",cloneref(game:GetService("HttpService")):JSONEncode(FeatureConfig))
end
getgenv().WriteFile = function(check,name,location,str)
    if not check then
        return
    end
    if type(name) == "string" then
        if not type(location) == "string" then
            location = ""
        end
        if not isfolder(location) then
            makefolder(location)
        end
        if type(str) ~= "string" then
            error("Argument 4 must be a string got " .. tostring(number))
        end
        writefile(location.."/"..name..".txt",str)
    else
        error("Argument 2 must be a string got " .. tostring(number))
    end
end
getgenv().AppendFile = function(check,name,location,str)
    if not check then
        return
    end
    if type(name) == "string" then
        if not type(location) == "string" then
            location = ""
        end
        if not isfolder(location) then
            WriteFile(check,name,location,str)
        end
        if type(str) ~= "string" then
            error("Argument 4 must be a string got " .. tostring(number))
        end
        if isfile(location.."/"..name..".txt") then
            appendfile(location.."/"..name..".txt",str)
        else
            WriteFile(check,name,location,str)
        end
    else
        error("Argument 2 must be a string got " .. tostring(number))
    end
end
do
    if type(LoadInfo) == "string" then
        local InfoTable = {"Coins", "Gems","Level"}
        function StratLoader(Strat,Player,Info,Amount)
            if type(Player) == "table" then
                for i,v in next,Player do
                    if not Config[v] then
                        Config[v] = {
                            Active = (Strat and true) or false,
                            StratName = Strat or "",
                            Limit = (table.find(InfoTable, Info) and Amount and true) or false,
                            TypeLimit = (table.find(InfoTable, Info) and Info) or "Coins",
                            Amount = Amount or 0,
                            AutoShut = false,
                            AutoRemove = false,
                        }
                        writefile("StratLoader/UserConfig/Config.txt", cloneref(game:GetService("HttpService")):JSONEncode(Config))
                    end
                end
            elseif type(Player) == "string" and not Config[Player] then
                Config[Player] = {
                    Active = (Strat and true) or false,
                    StratName = Strat or "",
                    Limit = (table.find(InfoTable, Info) and Amount and true) or false,
                    TypeLimit = (table.find(InfoTable, Info) and Info) or "Coins",
                    Amount = Amount or 0,
                    AutoShut = false,
                    AutoRemove = false,
                }
                writefile("StratLoader/UserConfig/Config.txt", cloneref(game:GetService("HttpService")):JSONEncode(Config))
            end
        end
        loadstring(LoadInfo)()
    end
end
repeat wait() until game:GetService("Players").LocalPlayer
local writelog = function(...)
    local TableText = {...}
    task.spawn(function()
        for i,v in next, TableText do
            if type(v) ~= "string" then
                TableText[i] = tostring(v)
            end
        end
        local Text = table.concat(TableText, " ")
        print(Text)
        if Config[game:GetService("Players").LocalPlayer.Name] then
            return WriteFile(Config[game:GetService("Players").LocalPlayer.Name],game:GetService("Players").LocalPlayer.Name.."'s log","StratLoader/UserLogs",tostring(Text))
        end
    end)
end
local appendlog = function(...)
    local TableText = {...}
    task.spawn(function()
        for i,v in next, TableText do
            if type(v) ~= "string" then
                TableText[i] = tostring(v)
            end
        end
        local Text = table.concat(TableText, " ")
        print(Text)
        if Config[game:GetService("Players").LocalPlayer.Name] then
            return AppendFile(Config[game:GetService("Players").LocalPlayer.Name],game:GetService("Players").LocalPlayer.Name.."'s log","StratLoader/UserLogs",tostring(Text).."\n")
        end
    end)
end
writelog("--------------------------- Profile Log ---------------------------"..
"\nLog Date ("..os.date("%X").." "..os.date("%x")..")"..
"\nName: " ..game:GetService("Players").LocalPlayer.Name.." | DisplayName: " ..game:GetService("Players").LocalPlayer.DisplayName..
"\nActive Status: "..tostring(Config[game:GetService("Players").LocalPlayer.Name] and Config[game:GetService("Players").LocalPlayer.Name].Active)..
"\nStrat Name: "..tostring(Config[game:GetService("Players").LocalPlayer.Name] and Config[game:GetService("Players").LocalPlayer.Name].StratName)..
"\n--------------------------- Feature Log ---------------------------"..
"\nGPU Limit: "..tostring(FeatureConfig["GPULimit"])..
"\nCustom Log: "..tostring(FeatureConfig["CustomLog"])..
"\nStrategies X Library: "..tostring(FeatureConfig["StrategiesX"])..
"\nJoinLessFeature Status: "..tostring(FeatureConfig["JoinLessFeature"].Enabled)..
"\n+ Active When: "..tostring(FeatureConfig["JoinLessFeature"].ActiveWhen)..
"\n+ Min Players: "..tostring(FeatureConfig["JoinLessFeature"].MinPlr)..
"\n+ Max Players: "..tostring(FeatureConfig["JoinLessFeature"].MaxPlr)..
"\n---------------------- Below here is the log ----------------------\n"
)
local function GetServersInfo(Placeid,MinPlr,MaxPlr,MaxPlaying)
    local Cancel = false
    local Servers = {}
    local CurrentCursor = ""
    repeat
        local Success = pcall(function()
            local ListRaw = game:HttpGet("https://games.roblox.com/v1/games/"..tostring(Placeid).."/servers/Public?sortOrder=Asc&limit=100&cursor="..CurrentCursor)
            local CurrentList = game:GetService("HttpService"):JSONDecode(ListRaw) -- done in 2 steps for getting cursor later
            for i = 1,#CurrentList.data do
                if CurrentList ~= nil and CurrentList.data[i].playing <= tonumber(MaxPlr) then
                   --print(CurrentList.data[i].playing)
                    table.insert(Servers, CurrentList.data[i])
                elseif CurrentList.data[i].playing > tonumber(MaxPlr)+1 then
                    Cancel = true
                end
            end
            local CursorIndex = string.find(ListRaw, "nextPageCursor")
            local EndComma = string.find(ListRaw, ",", CursorIndex)
            local ToEdit = string.gsub(string.sub(ListRaw, CursorIndex, EndComma - 1), '"', "")
            CurrentCursor = string.gsub(ToEdit, 'nextPageCursor:', "")
        end)
        task.wait()
    until (CurrentCursor == "null" and Success == true) or Cancel == true
    return Servers
end
local function TeleportHandler(Id,MinPlayers,MaxPlayers)
    local Id = Id or game.PlaceId
    local MinPlayers = MinPlayers or 1
    local MaxPlayers = MaxPlayers or 3
    local GetServers = GetServersInfo(Id,MinPlayers,MaxPlayers)
    local FailedConnection = game:GetService("TeleportService").TeleportInitFailed:Connect(function(Player, Result, Msg)
        if Player == game:GetService("Players").LocalPlayer then
            if Result == Enum.TeleportResult.Unauthorized or Result == Enum.TeleportResult.GameEnded or Result == Enum.TeleportResult.GameFull then
                table.remove(GetServers,IdRandom)
                if not GetServers[1] then 
                    MinPlayers = MaxPlayers - 1
                    repeat
                        MaxPlayers = MaxPlayers + 2
                        GetServers = GetServersInfo(Id,MinPlayers,MaxPlayers)
                        wait(.1)
                    until GetServers[1]
                end
                IdRandom = math.random(1,#GetServers)
                game:GetService("TeleportService"):TeleportToPlaceInstance(Id, GetServers[IdRandom].id, game:GetService("Players").LocalPlayer)
            end
        end
    end)     
    if not GetServers[1] then
        repeat
            MaxPlayers = MaxPlayers + 1
            GetServers = GetServersInfo(Id,MinPlayers,MaxPlayers)
            wait(.1)
        until GetServers[1]
    end
    local IdRandom = math.random(1,#GetServers)
    game:GetService("TeleportService"):TeleportToPlaceInstance(Id, GetServers[IdRandom].id, game:GetService("Players").LocalPlayer)
end
local Time = tostring(os.clock() - OldTime)
--print("TeleportHandler Library's Loaded:",Time)
appendlog("TeleportHandler Library Loaded: "..Time)

if FeatureConfig["StrategiesX"] then
    local OldNamecall
    OldNamecall = hookmetamethod(game, '__namecall', function(...)
        local Self, Args = (...), ({select(2, ...)})
        if getnamecallmethod() == 'HttpGet' then
            if Args[1] == "https://raw.githubusercontent.com/banbuskox/dfhtyxvzexrxgfdzgzfdvfdz/main/ckmhjvskfkmsStratFun2" then
                appendlog("Hooked AutoStrat Main Library Using hookmetamethod")
                Args[1] = "https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/MainSource.lua"
            elseif Args[1] == "https://raw.githubusercontent.com/banbuskox/dfhtyxvzexrxgfdzgzfdvfdz/main/asjhxnjfdStratFunJoin" then
                appendlog("Hooked AutoStrat Joining Library Using hookmetamethod")
                Args[1] = "https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/CustomJoiningElevators.lua"
            end
        elseif getnamecallmethod() == 'Kick' then
            wait(math.huge)
        end
        return OldNamecall(...,unpack(Args))
    end)
    local OldHook
    OldHook = hookfunction(game.HttpGet, function(Self, Url, ...)
        if Url == "https://raw.githubusercontent.com/banbuskox/dfhtyxvzexrxgfdzgzfdvfdz/main/ckmhjvskfkmsStratFun2" then
            appendlog("Hooked AutoStrat Main Library Using hookfunction")
            Url = "https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/MainSource.lua"
        elseif Url == "https://raw.githubusercontent.com/banbuskox/dfhtyxvzexrxgfdzgzfdvfdz/main/asjhxnjfdStratFunJoin" then
            appendlog("Hooked AutoStrat Joining Library Using hookfunction")
            Url = "https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/CustomJoiningElevators.lua"
        end
        return OldHook(Self, Url, ...)
    end)
    appendlog("Local AutoStrat Library Loaded: "..tostring(os.clock() - OldTime))
end
local GetFiles = function(path,excludefile)
    local tablefiles = {}
    local path = path or ""
    local tableexclude = type(excludefile) == "string" and {excludefile} or type(excludefile) == "table" and excludefile or {}
    if not tableexclude[1] then
        return listfiles(path)
    end
    for i,v in next,listfiles(path) do
        if v then
            local str = string.split(v,"\\")
            local filename = str[#str]
            if not table.find(tableexclude,filename) then
                table.insert(tablefiles,v)
            end
        end
    end
    return tablefiles
end
local GetFilesName = function(path,name)
    local tablefilesname = {}
    local name = name or ""
    local tablefiles = GetFiles(path,name)
    local path = path or ""
    for i,v in next, tablefiles do
        if isfile(v) then
            local str = string.split(v,"\\")
            local filename = str[#str]
            table.insert(tablefilesname,filename)
        end
    end
    return tablefilesname
end
local GetFullFileName = function(tablefilesname,name)
    local tablefilesname = type(tablefilesname) == "table" and tablefilesname or {}
    local name = tostring(name) or ""
    for i,v in next, tablefilesname do
        if string.find(v:lower(),name:lower(),1,true) then
            return v
        end
    end
    return ""
end
local GetFilePath = function(path,name)
    return path.."/"..name
end
local Time = tostring(os.clock() - OldTime)
--print("API Library's Loaded:",Time)
appendlog("Library's API Loaded: "..Time)

getgenv().MinimizeClient = function(boolean)
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
local LoadStrat = {}
local ErrorFile = {}
appendlog("Loaded File:")
for i,v in next,GetFilesName("StratLoader") do
    local strat = GetFilePath("StratLoader",v)
    if strat and isfile(strat) and tostring(loadfile(strat)) ~= "nil" then
        --print(v,loadfile(strat))
        appendlog("+ "..tostring(v))
        LoadStrat[v] = loadfile(strat)
    else
        table.insert(ErrorFile,tostring(v))
    end
end
appendlog("File Failed To Load: \n+ "..table.concat(ErrorFile,"\n+ "))

setmetatable(LoadStrat, {
    __index = function(self, key)
        print(LoadStrat, "has indexxed")
        for i,v in next, LoadStrat do
            if string.find(i:lower(),key:lower(),1,true) then
                return rawget(LoadStrat, i)
            end
        end
    end
})

function Loader()
    if Config[game:GetService("Players").LocalPlayer.Name] and Config[game:GetService("Players").LocalPlayer.Name].Active then
        local GetConfig = Config[game:GetService("Players").LocalPlayer.Name]
        local StratName = LoadStrat[GetFullFileName(GetFilesName("StratLoader"),GetConfig.StratName)]
        local Limit = GetConfig.Limit
        if game.PlaceId == 3260590327 and Limit and tonumber(game:GetService("Players").LocalPlayer:WaitForChild(GetConfig.TypeLimit).Value) >= GetConfig.Amount then
            if GetConfig.AutoRemove then
                Config[game:GetService("Players").LocalPlayer.Name] = nil
            end
            if GetConfig.AutoShut then
                wait()
                game:Shutdown()
            end
            return
        end
        if FeatureConfig["GPULimit"] then
            MinimizeClient(true)
        end
        if StratName then
            local Success = pcall(StratName)
            appendlog(GetFullFileName(GetFilesName("StratLoader"),GetConfig.StratName).." Loaded" ..(Success and "" or " FAILED"))
            appendlog("Strat's Time Loaded: "..tostring(os.clock() - OldTime))
        else
            --warn("Couldn't Find Strat Name "..GetConfig.StratName.." In StratLoader Folder.")
            appendlog("Couldn't Find Strat Name "..GetConfig.StratName.." In StratLoader Folder.")
            return
        end
        task.spawn(function()
            wait(100)
            if game.PlaceId == 5591597781 then
                if not (FeatureConfig["CustomLog"] or FeatureConfig["JoinLessFeature"].Enabled) then
                    return
                end
                local SendRequest = http_request or request or HttpPost or syn.request
                local LocalPlayer = game:GetService("Players").LocalPlayer
                local MatchGui = LocalPlayer.PlayerGui.RoactGame.Rewards.content.gameOver
                local Info = MatchGui.content.info
                local Stats = Info.stats
                local Rewards = Info.rewards
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local OldIndex
                OldIndex = hookmetamethod(game,"__index",function(...)
                    local Args = {...}
                    if Args[1] == Content and Args[2] == "Visible" and checkcaller() then --Spoof value
                        return false
                    end
                    return OldIndex(...)
                end)
                local CommaText = function(string)
                    return tostring(string):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
                 end
                MatchGui:GetPropertyChangedSignal("Visible"):Connect(function()
                    if readfile("TDS_AutoStrat/Webhook (Logs).txt") ~= "WEBHOOK HERE" and not (type(getgenv().UtilitiesConfig) == "table" and getgenv().UtilitiesConfig.Webhook.DisableCustomLog) then
                        local CheckRequest
                        task.spawn(function()
                            local function CheckStatus()
                                return MatchGui.banner.textLabel.Text
                            end
                            local function CheckReward()
                                local RewardType
                                repeat task.wait() until Rewards[1] and Rewards[2]
                                if Rewards[2].content.icon.Image == "rbxassetid://5870325376" then
                                   RewardType = "Coins"
                                else
                                   RewardType = "Gems"
                                end
                                return {RewardType, Rewards[2].content.textLabel.Text..((RewardType == "Coins" and " :coin:") or (RewardType == "Gems" and " :gem:") or "")}
                             end
                            local function CheckTower()
                                local str = ""
                                local troops = {}
                                for i,v in next,ReplicatedStorage.RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops") do
                                    if v.Equipped then
                                        table.insert(troops, i)
                                    end
                                end
                                for i,v in next,game.CoreGui:GetDescendants() do
                                    if v:IsA("Frame") and v.Name == "Auto Strats" then
                                        for i2,v2 in next,v.container:GetChildren() do
                                            if v2:IsA("Frame") and v2:FindFirstChild("section_lbl") and table.find(troops,string.split(v2:FindFirstChild("section_lbl").Text," : ")[1]) then
                                                str = str.."\n**"..string.split(v2:FindFirstChild("section_lbl").Text," : ")[1].." : **"..string.split(v2:FindFirstChild("section_lbl").Text," : ")[2]
                                            end
                                        end
                                    end
                                end
                                return str
                            end
                            local CheckColor = {
                                ["TRIUMPH!"] = tonumber(65280),
                                ["YOU LOST"] = tonumber(16711680),
                             }
                             
                            wait(2.3) --Need wait here because CheckReward() need over 1,5s to detect which value is visible
                            local GetReward = CheckReward()
                            local Data = {
                                ["username"] = "TDS AutoStrat Log",
                                ["embeds"] = {
                                    {
                                        ["title"] = "**AutoStrat Log ("..os.date("%X").." "..os.date("%x")..")**",
                                        ["description"] = "**--------------- ACCOUNT INFO ----------------**"..
                                        "\n**Name : **" ..LocalPlayer.Name.."** | DisplayName : **" ..LocalPlayer.DisplayName..
                                        "\n**Coins : **" ..LocalPlayer.Coins.Value.." :coin:** | Gems : **" ..LocalPlayer.Gems.Value.." :six_pointed_star:"..--" :gem:"..
                                        "\n**Level : **" ..LocalPlayer.Level.Value.." :chart_with_upwards_trend: ** | Exp : **" ..LocalPlayer.Experience.Value.." :star:"..
                                        "\n**Triumphs : **" ..LocalPlayer.Triumphs.Value.." :trophy: ** | Loses : **" ..LocalPlayer.Loses.Value.." :skull:"..
                                        "\n**------------------ GAME INFO ------------------**"..
                                        "\n**Mode : **"..ReplicatedStorage.State.Difficulty.Value.."** | Map : ** "..ReplicatedStorage.State.Map.Value..
                                        "\n**Game Time : **" ..Stats.duration.Text..
                                        "\n**Health : **" ..tostring(ReplicatedStorage.State.Health.Current.Value).." ("..tostring(ReplicatedStorage.State.Health.Max.Value)..")"..
                                        "\n**Won Experience : **" ..string.split(Rewards[1].content.textLabel.Text," XP")[1].." :star:"..
                                        "\n**Won " ..GetReward[1]..": **" ..GetReward[2]..
                                        "\n**----------------- TROOPS INFO -----------------**"..CheckTower()..
                                        "\n**----------------------------------------------------**"
                                        ,
                                        ["type"] = "rich",
                                        ["color"] = CheckColor[CheckStatus()],
                                    }
                                }
                            }
                            local SendData = {
                                Url = readfile("TDS_AutoStrat/Webhook (Logs).txt"), 
                                Body = game:GetService("HttpService"):JSONEncode(Data), 
                                Method = "POST", 
                                Headers = {
                                    ["content-type"] = "application/json"
                                }
                            }
                            CheckRequest = SendRequest(SendData)
                        end)
                        repeat task.wait() until type(CheckRequest) == "table"
                    else
                        repeat task.wait() until type(getgenv().SendCheck) == "table"
                    end
                    if FeatureConfig["JoinLessFeature"].Enabled then
                        local Min = FeatureConfig["JoinLessFeature"].MinPlr
                        local Max = FeatureConfig["JoinLessFeature"].MaxPlr
                        --print("Rejoin")
                        if getgenv().ASLibrary and not getgenv().RejoinLobby then
                            return
                        end
                        appendlog("Rejoining JLS After Match")
                        TeleportHandler(3260590327,Min,Max)
                    else
                        if getgenv().ASLibrary and not getgenv().RejoinLobby then
                            return
                        end
                        appendlog(getgenv().ASLibrary,getgenv().RejoinLobby)
                        appendlog("Rejoining Back To Lobby")
                        game:GetService("TeleportService"):Teleport(3260590327)
                    end
                end)
                return
            else
                if FeatureConfig["JoinLessFeature"].Enabled and #game:GetService("Players"):GetChildren() >= FeatureConfig["JoinLessFeature"].ActiveWhen then
                    local GetStatus
                    for i,v in next,game:GetService("CoreGui"):GetDescendants() do
                        if v.Name == "Lobby" then
                            for i2,v2 in next,v.container:GetChildren() do
                                if i2 == 3 and v2.Name == "Section" and v2:FindFirstChild("section_lbl") then
                                    GetStatus = v2:FindFirstChild("section_lbl")
                                end
                            end
                        end
                    end
                    appendlog("Detect If Player Is Joining Game")
                    repeat task.wait() until not (GetStatus.Text:match("Join") and not GetStatus.Text:match("Someone"))
                    appendlog("Rejoining JLS")
                    local Min = FeatureConfig["JoinLessFeature"].MinPlr
                    local Max = FeatureConfig["JoinLessFeature"].MaxPlr
                    TeleportHandler(3260590327,Min,Max)
                    return
                end
            end
        end)
    end
end
getgenv().UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/ROBLOX/main/ModificationWallyUi", true))()
local Time = tostring(os.clock() - OldTime)
--print("StratLoader Library's Loaded: ",Time)
appendlog("StratLoader Library's Loaded: "..Time)

if not game:IsLoaded() then
    game['Loaded']:Wait()
end

if game.PlaceId == 3260590327 and Config[game:GetService("Players").LocalPlayer.Name] and Config[game:GetService("Players").LocalPlayer.Name].Active and FeatureConfig["JoinLessFeature"].Enabled and #game:GetService("Players"):GetChildren() >= FeatureConfig["JoinLessFeature"].ActiveWhen then 
    local Min = FeatureConfig["JoinLessFeature"].MinPlr
    local Max = FeatureConfig["JoinLessFeature"].MaxPlr
    TeleportHandler(3260590327,Min,Max)
    return
end
local Time = tostring(os.clock() - OldTime)
appendlog("Library's Time Loaded: "..Time)
Loader() --Main Core

if not (Config[game:GetService("Players").LocalPlayer.Name] and Config[game:GetService("Players").LocalPlayer.Name].Active) then
    function GetPlayersList(name)
        if type(name) ~= "table" then
            return {}
        end
        local namelist = {}
        for i,v in next,name do
            if tostring(i) then
                table.insert(namelist,tostring(i))
            end
        end
        return namelist
    end

    local w = UILibrary:CreateWindow('Strat Loader')
    local PlayerName,PlayerRemove = {},""

    w:Section("Player: "..game:GetService("Players").LocalPlayer.DisplayName.."")
    w:Toggle("Auto Add Current User",{default = true, flag = "autoyourself"},function(bool)
        if bool then
            table.insert(PlayerName,game:GetService("Players").LocalPlayer.Name)
        else
            for i=1,#PlayerName do
                if PlayerName[i] == game:GetService("Players").LocalPlayer.Name then
                    table.remove(PlayerName,i)
                end
            end
        end
    end)
    w:Section("Choose Strat")
    local stratname = w:SearchBox("Strat Name", {
        flag = "StratFullName",
        list = GetFilesName("StratLoader")
    },function()
        print(w.flags.StratFullName)
    end)
    w:Button("Refresh Strat Name Box",function()
        stratname.Reload(GetFilesName("StratLoader"))
    end)
    w:Section("Add Players Same Config")
    w:TypeBox("Player Name",{flag = "plrname"},function(value)
        if #string.gsub(value, "%s*%p*", "") > 0 then
            --if (value:match(" ") or value:match(",")) then
            local str = string.gsub(tostring(value),","," ")
            local strs = string.split(str, " ")
            PlayerName = {}
            if w.flags.autoyourself then
                table.insert(PlayerName,game:GetService("Players").LocalPlayer.Name)
            end
            for i = 1, #strs do
                if #strs[i] > 0 then
                    table.insert(PlayerName,strs[i])
                end
            end
        else
            PlayerName = {}
            if w.flags.autoyourself then
                table.insert(PlayerName,game:GetService("Players").LocalPlayer.Name)
            end
        end
    end)
    w:Section("Remove Players Same Config")
    local rplr = w:SearchBox("Remove Player", {
        location = _G;
        flag = "RemovePlr";
        list = GetPlayersList(getgenv().Config)
    }, function(value)
        if #string.gsub(value, "%s*%p*", "") > 0 then
            if (value:match(" ") or value:match(",")) then
                local str = string.gsub(tostring(value),","," ")
                local strs = string.split(str, " ")
                PlayerRemove = {}
                for i = 1, #strs do
                    if #strs[i] > 0 then
                        table.insert(PlayerRemove,strs[i])
                    end
                end
            else
                PlayerRemove = value
            end
        else
            PlayerRemove = ""
        end
    end)
    w:Section("Limit Progress")
    w:Toggle("Enable Limit",{flag = "limit"})
    w:Dropdown("Type Of Limit", {
        flag = "Typelimitsetting";
        list = {
            "Coins";
            "Gems";
            'Level';
        }
    })
    w:Box('Amount', {
        flag = "AmountNumber";
        default = 0;
        type = 'number';
    })
    w:Toggle("Auto ShutDown Game",{flag = "shutdown"})
    w:Toggle("Auto Remove Config",{flag = "autoremconfig"})
    w:Section("Apply Strat Config Below")
    w:Button("Apply",function()
        if PlayerRemove then
            if type(PlayerRemove) == "table" and PlayerRemove[1] then
                for i =1, #PlayerRemove do
                    Config[PlayerRemove[i]] = nil
                    rplr.Reload(GetPlayersList(getgenv().Config))
                end
            else
                Config[PlayerRemove] = nil
                rplr.Reload(GetPlayersList(getgenv().Config))
            end
        end
        if w.flags.StratFullName and isfile(GetFilePath("StratLoader",w.flags.StratFullName)) then
            if not (type(PlayerName) == "table" and #PlayerName > 0) then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Strat Loader",
                    Text = "Put Player Name You Want To Use With Strat.";
                    Duration = 5;
                })
            else
                for i =1, #PlayerName do
                    if PlayerName[i] ~= PlayerRemove then
                        Config[PlayerName[i]] = {
                            Active = true,
                            StratName = w.flags.StratFullName or "",
                            Limit = w.flags.limit or false,
                            TypeLimit = w.flags.Typelimitsetting or "Coins",
                            Amount = w.flags.AmountNumber or 0,
                            AutoShut = w.flags.shutdown or false,
                            AutoRemove = w.flags.autoremconfig or false,
                        }
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Strat Loader",
                            Text = "Saved Config\nName: "..PlayerName[i].."\nStrat: "..w.flags.StratFullName;
                            Duration = 5;
                        })
                    end
                end
                rplr.Reload(GetPlayersList(getgenv().Config))
            end
            writefile("StratLoader/UserConfig/Config.txt", cloneref(game:GetService("HttpService")):JSONEncode(Config))
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "Strat Loader",
                Text = "Put Strat Name.";
                Duration = 5;
            })
        end
    end)
    w:Button("Start",function()
        if Config[game:GetService("Players").LocalPlayer.Name] and Config[game:GetService("Players").LocalPlayer.Name].Active then
            local JLFEnabled = FeatureConfig["JoinLessFeature"].Enabled
            if JLFEnabled and #game:GetService("Players"):GetChildren() >= FeatureConfig["JoinLessFeature"].ActiveWhen then
                local Min = FeatureConfig["JoinLessFeature"].MinPlr
                local Max = FeatureConfig["JoinLessFeature"].MaxPlr
                TeleportHandler(3260590327,Min,Max)
                return
            end
            w["object"].Parent.Parent:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/DevTest.lua", true))()
        end
    end)

    w:Button("Print Config",function()
        for i,v in next,getgenv().Config do
            if type(v) == "table" then
                for i2,v2 in next,v do
                    print(i,i2,v2)
                end
            else
                print(i,v)
            end
        end
    end)
    w:Button("Re-Execute",function()
        w["object"].Parent.Parent:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/DevTest.lua", true))()
    end)
    w:Button("Delete Gui",function()
        w["object"].Parent.Parent:Destroy()
    end)
elseif not FeatureConfig["StrategiesX"] then
    local Holder1 = UILibrary:CreateWindow('PlaceHolder')
    Holder1["object"].Visible = false
    if game.PlaceId == 5591597781 then
        local Holder2 = UILibrary:CreateWindow('PlaceHolder')
        Holder2["object"].Visible = false
        if type(getgenv().StratCreditsAuthor) == "string" then
            local Holder3 = UILibrary:CreateWindow('PlaceHolder')
            Holder3["object"].Visible = false
        end
    end
    for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
        if v:IsA("Frame") and v.Name == "Camera" then
            v.Position = UDim2.new(0, 215, 0, 0)
        elseif v:IsA("Frame") and v.Name == "Credits" then
            v.Position = UDim2.new(0, 415, 0, 0)
        end
    end
end

--Feature Setting Tab
local s = UILibrary:CreateWindow('Feature Settings')
local d = UILibrary:CreateWindow('Credits')
s:Toggle("Enable GPU Limit",{default = FeatureConfig["GPULimit"] or false, flag = "gpulimit"})
s:Toggle("Enable Custom Log",{default = FeatureConfig["CustomLog"] or false, flag = "customlog"})
s:Toggle("Enable Strategies X",{default = FeatureConfig["StrategiesX"] or false, flag = "strategiesx"})

local JLStab = s:DropSection("Join Less Feature")
JLStab:Toggle("Enable",{default = FeatureConfig["JoinLessFeature"].Enabled or false, flag = "joinlesstoggle"})
JLStab:Box("Active When Server Is", {
    default = FeatureConfig["JoinLessFeature"].ActiveWhen;
    flag = "serverplaying";
    type = 'number';
})
JLStab:Box("Min Players", {
    default = FeatureConfig["JoinLessFeature"].MinPlr;
    flag = "minplr";
    type = 'number';
})
JLStab:Box("Max Players", {
    default = FeatureConfig["JoinLessFeature"].MaxPlr;
    flag = "maxplr";
    type = 'number';
})
s:Section("Apply Feature Config Below")
s:Button("Apply",function()
    if not (JLStab.flags.serverplaying >= JLStab.flags.maxplr) then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Strat Loader",
            Text = "'Active When Server Is' Value Must Not Lower Than Max Players Value";
            Duration = 5;
        })
    elseif not (JLStab.flags.maxplr >= JLStab.flags.minplr) then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Strat Loader",
            Text = "Max Players Value Must Not Lower Than Min Players Value";
            Duration = 5;
        })
    else
        FeatureConfig = {
            ["JoinLessFeature"] = {
                Enabled = JLStab.flags.joinlesstoggle or false;
                ActiveWhen = JLStab.flags.serverplaying or 12;
                MinPlr = JLStab.flags.minplr or 1;
                MaxPlr = JLStab.flags.maxplr or 3;
            },
            ["GPULimit"] = s.flags.gpulimit or false,
            ["CustomLog"] = s.flags.customlog or false,
            ["StrategiesX"] = s.flags.strategiesx or false,
        }
        writefile("StratLoader/UserConfig/FeatureConfig.txt", cloneref(game:GetService("HttpService")):JSONEncode(FeatureConfig))
    end
    MinimizeClient(s.flags.gpulimit)
end)
s:Section("Cancel Strat")
s:Button("Abort Progress",function()
    Config[game:GetService("Players").LocalPlayer.Name].Active = false
    writefile("StratLoader/UserConfig/Config.txt", cloneref(game:GetService("HttpService")):JSONEncode(Config))
    game:GetService("TeleportService"):Teleport(3260590327)
end)
s:Button("Disable Dev-Test",function()
    FeatureConfig["DevTest"] = false
    writefile("StratLoader/UserConfig/FeatureConfig.txt", cloneref(game:GetService("HttpService")):JSONEncode(FeatureConfig))
    w["object"].Parent.Parent:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/ROBLOX/main/StratLoader", true))()
end)
s:Button("MeMayBeo Feature")

--Credits Tab
d:Section(Version)
d:Button("Changelog:")
for i = 1,#Changelog do
    if type(Changelog[i]) == "string" then
        d:Section(Changelog[i])
    end
end
local Time = tostring(os.clock() - OldTime)
--print("Total Time Loaded:",Time)
appendlog("Total Time Loaded: "..Time)
getgenv().AppendFile(true,game.Players.LocalPlayer.Name.."'s log","StratLoader/UserLogs","\n--------------------------- Strat's log ---------------------------\n")