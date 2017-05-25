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

mod.items = add_prefix{'wooden-chest', 'iron-chest', 'steel-chest'}
