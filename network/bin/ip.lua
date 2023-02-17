local networklib = require("network")
local ethernet   = require("layers.ethernet")
local ipv4       = require("layers.ipv4")
local shell      = require("shell")

local args, opts = shell.parse(...)


if (args[1] == "a") then
    local interfaces = networklib.getInterface()
    for mac, itf in pairs(interfaces) do
        itf = itf.ethernet --[[@as EthernetInterface]]
        print(mac:match("(%x+)"))
        print(string.format("\tMAC : %s MTU : %d", itf:getAddr(), itf:getMTU()))
        local ipLayer = itf:getLayer(ethernet.TYPE.IPv4) --[[@as IPv4Layer]]
        print(string.format("\tIP : %s Mask : %s", ipv4.address.tostring(ipLayer:getAddr()), ipv4.address.tostring(ipLayer:getMask())))
    end
elseif (args[1] == "r") then
    local routes = networklib.router:listRoutes()
    for i, v in ipairs(routes) do
        print(string.format("%d : %-15s\t%-15s\t%-15s\t%d", i, ipv4.address.tostring(v.network), ipv4.address.tostring(v.mask), ipv4.address.tostring(v.gateway), v.metric or 0))
    end
end
