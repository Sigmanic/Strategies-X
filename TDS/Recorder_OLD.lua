local RecVersion = "V2.4"
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local State = ReplicatedStorage.State;
local RS = game:WaitForChild('ReplicatedStorage')
local RSRF = RS:WaitForChild("RemoteFunction")
local RSRE = RS:WaitForChild("RemoteEvent")
getgenv().Towers = {}
getgenv().GoldenPerks = {}
getgenv().Generated = ""
--getgenv().StratName..".txt"
for i,v in pairs(game:GetService("CoreGui"):GetDescendants()) do if v:IsA("Frame") and v.Name == "What do you do?" then v:Remove() end end
for TowerName, Tower in next, game.ReplicatedStorage.RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops") do
		if (Tower.Equipped) then
			table.insert(getgenv().Towers, TowerName)
			if (Tower.GoldenPerks) then
				table.insert(getgenv().GoldenPerks, TowerName)
			end
		end;
	end;
for c=1,5 do if getgenv().Towers[c] == nil then getgenv().Towers[c] = "nil" end end
local gperksl = ""
if getgenv().GoldenPerks[1] then
    gperksl = gperksl.."getgenv().GoldenPerks = {"
    for i,v in pairs(getgenv().GoldenPerks) do
        gperksl = gperksl..'"'..v..'",'
    end
    gperksl = gperksl.."}\n"
end
    if gperksl ~= "" then
        getgenv().Generated = getgenv().Generated.."--"..RecVersion.."\n"..gperksl..'local '..getgenv().APIVar..' = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/MainSource.lua", true))() \n'..getgenv().APIVar..':Loadout("'..getgenv().Towers[1]..'", "'..getgenv().Towers[2]..'", "'..getgenv().Towers[3]..'", "'..getgenv().Towers[4]..'", "'..getgenv().Towers[5]..'") \n'..getgenv().APIVar..':Map("'..game:GetService("ReplicatedStorage").State.Map.Value..'", true, "'..game:GetService("ReplicatedStorage").State.Mode.Value..'")\n';
    else
        getgenv().Generated = getgenv().Generated .. "--"..RecVersion.."\n"..'local '..getgenv().APIVar..' = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/Strategies-X/main/MainSource.lua", true))() \n'..getgenv().APIVar..':Loadout("'..getgenv().Towers[1]..'", "'..getgenv().Towers[2]..'", "'..getgenv().Towers[3]..'", "'..getgenv().Towers[4]..'", "'..getgenv().Towers[5]..'") \n'..getgenv().APIVar..':Map("'..game:GetService("ReplicatedStorage").State.Map.Value..'", true, "'..game:GetService("ReplicatedStorage").State.Mode.Value..'")\n';
    end
