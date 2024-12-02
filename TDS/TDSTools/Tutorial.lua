local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
local TDS = Strat.new()
TDS:Map("Tutorial", true, "Tutorial")
if not CheckPlace() then
    return 
end
function WaitSpotlight()
    repeat 
        task.wait()
    until LocalPlayer.PlayerGui.Tutorial.tutorial.Spotlight and LocalPlayer.PlayerGui.Tutorial.tutorial.Spotlight.Visible
    task.wait(.5)
end
local SelectedTower = {"Scout","Sniper","Demoman","Medic","Minigunner",}
for i,v in next, SelectedTower do
    StratXLibrary.TowerInfo[v] = {maintab:Section(v.." : 0"), 0, v}
end
TimeWaveWait(1,0,0,true)
WaitSpotlight()
RemoteEvent:FireServer("Hotbar", "Click", 1)
TDS:Place("Scout", 10.461, 17.695, -28.165, 1, 0, 0, true, 0, 0, 0)

TimeWaveWait(2,0,0,true)
WaitSpotlight()
RemoteEvent:FireServer("Hotbar", "Click", 2)
TDS:Place("Sniper", 12.647, 20.162, -0.038, 2, 0, 0, true, 0, 0, 0)

TimeWaveWait(3,0,0,true)
WaitSpotlight()
RemoteEvent:FireServer("Hotbar", "Click", 3)
TDS:Place("Demoman", 20.536, 18.175, -16.671, 3, 0, 0, true, 0, 0, 0)

TimeWaveWait(4,0,0,true)
task.wait(15)
TDS:Upgrade(1, 4, 0, 0, true)
TDS:Upgrade(1, 4, 0, 0, true)
task.wait(.5)
TDS:Upgrade(2, 4, 0, 0, true)
TDS:Upgrade(2, 4, 0, 0, true)

TimeWaveWait(5,0,0,true)
WaitSpotlight()
RemoteEvent:FireServer("Hotbar", "Click", 4)
TDS:Place("Medic", 20.68, 17.921, 16.738, 5, 0, 0, true, 0, 0, 0)

TimeWaveWait(6,0,0,true)
task.wait(15)
--WaitSpotlight()
TDS:Sell(1, 6, 0, 0, true)
task.wait(.5)
TDS:Sell(2, 6, 0, 0, true)
task.wait(1.7)
RemoteEvent:FireServer("Hotbar", "Click", 5)
TDS:Place("Minigunner", 24.955, 17.919, 0.2, 6, 0, 0, true, 0, 0, 0)
