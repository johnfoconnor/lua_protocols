local Enumerable = require 'enumerable'
local Iterator = require 'iterator'
local List = {}
List.__index = List
setmetatable(List, { __call = function(_, ...) return List.new(...) end })

function List.new()
    local self = setmetatable({}, List)
    return self
end

function List.iterator(list)
    return Iterator.new(ipairs(list))
end

-- Collectable Protocol
--- IMPURE function
local collector = function(collection, cmd, value)
    if cmd == "cont" then
        table.insert(collection, value)
        return collection
    elseif cmd == "done" then
        return collection
    elseif cmd == "halt" then
        return collection
    end
end

function List.into() List.into(List.new()) end
function List.into(initial) return initial, collector end

-- Enumerable Protocol
function List.reduce(list, reducer, cmd, acc)
    return List.do_reduce(List.iterator(list), reducer, cmd, acc)
end

function List.do_reduce(iter, reducer, cmd, acc)
    assert(iter)
    if cmd == "halt" then
        return "halted", acc
    elseif cmd == "suspend" then
        return "suspended", acc, function(cmd, acc)
            List.reduce(iter, reducer, cmd, acc)
        end
    elseif cmd == "cont" then
        local val = Iterator._next(iter)
        -- val[1] is the key/index, we want the value
        local state = val[2]
        if state == nil then
            return "done", acc
        else
            cmd, acc = reducer(state, acc)
            return List.do_reduce(iter, reducer, cmd, acc)
        end
    end
end

Enumerable:_impl(List)
return List
