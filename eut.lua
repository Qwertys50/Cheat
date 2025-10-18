local TweenService = game:GetService("TweenService")
local LocalizationService = game:GetService("LocalizationService")

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

local result, code = pcall(function()
	return LocalizationService:GetCountryRegionForPlayerAsync(plr)
end)


local color_validate = Color3.new(0.717647, 1, 0.666667)

local autofarms = {
	["Autofarm Roulette"] = false,
	["Autofarm Mango"] = false,
	["Autofarm Puzzle"] = false,
}

local vib = {}

local tweenInfo = TweenInfo.new(
	0.3,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local ScreenFrame

local susc, _ = pcall(function()
	local objs = workspace.objects
	ScreenFrame = objs.puzzle.Screen.SurfaceGui.ScreenFrame
end)

if not susc then print("ВЫ ТОЧНО ТУДА ПОПАЛИ?!") return end


local screen_game = Instance.new("ScreenGui", gui)

local UI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Qwertys50/gui_cheat/refs/heads/main/main.luau'))()
local mainFrame, homeFrame, scrollFrame, pages, navFrame = UI.create_starter(screen_game)

mainFrame.Visible = false

local button_new = Instance.new("Frame", gui.gui.sidebar)
button_new.Name = "Cheat"
button_new.Size = UDim2.new(1, 0, 0, 40)
button_new.BorderSizePixel = 0
button_new.BackgroundTransparency = 1

if gui.gui.sidebar.menu.item_name.Text ~= "Menu" then
	
	button_new.Visible = false
end

gui.gui.sidebar.menu.btn.MouseButton1Up:Connect(function()
	if gui.gui.sidebar.menu.item_name.Text == "MENU" then

		button_new.Visible = true
	else
		button_new.Visible = false
	end

end)

local btn_button_new = Instance.new("ImageButton", button_new)
btn_button_new.Size = UDim2.new(1, 0, 1, 0)
btn_button_new.Position = UDim2.new(0, 10, 0, 0)
btn_button_new.BorderSizePixel = 0
btn_button_new.Image = "rbxassetid://94540935178190"

local stroke = Instance.new("UIStroke", btn_button_new)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(70, 129, 255)

local txt_button_new = Instance.new("TextLabel", button_new)
txt_button_new.Text = "Cheat"
txt_button_new.Position = UDim2.new(0, 55, 0.5, 0)
txt_button_new.Size = UDim2.new(0, 1, 0, 50)
txt_button_new.AnchorPoint = Vector2.new(0, 0.5)
txt_button_new.TextSize = 20
txt_button_new.FontFace.Weight = Enum.FontWeight.Bold
txt_button_new.BorderSizePixel = 0
txt_button_new.Transparency = 1
txt_button_new.TextXAlignment = Enum.TextXAlignment.Left
txt_button_new.TextStrokeTransparency = 0
txt_button_new.TextColor3 = Color3.fromRGB(255, 255, 255)

local stroke = Instance.new("UIStroke", txt_button_new)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(31, 54, 136)
stroke.Transparency = 1

btn_button_new.MouseEnter:Connect(function()
	local goals = {
		Position = UDim2.new(0, 65, 0.5, 0),
		TextTransparency = 0
	}

	local strokeGoals = {
		Transparency = 0
	}

	local tween1 = TweenService:Create(txt_button_new, tweenInfo, goals)
	local tween2 = TweenService:Create(stroke, tweenInfo, strokeGoals)

	tween1:Play()
	tween2:Play()
end)

btn_button_new.MouseLeave:Connect(function()
	local goals = {
		Position = UDim2.new(0, 55, 0.5, 0),
		TextTransparency = 1
	}

	local strokeGoals = {
		Transparency = 1
	}

	local tween1 = TweenService:Create(txt_button_new, tweenInfo, goals)
	local tween2 = TweenService:Create(stroke, tweenInfo, strokeGoals)

	tween1:Play()
	tween2:Play()
end)

btn_button_new.MouseButton1Up:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)


local imageLabel: ImageLabel, nameLabel, countryLabel = UI.create_home(game.Name, homeFrame)

nameLabel.Text = game.Players.Name
countryLabel.Text = code

imageLabel.Image = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)

local button_roulette, _ = UI.create_button("Autofarm Roulette", scrollFrame)
local button_manga, _ = UI.create_button("Autofarm Manga", scrollFrame)

local all_vib, button_puzzle = UI.create_vib("Autofarm Puzzle", "Open", {["Public Server"] = 1, ["Local Server"] = 2}, scrollFrame, 1)

for _, button_vib in all_vib do
	
	button_vib.TextButton.MouseButton1Up:Connect(function()
		local id = button_vib:GetAttribute("id")

		local quests_id = "puzzle_1"
		if not vib[quests_id] then vib[quests_id] = {} end

		local wasSelected = vib[quests_id][id]

		local container = button_vib.Parent
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("TextButton") or child:FindFirstChild("TextButton") then
				local buttonId = child:GetAttribute("id")
				if buttonId then
					vib[quests_id][buttonId] = false
					child.TextButton.BackgroundColor3 = Color3.new(0.764706, 0.764706, 0.764706)
				end
			end
		end

		if not wasSelected then
			button_vib.TextButton.BackgroundColor3 = color_validate
			vib[quests_id][id] = true
		end
	end)
end

button_roulette.MouseButton1Up:Connect(function()
	
	if autofarms["Autofarm Roulette"] then
		
		button_roulette.BackgroundColor3 = Color3.new(1, 0, 0)
		autofarms["Autofarm Roulette"] = false
	else
		button_roulette.BackgroundColor3 = color_validate
		autofarms["Autofarm Roulette"] = true
	end
end)

