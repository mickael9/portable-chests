require 'defines'

for vanilla_item, item in pairs(mod.containers) do
    local entity_prototype = data.raw.container[vanilla_item]
    local item_prototype = data.raw.item[vanilla_item]
    local recipe_prototype = data.raw.recipe[vanilla_item]

    local entity_prototype = table.merge(entity_prototype, {
        name = item,
        enable_inventory_bar = false,
        icon = mod.dir .. '/graphics/icons/' .. item .. '.png',
        order = item_prototype.order .. '-a',
    })

    entity_prototype.minable.result = item
    entity_prototype.picture.filename = mod.dir .. '/graphics/entity/' .. item .. '.png'
    entity_prototype.fast_replaceable_group = nil

    local builder_prototype = table.merge(entity_prototype, {
        name = item .. '-builder',
        localised_name = { 'entity-name.' .. item },
        localised_description = { 'entity-description.' .. item },
    })

    local item_prototype = {
        name = item,
        type = 'item-with-inventory',
        flags = {'goes-to-quickbar'},
        subgroup = item_prototype.subgroup,
        stack_size = 1,
        order = item_prototype.order .. '-a',
        inventory_size = entity_prototype.inventory_size,
        icon = mod.dir .. '/graphics/icons/' .. item .. '.png',
        localised_name = {'entity-name.' .. item},
        place_result = item .. '-builder',
        draw_label_for_cursor_render = true,
    }

    data:extend{
        entity_prototype,
        builder_prototype,
        item_prototype,
        {
            type = 'recipe',
            name = item,
            enabled = recipe_prototype.enabled,
            result = item,
            ingredients = {
                { vanilla_item, 1 },
                { 'electronic-circuit', entity_prototype.inventory_size },
            },
        },
    }
end

for technology, recipes in pairs(mod.unlock_recipes) do
    for _, recipe in pairs(recipes) do
        table.insert(data.raw.technology[technology].effects, {
            type = 'unlock-recipe',
            recipe = recipe,
        })
    end
end
