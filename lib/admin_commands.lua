-- admin_commands.lua
-- May 2019
-- 
-- Yay, admin commands!

require("lib/oarc_utils")

-- name :: string: Name of the command.
-- tick :: uint: Tick the command was used.
-- player_index :: uint (optional): The player who used the command. It will be missing if run from the server console.
-- parameter :: string (optional): The parameter passed after the command, separated from the command by 1 space.

-- Give yourself or another player, power armor
commands.add_command("give-power-armor-kit", "give a start kit", function(command)
    
    local player = game.players[command.player_index]
    local target = player
    
    if player ~= nil and player.admin then
        if (command.parameter ~= nil) then
        	if game.players[command.parameter] ~= nil then
        		target = game.players[command.parameter]
        	else
        		target.print("Invalid player target. Double check the player name?")
        		return
        	end
        end

        GiveQuickStartPowerArmor(target)
        player.print("Gave a powerstart kit to " .. target.name)
        target.print("You have been given a power armor starting kit!")
    end
end)


commands.add_command("give-test-kit", "give a start kit", function(command)
    
    local player = game.players[command.player_index]
    local target = player
    
    if player ~= nil and player.admin then
        if (command.parameter ~= nil) then
            if game.players[command.parameter] ~= nil then
                target = game.players[command.parameter]
            else
                target.print("Invalid player target. Double check the player name?")
                return
            end
        end

        GiveTestKit(target)
        player.print("Gave a test kit to " .. target.name)
        target.print("You have been given a test kit!")
    end
end)


commands.add_command("load-quickbar", "Pre-load quickbar shortcuts", function(command)

    local p = game.players[command.player_index]

    -- 1st Row
    p.set_quick_bar_slot(1, "transport-belt");
    p.set_quick_bar_slot(2, "small-electric-pole");
    p.set_quick_bar_slot(3, "inserter");
    p.set_quick_bar_slot(4, "underground-belt");
    p.set_quick_bar_slot(5, "splitter");

    p.set_quick_bar_slot(6, "coal");
    p.set_quick_bar_slot(7, "repair-pack");
    p.set_quick_bar_slot(8, "gun-turret");
    p.set_quick_bar_slot(9, "stone-wall");
    p.set_quick_bar_slot(10, "radar");

    -- 2nd Row
    p.set_quick_bar_slot(11, "stone-furnace");
    p.set_quick_bar_slot(12, "wooden-chest");
    p.set_quick_bar_slot(13, "steel-chest");
    p.set_quick_bar_slot(14, "assembling-machine-1");
    p.set_quick_bar_slot(15, "assembling-machine-2");

    p.set_quick_bar_slot(16, nil);
    p.set_quick_bar_slot(17, nil);
    p.set_quick_bar_slot(18, nil);
    p.set_quick_bar_slot(19, nil);
    p.set_quick_bar_slot(20, nil);

    -- 3rd Row
    p.set_quick_bar_slot(21, "electric-mining-drill");
    p.set_quick_bar_slot(22, "fast-inserter");
    p.set_quick_bar_slot(23, "long-handed-inserter");
    p.set_quick_bar_slot(24, "medium-electric-pole");
    p.set_quick_bar_slot(25, "big-electric-pole");

    p.set_quick_bar_slot(26, "stack-inserter");
    p.set_quick_bar_slot(27, nil);
    p.set_quick_bar_slot(28, nil);
    p.set_quick_bar_slot(29, nil);
    p.set_quick_bar_slot(30, nil);

    -- 4th Row
    p.set_quick_bar_slot(31, "fast-transport-belt");
    p.set_quick_bar_slot(32, "medium-electric-pole");
    p.set_quick_bar_slot(33, "fast-inserter");
    p.set_quick_bar_slot(34, "fast-underground-belt");
    p.set_quick_bar_slot(35, "fast-splitter");

    p.set_quick_bar_slot(36, "stone-wall");
    p.set_quick_bar_slot(37, "repair-pack");
    p.set_quick_bar_slot(38, "gun-turret");
    p.set_quick_bar_slot(39, "laser-turret");
    p.set_quick_bar_slot(40, "radar");

    -- 5th Row
    p.set_quick_bar_slot(41, "train-stop");
    p.set_quick_bar_slot(42, "rail-signal");
    p.set_quick_bar_slot(43, "rail-chain-signal");
    p.set_quick_bar_slot(44, "rail");
    p.set_quick_bar_slot(45, "big-electric-pole");

    p.set_quick_bar_slot(46, "locomotive");
    p.set_quick_bar_slot(47, "cargo-wagon");
    p.set_quick_bar_slot(48, "fluid-wagon");
    p.set_quick_bar_slot(49, "pump");
    p.set_quick_bar_slot(50, "storage-tank");

    -- 6th Row
    p.set_quick_bar_slot(51, "oil-refinery");
    p.set_quick_bar_slot(52, "chemical-plant");
    p.set_quick_bar_slot(53, "storage-tank");
    p.set_quick_bar_slot(54, "pump");
    p.set_quick_bar_slot(55, nil);

    p.set_quick_bar_slot(56, "pipe");
    p.set_quick_bar_slot(57, "pipe-to-ground");
    p.set_quick_bar_slot(58, "assembling-machine-2");
    p.set_quick_bar_slot(59, "pump");
    p.set_quick_bar_slot(60, nil);

    -- 7th Row
    p.set_quick_bar_slot(61, "roboport");
    p.set_quick_bar_slot(62, "logistic-chest-storage");
    p.set_quick_bar_slot(63, "logistic-chest-passive-provider");
    p.set_quick_bar_slot(64, "logistic-chest-requester");
    p.set_quick_bar_slot(65, "logistic-chest-buffer");

    p.set_quick_bar_slot(66, "logistic-chest-active-provider");
    p.set_quick_bar_slot(67, "logistic-robot");
    p.set_quick_bar_slot(68, "construction-robot");
    p.set_quick_bar_slot(69, nil);
    p.set_quick_bar_slot(70, nil);

end)

