local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RemoteFunction = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteFunction") else SpoofEvent
local RemoteEvent = if not GameSpoof then ReplicatedStorage:WaitForChild("RemoteEvent") else SpoofEvent
--[[{
    ["Wave"] = number,
    ["Minute"] = number,
    ["Second"] = number,
}]]
return function(self, p1)
    local tableinfo = p1--ParametersPatch("Skip",...)
    local Wave,Min,Sec,InWave = tableinfo["Wave"] or 0, tableinfo["Minute"] or 0, tableinfo["Second"] or 0, tableinfo["InBetween"] or false
    if not CheckPlace() then
        return
    end
    local VoteGUI = LocalPlayer.PlayerGui:WaitForChild("ReactOverridesVote"):WaitForChild("Frame"):WaitForChild("votes"):WaitForChild("vote") -- it is what it is
    SetActionInfo("Skip","Total")
    task.spawn(function()
        if not TimeWaveWait(Wave, Min, Sec, InWave, tableinfo["Debug"]) then
            return
        end
        local SkipCheck
        if VoteGUI:WaitForChild("count").Text ~= `0/{#Players:GetChildren()} Required` then
            repeat
                task.wait()
            until VoteGUI:WaitForChild("count").Text == `0/{#Players:GetChildren()} Required`
        end
        if VoteGUI.Position ~= UDim2.new(0.5, 0, 0.5, 0) then --UDim2.new(scale_x, offset_x, scale_y, offset_y)
            return
        end
        repeat
            if VoteGUI:WaitForChild("prompt").Text ~= "Skip Wave?" then
                return
            end
            SkipCheck = RemoteFunction:InvokeServer("Voting", "Skip")
            task.wait()
        until SkipCheck or VoteGUI:WaitForChild("count").Text ~= `0/{#Players:GetChildren()} Required`
        SetActionInfo("Skip")
        ConsoleInfo(`Skipped Wave {Wave} (Min: {Min}, Sec: {Sec}, InBetween: {InWave})`)
    end)
end