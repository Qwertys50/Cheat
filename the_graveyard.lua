local TweenService = game:GetService("TweenService")
local LocalizationService = game:GetService("LocalizationService")

local select_id = "0,0"
local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

local result, code = pcall(function()
	return LocalizationService:GetCountryRegionForPlayerAsync(plr)
end)

local autofarms = {
	["Go Coordinate"] = false,
}
local vib = {}
local currentPathTask = nil
local stopPathfinding = false

local screen_game = Instance.new("ScreenGui", gui)

local btn_button_new = Instance.new("ImageButton", screen_game)
btn_button_new.Size = UDim2.new(0, 50, 0, 50)
btn_button_new.Position = UDim2.new(0, 10, 0, 10)
btn_button_new.BorderSizePixel = 0
btn_button_new.Image = "rbxassetid://94540935178190"

local UI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Qwertys50/gui_cheat/refs/heads/main/main.luau'))()
local mainFrame, homeFrame, scrollFrame, pages, navFrame = UI.create_starter(screen_game)
local imageLabel: ImageLabel, nameLabel, countryLabel = UI.create_home(game.Name, homeFrame)

nameLabel.Text = plr.Name
countryLabel.Text = code

imageLabel.Image = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)

local button_cord, coord_event = UI.create_text_button("Go Coordinate", scrollFrame, false, false)


mainFrame.Visible = false

btn_button_new.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

local pfs = game:GetService("PathfindingService")

local my_id = gui.CoordinatesDisplay.Holder.TextHolder
local character = plr.Character

local chunks = workspace.Chunks :: Model

local function GetChunk()
	for _, i in ipairs(chunks:GetChildren()) do
		local zonePivot = i:GetPivot()
		local zoneSize = i:GetExtentsSize()
		local charPos = character:GetPivot().Position
		
		local minX = zonePivot.X - zoneSize.X/2
		local maxX = zonePivot.X + zoneSize.X/2
		local minY = zonePivot.Y - zoneSize.Y/2
		local maxY = zonePivot.Y + zoneSize.Y/2
		local minZ = zonePivot.Z - zoneSize.Z/2
		local maxZ = zonePivot.Z + zoneSize.Z/2
		
		if charPos.X >= minX and charPos.X <= maxX
		and charPos.Y >= minY and charPos.Y <= maxY
		and charPos.Z >= minZ and charPos.Z <= maxZ then
			return i
		end
	end
	return chunks:FindFirstChild("0,0")
end

local function getNumber(text)
	local parts = text:gsub("%s+", ""):split(",")
	local num1 = tonumber(parts[1])
	local num2 = tonumber(parts[2])
	return num1, num2
end

local function moveToPosition(targetPosition)
	local path = pfs:CreatePath({
		WaypointSpacing = 10
	})
	
	local success, errorMessage = pcall(function()
		path:ComputeAsync(character.HumanoidRootPart.Position, targetPosition)
	end)

	if success and path.Status == Enum.PathStatus.Success then
		local waypoints = path:GetWaypoints()
		
		for _, waypoint in ipairs(waypoints) do

			if stopPathfinding or not autofarms["Go Coordinate"] then
				character.Humanoid:MoveTo(character.HumanoidRootPart.Position)
				return false
			end
			
			character.Humanoid:MoveTo(waypoint.Position)
			
			local reached = character.Humanoid.MoveToFinished:Wait(5)
			if not reached then
				return false
			end
		end
		return true
	end

	return false
end

local function deleteModel(chunk)
	for _, i in ipairs(chunk:GetChildren()) do
		if i:IsA("Model") then deleteModel(i) end
		if i:IsA("BasePart") or i:IsA("Part") and i.Name ~= "Grass" then
			i.CanCollide = false
		end
	end
end

