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
    local Location = if CheckPlace() then "Map" else "Environment"
    if bool then
        repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
        LocalPlayer.Character.Humanoid.PlatformStand = true
        LocalPlayer.Character.HumanoidRootPart.Anchored = true
        for i,v in next, Workspace[Location]:GetChildren() do
            if Location == "Map" and v.Name == "Paths" then
                continue
            end
            v.Parent = Folder
        end
    else
        if not (CheckPlace() and getgenv().DefaultCam ~= 1) then
            repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
            LocalPlayer.Character.Humanoid.PlatformStand = false
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
        for i,v in next, Folder:GetChildren() do
            v.Parent = Workspace[Location]
        end
    end
    MinimizeClient(bool)
    prints(`{if bool then "Enabled" else "Disabled"} Low Graphics Mode`)
end