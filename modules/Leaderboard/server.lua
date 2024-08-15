lib.callback.register('senor-stats:server:ObtainTop10', function(source, category)
    if not Config.DBFields[category] then return end

    local response = MySQL.query.await(string.format('SELECT `identifier`, `%s`, `name` FROM `players_stats` ORDER BY %s DESC LIMIT 10', category, category))

    local formattedData = {}
    for _, data in each(response) do
        print(string.format('%s %s', data[category], category))
        if category == 'playtime' then
            data[category] = SecondsToClock(data[category])
        end
        formattedData[#formattedData+1] = {
            title = string.format('%s %s', data.name, category),
            description = string.format('%s %s', data[category], category),
            icon = Enums.Icons[category],
        }
    end
    return formattedData
end)
