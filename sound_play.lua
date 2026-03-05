local HttpService = game:GetService("HttpService")
local SERVER_URL = "http://100.125.136.26:5000"
local plr = game.Players.LocalPlayer
local isPolling = false

local coreGui = game:GetService("CoreGui")
local topBar = coreGui.TopBarApp.TopBarApp

local function GetTextureFromAssetId(assetId: number): string
	return "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId="..assetId
end

local LeftBar = topBar.UnibarLeftFrame :: Frame

local function CreateFrame(parent)
	local frame = Instance.new("Frame", parent)
	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = Color3.new(1, 1, 1)
	return frame
end

local function CreateButton(frame)
	local btn = Instance.new("TextButton", frame)
	btn.BorderSizePixel = 0
	btn.BackgroundColor3 = Color3.new(1, 1, 1)
	pcall(function()
		btn.FontFace = Font.fromId(12187375716, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	end)
	
	btn.TextSize = 14
	return btn
end

local function CreateImageButton(frame)
	local btn = Instance.new("ImageButton", frame)
	btn.BorderSizePixel = 0
	btn.BackgroundColor3 = Color3.new(1, 1, 1)
	btn.AutoButtonColor = false
		
	return btn
end

local function create_UICorner(radius: UDim, parent)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = radius
end

local function create_UIList(padding: UDim, align: Enum.HorizontalAlignment, parent)
	local list = Instance.new("UIListLayout", parent)
	list.Padding = padding
	list.HorizontalAlignment = align
	return list
end

local function CreateScrollFrame(name: string, parent, hasList: boolean?)
	local frame = Instance.new("ScrollingFrame")
	frame.Name = name
	frame.Parent = parent
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.ScrollBarThickness = 6
	frame.ScrollBarImageColor3 = Color3.new(0.462745, 0.341176, 0.427451)
	frame.CanvasSize = UDim2.new(0, 0, 2, 0)

	if hasList then
		local list = create_UIList(UDim.new(0.001, 15), Enum.HorizontalAlignment.Center, frame)
		list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			frame.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
		end)
	end

	return frame
end

