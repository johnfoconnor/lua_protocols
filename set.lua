local Enumerable = require 'enumerable'
local Iterator = require 'iterator'
local Set = {}
Set.__index = Set
setmetatable(Set, { __call = function(_, ...) return Set.new(...) end })

function Set.new()
    local self = setmetatable({}, Set)
    return self
end

function Set.insert(set, val)
    assert(set)
    assert(val)
    set[val] = true
    return set
end

function Set.remove(set, val)
    assert(set)
    assert(val)
    set[val] = nil
    return set
end

function Set.iterator(set)
    assert(set)
    return Iterator.new(pairs(set))
end

-- Collectable Protocol
--- IMPURE function
local collector = function(collection, cmd, value)
    if cmd == "cont" then
        return Set.insert(collection, value)
    elseif cmd == "done" then
        return collection
    elseif cmd == "halt" then
        return collection
    end
end

function Set.into() Set.into(Set.new()) end
function Set.into(initial) return initial, collector end

-- Enumerable Protocol
function Set.reduce(set, reducer, cmd, acc)
    return Set.do_reduce(Set.iterator(set), reducer, cmd, acc)
end

function Set.do_reduce(iter, reducer, cmd, acc)
    if cmd == "halt" then
        return "halted", acc
    elseif cmd == "suspend" then
        local fun = function(cmd, acc)
            Set.do_reduce(iter, reducer, cmd, acc)
        end
        return "suspended", acc, fun
    elseif cmd == "cont" then
        local val = Iterator._next(iter)
        if val[2] == nil then
            return "done", acc
        else
            -- val[2] is the value, we want the index
            cmd, acc = reducer(val[1], acc)
            return Set.do_reduce(iter, reducer, cmd, acc)
        end
    end
end

-- TODO make this data driven by taking the protocol impl as an arg
Enumerable:_impl(Set)
return Set