button_puzzle.MouseButton1Up:Connect(function()

	if autofarms["Autofarm Puzzle"] then

		button_puzzle.BackgroundColor3 = Color3.new(1, 0, 0)
		autofarms["Autofarm Puzzle"] = false
	else
		button_puzzle.BackgroundColor3 = color_validate
		autofarms["Autofarm Puzzle"] = true
	end
end)

button_manga.MouseButton1Up:Connect(function()

	if autofarms["Autofarm Mango"] then

		button_manga.BackgroundColor3 = Color3.new(1, 0, 0)
		autofarms["Autofarm Mango"] = false
	else
		button_manga.BackgroundColor3 = color_validate
		autofarms["Autofarm Mango"] = true
	end
end)


--######puzzle########

task.spawn(function()

	local a = ScreenFrame.Buttons

	local proset = false
	local finnalyEtap = false

	local an = 0

	local function BaseToNumber(input)
		local ses, errors = pcall(function()

			local numberStr = string.match(input, "^(%d+)")
			local basePart = string.match(input, "%((%d+)%)")
			local base = tonumber(basePart)

			local result = 0
			local length = #numberStr
			for i = 1, length do
				local digit = tonumber(string.sub(numberStr, i, i))
				if digit == nil or digit >= base then
					error("Некорректная цифра " .. digit .. " для системы счисления " .. base)
				end
				result = result * base + digit
			end

			return result
		end)

		if ses then
			return errors
		else
			return 0
		end

	end

	local function processInput(input)
		local charMap = {
			["!"] = "1", ["@"] = "2", ["#"] = "3", ["$"] = "4",
			["%"] = "5", ["^"] = "6", ["&"] = "7", ["*"] = "8",
			["("] = "9", [")"] = "0"
		}

		local num = tonumber(input)
		if num then
			return num
		end

		local result = ""

		for i = 1, #input do
			local char = input:sub(i, i)
			result = result .. (charMap[char] or char)
		end

		if tonumber(result) then return tonumber(result)
		else return nil end
	end
	local function sortAndClick(frames)
		table.sort(frames, function(a, b)
			return a.number < b.number
		end)

		for _, item in ipairs(frames) do
			local connections = getconnections(item.frame.TextButton.Activated)
			if connections and #connections > 0 then
				connections[1]:Fire()
			end
			task.wait(0.1)
			if finnalyEtap then

				task.wait(0.4)
			end
		end

		task.wait(1)

		proset = false
		if finnalyEtap == true then
			finnalyEtap = false
		end
	end

	local function getNumbersFromFrames()
		local frames = {}

		local function MathSolver()
			for _, frame in pairs(a:GetChildren()) do
				if frame:IsA("Frame") then
					local mathTextBox = frame:FindFirstChild("MathTextBox")
					if mathTextBox then
						local args = {
							mathTextBox,
							frame.TextButton.Text
						}
						game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("puzzle"):WaitForChild("MathBoxRemote"):FireServer(unpack(args))
					end
					task.wait(2)
				end
			end

			local newFrames = getNumbersFromFrames()
			if newFrames and #newFrames > 0 then
				sortAndClick(newFrames)
			end
		end

		for _, i in ipairs(a:GetChildren()) do
			if not i:IsA("Frame") then continue end
			if i:FindFirstChild("MathTextBox") and #i.MathTextBox.Text == 0 and i.MathTextBox.Visible == true then 
				finnalyEtap = true
				MathSolver() 
				return frames
			end
			local num = processInput(i.TextButton.Text)
			if not num then
				num = processInput(i.TextLabel.Text)
			end
			local baseTo = BaseToNumber(i.TextButton.Text)
			if not baseTo then
				baseTo = processInput(i.TextLabel.Text)
			end
			if baseTo > 0 then num = baseTo end
			if num then
				table.insert(frames, {
					frame = i,
					number = num
				})
			end
		end
		return frames
	end

	local function Start()
		local button = ScreenFrame.Play.PlayButton
		local connections = getconnections(button.Activated)
		if connections and #connections > 0 then
			connections[1]:Fire()
		end
	end

	while task.wait() do
		if autofarms["Autofarm Puzzle"] and (vib["puzzle_1"] and vib["puzzle_1"]["Local Server"]) then
			if ScreenFrame.Play.Visible == true then
				Start()
				task.wait(3)
			end
			an += 1

			if an == 3 or an == 4 then
				task.wait(0.5)
			end

			if not proset and ScreenFrame.Buttons.Visible == true then
				proset = true    
				local framesTable = getNumbersFromFrames()
				sortAndClick(framesTable)
			end
			if an == 4 then an = 0 end
		elseif autofarms["Autofarm Puzzle"] and (vib["puzzle_1"] and vib["puzzle_1"]["Public Server"]) then
			
			local connections = getconnections(ScreenFrame.RegenerateStage.Activated)
			if connections and #connections > 0 then
				connections[1]:Fire()
			end
		end
	end
end)

--#######manga#######--
task.spawn(function()

	local function teleportBlocks()
		
		local player = plr
		
		local mangoTree = workspace.objects.mangotree.mangoes
		if not mangoTree then return end

		local character = player.Character
		if not character or not character.HumanoidRootPart then return end

		for _, block in pairs(mangoTree:GetChildren()) do
			if block:IsA("BasePart") then
				block.Position = character.HumanoidRootPart.Position
			end
		end
	end
	
	while task.wait(1) do
		if autofarms["Autofarm Mango"] then
			teleportBlocks() 
		end
	end
end)

task.spawn(function()
	while task.wait() do
		if autofarms["Autofarm Roulette"] then
			game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("gamble"):InvokeServer()
			
		end
	end
end)
