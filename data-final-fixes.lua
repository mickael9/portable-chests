require 'util'
require 'defines'

for vanilla_item, item in pairs(mod.items) do
    local entity_prototype = util.table.deepcopy(data.raw.container[vanilla_item])
    local item_prototype = util.table.deepcopy(data.raw.item[vanilla_item])

    entity_prototype.name = item
    entity_prototype.minable.result = item
    entity_prototype.enable_inventory_bar = false
    entity_prototype.icon = mod.dir .. '/graphics/entity/' .. item .. '.png'

    item_prototype.name = item
    item_prototype.place_result = item
    item_prototype.type = 'item-with-inventory'
    item_prototype.stack_size = 1
    item_prototype.order = item_prototype.order .. '-a'
    item_prototype.inventory_size = entity_prototype.inventory_size
    item_prototype.fuel_category = nil
    item_prototype.fuel_value = nil
    item_prototype.icon = mod.dir .. '/graphics/icons/' .. item .. '.png'

    data:extend{
        entity_prototype, 
        item_prototype,
        {
            type = 'recipe',
            name = item,
            enabled = true,
            result = item,
            ingredients = {
                { vanilla_item, 10 },
            },
        },
    }
end


