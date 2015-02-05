local Protocol = require 'protocol'
--list of function names required by this protocol
local spec = {
    "into"
}

return Protocol.new("collectable", spec)
