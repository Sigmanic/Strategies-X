local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = Workspace.CurrentCamera
local OldCameraOcclusionMode = LocalPlayer.DevCameraOcclusionMode

CurrentCamera.CameraType = Enum.CameraType.Scriptable
local FOV = CurrentCamera.FieldOfView
local movePosition = Vector2.new(0, 0)
local moveDirection = Vector3.new(0, 0, 0)
local targetMovePosition = movePosition
local lastRightButtonDown = Vector2.new(0, 0)
local rightMouseButtonDown,sprinting = false,false
local keysDown,moveKeys = {}, {
    [Enum.KeyCode.D] = Vector3.new(1, 0, 0),
    [Enum.KeyCode.A] = Vector3.new(-1, 0, 0),
    [Enum.KeyCode.S] = Vector3.new(0, 0, 1),
    [Enum.KeyCode.W] = Vector3.new(0, 0, -1),
    [Enum.KeyCode.E] = Vector3.new(0, 1, 0),
    [Enum.KeyCode.Q] = Vector3.new(0, -1, 0)
}
function Tween(Value,Time)
    pcall(function()
        if Value == CurrentCamera.FieldOfView then
            return
        end
        game:GetService("TweenService"):Create(CurrentCamera, TweenInfo.new(Time, Enum.EasingStyle.Linear), {FieldOfView = Value}):Play() 
        task.wait(Time)
    end)
end
UserInputService.InputChanged:connect(function(Y)
    if Y.UserInputType == Enum.UserInputType.MouseMovement then
        movePosition = movePosition + Vector2.new(Y.Delta.x, Y.Delta.y)
    end
end)
function CalculateMovement()
    local Z = Vector3.new(0, 0, 0)
    for i,v in next, keysDown do
        Z = Z + (moveKeys[i] or Vector3.new(0, 0, 0))
    end
    return Z
end
function Input(InputTyped)
    if moveKeys[InputTyped.KeyCode] then
        if InputTyped.UserInputState == Enum.UserInputState.Begin then
            keysDown[InputTyped.KeyCode] = true
        elseif InputTyped.UserInputState == Enum.UserInputState.End then
            keysDown[InputTyped.KeyCode] = nil
        end
    else
        if InputTyped.UserInputState == Enum.UserInputState.Begin then
            if InputTyped.UserInputType == Enum.UserInputType.MouseButton2 and  StratXLibrary.UtilitiesConfig.Camera == 3 then
                rightMouseButtonDown = true
                lastRightButtonDown = Vector2.new(Mouse.X, Mouse.Y)
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            elseif InputTyped.KeyCode == Enum.KeyCode.Z then
                FOV = 20
            elseif InputTyped.KeyCode == Enum.KeyCode.LeftShift then
                sprinting = true
            end
        else
            if InputTyped.UserInputType == Enum.UserInputType.MouseButton2 then
                rightMouseButtonDown = false
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            elseif InputTyped.KeyCode == Enum.KeyCode.Z then
                FOV = 70
            elseif InputTyped.KeyCode == Enum.KeyCode.LeftShift then
                sprinting = false
            end
        end
    end
end
Mouse.WheelForward:connect(function()
    CurrentCamera.CoordinateFrame = CurrentCamera.CoordinateFrame * CFrame.new(0, 0, -5)
end)
Mouse.WheelBackward:connect(function()
    CurrentCamera.CoordinateFrame = CurrentCamera.CoordinateFrame * CFrame.new(-0, 0, 5)
end)
UserInputService.InputBegan:connect(Input)
UserInputService.InputEnded:connect(Input)
game:GetService("RunService").RenderStepped:Connect(function()
    if StratXLibrary.UtilitiesConfig and StratXLibrary.UtilitiesConfig.Camera == 3 then
        targetMovePosition = movePosition
        CurrentCamera.CoordinateFrame = CFrame.new(CurrentCamera.CoordinateFrame.p) * CFrame.fromEulerAnglesYXZ(-targetMovePosition.Y / 300,-targetMovePosition.X / 300,0) * CFrame.new(CalculateMovement() * (({[true] = 3})[sprinting] or .5))
        Tween(FOV,.1)
        if rightMouseButtonDown then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            movePosition = movePosition - (lastRightButtonDown - Vector2.new(Mouse.X, Mouse.Y))
            lastRightButtonDown = Vector2.new(Mouse.X, Mouse.Y)
        end
    end
end)