local SendRequest = http_request or request or HttpPost or syn.request
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MatchGui = LocalPlayer.PlayerGui.RoactGame.Rewards.content.gameOver
local Info = MatchGui.content.info
local Stats = Info.stats
local Rewards = Info.rewards
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Executor = identifyexecutor()
local UtilitiesConfig = StratXLibrary.UtilitiesConfig


local CommaText = function(string)
   local String = tostring(string):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
   return String
end
local TimeFormat = function(string)
   local Time = string.gsub(string,"%D+",":"):gsub(".?$","")
   return Time
end

local GameInfo
local GetGameInfo = getgenv().GetGameInfo or function()
   if GameInfo then
      return GameInfo
   end
   repeat
      for i,v in next, ReplicatedStorage.StateReplicators:GetChildren() do
         if v:GetAttribute("TimeScale") then
               GameInfo = v
               return v
         end
      end
      task.wait()
   until GameInfo
end

local function CheckStatus()
   return MatchGui.banner.textLabel.Text
end
local function CheckReward()
   local RewardType
   repeat task.wait() until Rewards[1] and Rewards[2]
   if Rewards[2].content.icon.Image == "rbxassetid://5870325376" then
      RewardType = "Coins"
   else
      RewardType = "Gems"
   end
   return {RewardType, Rewards[2].content.textLabel.Text..((RewardType == "Coins" and " :coin:") or (RewardType == "Gems" and " :gem:") or "")}
end

local function CheckTower()
   local str = ""
   local TowerInfo = StratXLibrary.TowerInfo or {}
   for i,v in next, TowerInfo do
      str = str.."\n"..v[3].." : "..tostring(v[2])
   end
   return str
end

local CheckColor = {
   ["TRIUMPH!"] = tonumber(65280),
   ["YOU LOST"] = tonumber(16711680),
}

local GetReward = CheckReward()

local Data = {
   ["content"] = "",
   ["embeds"] = {
      {
         ["title"] = "**Strategies X Logger ("..os.date("%X").." "..os.date("%x")..")**",
         ["color"] = CheckColor[CheckStatus()], --decimal
         ["fields"] = {
            {
               ["name"] = "-------------------- PLAYER INFO --------------------",
               ["value"] = "",
            },
            {
               ["name"] = "Username:",
               ["value"] = (UtilitiesConfig.Webhook.HideUser and "Anonymous") or LocalPlayer.Name,
               ["inline"] = true
            },
            {
               ["name"] = "Display Name:",
               ["value"] = (UtilitiesConfig.Webhook.HideUser and "Anonymous") or LocalPlayer.DisplayName,
               ["inline"] = true
            },
            {
               ["name"] = "Executor Used:",
               ["value"] = Executor,
               ["inline"] = true
            },
            {
               ["name"] = "Level:",
               ["value"] = CommaText(LocalPlayer.Level.Value).." :chart_with_upwards_trend:",
               ["inline"] = true
            },
            {
               ["name"] = "Coins:",
               ["value"] = CommaText(LocalPlayer.Coins.Value).." :coin:",
               ["inline"] = true
            },
            {
               ["name"] = "Gems:",
               ["value"] = CommaText(LocalPlayer.Gems.Value).." :gem:",
               ["inline"] = true
            },
            {
               ["name"] = "Triumphs:",
               ["value"] = CommaText(LocalPlayer.Triumphs.Value).." :trophy:",
               ["inline"] = true
            },
            {
               ["name"] = "Loses:",
               ["value"] = CommaText(LocalPlayer.Loses.Value).." :skull:",
               ["inline"] = true
            },
            {
               ["name"] = "Exp:",
               ["value"] = CommaText(LocalPlayer.Experience.Value).." :star:",
               ["inline"] = true
            },
            {
               ["name"] = "-------------------- GAME INFO ---------------------",
               ["value"] = "",
            },
            {
               ["name"] = "Map:",
               ["value"] = ReplicatedStorage.State.Map.Value,
               ["inline"] = true
            },
            {
               ["name"] = "Mode:",
               ["value"] = ReplicatedStorage.State.Difficulty.Value,
               ["inline"] = true
            },
            {
               ["name"] = "Wave / Health:",
               ["value"] = GetGameInfo():GetAttribute("Wave").." / "..tostring(ReplicatedStorage.State.Health.Current.Value).." ("..tostring(ReplicatedStorage.State.Health.Max.Value)..")",
               ["inline"] = true
            },
            {
               ["name"] = "Game Time:",
               ["value"] = TimeFormat(Stats.duration.Text),
               ["inline"] = true
            },
            {
               ["name"] = "Won "..GetReward[1]..":",
               ["value"] = GetReward[2],
               ["inline"] = true
            },
            {
               ["name"] = "Won Experiences:",
               ["value"] = string.split(Rewards[1].content.textLabel.Text," XP")[1].." :star:",
               ["inline"] = true
            },
            {
               ["name"] = "-------------------- TROOPS INFO --------------------",
               ["value"] = "```m\n"..CheckTower().."```",
               ["inline"] = true
            },
         }
      }
   }
}
local SendData = {
   Url = UtilitiesConfig.Webhook.Link, 
   Body = game:GetService("HttpService"):JSONEncode(Data), 
   Method = "POST", 
   Headers = {
       ["content-type"] = "application/json"
   }
}
getgenv().SendCheck = SendRequest(SendData)