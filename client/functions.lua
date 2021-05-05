function animation()
	local ped = PlayerPedId()
	if not IsPedSittingInAnyVehicle(ped) then 
	ClearPedSecondaryTask(ped)

	RequestAnimDict("mp_common")
	while (not HasAnimDictLoaded("mp_common")) do 
		Citizen.Wait(10) 
	end

	TaskPlayAnim(ped,"mp_common","givetake1_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
	SetCurrentPedWeapon(ped, 0xA2719263)
	Citizen.Wait(1500)
	ClearPedSecondaryTask(ped) 
  end
end
