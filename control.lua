require 'defines'

function transfer_inventory(source, destination)
    for i = 1, #source do
        destination[i].set_stack(source[i])
    end
end

function our_item(name)
    return name:match('^' .. mod.prefix:gsub('[^%w]', '%%%0'))
end

script.on_event(defines.events.on_preplayer_mined_item, function(event)
    local entity = event.entity
    local player = game.players[event.player_index]

    if not our_item(entity.name) then
        return
    end

    -- Use a temporary item stack holder for safely transferring the inventory
    -- keeping blueprints and other stateful items intact
    local temp_entity = player.surface.create_entity{
        name = 'item-on-ground',
        position = entity.position,
        force = player.force,
        stack = entity.name,
    }
    local entity_inv = event.entity.get_inventory(defines.inventory.chest)
    local temp_inv = temp_entity.stack.get_inventory(defines.inventory.chest)

    transfer_inventory(entity_inv, temp_inv)
    player.insert(temp_entity.stack)

    temp_entity.destroy()
    entity.destroy()
end)

script.on_event(defines.events.on_put_item, function(event)
    local player = game.players[event.player_index]
    local stack = player.cursor_stack
    local position = event.position

    if not our_item(stack.name) or not stack.valid_for_read then
        return
    end

    local item_inv = stack.get_inventory(defines.inventory.item_main)

    local place = {
        name = stack.name,
        position = event.position,
        force = player.force
    }

    if not player.surface.can_place_entity(place) then
        return
    end

    local entity = player.surface.create_entity(place)
    local entity_inv = entity.get_inventory(defines.inventory.chest)

    transfer_inventory(item_inv, entity_inv)

    stack.clear()

    script.raise_event(defines.events.on_built_entity, {
        created_entity = entity,
        player_index = player.index,
        item = entity.name
    })
end)
