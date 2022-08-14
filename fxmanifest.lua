fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'MatthewVsTheWorld'
description 'Passive Mode For FiveM Servers'
version '0.0.2'


server_scripts {
    'config.lua'
}


client_scripts { 
    'config.lua',
    'c_passive.lua'
}

escrow_ignore {
    'script/config.lua'
  }