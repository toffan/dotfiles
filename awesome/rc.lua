-- Required libraries {{{
-- Standard awesome library
local gears     = require("gears")
local awful     = require("awful")
                  require("awful.autofocus")
-- Widget and layout library
local wibox     = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty   = require("naughty")
-- Miscellaneous
local vicious = require("vicious")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- }}}

-- Error handling {{{
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify({
                preset = naughty.config.presets.critical,
                title = "Oops, an error happened!",
                text = tostring(err)
            })
            in_error = false
        end)
end
-- }}}

-- Variable definitions {{{
-- This is used later as the default terminal and editor to run.
altkey      = "Mod1"
modkey      = "Mod4"
terminal    = "terminator"
editor      = os.getenv("EDITOR")
editor_cmd  = terminal .. " -e " .. editor
browser     = os.getenv("BROWSER")
mail_client = "thunderbird"
-- }}}

-- Menu {{{
mainmenu = awful.menu({items = {
    {"awesome", {
        {"hotkeys", function() return false, hotkeys_popup.show_help end},
        {"manual", terminal .. " -e man awesome"},
        {"restart", awesome.restart},
        {"quit", {{"I mean it", awesome.quit}},},
    }, os.getenv("HOME") .. "/.config/awesome/icons/awesome32.png"},
    {"system", {
        {"suspend", function()
                awful.spawn("i3lock -u -t -i " .. os.getenv("HOME") .. "/Pictures/Wallpapers/screenlock; systemctl suspend")
            end},
        {"reboot", {{"I mean it", terminal .. " -e 'systemctl reboot'"}},},
        {"shutdown", {{"I mean it", terminal .. " -e 'systemctl poweroff'"}},},
    }, os.getenv("HOME") .. "/.config/awesome/icons/system32.png"},
}})
-- }}}

-- Wibox {{{
separator = wibox.widget.textbox(' | ')
padding = wibox.widget.textbox('  ')

-- Create a textclock widget {{{
textclock = require("widgets.textclock")
-- }}}

-- Battery Widget {{{
batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat,
    function(widget, args)
        r = 'BAT: '

        if args[3] == 'N/A' then
            r = r .. '↯'
        else
            r = r .. args[1]
        end

        r = r .. ' '
        if args[2] < 15 then
            r = r .. '<span color="red">' .. args[2] .. '</span>'
        elseif  args[2] < 35 then
            r = r .. '<span color="orange">' .. args[2] .. '</span>'
        else
            r = r .. args[2]
        end

        r = r .. '% '
        if args[3] ~= 'N/A' then
            r = r .. '(' .. args[3] .. ')'
        end

        -- notification if need to load
        if args[1] == '-' and args[2] < 75 then
            naughty.notify({
                    preset = naughty.config.presets.critical,
                    title = 'Batterie',
                    text = 'La batterie doit être chargée immédiatement !',
                    timeout = 30
            })
        end

        return r
    end, 10, 'BAT0')
-- }}}

-- Volume Widget {{{
volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume,
    function(widget, args)
        r = ''

        if args[2] == '♫' then
            r = 'SOUND: '
        else
            r = 'MUTED: '
        end

        r = r .. args[1] .. '%'

        return r
    end, 4, 'Master')
-- }}}

-- Memory Widget {{{
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem,
    function(widget, args)
        r = 'RAM: '

        if args[1] >= 80 then
            r = r .. '<span color="red">' .. args[1] .. '</span>'
        elseif args[1] >= 60 then
            r = r .. '<span color="orange">' .. args[1] .. '</span>'
        else
            r = r .. args[1]
        end

        r = r .. '%'

        return r
    end, 2)
-- }}}

-- CPU Temperature Widget {{{
cputempwidget = wibox.widget.textbox()
vicious.register(cputempwidget, vicious.widgets.thermal,
    function(widget, args)
        r = 'T: '
        temp = math.floor(args[1])
        color = ''

        if temp < 45 then
            color = 'turquoise'
        elseif  temp < 60 then
            color = 'yellow'
        elseif  temp < 75 then
            color = 'orange'
        else
            color = 'red'
        end

        r = ' <span color="' .. color .. '">' .. temp .. '</span>°C'

        return r
    end, 2, 'thermal_zone0')
-- }}}

