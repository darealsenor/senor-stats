local Kill = lib.class('Kill')
function Kill:constructor()
    self.EventLog = lib.array:new();
    self.size = 1
end

function Kill:tostring()
    print(json.encode(self.EventLog))
end

function Kill:Get()
    return self.EventLog
end

function Kill:onKill(killerId, victimId, weapon, headshot)
    lib.array.push(self.EventLog, {
        killer = killerId,
        victim = victimId,
        weapon = weapon,
        headshot = headshot,
        time = os.time()
    })


    self.size = self.size + 1;

    if self.size >= Config.UpdateSQLOn_Kills then
        self:SQLInsert()
        self.size = 1
    end
end

function Kill:ResetLog()
    self.EventLog = nil
    self.EventLog = lib.array:new();
end

function Kill:SQLInsert()

    if not next(self.EventLog) then return end

    local queries = lib.array:new()

    lib.array.forEach(self.EventLog, function(element)
        local killer,victim,weapon,time,headshot = element.killer, element.victim, element.weapon, element.time, element.headshot
        local victimLicense = GetPlayerIdentifierByType(victim, 'license')

        if killer and killer ~= 0 then -- killer = 0 means suicide
            local killerLicense = GetPlayerIdentifierByType(killer, 'license')
            if headshot then
                lib.array.push(queries,   { query = 'UPDATE players_stats SET kills = kills + 1, headshot = headshot + 1 WHERE identifier = (?)', values = { killerLicense }})
                return
            end
            lib.array.push(queries,   { query = 'UPDATE players_stats SET kills = kills + 1 WHERE identifier = (?)', values = { killerLicense }})
        end

        lib.array.push(queries,
        { query = 'UPDATE players_stats SET deaths = deaths + 1 WHERE identifier = (?)', values = { victimLicense }})
        end)

        local success = MySQL.transaction.await(queries)
        if success then
            print('Inserted to SQL')
            _Kill:ResetLog()
        end
end



RegisterNetEvent('senor-stats:server:onPlayerKilled')
AddEventHandler('senor-stats:server:onPlayerKilled', function(killerId, victimId, weapon, headshot)
    _Kill:onKill(killerId, victimId, weapon, headshot)
    -- _Kill:tostring()
end)


_Kill = Kill:new()