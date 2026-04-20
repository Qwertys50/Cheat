local plr = game.Players.LocalPlayer
local v18 = require(plr.PlayerGui.MainUI.Initiator.Global.FrameHandler)

local v_u_19 = v18.frames
local v_u_296 = v_u_19.inventory.InventoryFrame.List

local v_u_322 = v_u_296._Template:Clone()
v_u_322.Visible = true

local v_u_326 = v_u_322.ViewportFrame
local v_u_327 = Instance.new("Camera")
v_u_327.FieldOfView = 19
v_u_327.CFrame = CFrame.new(0, 0, 0)
v_u_327.Parent = v_u_326
v_u_326.CurrentCamera = v_u_327

local function Color(r,g,b): Color3
    return Color3.fromRGB(r,g,b)
end

local function GetSkinPlr(plr_)
    local v_u_3 = require(game:GetService("ReplicatedStorage"):WaitForChild("ReplicaDataModule"))
    local Event = game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder"):FindFirstChild("RequestLocalAsset")

    local v_u_16 = v_u_3.players[plr_]
    local a = {}
    local chromas = {}

    local function parseSkinKey(source, prefix)
        local withoutPrefix = string.gsub(source, "^" .. prefix, "")
        local underscorePos = string.find(withoutPrefix, "_")
        if not underscorePos then return end

        local name_item = string.sub(withoutPrefix, 1, underscorePos - 1)
        local skin_name = string.sub(withoutPrefix, underscorePos + 1)

        local chroma_name = nil
        local colonPos = string.find(skin_name, ":")
        if colonPos then
            chroma_name = string.sub(skin_name, colonPos + 1)
            skin_name = string.sub(skin_name, 1, colonPos - 1)
        end

        local result = "ToolSkins/" .. name_item .. "/" .. skin_name
        return result, chroma_name
    end

    for i, _ in v_u_16.data.Items do
        local result, chroma

        if string.find(i, "^Skin_") then
            result, chroma = parseSkinKey(i, "Skin_")
        elseif string.find(i, "^Bundle_") then
            result, chroma = parseSkinKey(i, "Bundle_")
        end

        if result and not table.find(a, result) then
            table.insert(a, result)
            if chroma then
                table.insert(chromas, {[result] = chroma})
            end
        end
    end

    for k, _ in v_u_16.data.ItemsEquipped do
        if string.find(k, "^Skin_") then
            local result, chroma = parseSkinKey(k, "Skin_")
            if result and not table.find(a, result) then
                table.insert(a, result)
                if chroma then
                    table.insert(chromas, {[result] = chroma})
                end
            end
        end
    end

    local assets = Event:InvokeServer(a) or {}
    return assets, chromas
end


local function CreateFrame(parent)
    local frame = Instance.new("Frame", parent)
    frame.BorderSizePixel = 0
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    return frame
end

local function CreateUICorner(parent, cornerRadius)
    local corner = Instance.new("UICorner", parent)
    if cornerRadius then
        corner.CornerRadius = cornerRadius
    end
    return corner
end

local function CreateButton(parent, text, textSize, textColor, backgroundColor)
    local button = Instance.new("TextButton", parent)
    button.BorderSizePixel = 0
    button.BackgroundColor3 = backgroundColor or Color3.new(0.8, 0.8, 0.8)
    button.Text = text or ""
    button.TextSize = textSize or 18
    button.TextColor3 = textColor or Color3.new(0, 0, 0)
    return button
end

local function CreateUIStroke(parent, thickness, color, transparency)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.new(0, 0, 0)
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

local function CreateScrollingFrame(parent, canvasSize)
    local scrollingFrame = Instance.new("ScrollingFrame", parent)
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    scrollingFrame.CanvasSize = canvasSize or UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarThickness = 8
    scrollingFrame.ScrollBarImageColor3 = Color3.new(0.5, 0.5, 0.5)
    return scrollingFrame
end

local function CreateListLayout(parent, padding)
    local listLayout = Instance.new("UIListLayout", parent)
    listLayout.Padding = padding or UDim.new(0, 5)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    return listLayout
end

local function CreatePadding(parent, paddingLeft, paddingRight, paddingTop, paddingBottom)
    local padding = Instance.new("UIPadding", parent)
    padding.PaddingLeft = UDim.new(0, paddingLeft or 0)
    padding.PaddingRight = UDim.new(0, paddingRight or 0)
    padding.PaddingTop = UDim.new(0, paddingTop or 0)
    padding.PaddingBottom = UDim.new(0, paddingBottom or 0)
    return padding
end

