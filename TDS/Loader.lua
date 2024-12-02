if game.PlaceId ~= 3260590327 and game.PlaceId ~= 5591597781 then return end
if getgenv().StrategiesXLoader then
    return
end
getgenv().ExecDis = true
if getgenv().Config then
    return
end
local OldTime = os.clock()
if not isfolder("StrategiesX") then
    makefolder("StrategiesX")
    makefolder("StrategiesX/UserLogs")
    makefolder("StrategiesX/UserConfig")
elseif not isfolder("StrategiesX/UserLogs") then
    makefolder("StrategiesX/UserLogs")
elseif not isfolder("StrategiesX/UserConfig") then
    makefolder("StrategiesX/UserConfig")
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
        if not game:GetService("Players").LocalPlayer then
            repeat task.wait() until game:GetService("Players").LocalPlayer
        end
        for i,v in next, TableText do
            if type(v) ~= "string" then
                TableText[i] = tostring(v)
            end
        end
        local Text = table.concat(TableText, " ")
        print(Text)
        return WriteFile(true,game:GetService("Players").LocalPlayer.Name.."'s log","StrategiesX/UserLogs",tostring(Text))
    end)
end
local appendlog = function(...)
    local TableText = {...}
    task.spawn(function()
        if not game:GetService("Players").LocalPlayer then
            repeat task.wait() until game:GetService("Players").LocalPlayer
        end
        for i,v in next, TableText do
            if type(v) ~= "string" then
                TableText[i] = tostring(v)
            end
        end
        local Text = table.concat(TableText, " ")
        print(Text)
        return AppendFile(true,game:GetService("Players").LocalPlayer.Name.."'s log","StrategiesX/UserLogs",tostring(Text).."\n")
    end)
end
local LinkTable = {
    "https://raw.githubusercontent.com/banbuskox/dfhtyxvzexrxgfdzgzfdvfdz/main/ckmhjvskfkmsStratFun2",
    "https://raw.githubusercontent.com/wxzex/mmsautostratcontinuation/main/autostratscode.txt"
}

local OldNamecall
OldNamecall = hookmetamethod(game, '__namecall', function(...)
    local Self, Args = (...), ({select(2, ...)})
    if getnamecallmethod() == 'HttpGet' then
        if table.find(LinkTable, Args[1]) then
            Args[1] = "https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/MainSource.lua"
            appendlog("Hooked AutoStrat Main Library Using hookmetamethod")
        --[[elseif Args[1] == "https://raw.githubusercontent.com/banbuskox/dfhtyxvzexrxgfdzgzfdvfdz/main/asjhxnjfdStratFunJoin" then
            Args[1] = "https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/CustomJoiningElevators.lua"
            appendlog("Hooked AutoStrat Joining Library Using hookmetamethod")]]
        end
    elseif getnamecallmethod() == 'Kick' then
        wait(math.huge)
    end
    return OldNamecall(...,unpack(Args))
end)
local OldHook
OldHook = hookfunction(game.HttpGet, function(Self, Url, ...)
    --if Url == "https://raw.githubusercontent.com/banbuskox/dfhtyxvzexrxgfdzgzfdvfdz/main/ckmhjvskfkmsStratFun2" then
    if table.find(LinkTable, Url) then
        Url = "https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/MainSource.lua"
        appendlog("Hooked AutoStrat Main Library Using hookfunction")
    --[[elseif Url == "https://raw.githubusercontent.com/banbuskox/dfhtyxvzexrxgfdzgzfdvfdz/main/asjhxnjfdStratFunJoin" then
        Url = "https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/CustomJoiningElevators.lua"
        appendlog("Hooked AutoStrat Joining Library Using hookfunction")]]
    end
    return OldHook(Self, Url, ...)
end)
getgenv().StrategiesXLoader = true
appendlog("Strategies X Loader Loaded: "..tostring(os.clock() - OldTime))
