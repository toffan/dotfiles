local awful = require("awful")
local naughty = require("naughty")

local notif = nil
local textclock = awful.widget.textclock("%a %d %b %H:%M", 13)

function get_timezones(zones)
    r = nil
    for _, zone in pairs(zones) do
        local label, tz = unpack(zone)
        local f = io.popen("TZ='" .. tz .. "' date +'%a %d %b %H:%M'")
        local line = f:read() .. ' - <b>' .. label .. '</b>'

        if r then
            r = r .. '\n' .. line
        else
            r = line
        end

        f:close()
    end

    return r
end

textclock:connect_signal("mouse::enter",
    function()
        notif = naughty.notify({
            title = "Time",
            timeout = 10,
            text = get_timezones({
                {"Mountain View", "America/Los_Angeles"},
                {"UTC", "UTC"},
                {"Paris", "Europe/Paris"},
                {"Amsterdam", "Europe/Amsterdam"},
            }),
            font = "Deja Vu Sans Mono 10",
        })
    end)

textclock:connect_signal("mouse::leave",
    function()
        if notif then
            naughty.destroy(notif)
            notif = nil
        end
    end)

return textclock
