RegisterNetEvent('sudo:runCommand')
AddEventHandler('sudo:runCommand', function(command)
    ExecuteCommand(command)
end)