local function CreateBTNDOORS(parent, txt)
    local frame1 = CreateFrame(parent)
    frame1.Size = UDim2.new(0.1, 0, 0.05, 0)
    frame1.Position = UDim2.new(0.0399999991, 0, 0.5, 0)
    frame1.AnchorPoint = Vector2.new(0, 0.5)
    frame1.BackgroundColor3 = Color(30, 17, 16)
    frame1.BackgroundTransparency = 0.2

    CreateUICorner(frame1, UDim.new(0, 8))
    CreateUIStroke(frame1, 3, Color(255, 222, 189), 0)

    local btn1 = CreateButton(frame1, txt, 15, Color3.fromRGB(255, 222, 189))
    btn1.Size = UDim2.new(1, 0, 1, 0)

    btn1.BackgroundTransparency = 1
    btn1.TextScaled = true
    btn1.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

    CreatePadding(btn1, 10, 10)

    return frame1, btn1
end


--CREATE LIST--

local asb = {}

local ui = game:GetService("Players").LocalPlayer.PlayerGui.GlobalUI.Inventory

local frame1, btn1 = CreateBTNDOORS(ui, plr.Name) 

local scroll1 = CreateScrollingFrame(frame1)
scroll1.Size = UDim2.new(1, 0, 4, 0)
scroll1.Position = UDim2.new(0, 0, 1.2, 0)
scroll1.BackgroundTransparency = 1

scroll1.Visible = false

CreatePadding(scroll1, 10, 10, 10)

local function SetActiveButtonColor(buttonFrame, button)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(255, 222, 189)
    buttonFrame.BackgroundTransparency = 0
    button.TextColor3 = Color3.fromRGB(57, 31, 24)
end

local function ResetAllButtonsColors()
    for _, btnData in pairs(asb) do
        btnData.frame.BackgroundColor3 = Color(30, 17, 16)
        btnData.frame.BackgroundTransparency = 0.2
        btnData.button.TextColor3 = Color3.fromRGB(255, 222, 189)
    end
end

local function removePlayerUI(playerName)
    for i, uiElement in pairs(asb) do
        if uiElement.frame.Name == playerName then
            uiElement.frame:Destroy()
            table.remove(asb, i)
            break
        end
    end
end

game.Players.PlayerRemoving:Connect(function(player)
    removePlayerUI(player.Name)
end)


btn1:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    
    local absol: UDim2 = btn1.AbsoluteSize

    for _, i in asb do
        
        i.frame.Size = UDim2.new(1, 0, 0, absol.Y)
    end
end)

local listLayout = CreateListLayout(scroll1, UDim.new(0, 10))
local function UpdateCanvas()
    task.wait()
    scroll1.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y+20)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

btn1.MouseButton1Click:Connect(function()
    
    scroll1.Visible = not scroll1.Visible
end)

--CREATE FAKE LIST INV--

