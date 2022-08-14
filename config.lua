config = {}

config.PassiveOnLoad = true -- Should the player be in passive mode when they load in (true/false)
config.CoolDownTimer = 60  -- Ammount of time in seconds the player has to wait before toggling passive mode again
config.ChatCommand = 'passive' -- Sets the command players can use to toggle passive mode
config.textPosX = 0.175 -- X Position for passive mode text
config.textPosY = 0.933 -- Y Position for passive mode text
config.useSafeZones = true -- Enable/Disable the Safe Zones feature  [new feature, disable if you encounter issues]


safeZones = { -- { {x,y,z}, radius }
	{ {459.92, -979.64, 29.68}, 100 }, -- mission row pd 
	{ {-1095.87, -800.9, 18.03}, 50 } -- vecpucci pd 
}
