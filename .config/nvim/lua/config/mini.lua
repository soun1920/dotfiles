local add = MiniDeps.add
local now = MiniDeps.now
local later = MiniDeps.later

now(function()
    vim.o.termguicolors = true

    add({ source = "catppuccin/nvim", name = "catppuccin" })
    add({ source = "folke/tokyonight.nvim" })
    add({ source = "cocopon/iceberg.vim" })
    add({ source = "zaldih/themery.nvim" })

    require("themery").setup({
        themes = {
            { name = "Catppuccin",         colorscheme = "catppuccin" },
            { name = "Tokyo Night Light",  colorscheme = "tokyonight-day" },
            { name = "Iceberg",            colorscheme = "iceberg" },
            { name = "Sigewinne Hydro",    colorscheme = "sigewinne-hydro" },
        },
        livePreview = true,
    })

    vim.keymap.set("n", "<leader>th", "<cmd>Themery<CR>", { desc = "Switch theme (Themery)" })

    vim.cmd("colorscheme sigewinne-hydro")
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
            { name = "New file", action = "enew",  section = "Actions" },
            { name = "Quit",     action = "qall",  section = "Actions" },
        },
        content_hooks = {
            starter.gen_hook.adding_bullet(),
            starter.gen_hook.aligning("center", "center"),
        },
    })
end)

now(function() require("mini.comment").setup() end)
now(function() require("mini.indentscope").setup() end)
now(function() require("mini.bracketed").setup() end)
now(function() require("mini.cursorword").setup() end)
now(function() require("mini.tabline").setup() end)
now(function() require("mini.statusline").setup() end)
now(function() require("mini.pick").setup() end)
later(function() require("mini.pairs").setup() end)
