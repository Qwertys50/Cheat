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


while task.wait() do  
    local a = 0  
    for _, i in ipairs(workspace:GetChildren()) do
        

        if i.Name == "Lolipop" then 
            a += 1
            task.wait()
            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = i.CFrame
        end
    end

    print(a)
    if a == 0 then 
        task.wait(10)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        
    break end
end
