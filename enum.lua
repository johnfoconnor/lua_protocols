local Enum = {}
Enum.__index = Enum

function Enum.count(enumerable)
    assert(enumerable.__protocols["enumerable"], "not enumerable")
    local reducer = function(x, acc)
        return "cont", acc + 1
    end
    local result, count = enumerable:reduce(reducer, "cont", 0)
    return count
end

function Enum.foldl(enumerable, acc, fun)
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
    local initial, collectable_fun = collectable:into()
    local callback = function(x, acc)
        return collectable_fun(acc, "cont", fun(x))
    end
    return into(enumerable, initial, collectable_fun, callback)
end


return Enum
