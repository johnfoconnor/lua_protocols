local Enum = {}
Enum.__index = Enum

function Enum.count(enumerable)
    Enumerable.is_defined_for(enumerable)
    local reducer = function(x, acc)
        return "cont", acc + 1
    end
    local result, count = enumerable:reduce(reducer, "cont", 0)
    return count
end

function Enum.foldl(enumerable, acc, fun)
    Enumerable.is_defined_for(enumerable)
    local reducer = function(x, acc)
        return "cont", fun(x, acc)
    end
    local result, value = enumerable:reduce(reducer, "cont", acc)
    print(result, value)
    return value
end

local into = function(enumerable, initial, fun, callback)
    local value = Enum.foldl(enumerable, initial, callback)
    return fun(value, "done")
end

function Enum.into(enumerable, collectable, fun)
    Enumerable.is_defined_for(enumerable)
    Collectable.is_defined_for(collectable)
    local initial, collectable_fun = collectable:into()
    local callback = function(x, acc)
        return collectable_fun(acc, "cont", fun(x))
    end
    return into(enumerable, initial, collectable_fun, callback)
end


return Enum
