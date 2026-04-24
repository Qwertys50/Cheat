local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local SERVER_LOG_FILE = "server_lumber.txt"
local placeId = game.PlaceId

-- ========== Файловые операции ==========
local function addVisitedServer(serverId)
    if not isfile(SERVER_LOG_FILE) then
        writefile(SERVER_LOG_FILE, "")
    end
    
    local content = readfile(SERVER_LOG_FILE)
    if not content:find(serverId, 1, true) then
        appendfile(SERVER_LOG_FILE, serverId .. "\n")
        print("[LOG] Added server to visited list:", serverId)
    end
end

local function isServerVisited(serverId)
    if not isfile(SERVER_LOG_FILE) then
        return false
    end
    
    local content = readfile(SERVER_LOG_FILE)
    return content:find(serverId, 1, true) ~= nil
end

local function getCurrentServerId()
    return game.JobId
end

-- ========== Получение списка серверов ==========
local function fetchAllServers()
    local allServers = {}
    local apiUrl = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100"
    
    print("[FETCH] Fetching servers from:", apiUrl)
    
    local success, response = pcall(function()
        return request({
            Url = apiUrl,
            Method = "GET",
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })
    end)
    
    if success and response and response.Success and response.Body then
        local decodeSuccess, decodedData = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)
        
        if decodeSuccess and decodedData and decodedData.data then
            for _, server in ipairs(decodedData.data) do
                table.insert(allServers, {
                    id = server.id,
                    playing = server.playing,
                    maxPlayers = server.maxPlayers,
                    region = server.region,
                    ping = server.ping
                })
            end
            
            -- Сортируем сервера: сначала с свободными местами, потом по количеству игроков
            table.sort(allServers, function(a, b)
                local aHasSpace = a.playing < a.maxPlayers
                local bHasSpace = b.playing < b.maxPlayers
                
                if aHasSpace ~= bHasSpace then
                    return aHasSpace
                end
                return a.playing < b.playing  -- Меньше игроков = лучше
            end)
            
            print("[FETCH] Found", #allServers, "servers")
            return allServers
        else
            warn("[FETCH] Failed to parse server data")
        end
    else
        warn("[FETCH] Failed to fetch servers:", success, response)
    end
    
    return {}
end

-- ========== Поиск самого маленького непосещенного сервера ==========
local function findSmallestUnvisitedServer()
    local servers = fetchAllServers()
    
    if #servers == 0 then
        print("[SEARCH] No servers found")
        return nil
    end
    
    local currentServerId = getCurrentServerId()
    local bestServer = nil
    local bestPlayerCount = math.huge
    
    for _, server in ipairs(servers) do
        -- Пропускаем текущий сервер
        if server.id ~= currentServerId then
            -- Проверяем, не посещали ли мы этот сервер
            if not isServerVisited(server.id) then
                -- Ищем сервер с меньшим количеством игроков
                if server.playing < bestPlayerCount then
                    bestPlayerCount = server.playing
                    bestServer = server
                end
            end
        end
    end
    
    if bestServer then
        print(string.format("[SEARCH] Found better server: %d players (current: %d players on current server)", 
            bestPlayerCount, #game.Players:GetPlayers()))
        return bestServer
    else
        print("[SEARCH] No unvisited smaller servers found")
        return nil
    end
end

-- ========== Подсчет CaveCrawler ==========
local function countCaveCrawlers()
    local count = 0
    for _, i in ipairs(Workspace:GetChildren()) do
        if i.Name == "TreeRegion" then
            for _, k in ipairs(i:GetDescendants()) do
                if k:IsA("StringValue") and k.Value == "CaveCrawler" and k.Parent.Owner:FindFirstChild("OwnerString") then
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- ========== Телепорт на другой сервер ==========
local function teleportToServer(serverId)
    if not serverId then
        print("[TELEPORT] No server ID provided")
        return false
    end
    
    print("[TELEPORT] Teleporting to server:", serverId)
    
    -- Добавляем текущий сервер в список посещенных
    addVisitedServer(getCurrentServerId())
    
    -- Настраиваем телепорт
    local TeleportOptions = Instance.new("TeleportOptions")
    TeleportOptions.ServerInstanceId = serverId
    
    -- Сохраняем скрипт для выполнения после телепорта
    queue_on_teleport(string.format([[
        loadstring(game:HttpGet("%s"))()
    ]], "https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/test2.lua"))
    
    -- Телепортируемся
    TeleportService:Teleport(placeId, LocalPlayer, nil, TeleportOptions)
    return true
end

-- ========== Основная логика ==========
local function findBetterServer()
    local currentCount = countCaveCrawlers()
    local currentPlayerCount = #Players:GetPlayers()
    
    print(string.format("[MAIN] Current server: %d players, %d CaveCrawlers", currentPlayerCount, currentCount))
    
    -- Если на сервере нет CaveCrawler'ов, проверяем не посещали ли мы его
    if currentCount == 0 then
        local currentServerId = getCurrentServerId()
        
        if isServerVisited(currentServerId) then
            print("[MAIN] Empty server already visited, looking for another...")
            local betterServer = findSmallestUnvisitedServer()
            
            if betterServer then
                teleportToServer(betterServer.id)
            else
                print("[MAIN] No better servers found, staying here")
            end
        else
            print("[MAIN] Found new empty server, claiming it")
            addVisitedServer(currentServerId)
        end
    else
        -- На сервере есть активность, ищем сервер с меньшим количеством игроков
        print("[MAIN] Server has activity, looking for smaller server...")
        local betterServer = findSmallestUnvisitedServer()
        
        if betterServer then
            teleportToServer(betterServer.id)
        else
            print("[MAIN] No smaller unvisited servers available")
        end
    end
end

-- ========== Настройка обработчика телепортов ==========
local function setupTeleportHandler()
    -- Добавляем текущий сервер в лог при старте
    addVisitedServer(getCurrentServerId())
    
    -- Настраиваем обработчик телепорта для игрока
    if LocalPlayer then
        LocalPlayer.OnTeleport:Connect(function()
            queue_on_teleport(string.format([[
                loadstring(game:HttpGet("%s"))()
            ]], "https://raw.githubusercontent.com/Qwertys50/Cheat/refs/heads/main/test2.lua"))
        end)
    end
end

-- ========== Инициализация ==========
-- Для новых игроков
game.Players.PlayerAdded:Connect(function(player)
    if player == LocalPlayer then
        setupTeleportHandler()
    end
end)

-- Для существующих игроков
for _, i in ipairs(game.Players:GetPlayers()) do
    if i == LocalPlayer then
        setupTeleportHandler()
        break
    end
end

-- Задержка перед поиском лучшего сервера
task.wait(2)

-- Запускаем поиск лучшего сервера
findBetterServer()