local function CreateTextBox(parent, placeholder)
	local box = Instance.new("TextBox", parent)
	box.BorderSizePixel = 0
	box.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	box.TextColor3 = Color3.new(0, 0, 0)
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
	box.TextSize = 14
	box.FontFace = Font.fromId(12187375716, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	box.ClearTextOnFocus = false
	return box
end

local function CreateTextLabel(parent)
	local lbl = Instance.new("TextLabel", parent)
	lbl.BorderSizePixel = 0
	lbl.BackgroundTransparency = 1
	lbl.BackgroundColor3 = Color3.new(1, 1, 1)
	lbl.TextColor3 = Color3.new(0, 0, 0)
	lbl.TextSize = 14
	lbl.FontFace = Font.fromId(12187375716, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	return lbl
end

local function SendRequests(image_id, sound_id)    
    if not SERVER_URL then return end

    local pressData = {
        player = {
            id = plr.UserId,
            name = plr.Name
        },
		info = {
			image_id = image_id,
			sound_id = sound_id
		}
    }
    local success, response = pcall(function()
        return request({
            Url = SERVER_URL .. "/button_press",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(pressData)
        })
    end)
end

local function createBillboardWithTween(imageId, soundId, character)
	task.spawn(function()
		SendRequests(imageId, soundId)
	end)
	
    local head = character.PrimaryPart
    
    local TweenService = game:GetService("TweenService")
    
    local new = Instance.new("BillboardGui")
    new.Size = UDim2.new(2, 0, 2, 0)
    new.AlwaysOnTop = true
    new.Parent = head
    
    local image = Instance.new("ImageLabel", new)
    image.Image = GetTextureFromAssetId(imageId:match("%d+"))
    image.Size = UDim2.new(1, 0, 1, 0)
    image.BackgroundTransparency = 1
    image.ImageTransparency = 1

    if not string.find(soundId, "rbxassetid://") then
        soundId = "rbxassetid://"..soundId
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Parent = new
    
    local tweenInfo = TweenInfo.new(
        1,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    )
    
    local transparencyTweenInfo = TweenInfo.new(
        0.8,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    )
    
    local targetOffset = {
        StudsOffsetWorldSpace = Vector3.new(0, 5, 0)
    }
    
    game:GetService("ContentProvider"):PreloadAsync({sound})

    sound:Play()
    local moveTween = TweenService:Create(new, tweenInfo, targetOffset)
    local transparencyTween = TweenService:Create(image, transparencyTweenInfo, {
        ImageTransparency = 0 
    })

    local transparencyTween_ = TweenService:Create(image, transparencyTweenInfo, {
        ImageTransparency =1 
    })
    
    moveTween:Play()
    transparencyTween:Play()
    
    transparencyTween.Completed:Connect(function()    
        transparencyTween_:Play()
        transparencyTween_.Completed:Connect(function()
            new:Destroy()
        end)
    end)
end

local function CreateAddSpis(parent, info)
    local size = 50

    local frame = CreateButton(parent)
    frame.BackgroundTransparency = 0.4
    frame.Text = ""
    frame.Size = UDim2.new(1, 0, 0, size)
    frame.AutoButtonColor = false
    create_UICorner(UDim.new(0, 4), frame)

    local text_ = CreateTextLabel(frame)
    text_.Text = info["name"]
    text_.TextColor3 = Color3.new(1, 1, 1)
    text_.Size = UDim2.new(0.5, 0, 1, 0)
    text_.Position = UDim2.new(0.5, 0, 0.5, 0)
    text_.AnchorPoint = Vector2.new(0.5, 0.5)
    
	local img = Instance.new("ImageLabel", frame)
	img.BackgroundTransparency = 1
	img.Size = UDim2.new(0, size-10, 0, size-10)
    img.Position = UDim2.new(0, size/2, 0.5, 0)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.Image = GetTextureFromAssetId(info.image:match("%d+"))
    create_UICorner(UDim.new(1, 0), img)

    return frame
end

local function startLongPolling()
    if isPolling then return end
    isPolling = true
    
    task.spawn(function()
        while task.wait(0.1) do
			if not SERVER_URL then continue end
            if not isPolling then continue end

            local success, response = pcall(function()
                return request({
                    Url = SERVER_URL .. "/poll_events",
                    Method = "GET",
                    Headers = {
                        ["Cache-Control"] = "no-cache"
                    },
                    Timeout = 35
                })
            end)
            
            if success and response.Success then
                local data = HttpService:JSONDecode(response.Body)
                
                if data.type and data.type ~= "timeout" then
                    if data.type == "button_press" then
                        if data.player.id ~= plr.UserId then
                            local name = data.player.name
							
							local plr_
							for _, i in ipairs(game.Players:GetPlayers()) do
								if i.Name == name then plr_ = i end
							end
							if not plr_ then continue end
							
							local character = plr_.Character
							task.spawn(function()
								createBillboardWithTween(
									data.info.image_id, data.info.sound_id, character
								)									
							end)
                        end
                    end
                end
            else
                task.wait(5)
            end
            
            task.wait(0.1)
        end
    end)
end

local selected_infos = {
    {
        sound = "rbxassetid://122653941885659",
        image =  "rbxassetid://90164279415082",
        name = "Mambo"
    }
}

makefolder("sound_free")
local file_path = "sound_free/saved.json"

local function is_file(file_path)
	for _, i in listfiles("sound_free") do
		if file_path == i then
			return true
		end
	end
	return false
end

local function save_autofarms()
	writefile(file_path, game:GetService("HttpService"):JSONEncode({selected_infos = selected_infos}))
end

if not is_file(file_path) then
	save_autofarms()
else
	local success, data = pcall(function()
		return game:GetService("HttpService"):JSONDecode(readfile(file_path))
	end)

	if success and type(data) == "table" then
		selected_infos = data.selected_infos
	end
end

local frame = CreateFrame(LeftBar)
create_UICorner(UDim.new(1, 0), frame)

frame.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
frame.Size = UDim2.new(0, 48, 0, 44)
frame.Position = UDim2.new(0, LeftBar.UnibarMenu.AbsoluteSize.X + 10, 0, 0)

LeftBar.UnibarMenu:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    frame.Position = UDim2.new(0, LeftBar.UnibarMenu.AbsoluteSize.X + 10, 0, 0)
end)

local btn = CreateImageButton(frame)
btn.Image = GetTextureFromAssetId("88204284600992")
btn.BackgroundTransparency = 1
btn.Size = UDim2.new(0.5, 0, 0.5, 0)
btn.Position = UDim2.new(0.5, 0, 0.5, 0)
btn.AnchorPoint = Vector2.new(0.5, 0.5)
btn.AutoButtonColor = true

local mainFrame = CreateFrame(frame)
mainFrame.Visible = false
create_UICorner(UDim.new(0, 8), mainFrame)

mainFrame.Position = UDim2.new(0, -52, 0, 50)
mainFrame.Size = UDim2.new(0, 192, 0, 280)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
mainFrame.BackgroundTransparency = 0.3

local mainButton = CreateButton(mainFrame)
mainButton.Text = "Create"
mainButton.Size = UDim2.new(1, 0, 0, 40)
mainButton.BackgroundTransparency = 1
mainButton.TextSize = 20
create_UICorner(UDim.new(0, 8), mainButton)

mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
local clrs = mainFrame.BackgroundColor3

mainButton.MouseEnter:Connect(function()
    mainButton.BackgroundColor3 = Color3.fromRGB(145, 145, 145)
    mainButton.BackgroundTransparency = 0
end)

mainButton.MouseLeave:Connect(function()
    mainButton.BackgroundColor3 = clrs
    mainButton.BackgroundTransparency = 1
end)

btn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local createFrame = CreateFrame(mainFrame)
createFrame.Visible = false
createFrame.Position = UDim2.new(0, 0, 0, 40)
createFrame.Size = UDim2.new(1, 0, 1, -40)
createFrame.BackgroundTransparency = 1

local soundBox = CreateTextBox(createFrame, "Введите sound ID")
soundBox.Size = UDim2.new(0.9, 0, 0, 30)
soundBox.Text = ""
soundBox.Position = UDim2.new(0.5, 0, 0, 0)
soundBox.AnchorPoint = Vector2.new(0.5, 0)
soundBox.TextScaled = true

local imageBox = CreateTextBox(createFrame, "Введите image ID")
imageBox.Size = UDim2.new(0.9, 0, 0, 30)
imageBox.Position = UDim2.new(0.5, 0, 0, 40)
imageBox.Text = ""
imageBox.AnchorPoint = Vector2.new(0.5, 0)
imageBox.TextScaled = true

local nameBox = CreateTextBox(createFrame, "Введите название")
nameBox.Size = UDim2.new(0.9, 0, 0, 30)
nameBox.Text = ""
nameBox.Position = UDim2.new(0.5, 0, 0, 80)
nameBox.AnchorPoint = Vector2.new(0.5, 0)
nameBox.TextScaled = true

local addBtn = CreateButton(createFrame)
addBtn.Size = UDim2.new(0.9, 0, 0, 30)
addBtn.Text = "Добавить"
addBtn.Position = UDim2.new(0.5, 0, 0, 120)
addBtn.AnchorPoint = Vector2.new(0.5, 0)
addBtn.BackgroundColor3 = Color3.new(0.3, 0.7, 0.3)
create_UICorner(UDim.new(0, 4), addBtn)

local scroll = CreateScrollFrame("Scroll", mainFrame, true)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.Size = UDim2.new(1, 0, 1, -40)

local function UpdateScrollList()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, i in ipairs(selected_infos) do
        local item = CreateAddSpis(scroll, i)
        item.MouseButton1Click:Connect(function()
            local character = plr.Character
            if character then
                task.spawn(function()
                    createBillboardWithTween(i.image, i.sound, character)
                end)
            end
        end)
    end
end

UpdateScrollList()

mainButton.MouseButton1Click:Connect(function()
    if mainButton.Text == "Create" then
        scroll.Visible = false
        createFrame.Visible = true
        mainButton.Text = "Back"
    else
        scroll.Visible = true
        createFrame.Visible = false
        mainButton.Text = "Create"
    end
end)

addBtn.MouseButton1Click:Connect(function()
    local sound = soundBox.Text
    local image = imageBox.Text
    local name = nameBox.Text
    
    if sound ~= "" and image ~= "" and name ~= "" then
        table.insert(selected_infos, {
            sound = sound,
            image = image,
            name = name
        })
        
        UpdateScrollList()
        save_autofarms()

        soundBox.Text = ""
        imageBox.Text = ""
        nameBox.Text = ""
        
        scroll.Visible = true
        createFrame.Visible = false
        mainButton.Text = "Create"
    end
end)

local urlFrame = CreateFrame(mainFrame)
urlFrame.Size = UDim2.new(1, 0, 1, 0)
urlFrame.Position = UDim2.new(0, 0, 0, 0)
urlFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
urlFrame.BackgroundTransparency = 0.1
urlFrame.Visible = true
urlFrame.ZIndex = 10
create_UICorner(UDim.new(0, 8), urlFrame)

local urlList = create_UIList(UDim.new(0, 10), Enum.HorizontalAlignment.Center, urlFrame)
urlList.VerticalAlignment = Enum.VerticalAlignment.Center

local urlInput = CreateTextBox(urlFrame, "http://your-server.com:5000")
urlInput.Size = UDim2.new(0.9, 0, 0.3, 0)
urlInput.LayoutOrder = 2
urlInput.Name = "1"
urlInput.Text = SERVER_URL

local urlButtonsFrame = CreateFrame(urlFrame)
urlButtonsFrame.Size = UDim2.new(0.9, 0, 0, 40)
urlButtonsFrame.BackgroundTransparency = 1
urlButtonsFrame.LayoutOrder = 3
urlButtonsFrame.Name = "2"

local urlButtonsList = Instance.new("UIListLayout", urlButtonsFrame)
urlButtonsList.FillDirection = Enum.FillDirection.Horizontal
urlButtonsList.Padding = UDim.new(0, 10)
urlButtonsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
urlButtonsList.VerticalAlignment = Enum.VerticalAlignment.Center

local enterBtn = CreateButton(urlButtonsFrame)
enterBtn.Size = UDim2.new(0.45, 0, 1, 0)
enterBtn.Text = "Enter"
enterBtn.BackgroundColor3 = Color3.new(0.3, 0.7, 0.3)
create_UICorner(UDim.new(0, 4), enterBtn)

local closeUrlBtn = CreateButton(urlButtonsFrame)
closeUrlBtn.Size = UDim2.new(0.45, 0, 1, 0)
closeUrlBtn.Text = "Close"
closeUrlBtn.BackgroundColor3 = Color3.new(0.7, 0.3, 0.3)
create_UICorner(UDim.new(0, 4), closeUrlBtn)

createFrame.Visible = false
scroll.Visible = false
mainButton.Visible = false

local function openMainGUI()
    urlFrame.Visible = false

    scroll.Visible = true
    mainButton.Visible = true
    
    startLongPolling()
end

enterBtn.MouseButton1Click:Connect(function()
    local url = urlInput.Text:match("^%s*(.-)%s*$")
    if url ~= "" then
        SERVER_URL = url
        openMainGUI()
    end
end)

closeUrlBtn.MouseButton1Click:Connect(function()
    SERVER_URL = nil
    openMainGUI()
end)

urlInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local url = urlInput.Text:match("^%s*(.-)%s*$")
        if url ~= "" then
            SERVER_URL = url
            openMainGUI()
        end
    end
end)