function sendw(message)
spawn(function()
if getgenv().Webhook ~= "WEBHOOK (OPTIONAL)" then
local url = getgenv().Webhook
local data = {
	["username"] = "TDS Recorder LOGGER",
	["content"] = message
}
local newdata = game:GetService("HttpService"):JSONEncode(data)
local headers = {
	["content-type"] = "application/json"
}
request = http_request or request or HttpPost or syn.request
local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
request(abcdef)
print("Webhook sent")
end
end)
end
if getgenv().LoggerWindow then
    if game.CoreGui:FindFirstChild("AutoStratsLogger") then
        game.CoreGui:FindFirstChild("AutoStratsLogger"):Remove()
    end
    local LoggerByBanbus = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local Glow = Instance.new("ImageLabel")
    local Top_Container = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Scroll = Instance.new("ScrollingFrame")

    LoggerByBanbus.Name = "AutoStratsLogger"
    LoggerByBanbus.Parent = game:WaitForChild("CoreGui")
    LoggerByBanbus.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.Name = "Main"
    Main.Parent = LoggerByBanbus
    Main.BackgroundColor3 = Color3.fromRGB(23, 21, 30)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.544935644, 0, 0.355803162, 0)
    Main.Size = UDim2.new(0, 500, 0, 400)

    Glow.Name = "Glow"
    Glow.Parent = Main
    Glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Glow.BackgroundTransparency = 1.000
    Glow.BorderSizePixel = 0
    Glow.Position = UDim2.new(0, -15, 0, -15)
    Glow.Size = UDim2.new(1, 30, 1, 30)
    Glow.ZIndex = 0
    Glow.Image = "rbxassetid://4996891970"
    Glow.ImageColor3 = Color3.fromRGB(15, 15, 15)
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(20, 20, 280, 280)

    Top_Container.Name = "Top_Container"
    Top_Container.Parent = Main
    Top_Container.AnchorPoint = Vector2.new(0.5, 0)
    Top_Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Top_Container.BackgroundTransparency = 1.000
    Top_Container.Position = UDim2.new(0.5, 0, 0, 18)
    Top_Container.Size = UDim2.new(1, -40, 0, 20)

    Title.Name = "Title"
    Title.Parent = Top_Container
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.00764120743, 0, -0.400000006, 0)
    Title.Size = UDim2.new(0.981785059, 0, 1.45000005, 0)
    Title.Font = Enum.Font.GothamBlack
    Title.Text = "AUTOSTRATS LOGGER"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 30.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Scroll.Name = "Scroll"
    Scroll.Parent = Main
    Scroll.Active = true
    Scroll.AnchorPoint = Vector2.new(0.5, 0)
    Scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Scroll.BackgroundTransparency = 1.000
    Scroll.BorderSizePixel = 0
    Scroll.Position = UDim2.new(0.5, 4, 0, 59)
    Scroll.Size = UDim2.new(1, -20, 1, -67)
    Scroll.BottomImage = "rbxassetid://5234388158"
    Scroll.CanvasSize = UDim2.new(200, 0, 100, 0)
    Scroll.MidImage = "rbxassetid://5234388158"
    Scroll.ScrollBarThickness = 8
    Scroll.TopImage = "rbxassetid://5234388158"
    Scroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always

    Scroll.ChildAdded:Connect(function()
        if #Scroll:GetChildren() > 16 then
            Scroll.CanvasPosition = Vector2.new(0,Scroll.CanvasPosition.Y + 20)
        end
    end)

    local function drag()
        local script = Instance.new('LocalScript', Main)
        script.Name = "Dragify"
        local UIS = game:GetService("UserInputService")
        function dragify(Frame)
            dragToggle = nil
            dragInput = nil
            dragStart = nil
            local dragPos = nil
            function updateInput(input)
                local Delta = input.Position - dragStart
                local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
                game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.1), {
                    Position = Position
                }):Play()
            end
            Frame.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
                    dragToggle = true
                    dragStart = input.Position
                    startPos = Frame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragToggle = false
                        end
                    end)
                end
            end)
            Frame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input
                end
            end)
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if input == dragInput and dragToggle then
                    updateInput(input)
                end
            end)
        end
        dragify(script.Parent)
    end
    drag()
    local function positioning()
        local script = Instance.new('LocalScript', Main)
        script.Name = "Positioning"
        script.Parent:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 1)
        script.Parent.Draggable = true
    end
    positioning()
    local prevOutputPos = -0.0073
    function TimeConverter(v)
        if v <= 9 then
            local conv = "0"..v
            return conv
        else
            return v
        end
    end
    getgenv().outputRec = function(msg, color)
        local hours = os.date("*t")["hour"]
        local mins = os.date("*t")["min"]
        local sec = os.date("*t")["sec"]
        local colour = Color3.fromRGB(255, 255, 255)
        if color then
        colour = color
        end
        local o = Instance.new("TextLabel", Scroll)
        o.Text = "["..TimeConverter(hours)..":"..TimeConverter(mins)..":"..TimeConverter(sec).."] "..msg
        o.Size = UDim2.new(0.005, 0, 0.001, 0)
        o.Position = UDim2.new(0, 0, .007 + prevOutputPos , 0)
        o.Font = Enum.Font.SourceSansSemibold
        o.TextColor3 = colour
        o.TextStrokeTransparency = 0
        o.BackgroundTransparency = 1
        o.BackgroundColor3 = Color3.new(0, 0, 0)
        o.BorderSizePixel = 0
        o.BorderColor3 = Color3.new(0, 0, 0)
        o.FontSize = "Size14"
        o.TextXAlignment = Enum.TextXAlignment.Left
        o.ClipsDescendants = true
        prevOutputPos = prevOutputPos + 0.0005
    end
