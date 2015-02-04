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

-- Enumerable Protocol
function List.reduce(list, reducer, cmd, acc)
    List.do_reduce(List.iterator(list), reducer, cmd, acc)
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
        if val[2] == nil then
            return "done", acc
        else
            cmd, acc = reducer(val[1], acc)
            return List.do_reduce(iter, reducer, cmd, acc)
        end
    end
end

Enumerable:_impl(List)
return List
