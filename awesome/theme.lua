--[[
    toffan theme
    derived from Dremora
    github.com/copycat-killer/awesome-copycats
--]]

theme               = {}
home                = os.getenv("HOME")
theme.dir           = home .. "/.config/awesome"
theme.wallpaper     = home .. "/pictures/wallpapers/wallpaper"

theme.font          = "Deja Vu Sans 10"
theme.fg_normal     = "#747474"
theme.bg_normal     = "#121212"
theme.fg_focus      = "#dddcff"
theme.bg_focus      = "#121212"
theme.fg_urgent     = "#dddcff"
theme.bg_urgent     = "#7a3228"

theme.border_width  = 0
theme.border_normal = "#121212"
theme.border_focus  = "#292929"

theme.menu_height   = "16"
theme.menu_width    = "140"

theme.submenu_icon          = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel   = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/square_unsel.png"
theme.arrl_lr_pre           = theme.dir .. "/icons/arrl_lr_pre.png"
theme.arrl_lr_post          = theme.dir .. "/icons/arrl_lr_post.png"

theme.layout_tile           = theme.dir .. "/icons/tile.png"
theme.layout_tilegaps       = theme.dir .. "/icons/tilegaps.png"
theme.layout_tileleft       = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom     = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop        = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv          = theme.dir .. "/icons/fairv.png"
theme.layout_fairh          = theme.dir .. "/icons/fairh.png"
theme.layout_spiral         = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle        = theme.dir .. "/icons/dwindle.png"
theme.layout_max            = theme.dir .. "/icons/max.png"
theme.layout_fullscreen     = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier      = theme.dir .. "/icons/magnifier.png"
theme.layout_floating       = theme.dir .. "/icons/floating.png"

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

return theme