end
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/banbuskox/dfhtyxvzexrxgfdzgzfdvfdz/main/jsdnfjdsfdjnsmvkjhlkslzLIB", true))()
if game.PlaceId == 5591597781 then
getgenv().recstatus = "Recording"
if getgenv().LoggerWindow then
    getgenv().outputRec("Recording")
end
local function Convert(Seconds)
    return math.floor(Seconds / 60), Seconds % 60;
end;
function isgame()
	if game.PlaceId == 5591597781 then
		return true
	else
		return false
	end
end
stateRep = nil
if isgame() then
	function getStateRep() for i,v in pairs(game:GetService("ReplicatedStorage").StateReplicators:GetChildren()) do if v:GetAttribute("TimeScale") then return v end end end
	repeat stateRep = getStateRep() until stateRep
end
local cashRep = nil
repeat
for i,v in pairs(game:GetService("ReplicatedStorage").StateReplicators:GetChildren()) do
    if v:GetAttribute("UserId") and v:GetAttribute("UserId") == game.Players.LocalPlayer.UserId then
        cashRep = v
    end
end
until cashRep
function CheckIfUpgrade(troop)
    local troopType = troop.Replicator:GetAttribute("Type")
    local upgradeNum = troop.Replicator:GetAttribute("Upgrade")
    local discountAmount = troop.Replicator:GetAttribute("DiscountBuff")
    local troopAssets = game:GetService("ReplicatedStorage").Assets.Troops[troopType]
    local nextUpgradePrice = require(troopAssets["Stats"]).Upgrades[upgradeNum+1].Cost
    if table.find(getgenv().GoldenPerks, troopType) then
        nextUpgradePrice = require(troopAssets["Stats_Golden"]).Upgrades[upgradeNum+1].Cost
    end
    if game:GetService("ReplicatedStorage").State.Difficulty.Value == "Hardcore" then
        nextUpgradePrice = math.floor(nextUpgradePrice*1.5)
    end
    if tonumber(discountAmount) > 0 then
        nextUpgradePrice = math.floor((nextUpgradePrice * (100-tonumber(discountAmount)))/100)
    end
    if cashRep:GetAttribute("Cash") >= nextUpgradePrice then
        return true
    else
        return false
    end
end
function CheckIfPlace(troopType)
    local troopAssets = game:GetService("ReplicatedStorage").Assets.Troops[troopType]
    local placePrice = require(troopAssets["Stats"]).Price
    if table.find(getgenv().GoldenPerks, troopType) then
        placePrice = require(troopAssets["Stats_Golden"]).Price
    end
    if game:GetService("ReplicatedStorage").State.Difficulty.Value == "Hardcore" then
        placePrice = math.floor(placePrice*1.5)
    end
    if cashRep:GetAttribute("Cash") >= placePrice then
        return true
    else
        return false
    end
end
local w = library:CreateWindow("Recorder")
w:Section("Last Record :")
w:Section("Recording")
local labelx
for i,v in pairs(game.CoreGui:GetDescendants()) do
    if v:IsA("TextLabel") and v.Text == "Recording" then
        labelx = v
    end