local function StartGo()
	if currentPathTask then
		task.cancel(currentPathTask)
		currentPathTask = nil
	end
	
	currentPathTask = task.spawn(function()
		local my_chunk = GetChunk()
		if not my_chunk then return end

		local num1, num2 = getNumber(my_chunk.Name)
		local my_1, my_2 = getNumber(select_id)

		local chunksToVisit = {}

		if num2 > my_2 then
			for z = num2, my_2, -1 do
				table.insert(chunksToVisit, {num1, z})
			end
		else
			for z = num2, my_2 do
				table.insert(chunksToVisit, {num1, z})
			end
		end

		if num1 <= my_1 then
			for x = num1 + 1, my_1 do
				table.insert(chunksToVisit, {x, my_2})
			end
		else
			for x = num1 - 1, my_1, -1 do
				table.insert(chunksToVisit, {x, my_2})
			end
		end

		for index, chunkCoords in ipairs(chunksToVisit) do
			if stopPathfinding or not autofarms["Go Coordinate"] then
				break
			end
			
			local chunkName = chunkCoords[1] .. "," .. chunkCoords[2]
			local targetChunk = chunks:FindFirstChild(chunkName) :: Model
			
			print(targetChunk)
			if targetChunk and targetChunk.PrimaryPart then      
					deleteModel(targetChunk.Enviromental)

					if targetChunk:FindFirstChild("ChunkSlots") then
						for _, i in ipairs(targetChunk.ChunkSlots:GetChildren()) do
							i.CanCollide = true
						end
					end
					
					local graves = targetChunk:FindFirstChild("Graves")
					if graves then 
						targetChunk.MainPart.CanCollide = true
						for _, i in ipairs(graves:GetChildren()) do
							if i:IsA("Model") then
								i.Main.CanCollide = true
								
								if i.Util:FindFirstChild("Tombstone") then
									i.Util.Tombstone.CanCollide = false
								end
								
								if i.Util:FindFirstChild("SaleSing") then
									i.Util.SaleSing.CanCollide = false
									if i.Util.SaleSing:FindFirstChild("Text") then
										i.Util.SaleSing.Text.CanCollide = false
									end
								end
							end
						end

						task.spawn(function()
							while task.wait() and targetChunk and targetChunk:FindFirstChild("Graves") do
								if stopPathfinding or not autofarms["Go Coordinate"] then break end
								
								for _, _i in ipairs(targetChunk.Graves:GetChildren()) do
									if _i:IsA("Model") then
										if _i.Util:FindFirstChild("Tombstone") then
											_i.Util.Tombstone.CanCollide = false
										end
										
										if _i.Util:FindFirstChild("SaleSign") then
											_i.Util.SaleSign.CanCollide = false
											if _i.Util.SaleSign:FindFirstChild("Text") then
												_i.Util.SaleSign.Text.CanCollide = false
											end
										end
									end
								end
							end
						end)
					end
				
				if stopPathfinding or not autofarms["Go Coordinate"] then
					break
				end
				
				local success = moveToPosition(targetChunk.PrimaryPart.Position)
				
				if stopPathfinding or not autofarms["Go Coordinate"] then
					break
				end
			end
		end
		
		currentPathTask = nil
	end)
end

button_cord.MouseButton1Up:Connect(function()
	if autofarms["Go Coordinate"] then
		autofarms["Go Coordinate"] = false
		stopPathfinding = true
	else
		autofarms["Go Coordinate"] = true
		stopPathfinding = false
		character = plr.Character
		if character and character.Parent then
			StartGo()
		end
	end
end)

coord_event.Event:Connect(function(text:String)
	select_id = text:gsub("%s+", "")
	
	if autofarms["Go Coordinate"] then
		stopPathfinding = true
		task.wait(0.1)
		stopPathfinding = false
		character = plr.Character
		if character and character.Parent then
			StartGo()
		end
	end
end)


local function stopCharacter()
	if character and character.Humanoid then
		character.Humanoid:MoveTo(character.HumanoidRootPart.Position)
		character.Humanoid:Move(Vector3.new(0,0,0), false)
	end
end

task.spawn(function()
	while task.wait(0.5) do
		if autofarms["Go Coordinate"] and not currentPathTask then
			character = plr.Character
			if character and character.Parent then
				StartGo()
			end
		elseif not autofarms["Go Coordinate"] then
			stopCharacter()
		end
	end
end)
