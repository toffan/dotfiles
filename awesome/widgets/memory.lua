local naughty = require("naughty")
local vicious = require("vicious")
local wibox = require("wibox")

local notif_usage = nil
local memwidget = wibox.widget.textbox()

vicious.register(memwidget, vicious.widgets.mem,
    function(widget, args)
        local r = 'RAM: '
        local percent = args[1]

        if percent >= 80 then
            r = r .. '<span color="red">' .. percent .. '</span>%'
        elseif percent >= 60 then
            r = r .. '<span color="orange">' .. percent .. '</span>%'
        else
            r = r .. percent .. '%'
        end

        return r
    end, 3)


function memusage()
    local f = io.popen("free -h")
    local r = f:read("*all")
    f:close()
    return r
end


function ps()
    local r = '<span weight="bold">%MEM\tPID\tCOMMAND</span>'
    -- Get the list of processes
    local p = io.popen("ps x -o %mem=,pid=,args=")

    local progs = {}
    while true do
        local mem = p:read("*number")
        local pid = p:read("*number")
        local args = p:read("*line")
        if not args then
            break
        end
        table.insert(progs, {mem, pid, args})
    end

    -- Reverse sort by memory consumption
    table.sort(progs, function(a, b) return a[1] > b[1] end)

    -- Display the 10 greatest RAM consummers
    for k=1,10 do
        mem, pid, args = unpack(progs[k])
        if #args > 63 then
            args = args:sub(2,63) .. '…'
        else
            args = args:sub(2,-1)
        end
        r = r .. '\n' ..  mem .. '%\t' .. pid .. '\t' .. args
    end

    return r
end


memwidget:connect_signal("mouse::enter",
    function()
        notif_usage = naughty.notify({
            title = "Memory usage",
            timeout = 20,
            text = memusage() .. '\n' .. ps(),
            font = "Deja Vu Sans Mono 10",
        })
    end)


memwidget:connect_signal("mouse::leave",
    function()
        if notif_usage then
            naughty.destroy(notif_usage)
            notif_usage = nil
        end
        if notif then
            naughty.destroy(notif)
            notif = nil
        end
    end)

return memwidget
