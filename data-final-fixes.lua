require 'util'
require 'defines'

for vanilla_item, item in pairs(mod.containers) do
    local entity_prototype = util.table.deepcopy(data.raw.container[vanilla_item])
    local item_prototype = util.table.deepcopy(data.raw.item[vanilla_item])
    local recipe_prototype = data.raw.recipe[vanilla_item]

    entity_prototype.name = item
    entity_prototype.minable.result = item
    entity_prototype.enable_inventory_bar = false
    entity_prototype.icon = mod.dir .. '/graphics/icons/' .. item .. '.png'
    entity_prototype.order = item_prototype.order .. '-a'
    entity_prototype.fast_replaceable_group = nil
    entity_prototype.picture.filename = mod.dir .. '/graphics/entity/' .. item .. '.png'

    item_prototype.name = item
    item_prototype.type = 'item-with-inventory'
    item_prototype.stack_size = 1
    item_prototype.order = item_prototype.order .. '-a'
    item_prototype.inventory_size = entity_prototype.inventory_size
    item_prototype.fuel_category = nil
    item_prototype.fuel_value = nil
    item_prototype.icon = mod.dir .. '/graphics/icons/' .. item .. '.png'
    item_prototype.localised_name = {'entity-name.' .. item}

    -- place_result unchanged becaused we don't want blueprints to be able to use the portable chest type
    -- since robots can pickup a non-empty chest when an empty one was requested
    -- side effect are that portable chests appear as normal chests before they're placed
    -- and that they can't be marked for deconstruction
    --item_prototype.place_result = item

    data:extend{
        entity_prototype, 
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

table.insert(data.raw.technology['steel-processing'].effects, {
    type = 'unlock-recipe',
    recipe = mod.containers['steel-chest'],
})
