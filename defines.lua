require 'util'

function table:merge(other)
    local result = util.table.deepcopy(self)

    for k, v in pairs(other) do
        result[k] = v
    end

    return result
end

mod = {}

mod.name = 'portable-chests'
mod.prefix = mod.name .. '-'
mod.dir = '__' .. mod.name .. '__'

function add_prefix(items)
    local result = {}
    for _, item in pairs(items) do
        result[item] = mod.prefix .. item
    end
    return result
end

mod.containers = add_prefix{'wooden-chest', 'iron-chest', 'steel-chest'}
mod.unlock_recipes = {
    ['steel-processing'] = { mod.containers['steel-chest'] }
}
