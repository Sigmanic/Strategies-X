local SendRequest = http_request or request or HttpPost or syn.request
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MatchGui = LocalPlayer.PlayerGui:WaitForChild("ReactGameRewards"):WaitForChild("Frame"):WaitForChild("gameOver") -- end result
local Info = MatchGui:WaitForChild("content"):WaitForChild("info")
local Stats = Info.stats
local Rewards = Info:WaitForChild("rewards")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "???"
local UtilitiesConfig = StratXLibrary.UtilitiesConfig
local PlayerInfo = StratXLibrary.UI.PlayerInfo.Property

local CommaText = function(string)
	local String = tostring(string):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
	return String
end
local TimeFormat = function(string)
	local Time = string.gsub(string,"%D+",":"):gsub(".?$","")
	return Time
end
local function CheckTower()
	local str = ""
	local TowerInfo = StratXLibrary.TowerInfo or {}
	for i,v in next, TowerInfo do
		str = `{str}\n{v[3]}: {v[2]}`
	end
	return str
end

local CheckColor = {
	["TRIUMPH!"] = tonumber(65280),
	["YOU LOST"] = tonumber(16711680),
	[true] = tonumber(65280),
	[false] = tonumber(16711680),
}

local Identifier = {
	["rbxassetid://17429548305"] = "Supply Drop",
	["rbxassetid://17448596007"] = "Airstrike",
	["rbxassetid://17429541513"] = "Barricade",
	["rbxassetid://17429537022"] = "Blizzard Bomb",
	["rbxassetid://17438487774"] = "Cooldown Flag",
	["rbxassetid://17438486138"] = "Damage Flag",
	["rbxassetid://17430416205"] = "Flash Bang",
	["rbxassetid://17429533728"] = "Grenade",
	["rbxassetid://17437703262"] = "Molotov",
	["rbxassetid://17448596749"] = "Napalm Strike",
	["rbxassetid://17430415569"] = "Nuke",
	["rbxassetid://124568805305441"] = "Pumpkin Bomb",
	["rbxassetid://17438486690"] = "Range Flag",
	["rbxassetid://114595010548022"] = "Sugar Rush",
	["rbxassetid://128078447476652"] = "Turkey Leg",
	["rbxassetid://17448597451"] = "UAV",
	["rbxassetid://7610093373"] = "Winter Storm",
	["rbxassetid://5870325376"] = "Coins",
	["rbxassetid://5870383867"] = "Gems",
	["rbxassetid://18493073533"] = "Spin Tickets",
	["rbxassetid://17447507910"] = "Timescale Tickets",
	["rbxassetid://18557179994"] = "Revive Tickets",
}

function NewWebhook(Link)
	local Data = {
		WebhookLink = Link,
		WebhookData = {
			embeds = {}
		}
	}

	local Webhook = {}

	function Webhook.AddMessage(Message)
		if Message then
			Data.WebhookData.content = Message
		end
		return Webhook
	end

	function Webhook.Profile(Username, Avatar)
		Username = Username or "Not Specified"
		Avatar = Avatar or ""

		Data.WebhookData.username = Username
		Data.WebhookData.avatar_url = Avatar

		return Webhook
	end

	function Webhook:CreateEmbed()
		local NewEmbed = {}
		table.insert(Data.WebhookData.embeds, NewEmbed)
		local EmbedFunctions = {}

		function EmbedFunctions.AddTitle(title)
			if title then
				NewEmbed.title = title
			end
			return EmbedFunctions
		end

		function EmbedFunctions.AddDescription(description)
			if description then
				NewEmbed.description = description
			end
			return EmbedFunctions
		end

		function EmbedFunctions.AddColor(Color)
			Color = Color or "#00ff52"
			NewEmbed.color = Color
			return EmbedFunctions
		end

		function EmbedFunctions.AddAuthor(Name, Link, Icon)
			NewEmbed.author = {}
			if Name then
				NewEmbed.author.name = Name
			end
			if Link then
				NewEmbed.author.url = Link
			end
			if Icon then
				NewEmbed.author.icon_url = Icon
			end
			return EmbedFunctions
		end

		function EmbedFunctions.AddField(Name, Value, Inline)
			NewEmbed.fields = NewEmbed.fields or {}
			local Field = {}
			Field["name"] = Name
			Field["value"] = Value
			if Inline ~= nil then
				Field["inline"] = Inline
			else
				Field["inline"] = true
			end
			table.insert(NewEmbed.fields, Field)
			--table.insert(NewEmbed.fields, {name = Name, value = Value, inline = Inline or false}) -- Inline is Sigma
			return EmbedFunctions
		end

		function EmbedFunctions.AddImage(Link)
			NewEmbed.image = {}
			if Link then
				NewEmbed.image.url = Link
			end
			return EmbedFunctions
		end

		function EmbedFunctions.AddThumbnail(Link)
			NewEmbed.thumbnail = {}
			if Link then
				NewEmbed.thumbnail.url = Link
			end
			return EmbedFunctions
		end

		function EmbedFunctions.AddFooter(Text, Icon)
			NewEmbed.footer = {}
			if Text then
				NewEmbed.footer.text = Text
			end
			if Icon then
				NewEmbed.footer.icon_url = Icon
			end
			return EmbedFunctions
		end

		function EmbedFunctions:Send()
			local Request = SendRequest

			if Request == nil then
				warn("Executor not supported.")
				return
			end

			local Respone = Request({
				Url = Data.WebhookLink,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = game:GetService("HttpService"):JSONEncode(Data.WebhookData)
			});

		end

		return EmbedFunctions
	end

	-- // Debugging Function
	function Webhook.GetFormattedData()
		return Data.WebhookData
	end

	function Webhook:Send()
		local Request = SendRequest
		if Request == nil then
			warn("Executor not supported.")
			return
		end
		local Respone = Request({
			Url = Data.WebhookLink,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = game:GetService("HttpService"):JSONEncode(Data.WebhookData)
		});
	end
	return Webhook
