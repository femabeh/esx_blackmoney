local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj  end)

RegisterServerEvent('fex_blackmoney:washMoney')
AddEventHandler('fex_blackmoney:washMoney', function(value)
	local xPlayer = ESX.GetPlayerFromId(source)
	accountMoney = xPlayer.getAccount('black_money').money

    if accountMoney > 0 then
        xPlayer.removeAccountMoney('black_money', value)
        xPlayer.addMoney(value)
        notification(_U('money_washed')..value)
    end
end)

ESX.RegisterServerCallback('fex_blackmoney:getBlackmoney', function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(source)
	local accountMoney = xPlayer.getAccount('black_money').money
    
    cb(accountMoney)
end)

