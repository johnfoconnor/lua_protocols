local Protocol = require 'protocol'
--list of function names required by this protocol
local spec = {
    "reduce"
}
local name = "enumerable"

local Enumerable = Protocol.new(name, spec)

return Enumerable
