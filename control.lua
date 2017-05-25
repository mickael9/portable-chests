require 'defines'

function clone_inventory(inventory)
    local result = {}
    for i = 1, #inventory do
        local stack = inventory[i]
        if stack.valid_for_read then
            result[i] = { name = stack.name, count = stack.count }
        else
            result[i] = nil
        end
    end
    return result
end

function transfer_inventory(saved, inventory)
    for i = 1, #inventory do
        inventory[i].set_stack(saved[i])
    end
end

function our_item(name)
    return name:match('^' .. mod.prefix:gsub('[^%w]', '%%%0'))
end

function init()
    global.entities = global.entities or {}
    global.items = global.items or {}
end

script.on_event(defines.events.on_preplayer_mined_item, function(event)
    if not our_item(event.entity.name) then
        return
    end

    init()

    local player = game.players[event.player_index]
    local inventory = event.entity.get_inventory(defines.inventory.chest)

    global.entities[event.entity.unit_number] = clone_inventory(inventory)
    inventory.clear()
end)

script.on_event(defines.events.on_player_mined_entity, function(event)
    local unit = event.entity.unit_number
    local name = event.entity.name
    local buffer = event.buffer

    if not our_item(name) then
        return
    end

    init()
    
    local container_inv = global.entities[unit]
    if not container_inv then
        log("container inventory not found")
        return
    end

    local item = event.buffer.find_item_stack(name)

    if not item then
        log("where is the item?")
        return
    end

    local item_inv = item.get_inventory(defines.inventory.item_main)

    for _, item in pairs(mod.items) do
    end

    transfer_inventory(container_inv, item_inv)

    global.entities[unit] = nil
end)

script.on_event(defines.events.on_put_item, function(event)
    local player = game.players[event.player_index]
    local stack = player.cursor_stack

    if not stack.valid_for_read then
        return
    end

    if not our_item(stack.name) then
        return
    end

    init()

    local item_inv = stack.get_inventory(defines.inventory.item_main)

    global.items[player.index] = clone_inventory(item_inv)
end)

script.on_event(defines.events.on_built_entity, function(event)
    local entity = event.created_entity
    local player = game.players[event.player_index]
    local stack = player.cursor_stack

    if not our_item(entity.name) then
        return
    end

    local item_inv = global.items[player.index]
    if not item_inv then
        log("invalid saved inventory")
        return
    end

    local container_inv = entity.get_inventory(defines.inventory.chest)
    transfer_inventory(item_inv, container_inv)
end)