end


local Link = UtilitiesConfig.Webhook.Link
local Webhook = NewWebhook(Link)
Webhook.AddMessage("")

local Start = tick()
local ToSurpass = Start + 1.3
local Embed = Webhook:CreateEmbed()
Embed.AddTitle("**Strategies X Webhook**")
Embed.AddColor(CheckColor[MatchGui:WaitForChild("banner"):WaitForChild("textLabel").Text])
Embed.AddFooter(`{os.date("%X")} {os.date("%x")}`)
Embed.AddField("------------------ GAME INFO ----------------","",false)
Embed.AddField("Map:",ReplicatedStorage.State.Map.Value)
Embed.AddField("Mode:",ReplicatedStorage.State.Difficulty.Value)
Embed.AddField("Wave / Health:",LocalPlayer.PlayerGui.ReactGameTopGameDisplay.Frame.wave.container.value.Text.." / "..tostring(ReplicatedStorage.State.Health.Current.Value).." ("..tostring(ReplicatedStorage.State.Health.Max.Value)..")")
Embed.AddField("Game Time:",TimeFormat(Stats.duration.Text))

repeat
	task.wait()
until (Rewards:FindFirstChild("1") ~= nil and Rewards:FindFirstChild("2") ~= nil) or (ToSurpass < tick())

for i , v in next, Rewards:GetChildren() do
	if v:IsA("Frame") then
		local TextLabel = v:WaitForChild("content"):WaitForChild("textLabel")
		if tonumber(TextLabel.Text) == nil then
			if string.match(TextLabel.Text, "XP") then
				Embed.AddField("Won Experiences:", TextLabel.Text)
				continue
			end
			Embed.AddField("Won Misc:", "1x "..TextLabel.Text)
		else
			local icon = v:WaitForChild("content"):FindFirstChild("icon")
			if icon:IsA("ImageLabel") then
				if Identifier[icon.Image] == nil then
					Embed.AddField("Won Unidentified Item:", "1x "..TextLabel.Text, icon.Image)
				else
					Embed.AddField("Won "..Identifier[icon.Image]..":", TextLabel.Text)
				end
			end
		end
	end
end

Embed.AddField("----------------- PLAYER INFO ---------------","", false)
Embed.AddField("Username:", (UtilitiesConfig.Webhook.HideUser and "Anonymous") or LocalPlayer.Name)
Embed.AddField("Display Name:", (UtilitiesConfig.Webhook.HideUser and "Anonymous") or LocalPlayer.DisplayName)
Embed.AddField("Executor Used:", Executor)
Embed.AddField("Level:", CommaText(PlayerInfo.Level).." :chart_with_upwards_trend:")
Embed.AddField("Coins:", CommaText(PlayerInfo.Coins).." :coin:")
Embed.AddField("Gems:", CommaText(PlayerInfo.Gems).." :gem:")
Embed.AddField("Triumphs:", CommaText(PlayerInfo.Triumphs).." :trophy:")
Embed.AddField("Loses:", CommaText(PlayerInfo.Loses).." :skull:")
Embed.AddField("Exp:", CommaText(PlayerInfo.Experience).." :star:")
Embed.AddField("Spin Tickets:", CommaText(PlayerInfo.SpinTickets).." :tickets:")
Embed.AddField("Revive Tickets:", CommaText(PlayerInfo.ReviveTickets).." :ticket:")
Embed.AddField("Timescale Tickets:", CommaText(PlayerInfo.TimescaleTickets).." :tickets:")
Embed.AddField("----------------- TROOPS INFO ---------------", "```m\n"..CheckTower().."```", false)

if #UtilitiesConfig.Webhook.Link ~= 0 then
	getgenv().SendCheck = Webhook:Send()
end