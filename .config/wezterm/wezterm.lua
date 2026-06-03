local wezterm    = require("wezterm")
local config     = wezterm.config_builder()

-- ─── OS detection ────────────────────────────────────────────────────────────
local is_windows = wezterm.target_triple:find("windows") ~= nil
local home       = wezterm.home_dir

-- ─── Background image toggle ─────────────────────────────────────────────────
local state_file = home .. "/.config/wezterm/.bg_enabled"

local function bg_enabled()
    local f = io.open(state_file, "r")
    if f then
        f:close()
        return true
    end
    return false
end

local wallpaper = home .. "/.config/wezterm/images/wallpaper.jpg"

if bg_enabled() then
    config.background = {
        {
            source = { File = wallpaper },
            width = "100%",
            height = "100%",
            horizontal_align = "Center",
            vertical_align = "Middle",
            repeat_x = "NoRepeat",
            repeat_y = "NoRepeat",
        },
        {
            source = { Color = "#161821" },
            width = "100%",
            height = "100%",
            opacity = 0.92,
        },
    }
end

-- ─── Colors (Iceberg Dark) ───────────────────────────────────────────────────
config.colors = {
    foreground    = "#c6c8d1",
    background    = "#161821",
    cursor_bg     = "#c6c8d1",
    cursor_fg     = "#161821",
    cursor_border = "#c6c8d1",
    selection_fg  = "#161821",
    selection_bg  = "#c6c8d1",
    ansi          = {
        "#1e2132", -- black
        "#e27878", -- red
        "#b4be82", -- green
        "#e2a478", -- yellow
        "#84a0c6", -- blue
        "#a093c7", -- magenta
        "#89b8c2", -- cyan
        "#c6c8d1", -- white
    },
    brights       = {
        "#6b7089", -- bright black
        "#e98989", -- bright red
        "#c0ca8e", -- bright green
        "#e9b189", -- bright yellow
        "#91acd1", -- bright blue
        "#ada0d3", -- bright magenta
        "#95c4ce", -- bright cyan
        "#d2d4de", -- bright white
    },
    tab_bar       = {
        background = "#161821",
        active_tab = {
            bg_color = "#44716a",
            fg_color = "#c6c8d1",
        },
        inactive_tab = {
            bg_color = "#1e2132",
            fg_color = "#6b7089",
        },
        inactive_tab_hover = {
            bg_color = "#2a2f45",
            fg_color = "#c6c8d1",
        },
        new_tab = {
            bg_color = "#161821",
            fg_color = "#6b7089",
        },
    },
}

-- ─── Font ─────────────────────────────────────────────────────────────────────
config.font = wezterm.font_with_fallback({
    { family = "HackGen Console NF", italic = false },
    { family = "Noto Sans Mono CJK JP", italic = false },
})
config.font_size = 15

-- ─── Cursor ───────────────────────────────────────────────────────────────────
config.default_cursor_style = "BlinkingBar"

-- ─── Window ───────────────────────────────────────────────────────────────────
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = true
config.enable_scroll_bar = false
config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
config.use_ime = true

if not is_windows then
    config.window_decorations = "NONE" -- タイトルバーなし (Linux)
end

-- ─── Shell / Domain ───────────────────────────────────────────────────────────
if is_windows then
    config.default_prog   = { "C:/Program Files/PowerShell/7/pwsh.exe", "-nologo" }
    config.default_domain = "WSL:Ubuntu"
end

-- ─── Keybindings ─────────────────────────────────────────────────────────────
config.keys = {
    -- CTRL+SHIFT+B: 背景画像トグル
    {
        key    = "b",
        mods   = "CTRL|SHIFT",
        action = wezterm.action_callback(function()
            if bg_enabled() then
                os.remove(state_file)
            else
                local f = io.open(state_file, "w")
                if f then f:close() end
            end
            wezterm.reload_configuration()
        end),
    },
}

-- ─── Variable tab width ──────────────────────────────────────────────────────
wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
    local title = tab.active_pane.title

    -- タイトルが長すぎる場合は切り詰める
    if #title > max_width - 2 then
        title = wezterm.truncate_right(title, max_width - 2)
    end

    -- max_width いっぱいにセンタリング
    local total_pad = max_width - #title
    local left_pad  = math.floor(total_pad / 2)
    local right_pad = total_pad - left_pad

    return string.rep(" ", left_pad) .. title .. string.rep(" ", right_pad)
end)

return config
