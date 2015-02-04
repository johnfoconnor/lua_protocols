local Iterator = {}

--- creates an iterator container
-- example `Iterator.new(pairs(my_table))`
function Iterator.new(gen, param, state)
    return {
        gen,
        param,
        state
    }
end

-- returns the next element in the iterator, or nil if no more elements exist
function Iterator._next(iter)
    local gen, param, state = unpack(iter)
    local vals = {gen(param, state)}
    iter[3] = vals[1]
    return vals
end

return Iterator
