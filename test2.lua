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


while not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainUI") do task.wait() end
while not game:GetService("Players").LocalPlayer.PlayerGui.MainUI:FindFirstChild("ItemShop") do task.wait() end

local a = game:GetService("Players").LocalPlayer.PlayerGui.MainUI.ItemShop :: TextLabel

a:GetPropertyChangedSignal("Visible"):Connect(function()
    
    print(a.Visible)
end)
