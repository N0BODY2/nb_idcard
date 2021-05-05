ESX = nil

local open = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('idcard:open')
AddEventHandler('idcard:open', function( data, type)
	open = true
	SendNUIMessage({ action = "open", array  = data, type   = type })
end)

Citizen.CreateThread(function()
	while true do 
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then --ESC OR BACKSPACE
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)


RegisterNetEvent('event:control:idcard')
AddEventHandler('event:control:idcard', function(useID)

	if useID == 0 or useID == nil then
		ShowMenu('idcard')
	elseif useID == 1 then
		ShowMenu('driver')
	elseif useID == 2 then
		ShowMenu('weapon')
	end
end)

function ShowMenu(type)

	local type = type
	local playerPed = PlayerPedId()
	local elements = {}
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)

	for i=1, #players, 1 do
		table.insert(elements, {
			label = GetPlayerName(players[i]),
			player = players[i]
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'license_menu', {
		title = 'Who do you want to show ID to',
		elements = elements
	}, function(data, menu)
		local player =	GetPlayerServerId(data.current.player)
		menu.close()
		if type == 'idcard' then
			TriggerServerEvent('idcard:open', GetPlayerServerId(PlayerId()), player)
			animation()
		else
			TriggerServerEvent('idcard:open', GetPlayerServerId(PlayerId()), player, type)
			animation()
		end

	end, function(data, menu)
		menu.close()
	end)
end