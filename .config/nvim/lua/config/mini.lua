local add = MiniDeps.add
local now = MiniDeps.now
local later = MiniDeps.later

-- カラースキーム ---------------------------------------------------------
now(function()
    vim.o.termguicolors = true

    add({ source = "oahlen/iceberg.nvim" })
    add({ source = "folke/tokyonight.nvim" })
    add({ source = "rebelot/kanagawa.nvim" })
    add({ source = "zaldih/themery.nvim" })

    require("themery").setup({
        themes = {
            { name = "Iceberg",           colorscheme = "iceberg" },
            { name = "Tokyo Night",       colorscheme = "tokyonight" },
            { name = "Tokyo Night Light", colorscheme = "tokyonight-day" },
            { name = "Kanagawa",          colorscheme = "kanagawa" },
        },
        livePreview = true,
    })

    vim.keymap.set("n", "<leader>th", "<cmd>Themery<CR>", { desc = "Switch theme (Themery)" })

    vim.cmd("colorscheme iceberg")
end)

now(function()
    local starter = require("mini.starter")
    starter.setup({
        header = table.concat({
            "                                                    ",
            " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        }, "\n"),
        items = {
            {
                name = "Open directory",
                action = function() require("oil").open(vim.fn.getcwd()) end,
                section = "Directory",
            },
            starter.sections.recent_files(5, false),
            starter.sections.recent_files(5, true),
            { name = "New file", action = "enew", section = "Actions" },
            { name = "Quit",     action = "qall", section = "Actions" },
        },
        content_hooks = {
            starter.gen_hook.adding_bullet(),
            starter.gen_hook.aligning("center", "center"),
        },
    })
end)

-- 常時ロード -----------------------------------------------------------------
now(function() require("mini.indentscope").setup() end)
now(function() require("mini.bracketed").setup() end)
now(function() require("mini.cursorword").setup() end)

-- 削除したもの:
--   mini.comment    … Neovim 0.10+ の組み込み gc / gcc で足りる
--   mini.tabline    … bufferline.nvim と重複（bufferline を採用）
--   mini.pick       … telescope.nvim と重複（telescope を採用）
--   mini.statusline … lualine.nvim に置き換え（ui.lua）

-- 遅延ロード -----------------------------------------------------------------
later(function() require("mini.pairs").setup() end)

-- バッファを閉じる（レイアウトを壊さない）
later(function()
    local bufremove = require("mini.bufremove")
    bufremove.setup()
    vim.keymap.set("n", "<leader>x", function() bufremove.delete(0, false) end, { desc = "バッファを閉じる" })
    vim.keymap.set("n", "<leader>X", function() bufremove.delete(0, true) end, { desc = "バッファを閉じる (force)" })
end)

-- Alt-hjkl で行・選択範囲を移動
later(function() require("mini.move").setup() end)

-- gS で引数リストを一行 <-> 複数行
later(function() require("mini.splitjoin").setup() end)

-- TODO/FIXME・カラーコード・16進数の可視化
later(function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
        highlighters = {
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            hack  = { pattern = "%f[%w]()HACK()%f[%W]",  group = "MiniHipatternsHack" },
            todo  = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo" },
            note  = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote" },
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end)

-- 末尾空白の可視化と除去（:lua MiniTrailspace.trim()）
later(function() require("mini.trailspace").setup() end)

-- キーマップの発見性（which-key 相当。mini.nvim 同梱なので追加コストなし）
later(function()
    local miniclue = require("mini.clue")
    miniclue.setup({
        triggers = {
            { mode = "n", keys = "<Leader>" },
            { mode = "x", keys = "<Leader>" },
            { mode = "n", keys = "g" },
            { mode = "x", keys = "g" },
            { mode = "n", keys = "'" },
            { mode = "n", keys = "`" },
            { mode = "n", keys = '"' },
            { mode = "i", keys = "<C-r>" },
            { mode = "n", keys = "<C-w>" },
            { mode = "n", keys = "z" },
            { mode = "x", keys = "z" },
            { mode = "n", keys = "[" },
            { mode = "n", keys = "]" },
        },
        clues = {
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
            { mode = "n", keys = "<Leader>f", desc = "+Find (telescope)" },
            { mode = "n", keys = "<Leader>g", desc = "+Git" },
            { mode = "n", keys = "<Leader>v", desc = "+LSP" },
            { mode = "n", keys = "<Leader>t", desc = "+Toggle" },
            { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
        },
        -- 画面中央〜下に大きく広がって邪魔だったので、右下に固定サイズで表示する
        window = {
            config = { width = 30, height = 10, anchor = "SE", row = "auto", col = "auto" },
            delay = 300,
        },
    })
end)
