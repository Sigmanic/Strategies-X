if game.PlaceId ~= 3260590327 and game.PlaceId ~= 5591597781 then return end
if getgenv().StrategiesXLoader then
    return
end
if not game:GetService("Players").LocalPlayer then
    repeat task.wait() until game:GetService("Players").LocalPlayer
end
if getgenv().Config then
    return
end
local OldTime = os.clock()
if not isfolder("StratLoader") then
    makefolder("StratLoader/UserLogs")
end
if not isfolder("StratLoader/UserLogs") then
    makefolder("StratLoader/UserLogs")
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
        return WriteFile(true,game:GetService("Players").LocalPlayer.Name.."'s log","StratLoader/UserLogs",tostring(Text))
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
        return AppendFile(true,game:GetService("Players").LocalPlayer.Name.."'s log","StratLoader/UserLogs",tostring(Text).."\n")
    end)
end
writelog("")

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
getgenv().StrategiesXLoader = true
appendlog("Local AutoStrat Library Loaded: "..tostring(os.clock() - OldTime))