commands.add_command("tp", "Teleport To Your Friend's Spawn", function(command)
    
    local player = game.players[command.player_index]
    
    if (player.vehicle) then
        player.print("先生，请先下车，然后再尝试传送...")
        return
    end

    if (command.parameter == nil) then
        player.print("非法参数? /tp [玩家名]")
        return
    end

    local target
    local count = 1
    for i in string.gmatch(command.parameter, "%S+") do
        if (count == 1) then
            target = i
        end
        count = count + 1
    end

    if (count ~= 2) then
        player.print("非法参数? /tp [玩家名]")
        return
    end

    if (player.name == target) then
        player.print("不能传送到自己家")
        return
    end

    -- Validate all the things...
    if (game.players[target] and 
        not game.players[target].ticks_to_respawn and 
        player) then
        local target_player = game.players[target]
        if (DoesPlayerHaveCustomSpawn(player)) then
            SafeTeleport(player,
                            game.surfaces[GAME_SURFACE_NAME],
                            global.ocore.playerSpawns[target])
            target_player.print("你的好友 " .. player.name .. " 来到了你的基地.")
        else
            player.print("你的好友 " .. target .. " 还没有基地,不能传送.")
            return
        end
    end
end)

commands.add_command("rm_player", "remove player offline", function(command)
    
    local player = game.players[command.player_index]
    
    if player == nil then
        return
    end

    if player ~= nil and not player.admin then
        player.print("命令仅管理员可用, 你不是管理员")
    end

    if (command.parameter == nil) then
        player.print("非法参数? /rm_player [玩家名]")
        return
    end

    local target
    local count = 1
    for i in string.gmatch(command.parameter, "%S+") do
        if (count == 1) then
            target = i
        end
        count = count + 1
    end

    if (count ~= 2) then
        player.print("非法参数? /rm_player [玩家名]")
        return
    end

    if (game.players[target] and 
        not game.players[target].ticks_to_respawn and 
        player) then
        -- Check if online
        online_flag = false
        for _,player in pairs(game.connected_players) do
            if player.name == target then
                player.print("玩家 " .. target .. " 当前在线,无法删除")
                return
            end
        end
        if not online_flag then
            local target_player = game.players[target]
            RemoveOrResetPlayer(target_player,true,true,true,true)
            SendBroadcastMsg("管理员 " .. player.name .. " 删除了玩家 " .. target .. " 的废弃基地")
        end
    end
end)