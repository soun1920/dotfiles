-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/nvim-mini/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Options
vim.g.lazyvim_python_ruff = "ruff"

-- Keymaps
local map = vim.keymap.set
map({ "n", "t", "i" }, "<C-k>", ":bnext<CR>", { noremap = true, silent = true })
map("t", "<C-k>", "<C-\\><C-n>:bnext<CR>", { noremap = true, silent = true })
map("i", "jj", "<Esc>", { silent = true })
map("i", ";;", "<C-o>A;")

-- VSCode compatibility
if vim.g.vscode ~= nil then
    return
end

-- Theme setup
now(function()
    vim.o.termguicolors = true
    add({ source = "oahlen/iceberg.nvim" })
    vim.cmd("colorscheme iceberg")
end)

-- Mini plugins
now(function() require("mini.comment").setup() end)
now(function() require("mini.surround").setup() end)
now(function() require("mini.indentscope").setup() end)
now(function() require("mini.bracketed").setup() end)
now(function() require("mini.ai").setup() end)
now(function() require("mini.cursorword").setup() end)
now(function() require("mini.files").setup() end)
now(function() require("mini.tabline").setup() end)
now(function() require("mini.pick").setup() end)
later(function() require("mini.pairs").setup() end)

-- Editor plugins
later(function()
    add({ source = "mattn/vim-lexiv" })
    add({ source = "ahmedkhalf/project.nvim" })
    add({ source = "wakatime/vim-wakatime" })
    add({
        source = "L3MON4D3/LuaSnip",
        checkout = "v2.*",
        hooks = { post_checkout = function() vim.cmd("!make install_jsregexp") end }
    })

    add({ source = "kdheepak/lazygit.nvim", depends = { "nvim-lua/plenary.nvim" } })
    map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
end)

-- UI plugins
later(function()
    add({ source = "sainnhe/gruvbox-material" })
    add({ source = "xiyaowong/transparent.nvim" })

    add({ source = "akinsho/bufferline.nvim" })
    require("bufferline").setup({
        options = {
            separator_style = "slant",
        },
    })

    add({ source = "lambdalisue/fern.vim" })
    vim.g["fern#renderer"] = "nerdfont"
    add({ source = "lambdalisue/fern-renderer-nerdfont.vim" })
    add({ source = "lambdalisue/fern-git-status.vim" })
    add({ source = "lambdalisue/nerdfont.vim" })
    add({ source = "lambdalisue/glyph-palette.vim" })
    add({ source = "akinsho/toggleterm.nvim" })
    require("toggleterm").setup()

    -- Fern configuration
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "fern",
        group = vim.api.nvim_create_augroup("FernSetting", { clear = true }),
        callback = function(args)
            vim.keymap.set("n", "<CR>", "<Plug>(fern-action-open:background)", {
                buffer = args.buf,
                noremap = true,
                silent = true,
                desc = "Fern: Open file in background",
            })
        end,
    })
end)

-- Treesitter
later(function()
    add({ source = "nvim-treesitter/nvim-treesitter", hooks = { post_checkout = function() vim.cmd("TSUpdate") end } })
end)

-- LSP and completion
later(function()
    add({ source = "williamboman/mason.nvim" })
    add({ source = "williamboman/mason-lspconfig.nvim" })
    add({ source = "neovim/nvim-lspconfig" })
    add({ source = "hrsh7th/nvim-cmp" })
    add({ source = "hrsh7th/cmp-nvim-lsp" })
    add({ source = "hrsh7th/cmp-buffer" })
    add({ source = "hrsh7th/cmp-path" })
    add({ source = "hrsh7th/cmp-emoji" })
    add({ source = "saadparwaiz1/cmp_luasnip" })

    require("config.lsp")
end)

-- Formatting
later(function()
    add({ source = "stevearc/conform.nvim" })
end)

-- Language-specific plugins
later(function()
    -- Python
    add({ source = "linux-cultist/venv-selector.nvim" })

    -- Terraform
    add({ source = "hashivim/vim-terraform" })

    -- LaTeX
    add({ source = "lervag/vimtex" })

    -- Thrift
    add({ source = "solarnz/thrift.vim" })

    -- TypeScript
    add({ source = "jose-elias-alvarez/typescript.nvim" })

    -- Zig
    add({ source = "ziglang/zig.vim" })

    -- Additional UI enhancements (from LazyVim extras)
    add({ source = "echasnovski/mini.animate" })
    require("mini.animate").setup()
end)
