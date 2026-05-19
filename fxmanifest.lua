fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'peak-clothingitems'
description 'Peak Clothing Items - Turn clothing into physical inventory items'
author 'Peak Studios'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/utils.lua',
    'shared/items.lua',
    'shared/config.lua',
    'locales/*.lua',
}

server_scripts {
    'server/init.lua',
    'server/bridge.lua',
    'server/clothing.lua',
    'server/items.lua',
    'server/main.lua',
}

client_scripts {
    'client/init.lua',
    'client/bridge.lua',
    'client/clothing.lua',
    'client/commands.lua',
    'client/menu.lua',
    'client/main.lua',
}
