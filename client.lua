local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local open = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Open ID card
RegisterNetEvent('idcard:open')
AddEventHandler('idcard:open', function( data, type)
	open = true
	SendNUIMessage({ action = "open", array  = data, type   = type })
end)

-- Key events
Citizen.CreateThread(function()
	while true do 
		Wait(0)
		if IsControlJustReleased(0, Keys['ESC']) and open or IsControlJustReleased(0, Keys['BACKSPACE']) and open or IsControlJustReleased(0, Keys['F9']) and open then --ESC OR BACKSPACE
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
		else
			TriggerServerEvent('idcard:open', GetPlayerServerId(PlayerId()), player, type)
		end

	end, function(data, menu)
		menu.close()
	end)
end