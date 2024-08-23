local Playtime = lib.class('Playtime')

function Playtime:constructor()
    self.Players = {}
    self.Queue = {}
end

function Playtime:tostring()
    lib.print.info(json.encode(self.Players), json.encode(self.Queue))
end


function Playtime:AddPlayer(identifier)
    if self.Players[identifier] then return self.Players[identifier] end

    self.Players[identifier] = {
        joinedAt = os.time(),
    }

    lib.print.debug(string.format('Player: %s was Added to active players list', identifier))

    return self.Players[identifier]
end

function Playtime:RemovePlayer(identifier)
    if not self.Players[identifier] then return false end

    self.Queue[identifier] = os.time() - self.Players[identifier].joinedAt
    self.Players[identifier] = nil

    lib.print.debug(string.format('Player: %s was transferred to Queue from Active player and waiting to be updated in SQL', identifier))
end

function Playtime:UpdateSQL()

    for k,v in each (self.Players) do
        self:RemovePlayer(k)
    end

    local queries = lib.array:new()

    for identifier,playtime in each(self.Queue) do
        lib.array.push(queries, { query = 'UPDATE players_stats SET playtime = playtime + (?) WHERE identifier = (?)', values = { playtime, identifier }})
    end

    MySQL.transaction.await(queries)
    -- lib.print.info(string.format('SQL status:', success))
end

function Playtime:GetQueue()
    return self.Queue
end

RegisterNetEvent('senor-stats:server:PlayerJoined')
AddEventHandler('senor-stats:server:PlayerJoined', function()
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license')

    _Playtime:AddPlayer(identifier)
    _Playtime:tostring()

end)

RegisterNetEvent('senor-stats:server:PlayerLeft')
AddEventHandler('senor-stats:server:PlayerLeft', function()
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license')

    _Playtime:RemovePlayer(identifier)
    _Playtime:tostring()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    local players = GetPlayers()
    if not next(players) then return end
    for k,v in each(players) do
        local identifier = GetPlayerIdentifierByType(v, 'license')
    
        _Playtime:AddPlayer(identifier)
        -- _Playtime:tostring()
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(Config.PlaytimeInterval)
        _Playtime:UpdateSQL()
    end
end)

-- RegisterCommand('remove', function(source)
--     local identifier = GetPlayerIdentifierByType(source, 'license')

--     _Playtime:RemovePlayer(identifier)
--     _Playtime:tostring()
-- end)

_Playtime = Playtime:new()