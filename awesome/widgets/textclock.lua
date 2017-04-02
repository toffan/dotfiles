local awful = require("awful")
local naughty = require("naughty")

local notif = nil
local textclock = awful.widget.textclock("%a %d %b %H:%M", 10)

function timezones(zones)
    result = nil
    for _, zone in pairs(zones) do
        local f = io.popen("TZ='" .. zone[2] .. "' date +'%a %d %b %H:%M'")
        local line = f:read() .. ' - <b>' .. zone[1] .. '</b>'

        if result ~= nil then
            result = result .. '\n' .. line
        else
            result = line
        end

        f:close()
    end

    return result
end

textclock:connect_signal("mouse::enter",
    function()
        if notif == nil then
            notif = naughty.notify({
                title = "Time",
                timeout = 10,
                text = timezones({
                    {"Mountain View", "America/Los_Angeles"},
                    {"UTC", "UTC"},
                    {"Paris", "Europe/Paris"},
                    {"Amsterdam", "Europe/Amsterdam"},
                })
            })
        end
    end)

textclock:connect_signal("mouse::leave",
    function()
        if notif ~= nil then
            naughty.destroy(notif)
            notif = nil
        end
    end)

return textclock
