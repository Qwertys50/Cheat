game.Players.PlayerAdded:Connect(function(player)
    if player == game.Players.LocalPlayer then
        
        player.OnTeleport:Connect(function()

            queue_on_teleport(string.format([[
                loadstring(game:HttpGet("%s"))()
            ]], "https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/test.lua"))
        end)

    end
end)

for _, i in ipairs(game.Players:GetPlayers()) do
    
    if i == game.Players.LocalPlayer then
        i.OnTeleport:Connect(function()

            queue_on_teleport(string.format([[
                loadstring(game:HttpGet("%s"))()
            ]], "https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/test.lua"))
        end)
    end
end

task.wait(1)
game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
