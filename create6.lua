local stoped = false

game.Players.PlayerAdded:Connect(function(player)

    if player == game.Players.LocalPlayer then
        
        print(123)
        player.OnTeleport:Connect(function()

            queue_on_teleport(string.format([[
                loadstring(game:HttpGet("%s"))()
            ]], "https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/create6.lua"))
        end)

    end
end)

for _, i in ipairs(game.Players:GetPlayers()) do
    
    if i == game.Players.LocalPlayer then
    print(123)
        i.OnTeleport:Connect(function()

            queue_on_teleport(string.format([[
                loadstring(game:HttpGet("%s"))()
            ]], "https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/create6.lua"))
        end)
    end
end

print(1)
