JSON = (loadfile "json.lua")()
local serpent = require "serpent0272"
local inflate = require "deflatelua"
local base64 = require "base64"

function parse(data)
    if (string.sub(data, 1, 8) ~= "do local") then
        -- Decompress string
        local output = {}
        local input = base64.dec(data)
        local status, result = pcall(inflate.gunzip, { input = input, output = function(byte) output[#output+1] = string.char(byte) end })
        if (status) then
            data = table.concat(output)
        else
            return nil
        end
    end

    local status, result = serpent.load(data)
    if (not status) then
        return nil
    end

    json = JSON:encode(result)
    print(json)
end
parse(arg[1])

