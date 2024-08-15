lib.callback.register('senor-stats:client:GetDisplaySettings', function()
    local res_x, res_y = GetActiveScreenResolution()
    return {res_x = res_x, res_y = res_y}
end)
