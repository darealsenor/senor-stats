RegisterNetEvent('senor-stats:server:UpdateField')
AddEventHandler('senor-stats:server:UpdateField', function(field, amount)
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license')


    MySQL.update.await(string.format('UPDATE players_stats SET %s = ? WHERE identifier = ?', field), {
        amount, identifier
    })
end)

RegisterNetEvent('senor-stats:server:IncrementField')
AddEventHandler('senor-stats:server:IncrementField', function(field, amount)
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license')

    amount = amount or 1


    MySQL.update.await(string.format('UPDATE players_stats SET %s = %s + ? WHERE identifier = ?', field, field), {
        amount, identifier
    })
end)