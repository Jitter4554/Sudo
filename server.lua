RegisterCommand("sudo", function(source, args, rawCommand)
    if source == 0 then
        if #args < 2 then
            print("Usage: sudo <player_id> <command>")
            return
        end

        local targetPlayerId = tonumber(args[1])
        local command = table.concat(args, " ", 2)

        if not targetPlayerId or not GetPlayerName(targetPlayerId) then
            print("Invalid player ID")
            return
        end

        TriggerClientEvent('sudo:runCommand', targetPlayerId, command)


        print(string.format("Executed command '%s' as player ID %d", command, targetPlayerId))
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'This command can only be run from the console!' } })
    end
end, true)
