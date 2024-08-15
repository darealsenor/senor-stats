fx_version "cerulean"
game "gta5"

shared_scripts {
    "config.lua",
    'modules/**/shared.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'modules/**/server.lua'
}

client_scripts {
    'client/*.lua',
    'modules/**/client.lua'
}

shared_script '@ox_lib/init.lua'

lua54 'yes'