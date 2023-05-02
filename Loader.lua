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