end
w:Section("")
w:Section("TimePassed")
    spawn(function()
        function TimeConverter(v)
            if v <= 9 then
                local conv = "0"..v
                return conv
            else
                return v
            end
        end
        local labelx = nil
        repeat
        for i,v in pairs(game.CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text == "TimePassed" then
            labelx = v
        end
        end
        task.wait()
        until labelx
        local startTime = os.time()
        while task.wait(0.1) do
        local t = os.time() - startTime
        local seconds = t % 60
        local minutes = math.floor(t / 60) % 60
        labelx.Text = "Time Passed : "..TimeConverter(minutes)..":"..TimeConverter(seconds)
        getgenv().TimePassed = "Time Passed : "..TimeConverter(minutes)..":"..TimeConverter(seconds)
        end
    end)
w:Section("")
w:Button("Auto Chain (One Time Use)", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/wxzex/mmsautostratcontinuation/main/autochainv1"))()
end)
w:Button("Auto Chain V2 (Multiple Uses)", function()
if not getgenv().OtherCOAV2 then
loadstring(game:HttpGet("https://raw.githubusercontent.com/wxzex/mmsautostratcontinuation/main/tdsautochainv2"))()
spawn(function()
repeat task.wait() until getgenv().Coms ~= nil
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local State = ReplicatedStorage.State;
local Wave = tonumber(stateRep:GetAttribute("Wave"));
local Timer = State.Timer;
local CurTime = Timer.Time.Value;
local TM, TS = Convert(CurTime);
local HalftTime = false
if Wave ~= 0 and game.Workspace:FindFirstChild("PathArrow") then
HalftTime = true
end
getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":AutoChain("..getgenv().Coms[1].Name..", "..getgenv().Coms[2].Name..", "..getgenv().Coms[3].Name..", "..Wave..", "..TM..", "..TS.."."..getgenv().WaveMillisecond..", "..tostring(HalftTime or "false")..")\n";
getgenv().Coms = nil
getgenv().recstatus = "AutoChainV2 Activated"
if getgenv().LoggerWindow then
    getgenv().outputRec("AutoChainV2 Activated")
end
end)
else
    getgenv().recstatus = "Can't activate AutoChainV2"
    if getgenv().LoggerWindow then
        getgenv().outputRec("Can't activate AutoChainV2")
    end
end
end)
w:Section("\\/ DANGER ZONE \\/")
w:Button("Sell All Farms", function()
    for i,v in pairs(game.Workspace.Towers:GetChildren()) do
        if getTroopType(v) == "Farm" and v.Owner.Value == game.Players.LocalPlayer.UserId then
            RSRF:InvokeServer("Troops","Sell",{["Troop"] = v,["Recorder"] = true})
            task.wait()
        end
    end
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local State = ReplicatedStorage.State;
local Wave = tonumber(stateRep:GetAttribute("Wave"));
local Timer = State.Timer;
local CurTime = Timer.Time.Value;
local TM, TS = Convert(CurTime);
getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":SellAllFarms( "..Wave..", "..TM..", "..TS.."."..getgenv().WaveMillisecond..")\n";
end)
w:Section("\\/ SAVE \\/")
w:Button("Save", function()
    writefile(getgenv().StratName..".txt", getgenv().Generated)
end)
w:Section("Auto_Save")
spawn(function()
    getgenv().AutoSave = 25
    while task.wait(1) do
        getgenv().AutoSave = getgenv().AutoSave - 1
        if getgenv().AutoSave == 0 then
            writefile(getgenv().StratName..".txt", getgenv().Generated)
            getgenv().AutoSave = 25
        end
    end
end)
spawn(function()
local labely = nil
repeat
for i,v in pairs(game.CoreGui:GetDescendants()) do
if v:IsA("TextLabel") and v.Text == "Auto_Save" then
    labely = v
end
end
task.wait()
until labelx
while task.wait(0.1) do
    labely.Text = "Auto Saving in: "..tostring(getgenv().AutoSave)
end
end)
spawn(function()
while task.wait() do
labelx.Text = getgenv().recstatus
end
end)
end

spawn(function()
cc = 0
if game.PlaceId == 5591597781 then
game:GetService("Workspace").Towers.ChildAdded:Connect(function(v)
repeat task.wait() until v:FindFirstChild("Owner") 
if v.Owner.Value == game.Players.LocalPlayer.UserId then
cc = cc + 1
v.Name = tostring(cc)
end
end)
end
end)

function getTroopTypeCheck(troop)
    return troop.Replicator:GetAttribute("Type")
end
function getTroopType(tr)
local check = getTroopTypeCheck(tr)
if check then
	return check
else
	return "Unable to GET"
end
end

local function Convert(Seconds)
    return math.floor(Seconds / 60), Seconds % 60;
end;



local Towers = {};
local GameTowers = game.Workspace.Towers;

spawn(function()
repeat task.wait() until getgenv().RecorderSync
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local State = ReplicatedStorage.State;
local Wave = tonumber(stateRep:GetAttribute("Wave"));
local Timer = State.Timer;
local CurTime = Timer.Time.Value;
local TM, TS = Convert(CurTime);
getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":AutoChain("..getgenv().Commanders[1].Name..", "..getgenv().Commanders[2].Name..", "..getgenv().Commanders[3].Name..", "..Wave..", "..TM..", "..TS.."."..getgenv().WaveMillisecond..")\n";
getgenv().recstatus = "Activated AutoChain"
if getgenv().LoggerWindow then
    getgenv().outputRec("Activated AutoChain")
end
sendw("Activated AutoChain")
end)

getgenv().GoldenPerks = {}
for TowerName, Tower in next, game.ReplicatedStorage.RemoteFunction:InvokeServer("Session", "Search", "Inventory.Troops") do
    if (Tower.Equipped) then
        if (Tower.GoldenPerks) then
            table.insert(getgenv().GoldenPerks, TowerName)
        end
    end;
end;
function checkIfGolden(Tower)
    return table.find(getgenv().GoldenPerks, Tower)
end
local changeThen = 0
game:GetService("ReplicatedStorage").State.Timer.Time:GetPropertyChangedSignal("Value"):Connect(function()
    changeThen = changeThen + 1
    local changeNow = changeThen
    getgenv().WaveMillisecond = 0
    for i=1,9 do
        if changeThen > changeNow then
            break
        end
        task.wait(0.09)
        if changeThen > changeNow then
            break
        end
        getgenv().WaveMillisecond = getgenv().WaveMillisecond + 1
    end
end)

local function passArgs(args, Msi, Wave, TM, TS, HalftTime, wasDid)
    if args[1] == "Troops" then
        if args[2] == "Place" then
            local PositionData = args[4]
            local Tower = args[3]
            local Position = PositionData.Position;
            if wasDid and type(wasDid) ~= "string" then
            if PositionData.Rotation.X > 0 or PositionData.Rotation.Y > 0 or PositionData.Rotation.Z > 0 then
                getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":Place('"..Tower.."', "..Position.X..", "..Position.Y..", "..Position.Z..", "..Wave..", "..TM..", "..TS.."."..Msi..", true, "..tostring(PositionData.Rotation.X)..", "..tostring(PositionData.Rotation.Y)..", "..tostring(PositionData.Rotation.Z)..", "..tostring(HalftTime or "false")..")\n";
            else
                getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":Place('"..Tower.."', "..Position.X..", "..Position.Y..", "..Position.Z..", "..Wave..", "..TM..", "..TS.."."..Msi..", false, 0, 0, 0, "..tostring(HalftTime or "false")..")\n";
            end
                getgenv().recstatus = "Placed "..Tower
                if getgenv().LoggerWindow then
                    getgenv().outputRec("Placed "..Tower)
                end
            sendw("Placed "..Tower)
            else
                getgenv().recstatus = "Failed To Place "..Tower
                if getgenv().LoggerWindow then
                    getgenv().outputRec("Failed To Place"..Tower)
                end
                sendw("Failed To Place "..Tower)
            end
        elseif args[2] == "Sell" then
            local Info = args[3]
            if not Info.Recorder then
                local ReplicatedStorage = game:GetService("ReplicatedStorage");
                local Index = Info.Troop.Name
                getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":Sell("..Index..", "..Wave..", "..TM..", "..TS.."."..Msi..", "..tostring(HalftTime or "false")..")\n";
                getgenv().recstatus = "Sold "..Info.Troop.Name
                if getgenv().LoggerWindow then
                    getgenv().outputRec("Sold "..Info.Troop.Name.." ("..getTroopType(Info.Troop)..")")
                end
                sendw("Sold "..Info.Troop.Name.." ("..getTroopType(Info.Troop)..")")
            end
        elseif args[2] == "Upgrade" and args[3] == "Set" then
            local Troop = args[4]
            local Index = Troop.Troop.Name;
            repeat task.wait() until Troop.Troop:FindFirstChild("Owner")
            if Troop.Troop:FindFirstChild("Owner").Value == game.Players.LocalPlayer.UserId then
            if wasDid ~= false then
            getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":Upgrade("..Index..", "..Wave..", "..TM..", "..TS.."."..Msi..", "..tostring(HalftTime or "false")..")\n";
            getgenv().recstatus = "Upgraded "..Troop.Troop.Name
            if getgenv().LoggerWindow then
                getgenv().outputRec("Upgraded "..Troop.Troop.Name)
            end
            sendw("Upgraded "..Index.." ("..getTroopType(Troop.Troop)..")")
            else
                getgenv().recstatus = "Failed To Upgrade "..Troop.Troop.Name
                if getgenv().LoggerWindow then
                    getgenv().outputRec("Failed To Upgrade "..Troop.Troop.Name)
                end
                sendw("Failed To Upgrade "..Troop.Troop.Name)
            end
            end
        elseif args[2] == "Target" and args[3] == "Set" then
            local Troop = args[4]
            local Index = Troop.Troop.Name
            local Target = Troop.Target
            getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":Target("..Index..", "..Wave..", \""..Target.."\", "..TM..", "..TS.."."..Msi..", "..tostring(HalftTime or "false")..")\n";
            getgenv().recstatus = "Changed Target "..Troop.Troop.Name
            if getgenv().LoggerWindow then
                getgenv().outputRec("Changed Target "..Troop.Troop.Name.." ("..getTroopType(Troop.Troop)..")")
            end
            sendw("Changed Target "..Troop.Troop.Name.." ("..getTroopType(Troop.Troop)..")")
        elseif args[2] == "Abilities" and args[3] == "Activate" then
            local Info = args[4]
            local Troop, Ability = Info.Troop, Info.Name;
            local Index = Info.Troop.Name
            if Info.AutoChain == nil then
                getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":Ability("..Index..", \""..Ability.."\", "..Wave..", "..TM..", "..TS.."."..Msi..", "..tostring(HalftTime or "false")..")\n";
                getgenv().recstatus = "Activated "..Info.Name.." In "..Info.Troop.Name
                if getgenv().LoggerWindow then
                    getgenv().outputRec("Activated "..Info.Name.." In "..Info.Troop.Name)
                end
                sendw("Activated "..Info.Name.." In "..Info.Troop.Name)
            end
        end
    elseif args[1] == "Voting" and args[2] == "Skip" then
        getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":Skip("..Wave..", "..TM..", "..TS.."."..Msi..", "..tostring(HalftTime or "false")..")\n";
        getgenv().recstatus = "Skipped Wave"
        if getgenv().LoggerWindow then
            getgenv().outputRec("Skipped Wave")
        end
        sendw("Skipped Wave")
    elseif args[1] == "Difficulty" and args[2] == "Vote" then
        local Difficulty = args[3]
        local DiffTable = {["Easy"] = "Normal", ["Normal"] = "Molten", ["Fallen"] = "Fallen", ["Intermediate"] = "Intermediate"}
        if game:GetService("ReplicatedStorage").State.Mode.Value == "Survival" then
            getgenv().Generated = getgenv().Generated .. getgenv().APIVar..":Mode('"..Difficulty.."' --[[ !DONT TOUCH! THIS IS CORRECT, IN GAME FILES "..DiffTable[Difficulty].." IS NAMED "..Difficulty.." ]])\n";
            getgenv().recstatus = "Voted For Difficulty"
            if getgenv().LoggerWindow then
                getgenv().outputRec("Voted For Difficulty")
            end
            sendw("Voted For Difficulty")
        end
    end
end

old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if getnamecallmethod() == "InvokeServer" and self.name == "RemoteFunction" and not table.find(args, "Rec") then
        local thread = coroutine.running()
        coroutine.wrap(function(args, stateRep)
            local Msi = getgenv().WaveMillisecond
            local Wave = tonumber(stateRep:GetAttribute("Wave"))
            local function Convert(Seconds) return math.floor(Seconds / 60), Seconds % 60; end
            local TM, TS = Convert(game.ReplicatedStorage.State.Timer.Time.Value)
            local HalftTime = false
            if Wave ~= 0 and game.Workspace:FindFirstChild("PathArrow") then
            HalftTime = true
            end
            table.insert(args, "Rec")
            if args[2] == "Place" then
                conn = game.Workspace.Towers.ChildAdded:Connect(function(v)
                    repeat task.wait() until v:FindFirstChild("Replicator")
                    if v.Owner.Value == game.Players.LocalPlayer.UserId and v.Replicator:GetAttribute("Type") == args[3] then
                        local selectModule = require(game:GetService("ReplicatedStorage").Client.Modules.Game.Interface.Elements.Upgrade.upgradeHandler) 
                        selectModule.selectTroop(selectModule, v)
                        conn:Disconnect()
                    end
                end)
            end
            local wasDid = self.InvokeServer(self, unpack(args))
            passArgs(args, Msi, Wave, TM, TS, HalftTime, wasDid)
            coroutine.resume(thread,wasDid)
        end)(args, stateRep)
        return coroutine.yield()
    end
    return old(self, ...)
end)
