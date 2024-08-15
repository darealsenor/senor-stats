Will add instruction & code rewrite soon, only need SQL and ox_lib for now (QBCore only - will add support in future)
if you want to change out of QB go to Utils -> Client -> change OnJoin event.

and add this to QBCore -> server -> player.lua
        MySQL.insert(
            'INSERT INTO players_stats (identifier, name) VALUES(:identifier, :name) ON DUPLICATE KEY UPDATE name = :name', {
                identifier = PlayerData.license,
                name = PlayerData.name,
            }
        )

under function QBCore.Player.Save function (line 670 approxmiately - could change between core updates)