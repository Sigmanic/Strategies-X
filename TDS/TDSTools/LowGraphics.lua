local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local MinimizeConfig = {
    [true] = {
        fps = 25,
        QualityLevel = Enum.QualityLevel.Level01,
        PhysicsThrottle = Enum.EnviromentalPhysicsThrottle.Disabled,
        Technology = Enum.Technology.Compatibility,
        GlobalShadows = false,
        Set3dRenderingEnabled = false,
    }
}
getgenv().MinimizeClient = getgenv().MinimizeClient or function(boolean)
    local boolean = if type(boolean) == "boolean" then boolean else true
    if not MinimizeConfig[false] then
        MinimizeConfig[false] = {
            fps = 60,
            GlobalShadow = Lighting.GlobalShadows,
            PhysicsThrottle = settings().Physics.PhysicsEnvironmentalThrottle,
            QualityLevel = settings():GetService("RenderSettings").QualityLevel,
            Technology = Enum.Technology.ShadowMap, --if gethiddenproperty then gethiddenproperty(Lighting, "Technology") else Enum.Technology.ShadowMap,
            Set3dRenderingEnabled = true,
        }
    end
    local Config = MinimizeConfig[boolean]
    pcall(function()
        setfpscap(Config.fps)
    end)
    settings():GetService("RenderSettings").QualityLevel = Config.QualityLevel
    settings().Physics.PhysicsEnvironmentalThrottle = Config.PhysicsThrottle
    if sethiddenproperty then
        sethiddenproperty(Lighting, "Technology", Config.Technology)
    end
    Lighting.GlobalShadows = Config.GlobalShadow
    game:GetService("RunService"):Set3dRenderingEnabled(Config.Set3dRenderingEnabled)
    for i,v in next, Lighting:GetChildren() do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") and v.Enabled ~= not boolean then
            v.Enabled = not boolean
        end
    end
end

local Folder = Instance.new("Folder")
Folder.Parent = ReplicatedStorage
Folder.Name = "Map"
StratXLibrary.LowGraphics = function(bool)
    local GameMode = if Workspace:FindFirstChild("IntermissionLobby") then "Survival" else "Hardcore"
	local Lobby = if GameMode == "Survival" then "IntermissionLobby" else "HardcoreIntermissionLobby"
    local Location = if not CheckPlace() then "Lobby" elseif Workspace:FindFirstChild(Lobby) then "Environment" else "Map"
    if Location == "Environment" then
        if not Workspace:FindFirstChild(Lobby):FindFirstChild(Location) then
            prints("Waiting Map Loaded to Use LowGraphics")
            repeat
                task.wait()
            until Workspace:FindFirstChild(Lobby):FindFirstChild(Location)
            task.wait(1)
        end
    elseif Location == "Lobby" then
        if not Workspace:WaitForChild("NewLobby"):WaitForChild("Areas"):FindFirstChild(Location) then
            prints("Waiting Map Loaded to Use LowGraphics")
            repeat
                task.wait()
            until Workspace:WaitForChild("NewLobby"):WaitForChild("Areas"):FindFirstChild(Location)
            task.wait(1)
        end
    elseif Location == "Map" then
        if not Workspace:FindFirstChild(Location) then
            prints("Waiting Map Loaded to Use LowGraphics")
            repeat
                task.wait()
            until Workspace:FindFirstChild(Location)
            task.wait(1)
        end
    end
    if bool then
        if Location == "Lobby" and not CheckPlace() then
            for i,v in next, Workspace:WaitForChild("NewLobby"):WaitForChild("Areas")[Location]:GetChildren() do
                v.Parent = Folder
            end
        elseif Location == "Map" and CheckPlace() then
            for i,v in next, Workspace[Location]:GetChildren() do
                if v.Name == "Paths" then
                    continue
                end
                v.Parent = Folder
            end
        elseif Location == "Environment" and CheckPlace() then
            for i,v in next, Workspace:WaitForChild(Lobby)[Location]:GetChildren() do
                v.Parent = Folder
            end
        end
    else
        if Location == "Lobby" and not CheckPlace() then
            for i,v in next, Folder:GetChildren() do
                v.Parent = Workspace:WaitForChild("NewLobby"):WaitForChild("Areas")[Location]
            end
        elseif Location == "Map" and CheckPlace() then
            for i,v in next, Folder:GetChildren() do
                v.Parent = Workspace[Location]
            end
        elseif Location == "Environment" and CheckPlace() then
            for i,v in next, Folder:GetChildren() do
                v.Parent = Workspace:WaitForChild(Lobby)[Location]
            end
        end
    end
    MinimizeClient(bool)
    prints(`{if bool then "Enabled" else "Disabled"} Low Graphics Mode`)
end