local function findGrip(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("Attachment") and v.Name == "ToolGripAttach" then
            return v
        end
    end
end

local function fitCamera(toolModel, camera)
    local center, size = toolModel:GetBoundingBox()
    local maxSize = math.max(size.X, size.Y, size.Z)
    local dist = (maxSize / 2) / math.tan(math.rad(camera.FieldOfView / 2)) * 1.2
    camera.CFrame = CFrame.new(center.Position + Vector3.new(0, 0, dist), center.Position)
    camera.Parent.LightDirection = camera.CFrame:VectorToWorldSpace(Vector3.new(1, -4, -6)).Unit
end

local function positionTool(toolAsset)
    local toolCFrame = CFrame.new(0, 0, -5) * CFrame.Angles(-0.4363323129985824, 2.792526803190927, -0.4363323129985824)

    local cleanClone = toolAsset:Clone()
    cleanClone.Parent = workspace

    local pose = cleanClone:FindFirstChild("ViewportPose")
    if pose then
        toolCFrame = pose.Value or toolCFrame
    end

    local cleanGrip = findGrip(cleanClone)

    if cleanGrip then
        local viewportOffset = cleanGrip:GetAttribute("ViewportOffset") or CFrame.identity

        local anchor = Instance.new("Part")
        anchor.Size = Vector3.new(1, 1, 1)
        anchor.Transparency = 1
        anchor.CFrame = cleanGrip.WorldCFrame * viewportOffset
        anchor.Parent = cleanClone
        cleanClone.PrimaryPart = anchor
        cleanClone:PivotTo(toolCFrame)

        local originalGrip = findGrip(toolAsset)
        if originalGrip then
            local relCF = originalGrip.WorldCFrame:ToObjectSpace(toolAsset:GetPivot())
            local targetCF = cleanGrip.WorldCFrame * viewportOffset * relCF

            local cleanBBCF, cleanBBSize = cleanClone:GetBoundingBox()
            local origBBCF, origBBSize = toolAsset:GetBoundingBox()

            local cleanDist = ((cleanGrip.WorldCFrame * viewportOffset).Position
                - (cleanBBCF.Position - cleanBBCF.LookVector * (cleanBBSize.Z / 2))).Magnitude

            local origDist = ((originalGrip.WorldCFrame * viewportOffset).Position
                - (origBBCF.Position - origBBCF.LookVector * (origBBSize.Z / 2))).Magnitude

            local zOffset = math.clamp(origDist - cleanDist, -1, 1)
            toolAsset:PivotTo(targetCF * CFrame.new(0, 0, zOffset))
        end
    else
        toolAsset:PivotTo(toolCFrame)
    end

    cleanClone:Destroy()
end

local function createToolViewport(parent, toolAsset, skin)
    local template = v_u_296._Template:Clone()
    template.Visible = true
    template.Name = toolAsset.Name
    template.Parent = parent

    local viewport = template.ViewportFrame
    local camera = Instance.new("Camera")
    camera.FieldOfView = 19
    camera.CFrame = CFrame.new(0, 0, 0)
    camera.Parent = viewport
    viewport.CurrentCamera = camera
    viewport.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    viewport.Ambient = Color3.new(0.5, 0.5, 0.5)

    local clone = toolAsset:Clone()
    positionTool(clone)
    clone.Parent = viewport
    if skin then
        if clone:FindFirstChild(skin) then
            
            require(clone[skin])(clone)
        end
    end
    

    fitCamera(clone, camera)
end

local uiFrame = game:GetService("Players").LocalPlayer.PlayerGui.GlobalUI.Inventory.InventoryFrame
local list = uiFrame.List:Clone() :: Frame

list.Visible = false
list.Name = "FakeList"
list.Parent = uiFrame
for _, i in ipairs(list:GetChildren()) do
    
    if i:IsA("TextButton") or i:IsA("TextLabel") then
        
        i:Destroy()
    end
end

local testFrame, testButton = CreateBTNDOORS(scroll1, plr.Name .. " [TEST]")
testFrame.Name = plr.Name .. "_TEST"
testFrame.Size = UDim2.new(1, 0, 0, 40)

testButton.MouseButton1Click:Connect(function()
    ResetAllButtonsColors()
    SetActiveButtonColor(testFrame, testButton)
    
    for _, q in ipairs(list:GetChildren()) do 
        if q:IsA("TextButton") then 
            q:Destroy() 
        end 
    end

    plr.PlayerGui.GlobalUI.Inventory.InventoryFrame.List.Visible = false
    list.Visible = true

    local a, b = GetSkinPlr(plr)

    for _, k in pairs(a) do
        local hasChroma = false
        for _, q in pairs(b) do
            if next(q) == "ToolSkins/"..k.Parent.Name.."/"..k.Name then
                createToolViewport(list, k, q[next(q)])
                hasChroma = true
            end
        end
        if not hasChroma then
            createToolViewport(list, k)
        end
    end
end)

table.insert(asb, {frame = testFrame, button = testButton})

for _, i in ipairs(game.Players:GetPlayers()) do
    local fr, btn = CreateBTNDOORS(scroll1, i.Name)
    fr.Name = i.Name
    fr.Size = UDim2.new(1, 0, 0, 40)

    if i.Name == plr.Name then
        SetActiveButtonColor(fr, btn)
    end

    btn.MouseButton1Click:Connect(function()
        ResetAllButtonsColors()
        SetActiveButtonColor(fr, btn)
        
        for _, q in ipairs(list:GetChildren()) do 
            if q:IsA("TextButton") then 
                q:Destroy() 
            end 
        end
        
        plr.PlayerGui.GlobalUI.Inventory.InventoryFrame.List.Visible = i.Name == plr.Name
        list.Visible = not (i.Name == plr.Name)

        local a, b = GetSkinPlr(i)

        for _, k in pairs(a) do
            local hasChroma = false
            for _, q in pairs(b) do
                if next(q) == "ToolSkins/"..k.Parent.Name.."/"..k.Name then
                    createToolViewport(list, k, q[next(q)])
                    hasChroma = true
                end
            end
            if not hasChroma then
                createToolViewport(list, k)
            end
        end
    end)

    table.insert(asb, {frame = fr, button = btn})
end

game.Players.PlayerAdded:Connect(function(player)
    
    local fr, btn = CreateBTNDOORS(scroll1, player.Name)
    fr.Name = player.Name
    fr.Size = UDim2.new(1, 0, 0, 40)
    
    table.insert(asb, {frame = fr, button = btn})
    
    btn.MouseButton1Click:Connect(function()
        ResetAllButtonsColors()
        SetActiveButtonColor(fr, btn)
        
        for _, q in ipairs(list:GetChildren()) do 
            if q:IsA("TextButton") then 
                q:Destroy() 
            end 
        end
        
        plr.PlayerGui.GlobalUI.Inventory.InventoryFrame.List.Visible = player.Name == plr.Name
        list.Visible = not (player.Name == plr.Name)

        local a, b = GetSkinPlr(player)

        for _, k in pairs(a) do
            local hasChroma = false
            for _, q in pairs(b) do
                if next(q) == "ToolSkins/"..k.Parent.Name.."/"..k.Name then
                    createToolViewport(list, k, q[next(q)])
                    hasChroma = true
                end
            end
            if not hasChroma then
                createToolViewport(list, k)
            end
        end
    end)
end)
