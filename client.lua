RegisterNetEvent('sudo:runCommand')
AddEventHandler('sudo:runCommand', function(command)
    print("[SUDO] Executing command: " .. command)
    
    ExecuteCommand(command)
    
    print("[SUDO] Command executed successfully")
end)