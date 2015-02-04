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


return Enum
