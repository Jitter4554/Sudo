local elevatedPlayers = {}
local webhookURL = "YOUR_DISCORD_WEBHOOK_URL"  -- Replace with your actual Discord Webhook URL

-- Function to grant temporary elevated permissions
function GrantTemporaryPermissions(playerId)
    elevatedPlayers[playerId] = true
    -- Debug: Log permission grant
    print(string.format("[SUDO] Granted elevated permissions to Player ID %d", playerId))
end

-- Function to revoke temporary permissions
function RevokeTemporaryPermissions(playerId)
    elevatedPlayers[playerId] = nil
    -- Debug: Log permission revocation
    print(string.format("[SUDO] Revoked elevated permissions from Player ID %d", playerId))
end

-- Function to log actions to Discord via a webhook
function LogToDiscord(message, playerId)
    PerformHttpRequest(webhookURL, function(err, text, headers) 
        if err == 200 then
            print("[SUDO] Successfully logged to Discord")
        else
            print("[SUDO] Failed to log to Discord")
        end
    end, 'POST', json.encode({username = "Sudo Logger", content = message}), {['Content-Type'] = 'application/json'})
    
    -- Debug: Log the message being sent to Discord
    print(string.format("[SUDO] Logging to Discord: %s | Player ID: %d", message, playerId))
end

-- Register the "sudo" command
RegisterCommand("sudo", function(source, args, rawCommand)
    if source == 0 then
        if #args < 2 then
            print("[SUDO] Usage: sudo <player_id> <command>")
            return
        end

        local targetPlayerId = tonumber(args[1])
        local command = table.concat(args, " ", 2)

        if not targetPlayerId or not GetPlayerName(targetPlayerId) then
            print("[SUDO] Invalid player ID")
            return
        end

        -- Grant temporary permissions
        GrantTemporaryPermissions(targetPlayerId)
        
        -- Log the action to Discord
        LogToDiscord(string.format("Admin executed command '%s' as Player ID %d", command, targetPlayerId), targetPlayerId)

        -- Send the command to the client
        TriggerClientEvent('sudo:runCommand', targetPlayerId, command)

        -- Revoke permissions after a short delay
        Citizen.SetTimeout(1000, function()
            RevokeTemporaryPermissions(targetPlayerId)
        end)

        -- Debug: Confirm command execution
        print(string.format("[SUDO] Command '%s' executed as Player ID %d", command, targetPlayerId))
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', '[SUDO] This command can only be run from the console!' } })
        print(string.format("[SUDO] Player ID %d attempted to run a console-only command.", source))
    end
end, true)