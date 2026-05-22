local axe
local tree = workspace.LogModels:GetChildren()[23].WoodSection
local camera = workspace.CurrentCamera
local eventNotifGUI = game:GetService("CoreGui").KronHub.Frame.MainHolder.BackGround.WoodTab:GetChildren()[9].ClickBt

local last_text = ""

game:GetService("CoreGui").Notify.Frame.ChildAdded:Connect(function(child)
    last_text = child.MainHolder.BackGround.MainText.Text
    print(last_text)

end)
local function NotifWait(text)
    run = true

    print(last_text, text)
    while task.wait() do
        if last_text ==  text then break end
    end

    while run and task.wait() do end
    con:Disconnect()
end


local function moveCameraToTarget(targetPart)
    local originalCameraType = camera.CameraType
    local originalCFrame = camera.CFrame
    
    camera.CameraType = Enum.CameraType.Scriptable
    local targetPosition = targetPart.Position
    local cameraHeight = 5
    
    local cameraPosition = Vector3.new(targetPosition.X, targetPosition.Y + cameraHeight, targetPosition.Z)
    
    camera.CFrame = CFrame.new(cameraPosition, targetPosition)
    
end

local function clickOnPart(targetPart)

	local camera = workspace.CurrentCamera
	local VirtualInputManager = game:GetService("VirtualInputManager")
	
	local screenPoint, isOnScreen = camera:WorldToViewportPoint(targetPart.Position)
	
	if not isOnScreen then
		warn("Часть '", targetPart.Name, "' сейчас не видна на экране!")
		return false
	end
	
	local targetScreenX = screenPoint.X
	local targetScreenY = screenPoint.Y
	
    VirtualInputManager:SendMouseButtonEvent(targetScreenX, targetScreenY, 0, true, nil, 1)
	task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(targetScreenX, targetScreenY, 0, false, nil, 1)
	
	return true
end

for _, i in ipairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do

    if i:FindFirstChild("ToolName") and string.find(i.ToolName.Value, "Axe") then

        axe = i
    end

end

if not axe then return nil end

axe.Parent = game.Players.LocalPlayer.Character
for i,v in pairs(getconnections(eventNotifGUI.MouseButton1Click)) do
    v:Fire()
end

local samvil = workspace.PlayerModels.Sawmill4

moveCameraToTarget(samvil.Parts:GetChildren()[20])
NotifWait("Click Sawmill")

task.wait(1)
clickOnPart(samvil.Parts:GetChildren()[20])
NotifWait("Tree Click")

moveCameraToTarget(tree)
clickOnPart(tree)

camera.CameraType = Enum.CameraType.Custom