AddEventHandler('gameEventTriggered', function(event, data)
    if event == 'CEventNetworkEntityDamage' then
        local victim, attacker, victimDied, weapon = data[1], data[2], data[4],
                                                     data[7]
        if not IsEntityAPed(victim) then return end
        if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and
            IsEntityDead(PlayerPedId()) then

            local headshot = false

            local found, bone = GetPedLastDamageBone(victim)
            if found and (bone == 31086 or bone == 39317) then
                headshot = true
            end

            local killerId = GetPlayerServerId(
                                 NetworkGetPlayerIndexFromPed(attacker))
            local victimId = GetPlayerServerId(
                                 NetworkGetPlayerIndexFromPed(victim))
            -- playerId = victimId
            TriggerEvent('senor-stats:client:onPlayerKilled', killerId,
                         victimId, weapon, headshot)
            TriggerServerEvent('senor-stats:server:onPlayerKilled', killerId,
                               victimId, weapon, headshot)
        end
    end
end)

