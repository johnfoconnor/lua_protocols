local Protocol = {}


function Protocol._impl(protocol, class)
    Protocol.validate_impl(protocol, class)
    Protocol._enable_protocol(protocol, class)
end

function Protocol.validate_impl(protocol, class)
    for i, v in ipairs(protocol.spec) do
        assert(type(class[v]) == "function", "protocol function not implemented")
    end
end

function Protocol._enable_protocol(protocol, class)
    if not class.__protocols then
        class.__protocols = {}
    end
    class.__protocols[protocol.name] = true
end


function Protocol.is_defined_for(name, class)
    assert(class.__protocols and class.__protocols[name],
           tostring(class) .. " is not " .. name)
    return true
end


-- create a Protocol with `name`
function Protocol.new(name, spec)
    assert(type(name) == "string", "protocol name must be a string")
    assert(type(spec) == "table", "supply a list of protocol function names")
    local protocol = {}
    protocol.name = name
    protocol.spec = spec
    protocol.is_defined_for = function(class)
        return Protocol.is_defined_for(name, class)
    end
    setmetatable(protocol, {__index = Protocol})
    return protocol
end


return Protocol
