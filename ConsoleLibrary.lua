local SpecialFunction = function(v)
    local metatable = (getrawmetatable or getmetatable)(v)
    if not metatable then
        return tostring(v)
    end
    local old_func = rawget(metatable, '__tostring')
    rawset(metatable, '__tostring', nil)
    local name = tostring(v)
    rawset(metatable, '__tostring', old_func)
    return name
end
local DataFuncs = {
    ["number"] = function(v)
        return tostring(v)
    end,
    ["boolean"] = function(v)
        return tostring(v)
    end,
    ["string"] = function(v)
        return "\""..v.."\""
    end,
    ["Instance"] = function(v)
        return v:GetFullName()
    end,
    ["table"] = SpecialFunction,
    ["function"] = SpecialFunction,
      
}
local SpecialData = function(v,TypeName)
    return TypeName..".new("..tostring(v)..")"
end
local GetIndexs = function(data)
    local indexs = 0
    for i,v in next, data do
        indexs += 1
    end
    return indexs
end

local function BeautyTable(data,tab)
    local str = ""
    local CurrentIndex = 1
    local tab = tab or 1
    local indexs = GetIndexs(data)
    if indexs == 0 and typeof(data) == "table" then
        return "{}"
    end
    local function format_value(v,is_table)
        return is_table and BeautyTable(v,tab+1) or (DataFuncs[typeof(v)] or SpecialData)(v,typeof(v))
    end

    for i,v in next, data do
        str = str.."\n"..string.rep("  ",tab).."["..DataFuncs[typeof(i)](i).."] = "..format_value(v,type(v) == "table")..(CurrentIndex < indexs and "," or "")
        CurrentIndex += 1
    end
    return "{"..str.."\n"..string.rep("  ",tab-1).."}"
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
rconsoleclear()
rconsolename("\""..LocalPlayer.Name.."\" Co biet ong Liem khong?")
local Typelist = {"Info","Warn","Error","Table"}

getgenv().ConsolePrint = function(Color,Type,...)
    if type(Color) ~= "string" then
        Color = "WHITE"
    end
    if not (type(Type) ~= "string" or table.find(Typelist,Type)) then
        Type = "Info"
    end
    local String = ""
    if Type == "Table" then
        local TotalIndex = 1
        for i,v in next, {...} do
            if type(v) ~= "table" then
                v = {v}
            end
            String = String..(TotalIndex > 1 and "\n" or "")..BeautyTable(v)
            TotalIndex += 1
        end
    else
        for i,v in next, {...} do
            if type(v) ~= "string" then
                v = tostring(v)
            end
        end
        String = table.concat({...}, ", ")
    end
    rconsoleprint("@@"..Color.."@@")
    rconsoleprint("["..os.date("%X").."]["..Type.."] "..String.."\n")
    getgenv().AppendFile(true,LocalPlayer.Name.."'s log","StratLoader/UserLogs",String.."\n")
end
getgenv().ConsoleInfo = function(Text)
    ConsolePrint("WHITE","Info",Text)
end
getgenv().ConsoleWarn = function(Text)
    ConsolePrint("BROWN","Warn",Text)
end
getgenv().ConsoleError = function(Text)
    ConsolePrint("RED","Error",Text)
end
getgenv().ConsoleTable = function(...)
    ConsolePrint("WHITE","Info",...)
end