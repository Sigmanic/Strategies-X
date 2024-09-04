function SetUIText(name,string)
    local UI = (StratXLibrary and StratXLibrary.UI) or UI
    if UI and UI[name] then
        local Name = UI[name]
        Name:SetText(string)
    else
        print(name,":",string)
    end
end
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
local TeleportService = game:GetService("TeleportService")
        
return function(self, p1)
    local tableinfo = p1
    local TotalTowers = tableinfo
    local GoldenTowers = tableinfo["Golden"] or {}
    local LoadoutProps = self.Loadout
    local AllowEquip = tableinfo["AllowEquip"] or false
    local SkipCheck = tableinfo["SkipCheck"] or false
    LoadoutProps.AllowTeleport = type(LoadoutProps.AllowTeleport) == "boolean" and LoadoutProps.AllowTeleport or false
    local TroopsOwned = GetTowersInfo()
    for i,v in next, LoadoutProps do
        if string.find(typeof(v):lower(),"thread") then
            task.cancel(v)
        end
    end

    if CheckPlace() then
        for i,v in ipairs(TotalTowers) do
            if not (TroopsOwned[v] and TroopsOwned[v].Equipped) then
                prints("Loadout",v,TroopsOwned[v] and TroopsOwned[v].Equipped)
                ConsoleInfo(`Tower "{v}" Didn't Equipped. Rejoining To Lobby`)
                task.wait(1)
                --TeleportHandler(3260590327,2,7)
                TeleportService:Teleport(3260590327, LocalPlayer) --Do instant teleport maybe avoid detect place wrong tower
                return
            end
        end
        ConsoleInfo("Loadout Selected: \""..table.concat(TotalTowers, "\", \"").."\"")
        return
    end
    --UI.EquipStatus:SetText("Troops Loadout: Equipping")

    self.Loadout.Task = task.spawn(function()
        if not SkipCheck then
            local MissingTowers = {}
            for i,v in ipairs(TotalTowers) do
                if not TroopsOwned[v] then
                    table.insert(MissingTowers,v)
                end
            end
            if #MissingTowers ~= 0 then
            --UI.EquipStatus:SetText("Troops Loadout: Missing")
            LoadoutProps.AllowTeleport = false
                repeat
                    TroopsOwned = GetTowersInfo()
                    for i,v in next, MissingTowers do
                        if not TroopsOwned[v] then
                            if true then
                                local BoughtCheck, BoughtMsg = RemoteFunction:InvokeServer("Shop", "Purchase", "tower",v)
                                if BoughtCheck or (type(BoughtMsg) == "string" and string.find(BoughtMsg,"Player already has tower")) then
                                    print(v..": Bought")
                                    --UI.TowersStatus[i].Text = v..": Bought"
                                else
                                    local TowerPriceStat = require(game:GetService("ReplicatedStorage").Content.Tower[v].Stats).Properties.Price
                                    local Price = tostring(TowerPriceStat.Value)
                                    local TypePrice = if tonumber(TowerPriceStat.Type) < 3 then "Coins" else "Gems"
                                    print(v..": Need "..Price.." "..TypePrice)
                                    --UI.TowersStatus[i].Text = v..": Need "..Price.." "..TypePrice
                                end
                            else
                                print(v..": Missing")
                                --UI.TowersStatus[i].Text = v..": Missing"
                            end
                        else
                            MissingTowers[i] = nil
                        end
                    end
                    task.wait(.5)
                until #MissingTowers == 0
            end
        end
        LoadoutProps.AllowTeleport = true
        if AllowEquip then
            local TroopsOwned = GetTowersInfo()
            for i,v in next, TroopsOwned do
                if v.Equipped then
                    RemoteEvent:FireServer("Inventory","Unequip","Tower",i)
                end
            end

            for i,v in ipairs(TotalTowers) do
                RemoteEvent:FireServer("Inventory", "Equip", "tower",v)
                local GoldenCheck = table.find(GoldenTowers,v)
                UI.TowersStatus[i].Text = (GoldenCheck and "[Golden] " or "")..v
                if TroopsOwned[v].GoldenPerks and not GoldenCheck then
                    RemoteEvent:FireServer("Inventory", "Unequip", "Golden", v)
                elseif GoldenCheck then
                    RemoteEvent:FireServer("Inventory", "Equip", "Golden", v)
                end
            end
            --UI.EquipStatus:SetText("Troops Loadout: Equipped")
            ConsoleInfo("Loadout Selected: \""..table.concat(TotalTowers, "\", \"").."\"")
        end
    end)
end