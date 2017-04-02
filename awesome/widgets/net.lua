local wibox = require("wibox")
local vicious = require("vicious")
local naughty = require("naughty")

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
    end, 10)

netwidget:connect_signal("mouse::enter",
    function()
        if textclock_notif == nil then
            local result = io.popen("ip addr show"):read("*a")
            notif = naughty.notify({
                title = "Interfaces",
                timeout = 0,
                text = result,
            })
        end
    end)

netwidget:connect_signal("mouse::leave",
    function()
        if notif ~= nil then
            naughty.destroy(notif)
            notif = nil
        end
    end)

return netwidget
