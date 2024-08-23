function GetPlayer(identifier)
    local row = MySQL.single.await('SELECT * FROM `players_stats` WHERE `identifier` = ? LIMIT 1', {
        identifier
    })

    if not row then return 'User not found' end

    return row
end

lib.addCommand('stats', {
    help = 'Show statistics about you / target player',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
            optional = true,
        },
    },
}, function(source, args, raw)
    local _target = args.target and args.target or source
    local license = GetPlayerIdentifierByType(_target, 'license')

    local DisplaySettings = lib.callback.await('senor-stats:client:GetDisplaySettings', _target)

    TriggerClientEvent('senor-stats:client:OpenContext-PersonalStats', source, GetPlayer(license), GetPlayerName(_target), DisplaySettings, source)
end)

lib.addCommand('leaderboard', {
    help = 'Show statistics about you / target player',
}, function(source, args, raw)
    TriggerClientEvent('senor-stats:client:OpenContext-Leaderboard', source)
end)
