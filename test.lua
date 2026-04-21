
game.Players.LocalPlayer.OnTeleport:Connect(function()

    queue_on_teleport(string.format([[
        loadstring(game:HttpGet("%s"))()
    ]], "https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/test.lua"))
end)

print(1)