-- CPU Information Widget {{{
cpuinfowidget = wibox.widget.textbox()
vicious.register(cpuinfowidget, vicious.widgets.cpu,
    function(widget, args)
        r = 'CPU: '
        color = ''

        if args[1] < 30 then
            color = 'turquoise'
        elseif args[1] < 50 then
            color = 'yellow'
        elseif args[1] < 70 then
            color = 'orange'
        else
            color = 'red'
        end

        r = r ..'<span color="' .. color .. '">' .. args[1] .. '</span>%'

        return r
    end, 2)
-- }}}

-- Net Widget {{{
netwidget = require("widgets.net")
-- }}}

-- WIFI Widget {{{
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi,
    function(widget, args)

        if args['{ssid}'] == 'N/A' then
            r = '-WLAN-'
        else
            r = args['{ssid}']
        end

        return r
    end, 10, 'wlp3s0')
-- }}}
-- }}}

-- Buttons {{{
local function toggle_client_menu()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({theme = {width = 250}})
        end
    end
end

local taglist_buttons = awful.util.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({modkey}, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({modkey}, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({}, 1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end),
    awful.button({}, 3, toggle_client_menu()),
    awful.button({}, 4,
        function ()
            awful.client.focus.byidx(1)
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.button({}, 5,
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then
                client.focus:raise()
            end
        end)
)
-- }}}

-- Wallpaper {{{
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Themes define colours, icons, and wallpapers
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")
-- }}}

-- Tags {{{
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
}

-- Define a tag table which hold all screen tags.
local tags = {
    {layout = awful.layout.suit.tile, keycode = 10},
    {layout = awful.layout.suit.tile, keycode = 11},
    {layout = awful.layout.suit.tile, keycode = 12},
    {layout = awful.layout.suit.tile, keycode = 13},
    {layout = awful.layout.suit.fair, keycode = 14},
    {layout = awful.layout.suit.tile, keycode = 15},
    {layout = awful.layout.suit.tile, keycode = 16},
    {layout = awful.layout.suit.tile, keycode = 17},
    {layout = awful.layout.suit.tile.top, keycode = 18},
}
-- }}}

-- Screens {{{
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    for i = 1, #tags do
        local tag = tags[i]
        tag.screen = s
        tag.gap_single_client = false
        tag.gap = 5

        awful.tag.add(i, tag)
    end

    local tag = awful.tag.gettags(s)[3]
    if tag then
       awful.tag.viewonly(tag)
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
        awful.button({}, 1, function () awful.layout.inc( 1) end),
        awful.button({}, 3, function () awful.layout.inc(-1) end),
        awful.button({}, 4, function () awful.layout.inc( 1) end),
        awful.button({}, 5, function () awful.layout.inc(-1) end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({position = "top", screen = s})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            padding,
            -- wifiwidget,
            -- separator,
            netwidget,
            separator,
            cpuinfowidget,
            cputempwidget,
            separator,
            memwidget,
            separator,
            volwidget,
            separator,
            batwidget,
            separator,
            mykeyboardlayout,
            textclock,
            padding,
            wibox.widget.systray(),
            paddind,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- Mouse bindings {{{
root.buttons(awful.util.table.join(
        awful.button({}, 3, function() mainmenu:toggle() end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- Key bindings {{{
-- local function toggle_display()
--     local connected =
--     return function()
--         if connected then
--             awful.spawn("

--     awful.spawn.easy_async(
--         "xrandr",
--         function(line) externscreen = line end
--     )

--     naughty.notify({title = "truc", text = externscreen})

    -- if otherscreen then
    --     awful.spawn("xrandr --output " .. otherscreen .. " --off")
    --     otherscreen = nil
    -- else
    --     if mode == "extend" then
    --         awful.spawn("xrandr --output " .. otherscreen .. " --right-of LVDS1 --auto")
    --     else -- mode == "duplicate"
    --         awful.spawn("xrandr --output " .. otherscreen .. " --auto")
    --     end
    -- end
-- end

Numeric_Pad = {"KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin", "KP_Right", "KP_Home", "KP_Up", "KP_Prior"}


globalkeys = awful.util.table.join(
    -- Awesome {{{
    awful.key({modkey}, "x",
        hotkeys_popup.show_help,
        {description="show help", group="awesome"}
    ),

    awful.key({modkey}, "w",
        function() mainmenu:show() end,
        {description = "show main menu", group = "awesome"}
    ),

    awful.key({modkey, "Control"}, "r",
        awesome.restart,
        {description = "reload awesome", group = "awesome"}
    ),

    awful.key({modkey, "Control"}, "q",
        awesome.quit,
        {description = "quit awesome", group = "awesome"}
    ),
    -- }}}

    -- Tag browsing {{{
    awful.key({modkey}, "Left",
        awful.tag.viewprev,
        {description = "view previous", group = "tag"}
    ),

    awful.key({modkey}, "Right",
        awful.tag.viewnext,
        {description = "view next", group = "tag"}
    ),

    awful.key({altkey, modkey}, "Left",
        function()
            local s = awful.screen.focused()
            for i = 1, #s.tags do
                awful.tag.viewprev()
                if #s.clients > 0 then
                    return
                end
            end
        end,
        {description = "view previous non empty", group = "tag"}
    ),

    awful.key({altkey, modkey}, "Right",
        function()
            local s = awful.screen.focused()
            for i = 1, #s.tags do
                awful.tag.viewnext()
                if #s.clients > 0 then
                    return
                end
            end
        end,
        {description = "view next non empty", group = "tag"}
    ),
    -- }}}

    -- Client focus {{{
    awful.key({modkey}, "j",
        function () awful.client.focus.byidx(1) end,
        -- function()
        --     awful.client.focus.bydirection("down")
        --     if client.focus then client.focus:raise() end
        -- end,
        {description = "focus next by index", group = "client"}
    ),

    awful.key({modkey}, "k",
        function () awful.client.focus.byidx(-1) end,
        -- function()
        --     awful.client.focus.bydirection("up")
        --     if client.focus then client.focus:raise() end
        -- end,
        {description = "focus previous by index", group = "client"}
    ),

    -- awful.key({modkey}, "h",
    --     function()
    --         awful.client.focus.bydirection("left")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "decrease master width factor", group = "layout"}
    -- ),

    -- awful.key({modkey}, "l",
    --     function()
    --         awful.client.focus.bydirection("right")
    --         if client.focus then client.focus:raise() end
    --     end,
    --     {description = "increase master width factor", group = "layout"}
    -- ),

    awful.key({modkey}, "Escape",
        function()
            if awful.client.urgent.get() then
                awful.client.urgent.jumpto()
            else
                awful.tag.history.restore()
            end

            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "jump to urgent client or go back", group = "client"}
    ),

    awful.key({modkey, "Control"}, "n",
        awful.client.restore,
        {description = "restore minimized", group = "client"}
    ),

    awful.key({modkey, "Shift"}, "j",
        function() awful.client.swap.byidx(1) end,
        {description = "swap with next client by index", group = "client"}
    ),

    awful.key({modkey, "Shift"}, "k",
        function() awful.client.swap.byidx(-1) end,
        {description = "swap with previous client by index", group = "client"}
    ),
    -- }}}

    -- Layout manipulation {{{
    awful.key({modkey, "Control"}, "j",
        function() awful.screen.focus_relative(1) end,
        {description = "focus the next screen", group = "screen"}
    ),

    awful.key({modkey, "Control"}, "k",
        function() awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}
    ),

    -- awful.key({modkey}, "Tab",
    --     function()
    --         awful.client.focus.byidx(1)
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}
    -- ),

    awful.key({modkey}, "l",
        function() awful.tag.incmwfact(0.05) end,
        {description = "increase master width factor", group = "layout"}
    ),

    awful.key({modkey}, "h",
        function() awful.tag.incmwfact(-0.05) end,
        {description = "decrease master width factor", group = "layout"}
    ),

    awful.key({modkey, "Shift"}, "h",
        function() awful.tag.incnmaster(1) end,
        {description = "increase the number of master clients", group = "layout"}
    ),

    awful.key({modkey, "Shift"}, "l",
        function() awful.tag.incnmaster(-1) end,
        {description = "decrease the number of master clients", group = "layout"}
    ),

    awful.key({modkey, "Control"}, "h",
        function() awful.tag.incncol(1) end,
        {description = "increase the number of columns", group = "layout"}
    ),

    awful.key({modkey, "Control"}, "l",
        function() awful.tag.incncol(-1) end,
        {description = "decrease the number of columns", group = "layout"}
    ),

    awful.key({modkey}, "space",
        function() awful.layout.inc(awful.layout.layouts, 1) end,
        {description = "select next", group = "layout"}
    ),

    awful.key({modkey, "Shift"}, "space",
        function() awful.layout.inc(layouts, -1) end,
        {description = "select previous", group = "layout"}
    ),
    -- }}}

    -- Launcher {{{
    awful.key({modkey}, "Return",
        function() awful.spawn(terminal, {screen = mouse.screen,}) end,
        {description = "open a terminal", group = "launcher"}
    ),

    awful.key({modkey}, "r",
        function() awful.screen.focused().mypromptbox:run() end,
        {description = "run prompt", group = "launcher"}
    ),

    awful.key({modkey}, "F1",
        function()
            awful.spawn("i3lock -u -t -i " .. os.getenv("HOME") .. "/Pictures/Wallpapers/screenlock")
        end,
        {description = "lock", group = "launcher"}
    ),

    awful.key({modkey}, Numeric_Pad[2],
        function() awful.spawn(browser) end,
        {description = "run web browser", group = "launcher"}
    ),

    awful.key({modkey}, Numeric_Pad[1],
        function() awful.spawn(mail_client) end,
        {description = "run mail client", group = "launcher"}
    ),

    -- Avez vous testé "AwesomeRocks" ?

    awful.key({modkey}, Numeric_Pad[5],
        function() awful.spawn("pidgin") end,
        {description = "run pidgin", group = "launcher"}
    ),

    -- awful.key({modkey}, Numeric_Pad[8],
    --     function()
    --         awful.spawn(terminal .. " -e 'mpd; ncmpcpp'", {tag = awful.tag.find_by_name(awful.screen.focused(), "8")})
    --     end,
    --     {description = "run ncmpcpp", group = "launcher"}
    -- ),

    awful.key({modkey}, Numeric_Pad[9],
        function() awful.spawn("discord-canary") end,
        {description = "run discord", group = "launcher"}
    ),

    awful.key({}, "XF86Calculator",
        function() awful.spawn(terminal .. " -e python") end,
        {description = "run python", group = "launcher"}
    ),

    awful.key({}, "XF86Launch1",
        function() awful.spawn("scrot -s " .. os.getenv("HOME") .. "/Pictures/screenshots/%Y-%m-%d_%H:%M:%S.png") end,
        {description = "take a screenshot", group = "launcher"}
    ),
    -- }}}

    -- Media keybindings {{{
    awful.key({}, "XF86TouchpadToggle",
        function() awful.spawn.with_shell("synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')") end,
        {description = "toggle touchpad", group = "media"}
    ),

    awful.key({}, "XF86AudioRaiseVolume",
        function()
            awful.spawn("amixer -q sset Master 2%+")
            vicious.force({volwidget,})
        end,
        {description = "raise volume", group = "media"}
    ),

    awful.key({}, "XF86AudioLowerVolume",
        function()
            awful.spawn("amixer -q sset Master 2%-")
            vicious.force({volwidget,})
        end,
        {description = "lower volume", group = "media"}
    ),

    awful.key({}, "XF86AudioMute",
        function()
            awful.spawn("amixer -q sset Master toggle")
            vicious.force({volwidget,})
        end,
        {description = "mute", group = "media"}
    ),

    awful.key({}, "XF86AudioPlay",
        function() awful.spawn("mpc toggle") end,
        {description = "mpd pause/play", group = "media"}
    ),

    awful.key({}, "XF86AudioNext",
        function() awful.spawn("mpc next") end,
        {description = "mpd next song", group = "media"}
    ),

    awful.key({}, "XF86AudioPrev",
        function() awful.spawn("mpc prev") end,
        {description = "mpd previous song", group = "media"}
    ),

    awful.key({}, "XF86AudioStop",
        function() awful.spawn("mpc stop") end,
        {description = "mpd stop playing", group = "media"}
    ),

    awful.key({}, "XF86Display",
        function() awful.spawn("xrandr --output HDMI1 --right-of LVDS1 --scale-from 1600x900 --auto") end,
        {description = "toggle an extended display", group = "screen"}
    ),

    awful.key({"Shift"}, "XF86Display",
        function() awful.spawn("xrandr --output HDMI1 --same-as LVDS1 --scale-from 1600x900 --auto") end,
        {description = "toggle a duplicated display", group = "screen"}
    ),
    -- }}}

    -- Alternative media keybindings {{{
    awful.key({modkey}, "F12",
        function()
            awful.spawn("amixer -q sset Master 2%+")
            vicious.force({volwidget,})
        end,
        {description = "raise volume", group = "media"}
    ),

    awful.key({modkey}, "F11",
        function()
            awful.spawn("amixer -q sset Master 2%-")
            vicious.force({volwidget,})
        end,
        {description = "lower volume", group = "media"}
    ),

    awful.key({modkey}, "F10",
        function()
            awful.spawn("amixer -q sset Master toggle")
            vicious.force({volwidget,})
        end,
        {description = "mute", group = "media"}
    ),

    awful.key({modkey}, "F9",
        function() awful.spawn.with_shell("synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')") end,
        {description = "toggle touchpad", group = "media"}
    ),

    awful.key({modkey}, "F4",
        function()
            awful.spawn("amixer -q sset Master 2%+")
            vicious.force({volwidget,})
        end,
        {description = "raise volume", group = "media"}
    ),

    awful.key({modkey}, "F3",
        function()
            awful.spawn("amixer -q sset Master 2%-")
            vicious.force({volwidget,})
        end,
        {description = "lower volume", group = "media"}
    )
    -- }}}
)

clientkeys = awful.util.table.join(
    awful.key({modkey}, "c",
        function(c) c:kill() end,
        {description = "close", group = "client"}
    ),

    awful.key({altkey}, "F4",
        function(c) c:kill() end,
        {description = "close", group = "client"}
    ),

    awful.key({modkey, "Control"}, "space",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
    ),

    awful.key({modkey, "Control"}, "Return",
        function(c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "client"}
    ),

    awful.key({modkey}, "o",
        awful.client.movetoscreen,
        {description = "move to screen", group = "client"}
    ),

    awful.key({modkey}, "n",
        function(c) c.minimized = true end,
        {description = "minimize", group = "client"}
    ),

    awful.key({modkey}, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "maximize", group = "client"}
    )
)

-- Bind all key numbers to tags.
for i, t in pairs(tags) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, "#" .. t.keycode,
            function()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                   awful.tag.viewonly(tag)
                end
            end),

        awful.key({modkey, "Control"}, "#" .. t.keycode,
            function()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                   awful.tag.viewtoggle(tag)
                end
            end),

        awful.key({modkey, "Shift"}, "#" .. t.keycode,
            function()
                if client.focus then
                    local screen = client.focus.screen
                    local tag = awful.tag.gettags(screen)[i]
                    if client.focus and tag then
                        awful.client.movetotag(tag)
                    end
                end
            end),

        awful.key({modkey, "Control", "Shift"}, "#" .. t.keycode,
            function()
                if client.focus then
                    local screen = client.focus.screen
                    local tag = awful.tag.gettags(screen)[i]
                    if client.focus and tag then
                        awful.client.toggletag(tag)
                    end
                end
            end)
    )
end

clientbuttons = awful.util.table.join(
    awful.button({}, 1,
        function(c)
            client.focus = c
            c:raise()
        end),
    awful.button({modkey}, 1, awful.mouse.client.move),
    awful.button({modkey}, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- Rules {{{
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            keys = clientkeys,
            buttons = clientbuttons,
            size_hints_honor = false
        }
    },

    {
        rule = {class = "MPlayer"},
        properties = {floating = true}
    },

    {
        rule = {class = "gimp"},
        properties = {floating = true}
    },

    -- Mapping rules
    {
        rule = {class = "Thunderbird"},
        properties = {screen = 1, tag = "1"}
    },

    {
        rule = {class = "Chromium"},
        properties = {screen = 1, tag = "2"}
    },

    {
        rule = {class = "Pidgin"},
        properties = {screen = 1, tag = "5"}
    },

    {
        rule = {class = "Pavucontrol"},
        properties = {screen = 1, tag = "9"}
    },

    {
        rule = {class = "discord"},
        properties = {screen = 1, tag = "9"}
    },
}
-- }}}

-- Signals {{{
-- Signal function to execute when a new client appears.
client.connect_signal("manage",
function(c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter",
function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
            awful.button({}, 1,
                function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),

            awful.button({}, 3,
                function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
        )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()

        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c)
        c.border_color = beautiful.border_focus end)

client.connect_signal("unfocus", function(c)
        c.border_color = beautiful.border_normal end)
-- }}}
