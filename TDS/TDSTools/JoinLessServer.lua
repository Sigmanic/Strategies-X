local function GetServersInfo(Placeid,MinPlr,MaxPlr)
    local Cancel = false
    local Servers = {}
    local CurrentCursor = ""
    repeat
        local Success = pcall(function()
            local ListRaw = game:HttpGetAsync("https://games.roblox.com/v1/games/"..tostring(Placeid).."/servers/Public?sortOrder=Asc&limit=100&cursor="..CurrentCursor)
            local CurrentList = game:GetService("HttpService"):JSONDecode(ListRaw)
            for i = 1,#CurrentList.data do
                if CurrentList.data[i].playing >= tonumber(MinPlr) and CurrentList.data[i].playing <= tonumber(MaxPlr) then
                    table.insert(Servers, CurrentList.data[i])
                elseif CurrentList.data[i].playing > tonumber(MaxPlr) then
                    Cancel = true
                    break
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
function TeleportHandler(Id,MinPlayers,MaxPlayers)
    local Id = Id or game.PlaceId
    local MinPlayers = MinPlayers or 1
    local MaxPlayers = MaxPlayers or 3
    if string.match(identifyexecutor():lower(),"solara") then
        game:GetService("TeleportService"):Teleport(Id)
        return
    end
    task.delay(20, function()
        game:GetService("TeleportService"):Teleport(Id)
    end)
    local GetServers = GetServersInfo(Id,MinPlayers,MaxPlayers)
    local GetServerId = GetServers[1]
    local FailedConnection = game:GetService("TeleportService").TeleportInitFailed:Connect(function(Player, Result, Msg)
        if Player == game:GetService("Players").LocalPlayer and (Result == Enum.TeleportResult.Unauthorized or Result == Enum.TeleportResult.GameEnded or Result == Enum.TeleportResult.GameFull) then
            table.remove(GetServers,table.find(GetServers,GetServerId))
            GetServerId = GetServers[1]
            if not GetServerId then 
                MinPlayers = MaxPlayers - 1
                repeat
                    MaxPlayers = MaxPlayers + 2
                    GetServers = GetServersInfo(Id,MinPlayers,MaxPlayers)
                    GetServerId = GetServers[1]
                    task.wait()
                until GetServerId
            end
            game:GetService("TeleportService"):TeleportToPlaceInstance(Id, GetServerId.id, game:GetService("Players").LocalPlayer)
        end
    end) 
    if not GetServerId then
        repeat
            MaxPlayers = MaxPlayers + 2
            GetServers = GetServersInfo(Id,MinPlayers,MaxPlayers)
            GetServerId = GetServers[1]
            task.wait()
        until GetServerId
    end
    print("Teleport:",GetServerId.id,GetServerId.playing)
    game:GetService("TeleportService"):TeleportToPlaceInstance(Id, GetServerId.id, game:GetService("Players").LocalPlayer)
end