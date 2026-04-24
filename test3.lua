local Workspace = game:GetService("Workspace")
local stoped = false

game.Players.PlayerAdded:Connect(function(player)
    if player == game.Players.LocalPlayer then
        
        player.OnTeleport:Connect(function()

            queue_on_teleport(string.format([[
                loadstring(game:HttpGet("%s"))()
            ]], "https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/test2.lua"))
        end)

    end
end)

for _, i in ipairs(game.Players:GetPlayers()) do
    
    if i == game.Players.LocalPlayer then
        i.OnTeleport:Connect(function()

            queue_on_teleport(string.format([[
                loadstring(game:HttpGet("%s"))()
            ]], "https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/test2.lua"))
        end)
    end
end

local a = 0

for _, i in ipairs(Workspace:GetChildren()) do
	
	if i.Name == "TreeRegion" then
		
		for _, k in ipairs(i:GetDescendants()) do
			
			if k:IsA("StringValue") and k.Value == "CaveCrawler" and k.Parent.Owner:FindFirstChild("OwnerString") then
				
				a += 1
			end
		end
	end
end

if a == 0 then ame:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer) end
