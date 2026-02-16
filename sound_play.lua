local function CreateFrame(parent)
	local frame = Instance.new("Frame", parent)
	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = Color3.new(1, 1, 1)
	return frame
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

local function GetTextureFromAssetId(assetId: number): string
	return "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId="..assetId
end

local function CreateAddSpis(parent, info)
    local frame = CreateButton(parent)
    frame.Text = ""
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.AutoButtonColor = false

    local text_ = CreateTextLabel(frame)
    text_.Text = info["name"]
    text_.Size = UDim2.new(0.5, 0, 1, 0)
    text_.Position = UDim2.new(0.5, 0, 0.5, 0)
    text_.AnchorPoint = Vector2.new(0.5, 0.5)
    
	local img = Instance.new("ImageLabel", frame)
	img.BackgroundTransparency = 1
	img.Size = UDim2.new(0, 30, 0, 30)
    img.Position = UDim2.new(0, 15, 0.5, 0)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.Image = GetTextureFromAssetId(info.image:match("%d+"))

    return frame
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

local gui_ = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local frame = CreateFrame(gui_)

local scroll = CreateScrollFrame("hm", frame, true)
scroll.Size = UDim2.new(1, 0, 0.9, 0)
scroll.Visible = true

local btn_ = CreateButton(frame)
btn_.Position = UDim2.new(0, 0, 0.9, 0)
btn_.Size = UDim2.new(1, 0, 0.1, 0)
btn_.Text = "Добавить новый"

local createFrame = CreateFrame(frame)
createFrame.Size = UDim2.new(1, 0, 0.9, 0)
createFrame.Position = UDim2.new(0, 0, 0, 0)
createFrame.Visible = false
createFrame.BackgroundColor3 = Color3.new(0.95, 0.95, 0.95)

local createList = Instance.new("UIListLayout", createFrame)
createList.Padding = UDim.new(0, 10)
createList.HorizontalAlignment = Enum.HorizontalAlignment.Center
createList.VerticalAlignment = Enum.VerticalAlignment.Top
createList.SortOrder = Enum.SortOrder.LayoutOrder

local soundBox = CreateTextBox(createFrame, "Введите sound ID (rbxassetid://...)")
soundBox.Size = UDim2.new(0.9, 0, 0.2, 0)
soundBox.Text = ""
soundBox.LayoutOrder = 1
soundBox.TextScaled = true

local imageBox = CreateTextBox(createFrame, "Введите image ID (rbxassetid://...)")
imageBox.Size = UDim2.new(0.9, 0, 0.2, 0)
imageBox.Text = ""
imageBox.LayoutOrder = 2
imageBox.TextScaled = true

local nameBox = CreateTextBox(createFrame, "Введите название")
nameBox.Size = UDim2.new(0.9, 0, 0.2, 0)
nameBox.Text = ""
nameBox.LayoutOrder = 3
nameBox.TextScaled = true

local addBtn = CreateButton(createFrame)
addBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
addBtn.Text = "Добавить"
addBtn.LayoutOrder = 4
addBtn.BackgroundColor3 = Color3.new(0.3, 0.7, 0.3)

frame.Size = UDim2.new(0, 150, 0, 100)
frame.Position = UDim2.new(0.9, 0, 0.7, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)

local _close = CreateButton(gui_)
_close.Size = UDim2.new(0, 100, 0, 50)
_close.Position = UDim2.new(0, 0, 0.8, 0)
_close.AnchorPoint = Vector2.new(0, 0.5)
_close.Text = "Close"
_close.BackgroundColor3 = Color3.new(0.501960, 0.376470, 0.376470)
_close.FontFace = Font.fromId(12187375716, Enum.FontWeight.Bold, Enum.FontStyle.Normal)


local function createBillboardWithTween(imageId, soundId)

    local plr = game.Players.LocalPlayer
    local character = plr.Character
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
    
    local targetTransparency = {
        ImageTransparency = 0 
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

local function UpdateScrollList()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, i in ipairs(selected_infos) do
        local btn = CreateAddSpis(scroll, i)
        btn.MouseButton1Click:Connect(function()
            createBillboardWithTween(
                i.image,i.sound
            )
        end)
    end
end

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
        --save_autofarms()

        soundBox.Text = ""
        imageBox.Text = ""
        nameBox.Text = ""
        
        scroll.Visible = true
        createFrame.Visible = false
        btn_.Visible = true
    else
        warn("Заполните все поля!")
    end
end)

btn_.MouseButton1Click:Connect(function()
    scroll.Visible = false
    createFrame.Visible = true
    btn_.Visible = false
end)

_close.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    if frame.Visible == true then
        _close.Text = "Close"

        scroll.Visible = true
        createFrame.Visible = false
        btn_.Visible = true
    else
        _close.Text = "Open"
    end
end)


UpdateScrollList()
