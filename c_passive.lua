
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion','/'.. config.ChatCommand, 'Toggle Passive Mode', {
    })
	passiveMode = config.PassiveOnLoad
	coolDown = false
	coolDownTimeRemaining = 0
	isInSafeZone = false
end)

if (config.PassiveOnLoad) then
	passiveText = "Passive Mode Enabled"
else
	passiveText = ""
end

RegisterCommand(config.ChatCommand, function(source,args)
	TogglePassive()
end)

function TogglePassive() 

	if passiveMode then
		if not coolDown then
			SetCanAttackFriendly(GetPlayerPed(-1), true, false)
			NetworkSetFriendlyFireOption(true)
           		ShowNotification("Passive Mode Disabled - You might get hurt!") 
		    	passiveMode = false
			passiveText = ""
            		StartCooldown()
        	else
           		ShowNotification("You need to wait at least ".. tostring(coolDownTimeRemaining) .." seconds to enter passive mode") 
       	 	end
	else
        	if not coolDown then
            		SetCanAttackFriendly(GetPlayerPed(-1), false, false)
            		NetworkSetFriendlyFireOption(false)
           			ShowNotification("Passive Mode Enabled - You are safe!") 
            		passiveMode = true
			passiveText = "Passive Mode Enabled"
            		StartCooldown()
        	else
           		ShowNotification("You need to wait at least ".. tostring(coolDownTimeRemaining) .." seconds to exit passive mode.")
        	end
	end

end

function StartCooldown() 
	coolDown = true
	coolDownTimeRemaining = config.CoolDownTimer
	
	Citizen.CreateThread(function()
		while (coolDownTimeRemaining ~= 0) do
			Wait( 1000 ) 
			coolDownTimeRemaining = coolDownTimeRemaining - 1
		end
	end)

	Citizen.Wait(config.CoolDownTimer * 1000)
	coolDown = false
end


exports("passiveModeEnabled",function()
	return passiveMode
end)

exports("isInSafeZone",function()
	return isInSafeZone
end)

function ShowNotification( text )
	SetNotificationTextEntry( "STRING" )
	AddTextComponentString( text )
	DrawNotification( false, false )
end


Citizen.CreateThread(function()
    local _string = "STRING"
    local _scale = 0.42
    local _font = 4 
    
    while true do
            SetTextScale(_scale, _scale)
            SetTextColour(0,255,127,255)
            SetTextFont(_font)
            SetTextOutline()
            BeginTextCommandDisplayText(_string)
            AddTextComponentSubstringPlayerName(passiveText)
            EndTextCommandDisplayText(config.textPosX, config.textPosY)
        Wait(0)
    end
end)


-- SAFE ZONES
if config.useSafeZones then 
	Citizen.CreateThread(function ()
		while true do
		Citizen.Wait(5)
			
				local player = GetPlayerPed(-1)
				local playerLoc = GetEntityCoords(player)
				local posCounts = 0
				for _,location in ipairs(safeZones) do

					loc = {
						x=location[1][1],
						y=location[1][2], 
						z=location[1][3],
						heading= 0,
						radius = location[2]
					}
		
					
					if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, loc.x, loc.y, loc.z, loc.radius)  then
						posCounts += 1

					end
				end
				
				if posCounts > 0 then
					isInSafeZone = true
				else 
					isInSafeZone = false
				end

				postCounts = 0

				if isInSafeZone then
					DisablePlayerFiring(player, true)
				end

				if isInSafeZone and not passiveMode  then
					SetCanAttackFriendly(GetPlayerPed(-1), false, false)
					NetworkSetFriendlyFireOption(false)
					passiveText = "Safe Zone"
				elseif isInSafeZone and passiveMode then
					passiveText = "Safe Zone"
				elseif not isInSafeZone  and not passiveMode then 
					SetCanAttackFriendly(GetPlayerPed(-1), true, false)
					NetworkSetFriendlyFireOption(true)
					passiveText = ""
				elseif not isInSafeZone and passiveMode then
					SetCanAttackFriendly(GetPlayerPed(-1), false, false)
					NetworkSetFriendlyFireOption(false)
					passiveText = "Passive Mode Enabled"
				end

			end
		
	end)

end


function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end