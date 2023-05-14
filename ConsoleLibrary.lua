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
        str = str.."\n"..string.rep("    ",tab).."["..DataFuncs[typeof(i)](i).."] = "..format_value(v,type(v) == "table")..(CurrentIndex < indexs and "," or "")
        CurrentIndex += 1
    end
    return "{"..str.."\n"..string.rep("    ",tab-1).."}"
end

local ConsoleUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/RBX-ImGui/main/RBXImGuiSource.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
--[[if not rconsoleclear then
    getgenv().rconsoleclear = function() end
    getgenv().rconsolename = function() end
    getgenv().rconsoleprint = function() end
end]]
--[[rconsoleclear()
rconsolename("\""..LocalPlayer.Name.."\" Co biet ong Liem khong?")]]

getgenv().AppendFile = getgenv().AppendFile or function() end

local Window = ConsoleUI.new({
    text = "Strategies X",
    size = Vector2.new(650, 370),
    shadow = 1,
    rounding = 1,
    transparency = 0.2,
    font = Enum.Font.SourceSansBold,
    position = UDim2.new(0,600,0,220)
})
Window.open()

local ConsoleTab = Window.new({
    text = "Console Output",
    autoscrolling = true,
    forcescrollbotom = true,
    font = Enum.Font.SourceSansBold,
})

local Typelist = {
    ["Info"] = Color3.fromRGB(255, 255, 255),
    ["Warn"] = Color3.fromRGB(255, 230, 30),
    ["Error"] = Color3.fromRGB(255, 0, 0),
}

getgenv().ConsolePrint = function(Color,Type,...)
    local Color = typeof(Color) == "Color3" and Color or Color3.fromRGB(255, 255, 255)
    local Type = type(Type) == "string" and Type or "Info"
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
    --rconsoleprint("@@"..Color.."@@")
    --rconsoleprint("["..os.date("%X").."]["..Type.."] "..String.."\n")
    for i,v in next, string.split(String, "\n") do
	    ConsoleTab.new("label", {
	        text = (i == 1 and "["..os.date("%X").."]["..Type.."] " or "")..v,
	        color = Typelist[Type],
	        font = Enum.Font.Ubuntu,
	    })
	end
    if Type == "Info" then
        print("["..os.date("%X").."]["..Type.."] "..String)
    elseif Type == "Warn" then
        pcall(function()
            warn("["..os.date("%X").."]["..Type.."] "..String)
        end)
    elseif Type == "Error" then
        pcall(function()
            error("["..os.date("%X").."]["..Type.."] "..String)
        end)
    end
    getgenv().AppendFile(true,LocalPlayer.Name.."'s log","StratLoader/UserLogs","["..os.date("%X").."]["..Type.."] "..String.."\n")
end
getgenv().ConsoleInfo = function(...)
    local TableText = {...}
    for i,v in next, TableText do
        if type(v) ~= "string" then
            TableText[i] = tostring(v)
        end
    end
    local Text = table.concat(TableText, " ")
    ConsolePrint(Typelist["Info"],"Info",Text)
end
getgenv().ConsoleWarn = function(...)
    local TableText = {...}
    for i,v in next, TableText do
        if type(v) ~= "string" then
            TableText[i] = tostring(v)
        end
    end
    local Text = table.concat(TableText, " ")
    ConsolePrint(Typelist["Warn"],"Warn",Text)
end
getgenv().ConsoleError = function(...)
    local TableText = {...}
    for i,v in next, TableText do
        if type(v) ~= "string" then
            TableText[i] = tostring(v)
        end
    end
    local Text = table.concat(TableText, " ")
    ConsolePrint(Typelist["Error"],"Error",Text)
end
getgenv().ConsoleTable = function(...)
    ConsolePrint(Typelist["Info"],"Table",...)
end