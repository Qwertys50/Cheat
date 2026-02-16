local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui
local HttpService = game:GetService("HttpService")

local result, code = pcall(function()
	return game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(plr)
end)

local function tableLength(t)
	local c = 0
	for _ in pairs(t) do c = c + 1 end
	return c
end

local color_validate = Color3.new(0.717647, 1, 0.666667)

makefolder("tree_1")

local file_path = "tree_1/saved.json"

local autofarms = {
	["Luck buttons"] = false,
    ["Auto upgrade"] = false,
    ["Auto wigle"] = false
}
local my_proz_1 = {}


local function is_file(file_path)
	for _, i in listfiles("tree_1") do
		if file_path == i then
			return true
		end
	end
	return false
end

local function save_autofarms()
        print(HttpService:JSONEncode(my_proz_1))
	writefile(file_path, game:GetService("HttpService"):JSONEncode({Autofarm = autofarms, my_proz_1=my_proz_1}))
end

if not is_file(file_path) then

	save_autofarms()
else

	local success, data = pcall(function()
		return game:GetService("HttpService"):JSONDecode(readfile(file_path))
	end)

	if success and type(data) == "table" then
        
		autofarms = data.Autofarm
		my_proz_1 = data.my_proz_1

        print(HttpService:JSONEncode(data))
	end
end

local screen_game = Instance.new("ScreenGui", gui)

local btn_button_new = Instance.new("ImageButton", screen_game)
btn_button_new.Size = UDim2.new(0, 50, 0, 50)
btn_button_new.Position = UDim2.new(0, 10, 0, 10)
btn_button_new.BorderSizePixel = 0
btn_button_new.Image = "rbxassetid://94540935178190"


local UI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/tdut_origin.lua'))()
local mainFrame, homeFrame, scrollFrame, pages, navFrame = UI.create_starter(screen_game)
local imageLabel: ImageLabel, nameLabel, countryLabel = UI.create_home(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, homeFrame)

nameLabel.Text = plr.Name
countryLabel.Text = code

imageLabel.Image = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)

mainFrame.Visible = false

btn_button_new.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

local function extractMinMax(rangeText)
    local minStr, maxStr = string.match(rangeText, "([%d%.]+)%s*%-%s*([%d%.]+)")
    
    if minStr and maxStr then
        local minValue = tonumber(minStr)
        local maxValue = tonumber(maxStr)
        return minValue, maxValue
    else
        return nil, nil
    end
end

local ___i = {}
for _,  i in ipairs(workspace.Unlock.Lucky:GetChildren()) do ___i[i.Name] = _ end 

local _, button_btn, hms_1  =  UI.create_texts_button_click("Autofarm Puzzle", "Open", ___i, scrollFrame, 1, true)
local color_upg = button_btn.BackgroundColor3


for n, i in hms_1 do
    
    
    if not my_proz_1[n] then my_proz_1[n] = 0 end
    
    save_autofarms()
    i.input.Text = my_proz_1[n]

    i.event.Event:Connect(function(text)
        
        local in_ = workspace.Unlock.Lucky:FindFirstChild(n)

        if in_ then

            local num1, num2 = extractMinMax(in_.Decoration.BillboardGui.Ranges.Text)

            if num1 < text and text > num2 then return end
        end
        
        my_proz_1[n] = text
        save_autofarms()
    end)
end

button_btn.MouseButton1Up:Connect(function()
    if workspace:FindFirstChild("Unlock") and workspace.Unlock:FindFirstChild("Lucky") then
        for _,  i in ipairs(workspace.Unlock.Lucky:GetChildren()) do
            
            task.spawn(function()
            
                while task.wait(0.2) do
                    
                    if my_proz_1[i.Name] > 0.1 then 
                        local val = i.Decoration.BillboardGui.Boost.Text

                        local number = string.match(val, "([%d%.]+)") 
                        local boostValue = tonumber(number)

                        print(boostValue, my_proz_1[i.Name], my_proz_1[i.Name] > boostValue)

                        if my_proz_1[i.Name] > boostValue then 
                            fireclickdetector(i.ClickDetector) 
                        else break
                        
                        end
                    else break end
                end
            end)
            
        end 
    end

    task.spawn(function()
        button_btn.BackgroundColor3 = Color3.new(0.062745, 0.431372, 0)
        task.wait(0.4)
        
        button_btn.BackgroundColor3 = color_upg
    end)
end)

local button_upg = UI.create_button("Auto upgrade", scrollFrame, autofarms["Auto upgrade"])

button_upg.MouseButton1Up:Connect(function()
	autofarms["Auto upgrade"] = not autofarms["Auto upgrade"]
    save_autofarms()
end)

local button_widle = UI.create_button("Auto wigle", scrollFrame, autofarms["Auto wigle"])

button_widle.MouseButton1Up:Connect(function()
	autofarms["Auto wigle"] = not autofarms["Auto wigle"]
    save_autofarms()
end)

task.spawn(function()


    while task.wait() do   
        
        if autofarms["Auto upgrade"] then
            local skill = workspace.Button.Skill
            local jumpify = workspace.Button.Jumpify
            local Unfailability = workspace.Button.Unfailability

            local combined = {}
            for _, child in ipairs(skill:GetChildren()) do
                table.insert(combined, child)
            end
            for _, child in ipairs(jumpify:GetChildren()) do
                table.insert(combined, child)
            end
            for _, child in ipairs(Unfailability:GetChildren()) do
                table.insert(combined, child)
            end
            task.spawn(function()
                for _, i in ipairs(combined) do
                    
                    if i:FindFirstChildWhichIsA("ClickDetector") and i.Bought.Value == false and autofarms["Auto upgrade"] then
                        
                        local ClickDetector = i:FindFirstChildWhichIsA("ClickDetector")
                        fireclickdetector(ClickDetector)
                        task.wait()
                    end
                end
            end)
        end

        if autofarms["Auto wigle"] then
            if workspace:FindFirstChild("Unlock") and workspace.Unlock:FindFirstChild("UF23") then

                local clickDetector = workspace.Unlock.UF23.Wedge.ClickDetector :: ClickDetector
                clickDetector.MaxActivationDistance = 999999

                task.spawn(function()
                    fireclickdetector(clickDetector)
                end)
            end
        end

    end

end)
