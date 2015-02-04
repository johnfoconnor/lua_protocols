local Protocol = require 'protocol'
--list of function names required by this protocol
local spec = {
    "reduce"
}

return Protocol.new("enumerable", spec)
