RegisterNetEvent('senor-stats:client:OpenContext-PersonalStats')
AddEventHandler('senor-stats:client:OpenContext-PersonalStats',
                function(data, name, displaysettings, id)
    local dpiString = data.dpi ~= 0 and tostring(data.dpi) or
                          'The user hasn\'t updated his DPI'
    local sensString = data.sens ~= -1 and tostring(data.sens) or
                           'The user havent updated his sensitvity'

    local KD = (data.kills / data.headshot)
    local KDFormat = KD < 0 and KD or '0'
    print(KD < 0)
    local options = {
        {title = string.format('%s Kills', data.kills), icon = Enums.Icons['kills']},
        {title = string.format('%s Deaths', data.deaths), icon = Enums.Icons['deaths']},
        {title = string.format('%s Headshots', data.headshot), icon = Enums.Icons['headshot']},
        {
            title = string.format("%.2f K/D", KDFormat),
            icon = Enums.Icons['kd']
        }, {
            title = 'Playtime',
            description = string.format('%s Total playtime',
                                        SecondsToClock(data.playtime)),
            icon = Enums.Icons['playtime']
        }, {
            title = 'Resolution',
            description = string.format('%s:%s', displaysettings.res_x,
                                        displaysettings.res_y),
            icon = Enums.Icons['resolution']
        }, {
            title = 'DPI',
            description = dpiString,
            icon = Enums.Icons['dpi'],
            disabled = id ~= cache.serverId,
            onSelect = function()
                local input = lib.inputDialog('Update your DPI', {
                    {
                        type = 'number',
                        label = 'Your DPI',
                        description = 'Write it here..',
                        icon = 'hashtag',
                        min = 100,
                        max = 10000
                    }
                })

                if not input then return end
                TriggerServerEvent('senor-stats:server:UpdateField', 'dpi',
                                   input)
            end
        }, {
            title = 'Sensitvity',
            description = sensString,
            icon = Enums.Icons['sens'],
            disabled = id ~= cache.serverId,
            onSelect = function()
                local input = lib.inputDialog('Update your Sensitivity', {
                    {
                        type = 'number',
                        label = 'Your GTA Sensitivity',
                        description = 'Update it here',
                        icon = 'hashtag',
                        min = 0,
                        max = 20
                    }
                })

                if not input then return end
                TriggerServerEvent('senor-stats:server:UpdateField', 'sens',
                                   input)
            end
        }

    }
    lib.registerContext({
        id = 'stats',
        title = string.format('%s Stats', name),
        options = options
    })

    lib.showContext('stats')
end)



RegisterNetEvent('senor-stats:client:OpenContext-Leaderboard')
AddEventHandler('senor-stats:client:OpenContext-Leaderboard', function()
    local options = {}

    for category, _ in each(Config.DBFields) do
        if _ then
            options[#options+1] = {
                title = category,
                description = string.format('Check out Top 10 of %s category', category),
                icon = Enums.Icons[category],
                onSelect = function()
                    local subOptions = {}
                    local result = lib.callback.await('senor-stats:server:ObtainTop10', false, category)

                    print(json.encode(result))

                    lib.registerContext({
                        id = string.format('%s_leaderboard', category),
                        title = 'Top 10 ' .. category,
                        options = result
                    })
                
                    lib.showContext(string.format('%s_leaderboard', category))
                end
        }
        end
    end


    lib.registerContext({
        id = 'leaderboard',
        title = 'Leaderboards',
        options = options
    })

    lib.showContext('leaderboard')
end)
