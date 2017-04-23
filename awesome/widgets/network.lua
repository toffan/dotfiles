local naughty = require("naughty")
local vicious = require("vicious")
local wibox = require("wibox")

local notif = nil
local netwidget = wibox.widget.textbox()

vicious.register(netwidget, vicious.widgets.net,
    function(widget, args)
        if args['{enp4s0 carrier}'] ~= 0 then
            r = '<span weight="bold">LAN</span>'
        else
            r = 'LAN'
        end

        if args['{wlp3s0 carrier}'] ~= 0 then
            r = r .. ' - <span weight="bold">WLAN</span>'
        else
            r = r .. ' - WLAN'
        end

        return r
    end, 11)


netwidget:connect_signal("mouse::enter",
    function()
        local f = io.popen("ip addr show")
        local r = f:read("*all"):sub(1, -2)
        f:close()

        notif = naughty.notify({
            title = "Interfaces",
            timeout = 0,
            text = r,
            font = "Deja Vu Sans Mono 10",
        })
    end)


netwidget:connect_signal("mouse::leave",
    function()
        if notif then
            naughty.destroy(notif)
            notif = nil
        end
    end)

return netwidget
