local ESX = nil
-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Open ID card
RegisterServerEvent('idcard:open')
AddEventHandler('idcard:open', function(ID, targetID, type)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false
	local _PED_ID = PED_ID

	MySQL.Async.fetchAll('SELECT firstname, lastname, job, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				if type ~= nil then
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								show = true
							end
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('idcard:open', _source, array, type)
				else
					if Config.ESXNotify then
					TriggerClientEvent('esx:showNotification', _source, _U('no_card'))
					else
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = _U('no_card')})
					end
				end
			end)
		end
	end)
end)

local cards = {
	["id_card"] = 0,
	["license_drive"] = 1,
	["license_weapon"] = 2,
}

CreateThread(function()
	for k,v in pairs(cards) do
		ESX.RegisterUsableItem(k, function(source)
			TriggerClientEvent('event:control:idcard', source, v)
		end)
	end
end)