RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
   TriggerServerEvent('senor-stats:server:PlayerJoined')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('senor-stats:server:PlayerLeft')
end)