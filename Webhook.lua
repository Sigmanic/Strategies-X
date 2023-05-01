local SendRequest = http_request or request or HttpPost or syn.request
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GameGui = LocalPlayer.PlayerGui.GameGui
local Content = GameGui.Results.Content
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Executor = identifyexecutor()
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
   for i,v in next,Content.Titles:GetChildren() do
      if v.Name ~= "Triumph2" and v.Visible == true then
         return tostring(v.Name)
      end
   end
end
local function CheckReward()
   for i,v in next,Content.Rewards:GetChildren() do
      if (v.Name == "Coins" or v.Name == "Gems") and v.Visible == true then
         return {v.Name,v.TextLabel.Text..((v.Name == "Coins" and " :coin:") or (v.Name == "Gems" and " :gem:") or "")}
      end
   end
end
local function CheckTower()
   local str = ""
   local TowerInfo = getgenv().TowerInfo or {}
   for i,v in next, TowerInfo do
      str = str.."\n"..v[3].." : "..tostring(v[2])
   end
   return str
end

local CheckColor = {
   ["Triumph"] = tonumber(65280),
   ["Lose"] = tonumber(16711680),
}
local CommaText = function(string)
   return tostring(string):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
local CheckRewardTable = CheckReward()
repeat 
   CheckRewardStr = CheckReward() 
   task.wait()
until type(CheckRewardTable) == "table"

local Data = {
   ["content"] = "",
   ["embeds"] = {
      {
         ["title"] = "**Strategies X Logger ("..os.date("%X").." "..os.date("%x")..")**",
         ["color"] = CheckColor[CheckStatus()], --decimal
         ["fields"] = {
            {
               ["name"] = "--------------------- PLAYER INFO --------------------",
               ["value"] = "",
            },
            {
               ["name"] = "Username:",
               ["value"] = (getgenv().UtilitiesConfig.Webhook.HideUser and "Anonymous") or LocalPlayer.Name,
               ["inline"] = true
            },
            {
               ["name"] = "Display Name:",
               ["value"] = (getgenv().UtilitiesConfig.Webhook.HideUser and "Anonymous") or LocalPlayer.DisplayName,
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
               ["name"] = "--------------------- GAME INFO ---------------------",
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
               ["value"] = GetGameInfo():GetAttribute("Wave").." / "..tostring(ReplicatedStorage.State.Health.Current.Value),
               ["inline"] = true
            },
            {
               ["name"] = "Game Time:",
               ["value"] = Content.Stats.Duration.Text,
               ["inline"] = true
            },
            {
               ["name"] = "Won "..CheckReward()[1]..":",
               ["value"] = CheckReward()[2],
               ["inline"] = true
            },
            {
               ["name"] = "Won Experiences:",
               ["value"] = Content.Rewards.Experience.TextLabel.Text,
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
   Url = readfile("TDS_AutoStrat/Webhook (Logs).txt"), 
   Body = game:GetService("HttpService"):JSONEncode(Data), 
   Method = "POST", 
   Headers = {
       ["content-type"] = "application/json"
   }
}
SendRequest(SendData)