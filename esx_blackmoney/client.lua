ESX = nil

CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
	while ESX.GetPlayerData().job == nil do Wait(100) end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
  PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerped = GetPlayerPed(-1)
        if ESX.PlayerData.job then
            for k,v in pairs(Config.Jobs) do
                if ESX.PlayerData.job.name == v then
                    DrawMarker(Config.Marker.type, Config.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Marker.size, Config.Marker.size, Config.Marker.size, Config.Marker.red, Config.Marker.green, Config.Marker.blue, 100, false, true, 2, false, false, false, false)
                end
            end
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerped = GetPlayerPed(-1)
        if ESX.PlayerData.job then
            for k,v in pairs(Config.Jobs) do
                if ESX.PlayerData.job.name == v then
                    if GetDistanceBetweenCoords(Config.Pos.x, Config.Pos.y, Config.Pos.z, GetEntityCoords(playerped)) < 1.0 then
                        helpnotification(_U('open'))
                        if IsControlPressed(0, Config.Open) then
                            ESX.TriggerServerCallback('fex_blackmoney:getBlackmoney', function(data)
                                if data > 0 then
                                    OpenMainMenu()
                                else
                                    notification(_U('NoMoney'))
                                end
                            end)
                            Citizen.Wait(1000)
                        end
                    end
                end
            end
        end
	end
end)



function OpenMainMenu()
    ESX.TriggerServerCallback('fex_blackmoney:getBlackmoney', function(data)
        local elements = {
            {label     = _U('Blackmoney'),
            value      = data,
            type       = 'slider',
            min        = 1,
            max        = data},
        }
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'fex_insured-main',
        {
            title    = (_U('title')),
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            TriggerServerEvent('fex_blackmoney:washMoney', data.current.value)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end)
end
